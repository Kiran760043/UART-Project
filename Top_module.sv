////////////////////////////////////////////////////////////////////////////////////////////////////
// Design Name: UART EXAMPLE PROJECT
// Engineer: kiran
////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps


module top_module(clk, rst, Tx, din, d_out);

    input  logic clk;
    input  logic rst;
    input  logic din;
    output logic Tx;
    output logic [7:0] d_out;

    logic b_clk;
    logic tick;
    
    logic en_rx;
    logic en_tx;
    
    logic [3:0]a, op, b;
    logic sign;
    
    logic [3:0]LSB,MSB;
    logic [7:0]operand;
    logic move;


    cal      CAL   (.*);
    clk_gen  TK    (.*);
    uart_rx UART_R (.*);
    uart_tx UART_T (.clk(b_clk),.Dout(Tx),.*);//,.rst(rst), .en_tx(en_tx), .MSB(MSB), .LSB(LSB), .op(op), .en_rx(en_rx),.Dout(Tx));
    
    
    assign operand = (sign == 0) ? 8'h2B : 8'h2D;
        
    assign d_out = {MSB,LSB};
    
endmodule
