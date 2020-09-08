////////////////////////////////////////////////////////////////////////////////////////////////////
// Design Name: UART Transmitter protocol
// Engineer: kiran
////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps


module uart_tx(clk,rst,en_tx,MSB,LSB,operand,en_rx,Dout);

    input  logic clk;
    input  logic rst;
    input  logic en_tx;
    input  logic [3:0]MSB,LSB;
    input  logic [7:0]operand;

//    output logic move;
    output logic en_rx;
    output logic Dout;
        
    typedef enum logic[3:0]{idle,start,trans,stop,finish,idle1,start1,trans1,stop1,finish1} FSM;
    FSM state, nxt_state;

    logic busy;
    
    logic [7:0]dval_reg,dval_nxt;
    logic [3:0]count;

    logic [7:0] array[0:58];
    logic [6:0]step_up;
    
    logic [7:0]data_arr[0:4];// = {8'h3D,operand,{4'h3,MSB},{4'h3,LSB},8'h0A};
    logic [7:0]data_reg,data_nxt;
    logic [3:0]data_inc;

    
    initial begin
        $readmemh("ascii.mem",array);
    end
    
    always_ff@(posedge clk, posedge rst)
        begin
            if(rst)begin
                data_arr   <= '{default:0};     
            end else begin
                data_arr[0] <= 8'h3D;
                data_arr[1] <= operand;
                data_arr[2] <= {4'h3,MSB};
                data_arr[3] <= {4'h3,LSB};
                data_arr[4] <= 8'h0A;
            end
        end
    
    always_ff@(posedge clk, posedge rst)
        begin
            if (rst) begin
                state    <= idle;
                dval_reg <= 0;
            end else begin
                state <= nxt_state;
                if(state==trans)
                    dval_reg <= dval_reg >> 1;
                else
                    dval_reg<=dval_nxt;
            end
        end

    always@(posedge clk, posedge rst)
        begin
            if (rst || step_up == 59) begin   //59
                count  <= 0;
                step_up<= 0;
            end else begin
            
                if(state==stop)
                    step_up <= step_up + 1;
                else
                    step_up <= step_up;
                    
                if(state==trans || state==trans1) 
                    count <= count + 1;
                else
                    count <= 0;
            end
        end
    
    always@(posedge clk, posedge rst)
        begin
            if(rst || data_inc == 5)begin
                data_inc <= 0;
                data_reg <= 0;
            end else begin
                if(state==stop1)
                    data_inc <= data_inc + 1;
                else
                    data_inc <= data_inc;
                    
                if(state==trans1)
                    data_reg <= data_reg >> 1;
                else
                    data_reg <= data_nxt;
            end
        end
        

     always@ *
        begin
            nxt_state = state;
            busy      = 0;
            Dout      = 1;
            en_rx     = 0;
            dval_nxt  = array[step_up];
            data_nxt  = data_arr[data_inc];
            case(state)
                idle :  begin
                            Dout      = 1;
                            nxt_state = start;
                        end
                start:  begin
                            Dout      = 0;
                            busy      = 1; 
                            nxt_state = trans;   
                        end
                trans:  begin
                            Dout  = dval_reg[0];
                            busy  = 1;
                            if (count == 7) begin
                                nxt_state = stop;
                            end else begin
                                nxt_state = trans;
                            end
                        end
                stop :  begin
                            Dout      = 1;
                            busy      = 0;
                            if(step_up == 58)   //58
                                nxt_state = finish;
                            else
                                nxt_state = idle;
                        end
              finish : begin
                            Dout      = 1;
                            nxt_state = finish;
                            en_rx     = 1;
                            if(en_tx == 1)begin
                                nxt_state = idle1;
                            end
                        end
                        
               idle1 :  begin
                            Dout      = 1;
                            nxt_state = start1;
                        end
               start1:  begin
                            Dout      = 0;
                            busy      = 1; 
                            nxt_state = trans1;   
                        end
               trans1:  begin
                            Dout  = data_reg[0];
                            busy  = 1;
                            if (count == 7) begin
                                nxt_state = stop1;
                            end else begin
                                nxt_state = trans1;
                            end
                        end
               stop1 :  begin
                            Dout      = 1;
                            busy      = 0;
                            if(data_inc == 4)   
                                nxt_state = finish1;
                            else
                                nxt_state = idle1;
                        end
             finish1 : begin
                            Dout      = 1;
                            nxt_state = idle;
                        end
                        
            endcase
        end
endmodule
