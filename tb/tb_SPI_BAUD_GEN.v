`timescale 1ns / 1ps

module tb_BAUD_GENERATOR;

    reg        PCLK;
    reg        PRESETn;
    reg [1:0]  SPI_MODE_I;
    reg        SPISWAI_I;
    reg [2:0]  SPPR_I;
    reg [2:0]  SPR_I;
    reg        CPOL_I;
    reg        CPHA_I;
    reg        SS_I;

    wire       SCLK_O;
    wire       MISO_RCV_SCLKP_O;
    wire       MISO_RCV_SCLKN_O;
    wire       MOSI_SEND_SCLKP_O;
    wire       MOSI_SEND_SCLKN_O;
    wire [11:0]BAUD_RATE_DIV_O;

    BAUD_GENERATOR DUT (
        .PCLK               (PCLK),
        .PRESETn            (PRESETn),
        .SPI_MODE_I         (SPI_MODE_I),
        .SPISWAI_I          (SPISWAI_I),
        .SPPR_I             (SPPR_I),
        .SPR_I              (SPR_I),
        .CPOL_I             (CPOL_I),
        .CPHA_I             (CPHA_I),
        .SS_I               (SS_I),
        .SCLK_O             (SCLK_O),
        .MISO_RCV_SCLKP_O   (MISO_RCV_SCLKP_O),
        .MISO_RCV_SCLKN_O   (MISO_RCV_SCLKN_O),
        .MOSI_SEND_SCLKP_O  (MOSI_SEND_SCLKP_O),
        .MOSI_SEND_SCLKN_O  (MOSI_SEND_SCLKN_O),
        .BAUD_RATE_DIV_O    (BAUD_RATE_DIV_O)
    );

    
    initial PCLK = 1'b0;
    always #5 PCLK = ~PCLK;

    
    task do_reset;
        begin
            PRESETn    = 1'b0;
            SS_I       = 1'b1;   // deselected
            SPISWAI_I  = 1'b0;
            SPI_MODE_I = 2'b00;  // run state
            repeat (2) @(negedge PCLK);
            PRESETn = 1'b1;
            @(negedge PCLK);
        end
    endtask

    //------------------------------------------------------------------
    // The ONLY place configuration fields are ever written.
    // Enforces: SS_I high -> write all fields together -> settle
    // one cycle -> drop SS_I. This is the sequencing fix itself.
    //------------------------------------------------------------------
    task configure_and_select;
        input [1:0] mode;
        input       cpol;
        input       cpha;
        input [2:0] sppr;
        input [2:0] spr;
        begin
            SS_I = 1'b1;              // make sure we're parked first
            @(posedge PCLK); #1;

            SPI_MODE_I = mode;
            CPOL_I     = cpol;
            CPHA_I     = cpha;
            SPPR_I     = sppr;
            SPR_I      = spr;

            @(posedge PCLK); #1;      // settle cycle: snapshot regs latch here

            $display("[%0t] Configured: MODE=%b CPOL=%b CPHA=%b SPPR=%0d SPR=%0d -> BAUD_RATE_DIV_O=%0d",
                       $time, mode, cpol, cpha, sppr, spr, BAUD_RATE_DIV_O);

            SS_I = 1'b0;              // now start the frame
        end
    endtask

    //------------------------------------------------------------------
    // Run the currently-selected frame for N PCLK cycles, then park.
    //------------------------------------------------------------------
    task run_then_deselect;
        input [31:0] num_pclk_cycles;
        begin
            repeat (num_pclk_cycles) @(posedge PCLK);
            SS_I = 1'b1;   // deassert -- frame ends, SCLK_O/count resync
            @(posedge PCLK); #1;
        end
    endtask

    //------------------------------------------------------------------
    // Stimulus
    //------------------------------------------------------------------
    initial begin
        do_reset;

        // Phase 1: Mode 3 (CPOL=1,CPHA=1), divisor = 3*8  = 24
        configure_and_select(2'b00, 1'b1, 1'b1, 3'd2, 3'd2);
        run_then_deselect(100);

        // Phase 2: Mode 2 (CPOL=0,CPHA=0), divisor = 8*8  = 64
        configure_and_select(2'b00, 1'b0, 1'b0, 3'd7, 3'd2);
        run_then_deselect(200);

        // Phase 3: SPI_MODE_I = 01 (mode[1] still 0 -> SCLK still enabled),
        // Mode 3 again, divisor = 8*16 = 128
        configure_and_select(2'b01, 1'b1, 1'b1, 3'd7, 3'd3);
        run_then_deselect(1000);

        // Phase 4: confirm SCLK_O stays parked at CPOL_I while SS_I is
        // held high and nothing is reconfigured yet
        repeat (20) @(posedge PCLK);

        // Phase 5: reconfigure to the fastest possible setting
        // (Mode 0, SPPR=0, SPR=0 -> divisor = 1*2 = 2) and run briefly
        configure_and_select(2'b00, 1'b0, 1'b1, 3'd0, 3'd0);
        run_then_deselect(150);

        $finish;
    end

    


endmodule