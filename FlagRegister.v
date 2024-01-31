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
*          Date                    By                           Change Notes
* ----------------------- ---------------------- ------------------------------------------
*    31st October 2023          Devyam Seal                         Base Code
*   
*   
*                                                                                
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module FlagRegister(input [3:0] ALU_in,
                    input rst,
                    input CL_f,
                    output [3:0] cu_out);

reg [3:0] FlagArray;

initial                         // Initialising
begin
    FlagArray[0] = 1'b0;
    FlagArray[1] = 1'b0;
    FlagArray[2] = 1'b0;
    FlagArray[3] = 1'b0;
end

assign cu_out = FlagArray;

always @(*)
begin

    if(rst == 1'b1)
    begin
        FlagArray = 0;
    end    

    if  (CL_f == 1'b1)  // Control signal to clear flags
        begin
            FlagArray[0] = 1'b0;
            FlagArray[1] = 1'b0;
            FlagArray[2] = 1'b0;
            FlagArray[3] = 1'b0;
        end

    FlagArray[0] = ALU_in[0];  // Getting flag data from ALU
    FlagArray[1] = ALU_in[1];
    FlagArray[2] = ALU_in[2];
    FlagArray[3] = ALU_in[3];

   // cu_out <= FlagArray;  // Sending flags to control unit
end
endmodule
