`timescale 1ns / 1ps

module tb_spi_shift_register;

    parameter WIDTH = 8;

    reg         PCLK, PRESETn;
    reg  [1:0]  SPI_MODE_I;
    reg         SPISWAI_I;
    reg  [2:0]  SPPR_I, SPR_I;
    reg         CPOL_I, CPHA_I, SS_I;

    reg         SEND_DATA_I, LSBFE_I, RECEIVE_DATA_I;
    reg  [WIDTH-1:0] DATA_MOSI_I;
    reg         MISO_I;

    wire        SCLK_O;
    wire        MISO_RCV_SCLKP, MISO_RCV_SCLKN, MOSI_SEND_SCLKP, MOSI_SEND_SCLKN;
    wire [11:0] BAUD_RATE_DIV_O;
    wire [WIDTH-1:0] DATA_MISO_O;
    wire        MOSI_O;

    integer     error_count, test_count;

    BAUD_GENERATOR bg (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .SPI_MODE_I(SPI_MODE_I), .SPISWAI_I(SPISWAI_I),
        .SPPR_I(SPPR_I), .SPR_I(SPR_I),
        .CPOL_I(CPOL_I), .CPHA_I(CPHA_I), .SS_I(SS_I),
        .SCLK_O(SCLK_O),
        .MISO_RCV_SCLKP_O(MISO_RCV_SCLKP), .MISO_RCV_SCLKN_O(MISO_RCV_SCLKN),
        .MOSI_SEND_SCLKP_O(MOSI_SEND_SCLKP), .MOSI_SEND_SCLKN_O(MOSI_SEND_SCLKN),
        .BAUD_RATE_DIV_O(BAUD_RATE_DIV_O)
    );

    SPI_SHIFT_REGISTER #(.WIDTH(WIDTH)) dut (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .CPOL_I(CPOL_I), .CPHA_I(CPHA_I), .SS_I(SS_I),
        .SEND_DATA_I(SEND_DATA_I), .LSBFE_I(LSBFE_I),
        .DATA_MOSI_I(DATA_MOSI_I),
        .MISO_I(MISO_I), .RECEIVE_DATA_I(RECEIVE_DATA_I),
        .MISO_RCV_SCLKP_I(MISO_RCV_SCLKP), .MISO_RCV_SCLKN_I(MISO_RCV_SCLKN),
        .MOSI_SEND_SCLKP_I(MOSI_SEND_SCLKP), .MOSI_SEND_SCLKN_I(MOSI_SEND_SCLKN),
        .DATA_MISO_O(DATA_MISO_O), .MOSI_O(MOSI_O)
    );

    // 100 MHz PCLK
    initial PCLK = 1'b0;
    always #5 PCLK = ~PCLK;

    initial begin
        error_count = 0;
        test_count  = 0;
    end

    task do_reset;
        begin
            PRESETn        = 1'b0;
            SS_I           = 1'b1;
            SPISWAI_I      = 1'b0;
            SPI_MODE_I     = 2'b00;
            SEND_DATA_I    = 1'b0;
            RECEIVE_DATA_I = 1'b0;
            MISO_I         = 1'b0;
            repeat (3) @(posedge PCLK);
            PRESETn = 1'b1;
            @(posedge PCLK);
        end
    endtask

    //------------------------------------------------------------------
    // Runs one full WIDTH-bit duplex transfer, acting as an ideal
    // external SPI slave: drives MISO_I and samples MOSI_O purely on
    // the real SCLK_O edges appropriate to the configured mode.
    //
    // For CPOL==CPHA: frame's first real event is a SAMPLE, so the
    // slave (like the DUT's own TX side) must have its first bit ready
    // on MISO_I the instant SS_I drops -- BEFORE any real edge occurs.
    // For CPOL!=CPHA: frame's first real event is a DRIVE, so the slave
    // naturally drives its first bit right at that first real edge --
    // no preload needed.
    //------------------------------------------------------------------
    task run_mode_test;
        input       cpol, cpha, lsbfe;
        input [7:0] tx_byte;     // byte the DUT (master) transmits
        input [7:0] slave_byte;  // byte the ideal slave sends back
        reg         sample_first;   // true when CPOL==CPHA
        reg [7:0]   slave_shift;
        reg [7:0]   captured_mosi;
        integer     i;
        begin
            sample_first  = (cpol == cpha);
            slave_shift   = slave_byte;
            captured_mosi = 8'h00;

            
            SS_I = 1'b1;
            @(posedge PCLK); #1;
            SPI_MODE_I  = 2'b00;
            SPISWAI_I   = 1'b0;
            CPOL_I      = cpol;
            CPHA_I      = cpha;
            LSBFE_I     = lsbfe;
            SPPR_I      = 3'd1;
            SPR_I       = 3'd2;
            SEND_DATA_I = 1'b1;
            DATA_MOSI_I = tx_byte;
            @(posedge PCLK); #1;      // Tx_shift_reg loads here (SS_I still 1)
            SEND_DATA_I = 1'b0;

            // For CPOL==CPHA: preload the slave's first bit onto MISO_I
            // in the SAME procedural step as dropping SS_I, so it is
            // valid before any real SCLK edge -- mirroring the DUT's
            // own Tx_shift_reg preload.
            if (sample_first)
                MISO_I = lsbfe ? slave_shift[0] : slave_shift[7];
            
            SS_I = 1'b0;              // start frame

            for (i = 0; i < WIDTH; i = i + 1) begin
                if (sample_first) begin
                    // sample edge = posedge, drive edge = negedge
                    @(posedge SCLK_O);
                    captured_mosi = lsbfe ? {MOSI_O, captured_mosi[7:1]}
                                          : {captured_mosi[6:0], MOSI_O};
                    if (i <  WIDTH) begin
                        @(negedge SCLK_O);
                        slave_shift = lsbfe ? (slave_shift >> 1) : (slave_shift << 1);
                        MISO_I      = lsbfe ? slave_shift[0] : slave_shift[7];
                    end
                end else begin
                    // drive edge = posedge, sample edge = negedge
                    @(posedge SCLK_O);
                    MISO_I      = lsbfe ? slave_shift[0] : slave_shift[7];
                    slave_shift = lsbfe ? (slave_shift >> 1) : (slave_shift << 1);
                    @(negedge SCLK_O);
                    captured_mosi = lsbfe ? {MOSI_O, captured_mosi[7:1]}
                                          : {captured_mosi[6:0], MOSI_O};
                end
            end

           
            
            
            
            
             SS_I = 1'b1;    // end frame
             @ (posedge PCLK) #1;
            // ---- checks ----
            test_count = test_count + 1;
            if (captured_mosi !== tx_byte) begin
                $display("[%0t] FAIL(TX): CPOL=%b CPHA=%b LSBFE=%b -> wire sequence=%b (%0d), expected %b (%0d)",
                          $time, cpol, cpha, lsbfe, captured_mosi, captured_mosi, tx_byte, tx_byte);
                error_count = error_count + 1;
            end else begin
                $display("[%0t] PASS(TX): CPOL=%b CPHA=%b LSBFE=%b -> wire sequence correct (%b / %0d)",
                          $time, cpol, cpha, lsbfe, captured_mosi, captured_mosi);
            end

            RECEIVE_DATA_I = 1'b1; #1;
            test_count = test_count + 1;
            if (DATA_MISO_O !== slave_byte) begin
                $display("[%0t] FAIL(RX): CPOL=%b CPHA=%b LSBFE=%b -> DATA_MISO_O=%b (%0d), expected %b (%0d)",
                          $time, cpol, cpha, lsbfe, DATA_MISO_O, DATA_MISO_O, slave_byte, slave_byte);
                error_count = error_count + 1;
            end else begin
                $display("[%0t] PASS(RX): CPOL=%b CPHA=%b LSBFE=%b -> DATA_MISO_O correct (%b / %0d)",
                          $time, cpol, cpha, lsbfe, DATA_MISO_O, DATA_MISO_O);
            end
            RECEIVE_DATA_I = 1'b0;
        end
    endtask

    initial begin
        $display("================================================================");
        $display(" SPI_SHIFT_REGISTER integration testbench v2");
        $display("================================================================");

        // ---- Mode 0 (CPOL=0,CPHA=0) ----
        do_reset;
        run_mode_test(1'b0, 1'b0, 1'b0, 8'b1011_0010, 8'b0110_1101); // MSB-first
        run_mode_test(1'b0, 1'b0, 1'b1, 8'hA5, 8'h5A);               // LSB-first

        // ---- Mode 3 (CPOL=1,CPHA=1) -- other CPOL==CPHA case, idle-high ----
        
        run_mode_test(1'b1, 1'b1, 1'b0, 8'hF0, 8'h0F);
        
        run_mode_test(1'b1, 1'b1, 1'b1, 8'h3C, 8'hC3);

        // ---- Mode 1 (CPOL=0,CPHA=1) ----
        
        run_mode_test(1'b0, 1'b1, 1'b0, 8'b1100_1010, 8'b0011_0101);
        
        run_mode_test(1'b0, 1'b1, 1'b1, 8'h81, 8'h18);

        // ---- Mode 2 (CPOL=1,CPHA=0) ----
        do_reset;
        run_mode_test(1'b1, 1'b0, 1'b0, 8'h96, 8'h69);
        do_reset;
        run_mode_test(1'b1, 1'b0, 1'b1, 8'hF0, 8'h0F);

        // ---- Edge patterns: all-zero / all-one, to catch stuck-bit
        //      masking that a mid-value byte could hide ----
        do_reset;
        run_mode_test(1'b0, 1'b0, 1'b0, 8'h00, 8'hFF);
        do_reset;
        run_mode_test(1'b0, 1'b0, 1'b0, 8'hFF, 8'h00);
        do_reset;
        run_mode_test(1'b0, 1'b1, 1'b0, 8'h00, 8'hFF);
        do_reset;
        run_mode_test(1'b0, 1'b1, 1'b0, 8'hFF, 8'h00);

        $display("\n================================================================");
        $display(" TOTAL TESTS : %0d", test_count);
        $display(" FAILURES    : %0d", error_count);
        if (error_count == 0)
            $display(" RESULT      : ALL TESTS PASSED");
        else
            $display(" RESULT      : %0d TEST(S) FAILED -- see log above", error_count);
        $display("================================================================");
        $finish;
    end

    // Global safety timeout
    initial begin
        #300000;
        $display("[%0t] ERROR: global testbench timeout", $time);
        $finish;
    end

endmodule