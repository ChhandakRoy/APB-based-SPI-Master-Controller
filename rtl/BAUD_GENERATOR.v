`timescale 1ns / 1ps

//----------------------------------------------------------------------------
// Created By : Chhandak Roy
// Create Date: 02.09.2026 22:27:00
// Design Name: Serial clock generator
// Module Name: BAUD_GENERATOR
// Project Name: SPI
// Additional Comments: It Generates Flags and Sclk, Cpol and Cphas determines 
// at which edge of sclk will sampling/driving be done. Here, I have used 
// alternate edges for sampling and driving in this module here.
//-----------------------------------------------------------------------------

module BAUD_GENERATOR(

input        PCLK,
input        PRESETn,
input [1:0]  SPI_MODE_I,
input        SPISWAI_I,
input [2:0]  SPPR_I,
input [2:0]  SPR_I,
input        CPOL_I,
input        CPHA_I,
input        SS_I,
output reg   SCLK_O,
output reg   MISO_RCV_SCLKP_O,
output reg   MISO_RCV_SCLKN_O,
output reg   MOSI_SEND_SCLKP_O,
output reg   MOSI_SEND_SCLKN_O,
output[11:0] BAUD_RATE_DIV_O

);

reg    [11:0]   count;
reg    [11:0]     active_BRD;
wire   [3:0]      baud_div_1    = (SPPR_I+1);
wire   [8:0]      baud_div_2    = (1<<(SPR_I+1));

assign            BAUD_RATE_DIV_O = active_BRD;

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        SCLK_O            <=CPOL_I;
        count             <=12'd0;
        active_BRD        <= 12'd0;
    end
    else
    begin
        if(((!SPISWAI_I && (SPI_MODE_I==2'b01)) ||(SPI_MODE_I==2'b00)) && !SS_I )             // Sclk will only be generated when SPI is in run state or wait state and spiswai=0 and salve is selected.
        begin
            if (count == (BAUD_RATE_DIV_O/2) -1)
            begin
                SCLK_O  <=~SCLK_O;
                count   <=0;
            end
            else
            begin
                count   <=count+1;
            end
        end
        else if(SS_I)
        begin
            SCLK_O      <=CPOL_I;
            active_BRD  <=baud_div_1 * baud_div_2;
            count       <=12'd0;
            
        end   
    end

end

always@(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        MISO_RCV_SCLKP_O  <=1'b0;
        MOSI_SEND_SCLKN_O <=1'b0;
        MISO_RCV_SCLKN_O  <=1'b0;
        MOSI_SEND_SCLKP_O <=1'b0;
    end
    else if(((!SPISWAI_I && (SPI_MODE_I==2'b01)) ||(SPI_MODE_I==2'b00)) && !SS_I )
    begin
        if(count==(BAUD_RATE_DIV_O/2) -2)     
        begin
            case ({CPOL_I,CPHA_I})
            
            2'b00,2'b11:      // Sample at posedge drive at negedge
            begin
                if(SCLK_O==0)
                    MISO_RCV_SCLKP_O  <=1'b1;
                else
                    MOSI_SEND_SCLKN_O <=1'b1;  
            end
            
            2'b01,2'b10:      // Sample at negedge and drive at posedge
            begin
                if(SCLK_O==0)
                    MOSI_SEND_SCLKP_O <=1'b1;
                else
                    MISO_RCV_SCLKN_O  <=1'b1;
                
            end 
          
            endcase
        end
        else        // Make the Flags 0 immediately after 1 PCLK period
        begin
            MISO_RCV_SCLKP_O  <=1'b0;
            MOSI_SEND_SCLKN_O <=1'b0;
            MISO_RCV_SCLKN_O  <=1'b0;
            MOSI_SEND_SCLKP_O <=1'b0;
        
        end
    end
    else if (SS_I)
    begin
        MISO_RCV_SCLKP_O  <=1'b0;
        MOSI_SEND_SCLKN_O <=1'b0;
        MISO_RCV_SCLKN_O  <=1'b0;
        MOSI_SEND_SCLKP_O <=1'b0;
    end
end


endmodule
