`timescale 1ns/1ps

module TB_SPI_Top;

    parameter WIDTH = 8;

    reg PCLK, PRESETn;
    reg PWRITE_I, PSEL_I, PENABLE_I;
    reg [WIDTH-1:0] PWDATA_I;
    reg [2:0] PADDR_I;
    reg MISO_I;

    wire [WIDTH-1:0] PRDATA_O;
    wire PREADY_O, PSLVERR_O, SPI_INTERRUPT_RQST_O;
    wire SCLK_O, MOSI_O, SS_O;

    integer error_count, test_count;
    reg [WIDTH-1:0] status_rdata, dr_rdata;
    reg [WIDTH-1:0] tx_byte, slave_byte, slave_shift, captured_mosi;
    integer k;

    SPI_TOP #(.WIDTH(WIDTH)) dut (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .PWRITE_I(PWRITE_I), .PSEL_I(PSEL_I), .PENABLE_I(PENABLE_I),
        .PWDATA_I(PWDATA_I), .PADDR_I(PADDR_I),
        .PRDATA_O(PRDATA_O), .PREADY_O(PREADY_O), .PSLVERR_O(PSLVERR_O),
        .SPI_INTERRUPT_RQST_O(SPI_INTERRUPT_RQST_O),
        .SCLK_O(SCLK_O), .MOSI_O(MOSI_O), .MISO_I(MISO_I), .SS_O(SS_O)
    );

    initial PCLK = 1'b0;
    always #5 PCLK = ~PCLK;

    initial begin
        error_count = 0;
        test_count  = 0;
    end

    task apb_write(input [2:0] addr, input [7:0] wdata);
        begin
            @(posedge PCLK);
            PSEL_I = 1'b1; PENABLE_I = 1'b0; PWRITE_I = 1'b1;
            PADDR_I = addr; PWDATA_I = wdata;
            @(posedge PCLK);
            PENABLE_I = 1'b1;
            @(posedge PCLK);
            @(posedge PCLK);      // extra settle cycle for the internal write
            PSEL_I = 1'b0; PENABLE_I = 1'b0; PWRITE_I = 1'b0;
        end
    endtask

    task apb_read(input [2:0] addr, output [7:0] rdata);
        begin
            @(posedge PCLK);
            PSEL_I = 1'b1; PENABLE_I = 1'b0; PWRITE_I = 1'b0; PADDR_I = addr;
            @(posedge PCLK);
            PENABLE_I = 1'b1;
            @(posedge PCLK);
            @(posedge PCLK);      // extra settle cycle for PRDATA_O
            rdata = PRDATA_O;
            PSEL_I = 1'b0; PENABLE_I = 1'b0;
        end
    endtask

    task do_reset;
        begin
            PRESETn = 1'b0;
            PSEL_I = 1'b0; PENABLE_I = 1'b0; PWRITE_I = 1'b0;
            PADDR_I = 3'd0; PWDATA_I = 8'd0;
            MISO_I = 1'b0;
            repeat (3) @(posedge PCLK);
            PRESETn = 1'b1;
            @(posedge PCLK);
        end
    endtask

    initial begin
        $display("================================================================");
        $display(" SPI_TOP: full autonomous end-to-end test");
        $display("================================================================");

        do_reset;

        apb_write(3'd1, 8'h00);   // CR2 = 0

        // CR1: SPIE=1,SPE=1,SPTIE=1,MSTR=1,CPOL=1,CPHA=0,SSOE=1,LSBFE=0 -> 0xFB
        apb_write(3'd0, 8'hFA);

        // BR: SPPR=1,SPR=1 -> divisor = 2*4 = 8
        apb_write(3'd2, 8'h11);

        tx_byte    = 8'hB2;   // 178
        slave_byte = 8'h6D;   // 109

        apb_write(3'd5, tx_byte);   // DR write -> autonomous dispatch

        // Dispatch propagates autonomously through APB -> control_select.
        // Just WAIT for the transfer to actually start -- no fixed delay
        // needed, @(negedge SS_O) blocks until it genuinely happens.
        @(negedge SS_O);
        $display("[%0t] Transfer autonomously started (SS_O low)", $time);

        // Mode 0 (CPOL=0,CPHA=0): sample edge = posedge, so preload the
        // ideal slave's first bit immediately -- SS_O has only just
        // dropped, and the first real SCLK edge is still at least one
        // full PCLK period away, so this is comfortably in time.
        slave_shift   = slave_byte;
        MISO_I        = slave_shift[7];
        captured_mosi = 8'h00;

        for (k = 0; k < WIDTH; k = k + 1) begin
            @(negedge SCLK_O);
            captured_mosi = {captured_mosi[6:0], MOSI_O};
            if (k < WIDTH-1) begin
                @(posedge SCLK_O);
                slave_shift = slave_shift << 1;
                MISO_I      = slave_shift[7];
            end
        end

        @(posedge SS_O);
        $display("[%0t] Transfer autonomously completed (SS_O high)", $time);
        @(posedge PCLK); #1;

        // ---- check 1: TX sequence on the wire ----
        test_count = test_count + 1;
        if (captured_mosi !== tx_byte) begin
            $display("[%0t] FAIL(TX): wire=%b(%0d), expected %b(%0d)",
                      $time, captured_mosi, captured_mosi, tx_byte, tx_byte);
            error_count = error_count + 1;
        end else begin
            $display("[%0t] PASS(TX): wire sequence correct (%b/%0d)",
                      $time, captured_mosi, captured_mosi);
        end

        // ---- check 2: interrupt asserted (SPIE=1, SPIF should now be 1) ----
        test_count = test_count + 1;
        if (SPI_INTERRUPT_RQST_O !== 1'b1) begin
            $display("[%0t] FAIL(INT): interrupt not asserted after autonomous receive",$time);
            error_count = error_count + 1;
        end else begin
            $display("[%0t] PASS(INT): interrupt correctly asserted",$time);
        end

        // ---- check 3: status register shows SPIF ----
        apb_read(3'd3, status_rdata);
        test_count = test_count + 1;
        if (status_rdata[7] !== 1'b1) begin
            $display("[%0t] FAIL(SPIF): status_reg=%b -> SPIF not set",$time,status_rdata);
            error_count = error_count + 1;
        end else begin
            $display("[%0t] PASS(SPIF): SPIF correctly set (status=%b)",$time,status_rdata);
        end

        // ---- check 4: APB read of DR returns the received byte ----
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

    initial begin
        #50000;
        $display("[%0t] ERROR: global testbench timeout", $time);
        $finish;
    end

endmodule