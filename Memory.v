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
             
reg [7:0] mem[59999:0];
reg [15:0] stack_mem[3999:0];
integer i;


initial
begin
    for(i = 0 ; i<= 59999; i = i+1)
    begin
        mem[i] = 8'b0;
    end
    
    for( i = 0; i<=3999; i = i+1)
    begin
        stack_mem[i] = 16'b0;
    end    

 //   out_data = 8'b0;
 //   out_address = 16'b0;   
end
//** making all outputs asynchronous
assign out_data = mem[areg];
assign out_address = rd_ab? {mem[areg], mem[areg + 1]} : stack_mem[sp];
    
    
always @(*)
begin
    
    mem[TestAd] = TestDat;
    $monitor("at time, %t, m0 = %b", $time, mem[0]);
    $monitor("at time, %t, m1 = %b", $time, mem[16'b0000000000000001]);
    $monitor("at time, %t, m2 = %b", $time, mem[16'b0000000000000010]);
    $monitor("at time, %t, m3 = %b", $time, mem[16'b0000000000000011]);
    $monitor("at time, %t, m4 = %b", $time, mem[16'b0000000000000100]);
    $monitor("at time, %t, m4 = %b", $time, mem[16'b0000000010000000]);
    $monitor("at time, %t, jumpmem = %b", $time, mem[16'b1000000000000000]);
    $monitor("at time, %t, STACK = %b", $time, stack_mem[1]);
    

    
    if(wr == 1)
    begin
        mem[areg] <= data ;
    end 
    
    
    if(wr_s == 1)
    begin
        stack_mem[sp] <= address;
    end 
    
    
end 

// add program to memory for execution. 

// * Probably something wrong with how TestAd and TestDat is happening. 
 
endmodule
