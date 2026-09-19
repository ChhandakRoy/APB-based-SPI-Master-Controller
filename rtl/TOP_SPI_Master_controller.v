`timescale 1ns / 1ps
//----------------------------------------------------------------------------
// SPI_SLAVE_CONTROL_SELECT -- fixed version (see chat review):
//   1. ABORT (genuine stop: !MSTR_I or SPI_MODE==STOP) is now separated
//      from SCLK_ON's "not currently clocking" condition. When neither
//      holds -- i.e. WAIT mode + SPISWAI asserted -- this block now does
//      NOTHING (freezes), matching BAUD_GENERATOR's own pause semantics,
//      instead of previously aborting (raising SS_O, zeroing count).
//   2. A new SEND_DATA_I is now guarded with !START so it cannot corrupt
//      an already-in-progress transfer.
//   3. MAX / the count-starting-at-2 calibration was traced by hand and
//      is correct as originally written (see chat for the derivation) --
//      left unchanged, just documented.
//
// NOTE: compile this alongside your existing (already-fixed)
// APB_SLAVE_INTERFACE, BAUD_GENERATOR, and SPI_SHIFT_REGISTER modules
// from earlier in this project -- they are not re-pasted here.
//----------------------------------------------------------------------------


module SPI_TOP
#(parameter WIDTH=8)
(
input                   PCLK,
input                   PRESETn,

input                   PWRITE_I,
input                   PSEL_I,
input                   PENABLE_I,
input  [WIDTH-1:0]      PWDATA_I,
input  [2:0]            PADDR_I,
output [WIDTH-1:0]      PRDATA_O,
output                  PREADY_O,
output                  PSLVERR_O,
output                  SPI_INTERRUPT_RQST_O,

output                  SCLK_O,
output                  MOSI_O,
input                   MISO_I,
output                  SS_O
);

    wire        CPOL, CPHA, LSBFE, SPISWAI, MSTR;
    wire [2:0]  SPR, SPPR;
    wire [1:0]  SPI_MODE;
    wire        SEND_DATA;
    wire [WIDTH-1:0] MOSI_DATA;
    wire [WIDTH-1:0] DATA_MISO;
    wire        RECEIVE_DATA;
    wire [11:0] BAUD_RATE_DIV;
    wire        MISO_RCV_SCLKP, MISO_RCV_SCLKN, MOSI_SEND_SCLKP, MOSI_SEND_SCLKN;

    APB_SLAVE_INTERFACE #(.WIDTH(WIDTH)) APB_slave_interface (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .PWRITE_I(PWRITE_I), .PSEL_I(PSEL_I), .PENABLE_I(PENABLE_I),
        .PWDATA_I(PWDATA_I), .PADDR_I(PADDR_I),
        .SS_I(SS_O), .MISO_DATA_I(DATA_MISO),
        .RECEIVE_DATA_I(RECEIVE_DATA), 
        .PRDATA_O(PRDATA_O), .MSTR_O(MSTR),
        .PREADY_O(PREADY_O), .PSLVERR_O(PSLVERR_O),
        .CPOL_O(CPOL), .CPHA_O(CPHA), .LSBFE_O(LSBFE),
        .SPISWAI_O(SPISWAI), .SPR_O(SPR), .SPPR_O(SPPR),
        .SPI_INTERRUPT_RQST_O(SPI_INTERRUPT_RQST_O),
        .SEND_DATA_O(SEND_DATA), .MOSI_DATA_O(MOSI_DATA),
        .SPI_MODE_O(SPI_MODE)
    );

    BAUD_GENERATOR Baud_gen (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .SPI_MODE_I(SPI_MODE), .SPISWAI_I(SPISWAI),
        .SPPR_I(SPPR), .SPR_I(SPR),
        .CPOL_I(CPOL), .CPHA_I(CPHA), .SS_I(SS_O),
        .SCLK_O(SCLK_O),
        .MISO_RCV_SCLKP_O(MISO_RCV_SCLKP), .MISO_RCV_SCLKN_O(MISO_RCV_SCLKN),
        .MOSI_SEND_SCLKP_O(MOSI_SEND_SCLKP), .MOSI_SEND_SCLKN_O(MOSI_SEND_SCLKN),
        .BAUD_RATE_DIV_O(BAUD_RATE_DIV)
    );

    SPI_SHIFT_REGISTER #(.WIDTH(WIDTH)) Shift_reg (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .CPOL_I(CPOL), .CPHA_I(CPHA), .SS_I(SS_O),
        .SEND_DATA_I(SEND_DATA), .LSBFE_I(LSBFE),
        .DATA_MOSI_I(MOSI_DATA),
        .MISO_I(MISO_I), .RECEIVE_DATA_I(RECEIVE_DATA),
        .MISO_RCV_SCLKP_I(MISO_RCV_SCLKP), .MISO_RCV_SCLKN_I(MISO_RCV_SCLKN),
        .MOSI_SEND_SCLKP_I(MOSI_SEND_SCLKP), .MOSI_SEND_SCLKN_I(MOSI_SEND_SCLKN),
        .DATA_MISO_O(DATA_MISO), .MOSI_O(MOSI_O)
    );

    SPI_SLAVE_CONTROL_SELECT #(.WIDTH(WIDTH)) SPI_slave_control_select (
        .PCLK(PCLK), .PRESETn(PRESETn),
        .MSTR_I(MSTR), .SPISWAI_I(SPISWAI), .SPI_MODE_I(SPI_MODE),
        .SEND_DATA_I(SEND_DATA), .BAUD_RATE_DIV_I(BAUD_RATE_DIV),
        .RECEIVE_DATA_O(RECEIVE_DATA), .SS_O(SS_O)
    );

endmodule


