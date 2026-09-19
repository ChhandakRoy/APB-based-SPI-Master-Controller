`timescale 1ns / 1ps
// ---------------------------------------------------------------------------------------------------
/*
CREATED DATE - 7th September, 2026
NAME - Chhandak Roy
PROJECT - BLOCK 3: APB Slave Interface
DESCRIPTION - The following Design is of an APB Slave, which is  a bridge link between the APB MASTER 
and the SPI Peripheral, the APB master writes data to be transmitted and the reads the data received 
by the SPI and send it to processor. And this data transfer is controlled by the Control Reg 1 and 2,
synchronized by Baud rate reg and the transmission status is updated at Status reg. This block controls
the read and write operation by the processor via APB master and also cordinates it with the SPI.
*/
// ---------------------------------------------------------------------------------------------------
module APB_SLAVE_INTERFACE
#(parameter WIDTH=8)
( 
input                       PCLK,
input                       PRESETn,
input                       PWRITE_I,
input                       PSEL_I,
input                       PENABLE_I,
input [WIDTH-1:0]           PWDATA_I,
input [2:0]                 PADDR_I,
input                       SS_I,
input [WIDTH-1:0]           MISO_DATA_I,
input                       RECEIVE_DATA_I,

output reg [WIDTH-1:0]      PRDATA_O,
output                      MSTR_O,
output                      PREADY_O,
output                      PSLVERR_O,
output                      CPOL_O,CPHA_O,LSBFE_O,
output                      SPISWAI_O,
output [2:0]                SPR_O,SPPR_O,
output                      SPI_INTERRUPT_RQST_O,
output reg                  SEND_DATA_O,
output reg [WIDTH-1:0]      MOSI_DATA_O,
output [1:0]                SPI_MODE_O
);

reg  [WIDTH-1:0] tx_data_reg;       // APB-write-only and SPI-read-only  (TX side)
reg  [WIDTH-1:0] rx_data_reg;       // APB-read-only  and SPI-write-only (RX side)

reg  [7:0]       br_reg;
reg              spif_reg, sptef_reg;
reg              dr_pending;

// ---------------------------- CONTROL REGISTER 1 ----------------------------------
reg  [7:0]       control_reg1;
wire spie,spe,sptie,ssoe;
assign {spie,spe,sptie,MSTR_O,CPOL_O,CPHA_O,ssoe,LSBFE_O} = control_reg1;
// ----------------------------------------------------------------------------------

// ---------------------------- CONTROL REGISTER 2 ---------------------------------- 
reg  [7:0]       control_reg2;
wire modfen;
assign SPISWAI_O  = control_reg2[1];
assign modfen     = control_reg2[4];
// ----------------------------------------------------------------------------------

// ----------------------------- STATUS REGISTER ------------------------------------
wire [7:0]       status_reg;
wire modf;
assign modf = (MSTR_O ^ ssoe) & modfen & (!SS_I);
assign status_reg = {spif_reg, 1'b0, sptef_reg, modf, 4'b0};
// ----------------------------------------------------------------------------------

// ---------------------------- BAUD RATE REGISTER ---------------------------------- 
assign SPR_O  = br_reg[2:0];
assign SPPR_O = br_reg[6:4];
// ----------------------------------------------------------------------------------

// --------------------------- INTERRUPT GEN LOGIC ----------------------------------
assign SPI_INTERRUPT_RQST_O = (sptie && sptef_reg) || (spie && (spif_reg || modf));
//-----------------------------------------------------------------------------------
reg [1:0] APB_state, SPI_state;
localparam APB_IDLE=2'd0, APB_SETUP=2'd1, APB_ENABLE=2'd2;
localparam SPI_RUN=2'd0, SPI_WAIT=2'd1, SPI_STOP=2'd2;

assign SPI_MODE_O = SPI_state;
assign PREADY_O   = (APB_state==APB_ENABLE);
assign PSLVERR_O  = (APB_state==APB_ENABLE) && (~SS_I) && PWRITE_I;

localparam [7:0] cr2_mask = 8'b00011010;
localparam [7:0] br_mask  = 8'b01110111;

wire wr_en = PWRITE_I && (APB_state==APB_ENABLE);
wire rd_en = (!PWRITE_I) && (APB_state==APB_ENABLE);

wire cr1_write = wr_en && (PADDR_I==3'd0);
wire cr2_write = wr_en && (PADDR_I==3'd1);
wire br_write  = wr_en && (PADDR_I==3'd2);
wire dr_write  = wr_en && (PADDR_I==3'd5);   // -> tx_data_reg
wire dr_read   = rd_en && (PADDR_I==3'd5);   // -> rx_data_reg

// ---------------------------------- CR1 / CR2 / BR ------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin
    if (!PRESETn) 
    begin
        control_reg1 <= 8'd0;
        control_reg2 <= 8'd0;
        br_reg       <= 8'd0;
    end else begin
        if (cr1_write)
            control_reg1 <= PWDATA_I;
        if (cr2_write) 
            control_reg2 <= PWDATA_I & cr2_mask;
        if (br_write)  
            br_reg       <= PWDATA_I & br_mask;
    end
end

// ----------------------- TX DATA REGISTER : WRITTEN ONLY BY THE APB SYSTEM --------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin
    if (!PRESETn)
        tx_data_reg <= {WIDTH{1'b0}};
    else if (dr_write)                      // In Real SPI peripherals, if again software or APB writes a second byte befroe dr_pending has been has sent the tx DR data to shift_reg block
        tx_data_reg <= PWDATA_I;            // without checking SPTEF (DR empty flag : gets set after DR content is sent to mosi_data_o), the still queued first byte is lost. This is typical SPI
                                            // DR behaviour, APB must check if SPTEF==1 and then only must writing a new byte into DR
end

// ---------------------- DR (RX) contents updated with the data rceived by SPI ------------------------------
always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
        rx_data_reg <= {WIDTH{1'b0}};
    else if (RECEIVE_DATA_I && !SPI_state[1])
        rx_data_reg <= MISO_DATA_I;
end

// ----------------------- DR (TX) contents dispatched to shift_reg + SPTEF logic ----------------------------
always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) 
    begin
        dr_pending  <= 1'b0;
        sptef_reg   <= 1'b1;                // buffer starts empty
        SEND_DATA_O <= 1'b0;
        MOSI_DATA_O <= {WIDTH{1'b0}};
    end 
    else
    begin
        if (dr_write)
        begin
            dr_pending <= 1'b1;
            sptef_reg  <= 1'b0;                                 // buffer now full bcoz dr has been written
        end
        else if (dr_pending && SS_I && !SPI_state[1])           // Once DR (Tx) is written and dr_write=0, we can safely send it to MOSI_DATA_O       
        begin     
            MOSI_DATA_O <= tx_data_reg;
            SEND_DATA_O <= 1'b1;
            dr_pending  <= 1'b0;
            sptef_reg   <= 1'b1;                                // tx_data_reg empty again (Now Software or APB can write a new byte in Data REgister)
        end
        else
            SEND_DATA_O <= 1'b0;                

    end
end

// ----- SPIF : It precisely checks if i have received a new data (from SPI) that hasn't been read yet ----------
always @(posedge PCLK or negedge PRESETn) 
begin
    if (!PRESETn)
        spif_reg <= 1'b0;
    else begin
        if (RECEIVE_DATA_I && !SPI_state[1])
            spif_reg <= 1'b1;     // a new byte has just landed in rx_data_reg which hasn't been read yet
        else if (dr_read)
            spif_reg <= 1'b0;     // after it's read, we make SPIF =0 
    end
end

// --------------- PRDATA_O: address 5 now reads rx_data_reg ----------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin
    if (!PRESETn)
        PRDATA_O <= {WIDTH{1'b0}};
    else if (rd_en) 
    begin
        case (PADDR_I)
            3'd0: PRDATA_O <= control_reg1;
            3'd1: PRDATA_O <= control_reg2;
            3'd2: PRDATA_O <= br_reg;
            3'd3: PRDATA_O <= status_reg;
            3'd5: PRDATA_O <= rx_data_reg;                    // Processor / APB master will read the rx_data_reg always (what SPI has received)
            default: PRDATA_O <= {WIDTH{1'b0}};
        endcase
    end else
        PRDATA_O <= {WIDTH{1'b0}};
end

// ------------------------ SPI MODES FSM MODEL -------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        SPI_state <=SPI_RUN;
    end
    else
    begin
        case(SPI_state)
        SPI_RUN :
        begin
            if(!spe)
                SPI_state <=SPI_WAIT;
            else
                SPI_state <=SPI_RUN;
        end
        SPI_WAIT:
        begin
            if(SPISWAI_O)
                SPI_state <=SPI_STOP;
            else if(spe)
                SPI_state <=SPI_RUN;
            else
                SPI_state <=SPI_WAIT;
        end
        SPI_STOP:
        begin
            if(!SPISWAI_O)
                SPI_state <=SPI_WAIT;
            else if (spe)
                SPI_state <=SPI_RUN;
            else
                SPI_state <=SPI_STOP;
        end
        endcase
    end
end
// ------------------------------------------------------------------------------------------------------------------
// ------------------- APB SLAVE FSM MODEL  -------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        APB_state <=APB_IDLE;
    end
    else
    begin
        case(APB_state)
        APB_IDLE :
        begin
            if(PSEL_I && !PENABLE_I)
                APB_state <=APB_SETUP;
            else
                APB_state <=APB_IDLE;
        end
        APB_SETUP:
        begin
            if(PSEL_I && PENABLE_I)
                APB_state <=APB_ENABLE;
            else if(!PSEL_I)
                APB_state <=APB_IDLE;
            else
                APB_state <=APB_SETUP;
        end
        APB_ENABLE:
        begin
            if(!PENABLE_I)
                APB_state <=APB_SETUP;
            else if (!PSEL_I)
                APB_state <=APB_IDLE;
            else
                APB_state <=APB_ENABLE;
        end
        endcase
    end
end


function integer logb2;
    input integer value;
    integer i;
    begin
        value = value - 1;
        for (i = 0; value > 0; i = i + 1)
            value = value >> 1;
        logb2 = i;
    end
endfunction


endmodule