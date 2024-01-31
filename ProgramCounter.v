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
*          Date                     By                          Change Notes
* ----------------------- ---------------------- ------------------------------------------
*   29th October 2023             Aditi Sharma                     Base Code
*   
*   
*                                                                                
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter(input rst,
                      input clk,
                      input i_pc, i2_pc, w_pc, r_pc,
                      input [15:0] address,
                      output [15:0] out, 
                      output [15:0] ar_out);
                      
reg [15:0] pc;

initial
begin
    pc = 16'b0;
    //ar_out = 16'b0;
   // out = 16'b0;
end       


assign ar_out = pc;
assign out = pc;
 
always @(posedge clk)
begin

    $monitor("%t, PC = %b", $time, pc);
    //ar_out <= pc; //direct connection with address register
    
    if(rst == 1'b1)
    begin
        pc = 0;
    end    
    
    if(i_pc == 1'b1)
    begin
        pc = pc + 1'b1;
    end
    
    if(i2_pc == 1'b1)
    begin
        pc = pc + 2;
    end
    
    if(w_pc == 1'b1)
    begin
        pc = address;
    end            
    
/*    if(r_pc == 1'b1)
    begin
        out = pc;
    end    
    */
end        
                   
endmodule
