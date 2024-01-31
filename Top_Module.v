`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2023 21:38:04
// Design Name: 
// Module Name: Top_Module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_Module(clk, rst, TestDat, TestAd, rbf, rcf, rdf ,ref, rff, rgf, rhf, rif, instructionout );

input clk, rst;
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
                 
Memory Mem(.out_data(from_memdata),
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
