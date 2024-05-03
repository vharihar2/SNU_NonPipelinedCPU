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
*   31st October 2023            Devyam Seal                       Base Code
*   
*   
*                                                                                
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module Top_Module(clkvga, clk, rst, TestDat, TestAd, rbf, rcf, rdf ,ref, rff, rgf, rhf, rif, instructionout );

input clkvga, clk, rst;
input  [7:0] TestDat;
input  [15:0] TestAd;
output [7:0] rbf, rcf, rdf ,ref, rff, rgf, rhf, rif, instructionout;

wire [7:0] to_memdata, from_memdata;
wire [15:0] to_memad, from_memad;
wire RD; 
wire wr, rd_ab, wr_s, rd_s;
wire [15:0] areg;
wire [15:0] sp; 

MidModule  MM(
               .rbout(rbf),
               .rcout(rcf),
               .rdout(rdf), 
               .reout(ref), 
               .rfout(rff), 
               .rgout(rgf), 
               .rhout(rhf), 
               .riout(rif), 
               .instruction(instructionout), 
               .to_memdata(to_memdata), 
               .to_memad(to_memad), 
               .RD(RD), 
               .wr(wr), 
               .rd_ab(rd_ab), 
               .wr_s(wr_s),
               .rd_s(rd_s), 
               .areg(areg), 
               .sp(sp), 
               .from_memdata(from_memdata), 
               .from_memad(from_memad), 
               .clk(clk), 
               .rst(rst)
                );
                 
Memory Mem(.clkvga(clkvga),
           .out_data(from_memdata),
           .out_address(from_memad),
           .data(to_memdata),
           .address(to_memad),
           .rd(RD), 
           .wr(wr), 
           .rd_ab(rd_ab), 
           .wr_s(wr_s), 
           .rd_s(rd_s),
           .areg(areg),
           .sp(sp),
           .TestAd(TestAd),
           .TestDat(TestDat),
           .clk(clk)
                            
         );


endmodule