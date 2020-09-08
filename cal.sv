//////////////////////////////////////////////////////////////////////////////////////////////////
// Design Name: 4-bit BCD Calculator Design for UART Receiver
// Engineer: kiran
// Operations: Add, Sub, Mul and Div
//////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps


module cal(a, op, b, sign, LSB, MSB);

    input  logic [3:0] a;
    input  logic [3:0] op;
    input  logic [3:0] b;
  
    output logic [3:0] LSB, MSB;
    output logic sign;
    
    logic [7:0] temp,result;

    
    assign  temp  = (op==10) ? a * b : (op==11) ? a + b : (op==13) ?  a - b : (op==15) ? a / b : 0;
    
    assign result = (temp[7] == 1) ? ~(temp) + 1 : temp;
    
    assign  sign  = (temp[7] == 1) ? 1 : 0;
    
    assign LSB = (result % 10) ;
    assign MSB = (result /10) % 10; 
    

endmodule
