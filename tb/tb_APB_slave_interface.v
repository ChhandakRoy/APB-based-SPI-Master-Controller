`timescale 1ns / 1ps

module tb_spi_apb_top;

    parameter WIDTH = 8;

    reg PCLK, PRESETn;
    reg PWRITE_I, PSEL_I, PENABLE_I;
    reg [WIDTH-1:0] PWDATA_I;
    reg [2:0] PADDR_I;
    reg SS_I, RECEIVE_DATA_I;
    reg MISO_I;

    wire [WIDTH-1:0] PRDATA_O;
    wire MSTR_O, PREADY_O, PSLVERR_O;
    wire CPOL_O, CPHA_O, LSBFE_O, SPISWAI_O;
    wire [2:0] SPR_O, SPPR_O;
    wire SPI_INTERRUPT_RQST;
    wire SEND_DATA_O;
    wire [WIDTH-1:0] MOSI_DATA_O;
    wire [1:0] SPI_MODE_O;

    wire SCLK_O;
    wire MISO_RCV_SCLKP, MISO_RCV_SCLKN, MOSI_SEND_SCLKP, MOSI_SEND_SCLKN;
    wire [11:0] BAUD_RATE_DIV_O;
    wire [WIDTH-1:0] DATA_MISO_O;
    wire MOSI_O;

    integer i;
    integer error_count, test_count;
    reg [WIDTH-1:0] status_rdata, dr_rdata;

    //------------------------------------------------------------------
    APB_SLAVE_INTERFACE #(.WIDTH(WIDTH)) apb (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .PWRITE_I(PWRITE_I), .PSEL_I(PSEL_I), .PENABLE_I(PENABLE_I),
        .PWDATA_I(PWDATA_I), .PADDR_I(PADDR_I),
        .SS_I(SS_I), .MISO_DATA_I(DATA_MISO_O),
        .RECEIVE_DATA_I(RECEIVE_DATA_I),
        .PRDATA_O(PRDATA_O), .MSTR_O(MSTR_O),
        .PREADY_O(PREADY_O), .PSLVERR_O(PSLVERR_O),
        .CPOL_O(CPOL_O), .CPHA_O(CPHA_O), .LSBFE_O(LSBFE_O),
        .SPISWAI_O(SPISWAI_O), .SPR_O(SPR_O), .SPPR_O(SPPR_O),
        .SPI_INTERRUPT_RQST_O(SPI_INTERRUPT_RQST),
        .SEND_DATA_O(SEND_DATA_O), .MOSI_DATA_O(MOSI_DATA_O),
        .SPI_MODE_O(SPI_MODE_O)
    );

    BAUD_GENERATOR bg (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .SPI_MODE_I(SPI_MODE_O), .SPISWAI_I(SPISWAI_O),
        .SPPR_I(SPPR_O), .SPR_I(SPR_O),
        .CPOL_I(CPOL_O), .CPHA_I(CPHA_O), .SS_I(SS_I),
        .SCLK_O(SCLK_O),
        .MISO_RCV_SCLKP_O(MISO_RCV_SCLKP), .MISO_RCV_SCLKN_O(MISO_RCV_SCLKN),
        .MOSI_SEND_SCLKP_O(MOSI_SEND_SCLKP), .MOSI_SEND_SCLKN_O(MOSI_SEND_SCLKN),
        .BAUD_RATE_DIV_O(BAUD_RATE_DIV_O)
    );

    SPI_SHIFT_REGISTER #(.WIDTH(WIDTH)) shreg (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .CPOL_I(CPOL_O), .CPHA_I(CPHA_O), .SS_I(SS_I),
        .SEND_DATA_I(SEND_DATA_O), .LSBFE_I(LSBFE_O),
        .DATA_MOSI_I(MOSI_DATA_O),
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

    //------------------------------------------------------------------
    task apb_write(input [2:0] addr, input [7:0] wdata);
        begin
            @(posedge PCLK);
            PSEL_I    = 1'b1;
            PENABLE_I = 1'b0;
            PWRITE_I  = 1'b1;
            PADDR_I   = addr;
            PWDATA_I  = wdata;
            @(posedge PCLK);      // now in SETUP
            PENABLE_I = 1'b1;
            @(posedge PCLK);      // now in ENABLE (PREADY_O=1 here)
            @(posedge PCLK);      // extra settle cycle for the internal write
            PSEL_I    = 1'b0;
            PENABLE_I = 1'b0;
            PWRITE_I  = 1'b0;
        end
    endtask

    task apb_read(input [2:0] addr, output [7:0] rdata);
        begin
            @(posedge PCLK);
            PSEL_I    = 1'b1;
            PENABLE_I = 1'b0;
            PWRITE_I  = 1'b0;
            PADDR_I   = addr;
            @(posedge PCLK);      // now in SETUP
            PENABLE_I = 1'b1;
            @(posedge PCLK);      // now in ENABLE (PREADY_O=1 here)
            @(posedge PCLK);      // extra settle cycle for PRDATA_O
            rdata = PRDATA_O;
            PSEL_I    = 1'b0;
            PENABLE_I = 1'b0;
        end
    endtask

    task do_reset;
        begin
            PRESETn = 1'b0;
            PSEL_I = 1'b0; PENABLE_I = 1'b0; PWRITE_I = 1'b0;
            PADDR_I = 3'd0; PWDATA_I = 8'd0;
            SS_I = 1'b1; RECEIVE_DATA_I = 1'b0; MISO_I = 1'b0;
            repeat (3) @(posedge PCLK);
            PRESETn = 1'b1;
            @(posedge PCLK);
        end
    endtask

    //------------------------------------------------------------------
    // One full batch: configure -> TX+RX duplex transfer -> deliver
    // received byte to APB -> check SPIF/interrupt -> APB read-back.
    //------------------------------------------------------------------
    task run_batch;
        input [7:0] cr1_val;
        input [7:0] br_val;
        input       cpol, cpha;      // must match the mode bits inside cr1_val
        input [7:0] tx_byte;
        input [7:0] slave_byte;
        reg         sample_first;    // true when CPOL==CPHA -> sample@posedge
        reg [7:0]   slave_shift;
        reg [7:0]   captured_mosi;
        integer     k;
        begin
            sample_first  = (cpol == cpha);
            slave_shift   = slave_byte;
            captured_mosi = 8'h00;

            // ---- configure (CR2 already 0x00 from before, left alone) ----
            apb_write(3'd0, cr1_val);
            apb_write(3'd2, br_val);

            // ---- write DR (TX byte) ----
            apb_write(3'd5, tx_byte);
            repeat (5) @(posedge PCLK);   // let shift_reg latch the TX load

            // CPOL==CPHA: preload ideal slave's first bit before SS_I drops
            if (sample_first)
                MISO_I = slave_shift[7];  // MSB-first (LSBFE fixed at 0)

            // ---- begin transfer ----
            SS_I  = 1'b0;
  

            for (k = 0; k <= WIDTH; k = k + 1) begin
                if (sample_first) begin
                    // sample edge = posedge, drive edge = negedge
                    @(posedge SCLK_O);
                    captured_mosi = {captured_mosi[6:0], MOSI_O};
                    if (k < WIDTH-1) begin
                        @(negedge SCLK_O);
                        slave_shift = slave_shift << 1;
                        MISO_I      = slave_shift[7];
                    end
                end else begin
                    // drive edge = posedge, sample edge = negedge
                    @(posedge SCLK_O);
                    MISO_I      = slave_shift[7];
                    slave_shift = slave_shift << 1;
                    @(negedge SCLK_O);
                    captured_mosi = {captured_mosi[6:0], MOSI_O};
                end
            end

            // ---- end transfer ----
            SS_I  = 1'b1;

            @(posedge PCLK); #1;

            // ---- check 1: TX sequence on the wire ----
            test_count = test_count + 1;
            if (captured_mosi !== tx_byte) begin
                $display("[%0t] FAIL(TX): CR1=%h BR=%h -> wire=%b(%0d), expected %b(%0d)",
                          $time, cr1_val, br_val, captured_mosi, captured_mosi, tx_byte, tx_byte);
                error_count = error_count + 1;
            end else begin
                $display("[%0t] PASS(TX): CPOL=%b CPHA=%b -> wire sequence correct (%b/%0d)",
                          $time, cpol, cpha, captured_mosi, captured_mosi);
            end

            // ---- deliver received byte to APB (stand-in for the
            //      not-yet-built spi_slave_control_select block) ----
            RECEIVE_DATA_I = 1'b1;
            @(posedge PCLK); #1;
            RECEIVE_DATA_I = 1'b0;
            @(posedge PCLK); #1;   // let SPIF/interrupt settle

            // ---- check 2: SPIF set, interrupt asserted (SPIE=1) ----
            test_count = test_count + 1;
            if (SPI_INTERRUPT_RQST !== 1'b1) begin
                $display("[%0t] FAIL(INT): SPI_INTERRUPT_RQST not asserted after receive (SPIE+SPIF expected)",$time);
                error_count = error_count + 1;
            end else begin
                $display("[%0t] PASS(INT): interrupt correctly asserted after receive",$time);
            end

            apb_read(3'd3, status_rdata);
            test_count = test_count + 1;
            if (status_rdata[7] !== 1'b1) begin
                $display("[%0t] FAIL(SPIF): status_reg=%b -> SPIF (bit7) not set",$time, status_rdata);
                error_count = error_count + 1;
            end else begin
                $display("[%0t] PASS(SPIF): SPIF correctly set (status=%b)",$time, status_rdata);
            end

            // ---- check 3: APB read of DR returns the received byte ----
            apb_read(3'd5, dr_rdata);
            test_count = test_count + 1;
            if (dr_rdata !== slave_byte) begin
                $display("[%0t] FAIL(RX): DR read=%b(%0d), expected %b(%0d)",
                          $time, dr_rdata, dr_rdata, slave_byte, slave_byte);
                error_count = error_count + 1;
            end else begin
                $display("[%0t] PASS(RX): DR correctly read back as %b(%0d)",
                          $time, dr_rdata, dr_rdata);
            end
        end
    endtask

    initial begin
        $display("================================================================");
        $display(" Full-duplex APB -> BAUD_GENERATOR -> SPI_SHIFT_REGISTER test");
        $display("================================================================");

        do_reset;

        // CR2 fixed for the whole run: SPISWAI=0, modfen=0
        apb_write(3'd1, 8'h00);

        // CR1 bits fixed across all batches: SPIE=1,SPE=1,SPTIE=1,MSTR=1,
        // SSOE=0, LSBFE=0. Only CPOL/CPHA (bits 3,2) vary per batch.
        //
        // Batch 1: Mode 0 (CPOL=0,CPHA=0) -> CR1=0xF0, divisor=8
        run_batch(8'hF0, 8'h11, 1'b0, 1'b0, 8'hB2, 8'h6D);

        // Batch 2: Mode 1 (CPOL=0,CPHA=1) -> CR1=0xF4, divisor=8
        run_batch(8'hF4, 8'h02, 1'b0, 1'b1, 8'hCA, 8'h35);

        // Batch 3: Mode 2 (CPOL=1,CPHA=0) -> CR1=0xF8, divisor=12
        run_batch(8'hF8, 8'h21, 1'b1, 1'b0, 8'h96, 8'h69);

        // Batch 4: Mode 3 (CPOL=1,CPHA=1) -> CR1=0xFC, divisor=16
        run_batch(8'hFC, 8'h12, 1'b1, 1'b1, 8'h3C, 8'hC3);

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
        #100000;
        $display("[%0t] ERROR: global testbench timeout", $time);
        $finish;
    end

endmodule