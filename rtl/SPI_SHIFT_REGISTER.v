`timescale 1ns / 1ps

//---------------------------------------------------------------------------------------------------------
/* Create Date: 04.09.2026 00:58:51
 Name: Chhandak Roy 
 Module Name: BLOCK 2:SPI_SHIFT_REGISTER
 DESCRIPTION : The shift regsiter block is for the sole purpose of receiving and sending data bits serially,
 it does so with help of 4 flags (2 send and 2 receive) which comes from BLOCK 1 (Baud rate geenrator block).
 This synchronized the data transfer, it also received permission from APB_slave interface (BLOCK 3) and also
 APB_slave_select (BLOCK 4) before and after data transfer.
 */
//---------------------------------------------------------------------------------------------------------
 

module SPI_SHIFT_REGISTER
# (parameter WIDTH=8 )
(
input               PCLK,
input               PRESETn,
input               CPOL_I,
input               CPHA_I,
input               SS_I,
input               SEND_DATA_I,
input               LSBFE_I,
input [WIDTH-1:0]   DATA_MOSI_I,
input               MISO_I,
input               RECEIVE_DATA_I,
input               MISO_RCV_SCLKP_I,
input               MISO_RCV_SCLKN_I,
input               MOSI_SEND_SCLKP_I,
input               MOSI_SEND_SCLKN_I,
output [WIDTH-1:0]  DATA_MISO_O,
output              MOSI_O

);

reg [WIDTH-1:0]              Tx_shift_reg;          // Tx reg will receive the data from DR from APB slave
                                                    // when send_data_i=1 via data_mosi_i , this is what we have to sent through mosi (accdng to lsbfe)
reg [WIDTH-1:0]              Rx_shift_reg;          // Rx reg will receive data visa mios_i bit by bit wrt lsbfe
                                                    // After completely receiving when rcv_data_i =1 it will pass it to APB slave via 8 bit data_mosi_0

reg [logb2(WIDTH):0]         bitcnt1,bitcnt2;       // For keeping a track as to how many bits has been transferred

reg                          Tx_status,Rx_status;   // To keep at track of completion of Tx and Rx 

// Both outputs have been Used as Wire for immediate updation
assign MOSI_O       = LSBFE_I ? Tx_shift_reg[0]:Tx_shift_reg[WIDTH-1];
assign DATA_MISO_O  = RECEIVE_DATA_I ? Rx_shift_reg : {WIDTH{1'b0}};

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        Tx_shift_reg <= {WIDTH{1'b0}};
        Rx_shift_reg <= {WIDTH{1'b0}};
        Tx_status    <= 1'b0;
        Rx_status    <= 1'b0;
    end
    else
    begin
        if(SS_I)                // NO Transmission happening, initialize Values
        begin
            Tx_status           <=1'b0;
            Rx_status           <=1'b0;
            if(SEND_DATA_I)
                Tx_shift_reg    <=DATA_MOSI_I;
                
            bitcnt1            <=5'd0;
            bitcnt2            <=5'd0;         
        end
        else                                     // Transfer of data begins as soon as SS_I==0
        begin
            if(CPOL_I == CPHA_I)
            begin
                if(LSBFE_I)                      // LSBFE = 1 : LSB is sent first 
                begin
                    if(MOSI_SEND_SCLKN_I)        // Drive/send MOSI at negedge of SCLK
                    begin
                        if(bitcnt1 < WIDTH-1)
                        begin
                            Tx_shift_reg <=Tx_shift_reg >> 1;
                            bitcnt1      <=bitcnt1 +1;
                        end
                        if(bitcnt1 == WIDTH-2)
                            Tx_status    <=1'b1;
                    end
                    if(MISO_RCV_SCLKP_I)         // Sample/receive from MISO at posedge of SCLK
                    begin
                        if(bitcnt2 < WIDTH)
                        begin
                            Rx_shift_reg <={MISO_I,Rx_shift_reg[WIDTH-1:1]}; 
                            bitcnt2      <=bitcnt2 +1;
                        end
                        if(bitcnt2 == WIDTH-1)
                            Rx_status   <=1'b1;
                    end
                end
                else                             // LSBFE = 0 : MSB will be sent first
                begin
                    if(MOSI_SEND_SCLKN_I)
                    begin
                        if(bitcnt1 < WIDTH-1)
                        begin
                            Tx_shift_reg <=Tx_shift_reg << 1;
                            bitcnt1      <=bitcnt1 +1;
                        end
                        if(bitcnt1 == WIDTH-2)
                            Tx_status    <=1'b1;
                    end
                    if(MISO_RCV_SCLKP_I)
                    begin
                        if(bitcnt2 < WIDTH)
                        begin
                            Rx_shift_reg <={Rx_shift_reg[WIDTH-2:0], MISO_I};
                            bitcnt2      <=bitcnt2+1; 
                        end
                        if(bitcnt2 == WIDTH-1)
                            Rx_status    <=1'b1;
                    end
                end
            end
            else
            begin                                // When CPOL != CPHA
                if(LSBFE_I)                      // LSBFE=1 : Send LSB first
                begin
                    if(MOSI_SEND_SCLKP_I)
                    begin
                        if(bitcnt1 < WIDTH-1)
                        begin
                            Tx_shift_reg <=Tx_shift_reg >> 1;
                            bitcnt1      <=bitcnt1 +1;
                        end
                        if(bitcnt1== WIDTH-2)
                            Tx_status    <=1'b1;
                    end
                    if(MISO_RCV_SCLKN_I)
                    begin
                        if(bitcnt2 < WIDTH)
                        begin
                            Rx_shift_reg <={MISO_I,Rx_shift_reg[WIDTH-1:1]}; 
                            bitcnt2      <=bitcnt2 +1;
                        end
                        if(bitcnt2 == WIDTH-1)
                            Rx_status   <=1'b1;
                    end
                end
                else                    // LSBFE = 0 : MSB will be sent first
                begin
                    if(MOSI_SEND_SCLKP_I)
                    begin
                        if(bitcnt1 < WIDTH-1)
                        begin
                            Tx_shift_reg <=Tx_shift_reg << 1;
                            bitcnt1      <=bitcnt1 +1;
                        end
                        if(bitcnt1 == WIDTH-2)
                            Tx_status    <=1'b1;
                    end
                    if(MISO_RCV_SCLKN_I)
                    begin
                        if(bitcnt2 < WIDTH)
                        begin
                            Rx_shift_reg <={Rx_shift_reg[WIDTH-2:0], MISO_I}; 
                            bitcnt2      <=bitcnt2 +1;
                        end
                        if (bitcnt2 == WIDTH-1)
                            Rx_status   <=1'b1; 
                    end
                end
            end
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
