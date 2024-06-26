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
*            Date                  By                          Change Notes
* ----------------------- ---------------------- ------------------------------------------
*    26th October 2023          Aditi Sharma                  Base Code
*   
*   
*                                                                                
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module OperandRegister( input clk, 
                        input rst,
                        input r_or, w_or,
                        input [7:0] data,
                        output [7:0] out_or,
                        output [7:0] alu_out);
                        
reg [7:0] opr;
wire [7:0] opreg;

assign opreg = (w_or)? data : opr;

assign alu_out = opreg;

assign out_or = opreg;

initial
begin
    opr <= 8'bz;
end

always @(posedge clk)
begin
    //$monitor("%t, OR = %b" , $time, opreg);

    
    if(rst == 1'b1)
        begin
            opr <= 0;
        end    

    /*if(w_or == 1'b1)
    begin 
        opr <= data;
    end */
    
    opr <= opreg;

end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
 

endmodule
