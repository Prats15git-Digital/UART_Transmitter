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


module UART_Transmitter_tb;
    reg clk; //system clock
    reg reset;    //system reset
    reg [7:0]data; //data to be transmitted
    reg transmit_data;  //trigger for transmitting new data
    wire tx;   //output pin of the UART

UART_Transmitter dut (.clk(clk),.reset(reset),.data(data),.transmit_data(transmit_data),.tx(tx));

always
begin
    #5 clk <= ~clk;
end

initial 
begin
        // Initialize signals
        clk = 0;
        reset = 0;
        data = 8'b00000000;  // Start with zero data
        transmit_data = 0;
        
        #10 reset = 1;    // Assert reset
        #10 reset = 0;    // Deassert reset
        
        //Test case 1: Transmit 8-bit data 0x55 (01010101)
        #10 data = 8'h55;  // Load data to transmit
        transmit_data = 1;    // Trigger data transmission
        #100 transmit_data = 0;  // End transmission trigger
        #200;  // Wait for transmission to complete
        
        // Test case 2: Transmit 8-bit data 0xFF (11111111)
        #10 data = 8'hFF;
        transmit_data = 1;
        #100 transmit_data = 0;
        #200;
        $stop;
end
endmodule



