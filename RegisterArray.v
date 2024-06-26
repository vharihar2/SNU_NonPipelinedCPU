`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
* Copyright (c) 2023, Shiv Nadar University, Delhi NCR, India. All Rights
* Reserved. Permission to use, copy, modify and distribute this software for
* educational, research, and not-for-profit purposes, without fee and without a
* signed license agreement, is hereby granted, provided that this paragraph and
* the following two paragraphs appear in all copies, modifications, and
* distributions.
*
* IN NO EVENT SHALL SHIV NADAR UNIVERSITY BE LIABLE TO ANY PARTY FOR DIRECT,
* INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST
* PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE.
*
* SHIV NADAR UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT
* NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
* PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS PROVIDED "AS IS". SHIV
* NADAR UNIVERSITY HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
* ENHANCEMENTS, OR MODIFICATIONS.
*
* Revision History:
*            Date                   By                          Change Notes
* ----------------------- ---------------------- ------------------------------------------
*    23rd October 2023           Devyam Seal                    Base Code
*
*    2nd April 2024              Aditi Sharma             rst shifed inside always block 
*                                                         to prevent concurrent assignment  
*   
*                                                                                 
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module RegisterArray(   input rst,
                        input [7:0] data_in,
                        input r_a,r_rn,w_rn,wa_rn,w_a,r_rp,
                        input [7:0] opcode,
                        input clk,
                        //output reg [7:0] data_out, ac_out,
                        output [7:0] data_out,
                        output [15:0] addr_out,
                        output [7:0] ac_ALU,
                        output [7:0] rb,
                        output [7:0] rc,
                        output [7:0] rd,
                        output [7:0] re,
                        output [7:0] rf,
                        output [7:0] rg,
                        output [7:0] rh,
                        output [7:0] ri
                        
                        
                        );

reg [7:0] register [7:0];
reg [7:0] ac;
reg [7:0] rn_out;
//reg [7:0] a_out;
reg [15:0] pair;
reg [2:0] reg_sel;
reg [4:0] pair_sel;



initial
    begin
        ac <= 0;
        reg_sel <= 3'bz;
        pair_sel <= 5'bz;
        register[0]<= 0;
        register[1]<= 0;
        register[2]<= 0;
        register[3]<= 0;
        register[4]<= 0;
        register[5]<= 0;
        register[6]<= 0;
        register[7]<= 0;
    end
    
assign ac_ALU = ac;   
assign addr_out = pair; 
assign data_out = r_a? ac : register[reg_sel];
    
always @(posedge clk)
begin

  /*  if(rst == 1'b1)
    begin
       
        ac <= 0;
        register[0]<= 0;
        register[1]<= 0;
        register[2]<= 0;
        register[3]<= 0;
        register[4]<= 0;
        register[5]<= 0;
        register[6]<= 0;
        register[7]<= 0;
        
    end    */

    if (opcode[7:6] == 2'b11)
    begin
        pair_sel <= opcode[4:0];
    end

    else if(opcode[7:6] == 2'b10 || opcode[7:6] == 2'b01)
    begin
        reg_sel <= opcode[2:0];
    end   
    
    case(pair_sel)
        5'b00000: pair <= {register[0], register[1]};
        5'b00001: pair <= {register[0], register[2]};
        5'b00010: pair <= {register[0], register[3]};
        5'b00011: pair <= {register[0], register[4]};
        5'b00100: pair <= {register[0], register[5]};
        5'b00101: pair <= {register[0], register[6]};
        5'b00110: pair <= {register[0], register[7]};
        5'b00111: pair <= {register[1], register[2]};
        5'b01000: pair <= {register[1], register[3]};
        5'b01001: pair <= {register[1], register[4]};
        5'b01010: pair <= {register[1], register[5]};
        5'b01011: pair <= {register[1], register[6]};
        5'b01100: pair <= {register[1], register[7]};
        5'b01101: pair <= {register[2], register[3]};
        5'b01110: pair <= {register[2], register[4]};
        5'b01111: pair <= {register[2], register[5]};
        5'b10000: pair <= {register[2], register[6]};
        5'b10001: pair <= {register[2], register[7]};
        5'b10010: pair <= {register[3], register[4]};
        5'b10011: pair <= {register[3], register[5]};
        5'b10100: pair <= {register[3], register[6]};
        5'b10101: pair <= {register[3], register[7]};
        5'b10110: pair <= {register[4], register[5]};
        5'b10111: pair <= {register[4], register[6]};
        5'b11000: pair <= {register[4], register[7]};
        5'b11001: pair <= {register[5], register[6]};
        5'b11010: pair <= {register[5], register[7]};
        5'b11011: pair <= {register[6], register[7]};
        
        default : pair <= 16'b0;
    endcase
    
end    


    
always @(posedge clk)
begin

    //$monitor("%t, accumulator = %b" , $time, ac);
    if(rst == 1'b0)
    begin
    
        if(wa_rn)
        begin
            ac <= 0;
            register[0]<= 0;
            register[1]<= 0;
            register[2]<= 0;
            register[3]<= 0;
            register[4]<= 0;
            register[5]<= 0;
            register[6]<= 0;
            register[7]<= 0;
         end
    
        if (w_a)
        begin
            ac <= data_in;
        end
        if (w_rn)
        begin
            register[reg_sel] <= data_in;
        end
    end   
    
    else if(rst == 1'b1)
    begin
        ac <= 0;
        register[0]<= 0;
        register[1]<= 0;
        register[2]<= 0;
        register[3]<= 0;
        register[4]<= 0;
        register[5]<= 0;
        register[6]<= 0;
        register[7]<= 0;
    end    
end    

        assign rb = register[0];
        assign rc = register[1];
        assign rd = register[2];
        assign re = register[3];
        assign rf = register[4];
        assign rg = register[5];
        assign rh = register[6];
        assign ri = register[7];      

endmodule