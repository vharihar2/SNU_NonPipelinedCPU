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
*   23rd October 2023            Aditi Sharma                      Base Code
*
*   2nd April 2024               Aditi Sharma             rst shifed inside always block 
*                                                         to prevent concurrent assignment
*   
*   
*                                                                                
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////

module InstructionRegister(
    input rst,
    input clk,
    input w_ir,
    input [7:0] data,
    output [7:0] out_ir);

reg [7:0] ir;
//reg skip;

assign out_ir = ir;


initial
begin
    ir <= 8'bz;
end

/*always @(posedge clk)
begin

    if(rst == 1'b1)
    begin
        ir <= 8'b0;
    end    
   
end*/


always @(posedge clk)
begin
    
    if(w_ir == 1'b1 & rst == 1'b0)
    begin 
        ir <= data;
    end
    else if(rst == 1'b1)
    begin
        ir <= 8'b0;
    end    
    
    //$monitor("%t, IR = %b", $time, ir);
end        
 
endmodule