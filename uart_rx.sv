//////////////////////////////////////////////////////////////////////////////////////////////////
// Design Name: Oversampling for UART Receiver
// Engineer: kiran
// Reference: FPGA Prototyping by Verilog by Pong P. Chu
//////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module uart_rx(clk, rst, en_rx, tick, din, en_tx, a, op, b);

    input  logic clk;
    input  logic rst;
    input  logic en_rx;
    input  logic tick;
    input  logic din;
//    input  logic move;
    
    output logic en_tx;
    output logic [3:0] a, op, b;

    typedef enum logic[2:0] {idle,start, receive, stop, finish} FSM;
    FSM state, nxt_state;

    logic [3:0]ov_reg, ov_nxt;
    logic [3:0] d_reg,  d_nxt;

    logic [7:0]data_reg, data_nxt;
    
    logic [7:0]value_reg[2:0];
    logic [7:0]value_nxt[2:0];
    logic [1:0]cnt_reg, cnt_nxt;
    
    logic en_tx_reg,en_tx_nxt;
     


    always_ff@(posedge clk, posedge rst)
        begin
            if(rst)begin
                state   <= idle;
                ov_reg  <= 0;
                d_reg   <= 0;
                cnt_reg <= 0;
                data_reg<= 0;
            end else begin
                if(en_rx==1) begin
                    state   <= nxt_state;
                    ov_reg  <= ov_nxt;
                    d_reg   <= d_nxt;
                    cnt_reg <= cnt_nxt;
                    data_reg<=data_nxt;
                 end else begin
                    state   <= idle;
                    ov_reg  <= 0;
                    d_reg   <= 0;
                    cnt_reg <= 0;
                    data_reg<= 0;                
                end
            end
        end
        
    always_ff@(posedge clk, posedge rst)
        begin
            if(rst)begin
                value_reg <= '{default:0};
                a  <= 0;
                op <= 0;
                b  <= 0;
            end else begin
                value_reg <= value_nxt;
                if(state==finish)begin
                    a  <= value_reg[0][3:0];
                    op <= value_reg[1][3:0];
                    b  <= value_reg[2][3:0];
                end else begin
                    a  <= a;
                    op <= op;
                    b  <= b;
                end
            end
        end
        
    always@(posedge clk, posedge rst)    
        begin
            if(rst || state==~finish)
                en_tx_reg <= 0;
            else
                en_tx_reg <=en_tx_nxt;
        end
        
    always@*
        begin
            nxt_state = state;
            ov_nxt    = ov_reg;
            d_nxt     = d_reg;
            data_nxt  = data_reg;
            cnt_nxt   = cnt_reg;
            value_nxt = value_reg;
            en_tx_nxt = en_tx_reg;       
            case(state)
                idle    :   begin
                                if(tick)begin
                                    en_tx_nxt = 0; 
                                    if(din==0)begin
                                        nxt_state = start;
                                        ov_nxt    = 0;
                                    end
                                end else begin
                                    nxt_state = idle;
                                end
                            end
                start   :   begin    
                                if(tick)begin
                                    ov_nxt = ov_reg + 1;
                                    if(ov_reg == 8)begin
                                        nxt_state = receive;
                                        d_nxt     = 0;
                                    end
                                end else begin
                                    nxt_state = start;
                                end
                            end
                receive :   begin
                                if(tick)begin
                                    if(ov_reg == 8)begin
                                        data_nxt = {din, data_reg[7:1]};
                                        if(d_reg==7)
                                            nxt_state = stop;
                                        else
                                            d_nxt = d_reg + 1;
                                    end
                                end else begin
                                    ov_nxt = ov_reg + 1;
                                end
                            end
                stop    :   begin
                                if(tick)begin
                                    if(ov_reg == 8)begin
                                        value_nxt[cnt_reg] = data_reg;
                                        cnt_nxt            = cnt_reg + 1;
                                        if(cnt_reg == 2)
                                            nxt_state = finish;
                                        else
                                            nxt_state = idle;
                                    end else begin
                                        nxt_state = stop;
                                    end
                                end else begin
                                    ov_nxt = ov_reg +1;
                                end
                            end
                finish   : begin
                              if(tick)begin
                                    en_tx_nxt = 1;
//                                    if(move==1)begin
//                                        nxt_state = idle;
//                                    end else begin
//                                        nxt_state = finish;
//                                    end
//                              end else begin
//                                nxt_state = finish;
                              end
                           end                           
            endcase
        end

    assign en_tx = en_tx_reg;
    
endmodule
