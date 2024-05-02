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
*            Date                    By                        Change Notes
* ----------------------- ---------------------- ------------------------------------------
*    22nd October 2023           Aditi Sharma                     Base Code
*   
*   
*                                                                                 
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module Memory(
             output [7:0] out_data,
             output [15:0] out_address,
             input [7:0] data,
             input [15:0] address,
             input rd, wr, rd_ab, wr_s, rd_s,
             input [15:0] areg,
             input [15:0] sp,
             input [15:0] TestAd,
             input [7:0] TestDat,
             input clk 
             );
             
reg [7:0] mem[60000:0];

reg [15:0] stack_mem [4000:0];

//** making all outputs asynchronous
assign out_data = mem[areg];
assign out_address = rd_ab? {mem[areg+1], mem[areg + 2]} : stack_mem[sp];

//assign out_data = tempdat[0];
//assign out_address = rd_ab? {tempdat[1], tempdat[2]} : tempad[0];
    
       
always @(*)
begin
    
    mem[TestAd] <= TestDat;
    
    if(wr == 1)
    begin
        mem[areg] <= data ;
    end 
    
    
    if(wr_s == 1)
    begin
        stack_mem[sp] <= address;
    end 
   
            
    
  
    //tempdat[0] <= mem[areg];
    //tempdat[1] <= mem[areg + 1];
    //tempdat[2] <= mem[areg + 2];
    //tempad [0] <= stack_mem[sp];
    
    
end 
 
endmodule