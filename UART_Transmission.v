`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pratyai Chakrabarty
// 
// Create Date: 06.02.2025 14:55:33
// Design Name: 
// Module Name: UART_Transmission
// Project Name: UART_TX
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_Transmitter(
    input clk, //system clock
    input reset,    //system reset
    input [7:0]data, //data to be transmitted
    input transmit_data,  //trigger for transmitting new data
    output reg tx   //output pin of the UART
);

reg [3:0]bit_counter; //10 bits in one data frame
reg [13:0]baud_counter; //counting upto 10416, i.e 100Mhz/9600bps
reg [9:0]shift_reg;  //for shifting the bits during transmission
reg transmit;  //signal to notify that transmission is going on

//Baud_rate generation
parameter BAUD_RATE = 9600;
parameter CLK_FREQ = 100000000; 
parameter BAUD_DIV = CLK_FREQ/BAUD_RATE;

always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        tx <= 1;    //idle state
        transmit <= 0; //it is not transmitting data
        bit_counter <= 0; //initialize bit_counter
        baud_counter <= 0; //initialize baud_counter
        shift_reg <= 10'b1111111111;  //initialize shift reg with all bits high, so that when start bit is 0 the transmission can start 
    end
    else
    begin
        if(transmit)
        begin
            if(baud_counter == BAUD_DIV-1)  //to synchronize the transmission
            begin
                baud_counter <= 0;
                if(bit_counter < 10)  //start shifting out data
                begin
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_counter <= bit_counter+1;
                end
                else
                begin
                    transmit <= 0; //reset transmit to show transmission is complete
                    bit_counter <= 0; //reset bit_counter
                    tx <= 1; //return to idle state
                end
            end
            else
            begin
                baud_counter <= baud_counter+1;
            end
         end
         else if(transmit_data)
         begin
            transmit <= 1; //start transmission
            bit_counter <= 0; //reset bit_counter 
            shift_reg <= {1'b1, data, 1'b0}; //load the data
         end
    end
end
endmodule
