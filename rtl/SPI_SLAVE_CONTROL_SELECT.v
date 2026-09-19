`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Created by : Chhandak Roy
// Create Date: 09.09.2026 00:00:35
// Module Name: SPI_SLAVE_CONTROL_SELECT
// Description: It generates the Slave select as output from the Baud rate generator
//              register and total width of data.
//////////////////////////////////////////////////////////////////////////////////


module SPI_SLAVE_CONTROL_SELECT
#(parameter WIDTH=8)
(
input               PCLK,
input               PRESETn,
input               MSTR_I,
input               SPISWAI_I,
input [1:0]         SPI_MODE_I,
input               SEND_DATA_I,
input [11:0]        BAUD_RATE_DIV_I,

output reg          RECEIVE_DATA_O,
output reg          SS_O  
);
 
wire [15:0] MAX= BAUD_RATE_DIV_I << logb2 (WIDTH);      // to avoid multiplication
reg [15:0]  count;
reg         START;
reg         END;

wire ABORT   = !MSTR_I || (SPI_MODE_I == 2'b10);
wire SCLK_ON = (SPI_MODE_I == 2'b00 || (SPI_MODE_I == 2'b01 && (!SPISWAI_I))) && MSTR_I;



always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        count           <= 16'd0;
        START           <= 1'b0;
        END             <= 1'b0;
        SS_O            <= 1'b1;
        RECEIVE_DATA_O  <= 1'b0;
    end
    else
    begin
        if(SCLK_ON)
        begin
            if(SEND_DATA_I)
            begin
                count   <=16'd1;
                START   <=1'b1;
                SS_O    <=1'b0;
            end
        end
        else if(ABORT)
        begin
            SS_O            <= 1'b1;
            RECEIVE_DATA_O  <= 1'b0;    
            count           <= 16'd0;
        end
        
        if(START && SCLK_ON)
        begin
            if(count < MAX)
            begin
                count   <= count +1;
                SS_O    <= 1'b0;
            end
            else
            begin
                START   <=1'b0;
                SS_O    <=1'b1;
                RECEIVE_DATA_O  <= 1'b1;    
                END             <= 1'b1;
            end    
            
        end
        
        if(END)
        begin
            RECEIVE_DATA_O  <= 1'b0;    
            END             <= 1'b0;                  
        end
        
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
