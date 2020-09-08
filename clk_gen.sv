////////////////////////////////////////////////////////////////////////////////////////////////////
// Design Name: Clock Generation for UART Receiver
// Engineer: kiran
// Refence: counter = (clk/baud rate*16) => (100Mhz/BR*16) {BR=115200}
////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module clk_gen(clk, rst, b_clk, tick);

    input  logic clk;
    input  logic rst;

    output logic b_clk;
    output logic tick;


    logic [9:0] br = 10'd870;
    logic [9:0] br_cnt = 10'd000;              //counter for Baud clock

    logic [5:0] tick_v = 6'd55;
    logic [5:0] t_cnt  = 6'd00;             //counter for tick generation


    always_ff@(posedge clk, posedge rst)
        begin
            if(rst || br_cnt == br) begin
                br_cnt <= 0;
            end else begin
                br_cnt <= br_cnt + 1;
            end
        end

//    assign b_clk = (br_cnt < br/2) ? 1'b0 : 1'b1 ;
    
    always@(posedge clk)
        begin
            if(br_cnt < br/2) 
                b_clk <= 0;
            else
                b_clk <= 1;
        end
        
        
    always_ff@(posedge clk, posedge rst)
        begin
            if(rst || t_cnt == tick_v) begin
                t_cnt <= 0;
            end else begin
                t_cnt <= t_cnt + 1;
            end
        end

    assign tick = (t_cnt == tick_v) ? 1'b1 : 1'b0 ;

endmodule
