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
*            Date                  By                       Change Notes
* ----------------------- ---------------------- ------------------------------------------
*     29th October 2023         Devyam Seal                  Base Code
*   
*   
*                                                                                
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module AddressRegister( input clk,
                        input rst,
                        input [15:0] PC_in,
                        input [15:0] AB_in,
                        input P_ar, A_ar,
                        output [15:0] AdReg_out);
   
reg [15:0] ADR;                        
initial
begin
ADR <= 16'b0;
end


assign  AdReg_out = (P_ar)? PC_in :(
                 (A_ar)? AB_in  : ADR );

always @(posedge clk)
begin

    if(rst == 1'b1)
    begin
        ADR <= 0;
    end    
    
    $monitor("%t, AR = %b" , $time, AdReg_out);
    ADR <= AdReg_out;
    
end               
endmodule
