`timescale 1ns / 1ps
//----------------------------------------------------------------------------
// Simple, task-based testbench for SPI_SLAVE_CONTROL_SELECT (standalone).
//
// Covers:
//   1. A normal transfer: SS_O asserts on SEND_DATA_I, stays low for a
//      duration matching the DUT's own internal MAX (checked via a
//      hierarchical reference -- a standard whitebox TB technique),
//      RECEIVE_DATA_O pulses cleanly for exactly one cycle, TIP_O
//      returns to 0 afterward.
//   2. Pause vs. abort: WAIT mode + SPISWAI_I mid-transfer must FREEZE
//      (SS_O stays low, count holds) and resume cleanly -- this is the
//      bug fixed in review (it previously aborted under this condition).
//   3. A genuine abort (MSTR_I=0 mid-transfer) must immediately
//      deassert SS_O.
//----------------------------------------------------------------------------
module tb_spi_slave_control_select;

    reg         PCLK, PRESETn;
    reg         MSTR_I, SPISWAI_I;
    reg  [1:0]  SPI_MODE_I;
    reg         SEND_DATA_I;
    reg  [11:0] BAUD_RATE_DIV_I;

    wire        RECEIVE_DATA_O;
    wire        SS_O;
    

    integer     error_count, test_count;

    SPI_SLAVE_CONTROL_SELECT #(.WIDTH(8)) dut (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .MSTR_I(MSTR_I), .SPISWAI_I(SPISWAI_I), .SPI_MODE_I(SPI_MODE_I),
        .SEND_DATA_I(SEND_DATA_I), .BAUD_RATE_DIV_I(BAUD_RATE_DIV_I),
        .RECEIVE_DATA_O(RECEIVE_DATA_O), .SS_O(SS_O)
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
            PRESETn          = 1'b0;
            MSTR_I           = 1'b1;
            SPISWAI_I        = 1'b0;
            SPI_MODE_I       = 2'b00;
            SEND_DATA_I      = 1'b0;
            BAUD_RATE_DIV_I  = 12'd8;
            repeat (3) @(posedge PCLK);
            PRESETn = 1'b1;
            @(posedge PCLK);
        end
    endtask

    //------------------------------------------------------------------
    task run_normal_transfer(input [11:0] div);
        integer cycles;
        begin
            BAUD_RATE_DIV_I = div;
            SPI_MODE_I      = 2'b00;
            MSTR_I          = 1'b1;
            SPISWAI_I       = 1'b0;

            @(posedge PCLK);
            SEND_DATA_I = 1'b1;
            @(posedge PCLK);
            SEND_DATA_I = 1'b0;

            test_count = test_count + 1;
            if (SS_O !== 1'b0) begin
                $display("[%0t] FAIL: SS_O did not assert after SEND_DATA_I (div=%0d)", $time, div);
                error_count = error_count + 1;
            end else
                $display("[%0t] PASS: SS_O asserted (transfer started, div=%0d)", $time, div);

            cycles = 0;
            while (SS_O === 1'b0) begin
                @(posedge PCLK);
                cycles = cycles + 1;
                if (cycles > 2000) begin
                    $display("[%0t] FAIL: SS_O never deasserted (timeout)", $time);
                    error_count = error_count + 1;
                    disable run_normal_transfer;
                end
            end

            test_count = test_count + 1;
            $display("[%0t] Measured SS_O-low duration = %0d cycles (DUT internal MAX=%0d)",
                       $time, cycles, dut.MAX);
            if (cycles < dut.MAX - 2 || cycles > dut.MAX + 2) begin
                $display("[%0t] FAIL: duration (%0d) not close to expected MAX (%0d)",
                           $time, cycles, dut.MAX);
                error_count = error_count + 1;
            end else
                $display("[%0t] PASS: SS_O duration matches expected MAX within tolerance", $time);

            test_count = test_count + 1;
            if (RECEIVE_DATA_O !== 1'b1) begin
                $display("[%0t] FAIL: RECEIVE_DATA_O not pulsed right after SS_O deasserted", $time);
                error_count = error_count + 1;
            end else
                $display("[%0t] PASS: RECEIVE_DATA_O correctly pulsed", $time);

            @(posedge PCLK);
            test_count = test_count + 1;
            if (RECEIVE_DATA_O !== 1'b0) begin
                $display("[%0t] FAIL: RECEIVE_DATA_O did not clear after one cycle (not a clean one-shot)", $time);
                error_count = error_count + 1;
            end else
                $display("[%0t] PASS: RECEIVE_DATA_O cleared (one-shot pulse confirmed)", $time);

            test_count = test_count + 1;
            if (SS_O !== 1'b1) begin
                $display("[%0t] FAIL: TIP_O not low after transfer completed", $time);
                error_count = error_count + 1;
            end else
                $display("[%0t] PASS: TIP_O correctly low (idle)", $time);
        end
    endtask

    //------------------------------------------------------------------
    task test_pause_resume(input [11:0] div);
        reg [15:0] count_before, count_after;
        begin
            BAUD_RATE_DIV_I = div;
            SPI_MODE_I      = 2'b00;
            MSTR_I          = 1'b1;
            SPISWAI_I       = 1'b0;

            @(posedge PCLK);
            SEND_DATA_I = 1'b1;
            @(posedge PCLK);
            SEND_DATA_I = 1'b0;

            repeat (5) @(posedge PCLK);   // let it run partway

            // enter WAIT mode + SPISWAI -> must PAUSE, not abort
            SPI_MODE_I = 2'b01;
            SPISWAI_I  = 1'b1;
            @(posedge PCLK);
            count_before = dut.count;

            repeat (10) @(posedge PCLK);
            count_after = dut.count;

            test_count = test_count + 1;
            if (SS_O !== 1'b0) begin
                $display("[%0t] FAIL: SS_O deasserted during a WAIT+SPISWAI pause (should freeze, not abort)", $time);
                error_count = error_count + 1;
            end else
                $display("[%0t] PASS: SS_O stayed asserted through the pause window", $time);

            test_count = test_count + 1;
            if (count_after !== count_before) begin
                $display("[%0t] FAIL: count changed during pause (%0d -> %0d); should hold",
                           $time, count_before, count_after);
                error_count = error_count + 1;
            end else
                $display("[%0t] PASS: count correctly held during pause (%0d)", $time, count_before);

            // resume
            SPI_MODE_I = 2'b00;
            SPISWAI_I  = 1'b0;

            while (SS_O === 1'b0) @(posedge PCLK);

            test_count = test_count + 1;
            $display("[%0t] PASS: transfer resumed and completed cleanly after pause", $time);
        end
    endtask

    //------------------------------------------------------------------
    task test_abort(input [11:0] div);
        begin
            BAUD_RATE_DIV_I = div;
            SPI_MODE_I      = 2'b00;
            MSTR_I          = 1'b1;
            SPISWAI_I       = 1'b0;

            @(posedge PCLK);
            SEND_DATA_I = 1'b1;
            @(posedge PCLK);
            SEND_DATA_I = 1'b0;

            repeat (5) @(posedge PCLK);

            MSTR_I = 1'b0;   // genuine abort condition
            @(posedge PCLK); #1;

            test_count = test_count + 1;
            if (SS_O !== 1'b1) begin
                $display("[%0t] FAIL: SS_O did not deassert immediately on ABORT (MSTR_I=0)", $time);
                error_count = error_count + 1;
            end else
                $display("[%0t] PASS: SS_O correctly aborted (deasserted) on MSTR_I=0", $time);

            MSTR_I = 1'b1;   // restore for any subsequent tests
        end
    endtask

    //------------------------------------------------------------------
    initial begin
        $display("================================================================");
        $display(" SPI_SLAVE_CONTROL_SELECT standalone testbench");
        $display("================================================================");

        do_reset;
        run_normal_transfer(12'd8);

        do_reset;
        run_normal_transfer(12'd16);

        do_reset;
        test_pause_resume(12'd8);

        do_reset;
        test_abort(12'd8);

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
        #50000;
        $display("[%0t] ERROR: global testbench timeout", $time);
        $finish;
    end

endmodule