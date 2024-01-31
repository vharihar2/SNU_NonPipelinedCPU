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
*    8th November 2023          Aditi Sharma                      Base Code
*   
*   
*                                                                                
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module MidModule(from_memdata, from_memad, clk, rst, rbout, rcout, rdout, 
                 reout, rfout, rgout, rhout, riout, instruction, to_memdata, 
                 to_memad, RD, wr, rd_ab, wr_s, rd_s, areg, sp); //control signals & I/Os 
                                                                 // for memory block

input clk, rst;
input [7:0] from_memdata;
input [15:0] from_memad;
output [7:0] to_memdata;
output [15:0] to_memad;
output  RD, wr, rd_ab, wr_s, rd_s;
output [15:0] areg;
output [15:0] sp;
//output reg [7:0] rb, rc, rd ,re, rf, rg, rh, ri;

output [7:0] rbout, rcout, rdout ,reout, rfout, rgout, rhout, riout;


//wire [7:0] Rb, Rc, Rd ,Re, Rf, Rg, Rh, Ri;

output [7:0] instruction;
     
//control signals
wire r_or, w_or,w_ir,i_pc,i2_pc, w_pc, r_pc,p_ar, a_ar,r_a, 
     r_rn, w_rn, r_rp,w_a, wa_rn, r_sp, i_sp, d_sp, cl_fr, E, IF;
     
// busses     
wire [7:0] databus;
wire [15:0] addressbus; 

// data and address bus connections
wire [7:0] from_memdata, r_out, or_out, alu_out;
wire [15:0] rp_out, pc_out, from_memad; 

//wire connections
wire [3:0] Flags;
wire [7:0] or_ALU;
wire [7:0] ac_ALU;
wire [7:0] ir_out;
wire [15:0] pc_ar;
wire [3:0] flag_cu;
wire [7:0] opcode;


assign instruction = ir_out;   

/*initial
begin
    databus = 8'bz;
end  */  

/*always @(*)
begin
*/
 
 /*   rb = Rb;
    rc = Rc;
    rd = Rd;
    re = Re;
    rf = Rf;
    rg = Rg; 
    rh = Rh;
    ri = Ri;
    */
    //instruction = ir_out;
    
assign    opcode = ir_out;

assign    databus = (RD)? from_memdata :(
              (r_rn)? r_out     :(
              (r_a)?  r_out     :( //data_out for register array can be AC or RN
              (r_or)? or_out     : alu_out)));
              
assign    addressbus = (r_rp)? rp_out :(
                 (r_pc)? pc_out :(
                 (rd_ab | rd_s)? from_memad : 16'b0 ));
                 
assign    to_memdata = databus;
assign    to_memad = addressbus;  

//$monitor("at time, %t, DATABUS = %b", $time, databus);     
    
           
                           
//end                
always @(*)
begin
    $monitor("At time, %t, databus = %b" , $time, databus);
end    

ControlUnit control(RD, wr, rd_ab, wr_s, rd_s,r_or, w_or,w_ir,i_pc, 
                    i2_pc, w_pc, r_pc,p_ar, a_ar,r_a, r_rn, w_rn, r_rp, 
                    w_a, wa_rn, r_sp, i_sp, d_sp, cl_fr, E, IF, clk, opcode, rst);
                    
ALU Alu(
         .clk(clk),
         .Out(alu_out),
         .Flag(Flags),
         .RN(databus),
         .OD(or_ALU),
         .AC(ac_ALU),
         .opcode(opcode)
        ); 
        
OperandRegister  OpR( .clk(clk),
                      .rst(rst),
                      .r_or(r_or), 
                      .w_or(w_or),
                      .data(databus),
                      .out_or(or_out), 
                      .alu_out(or_ALU)
                     );                   
AddressRegister AR( .clk(clk),
                    .rst(rst),
                    .PC_in(pc_ar),
                    .AB_in(addressbus),
                    .P_ar(p_ar), 
                    .A_ar(a_ar),
                    .AdReg_out(areg)
                    
                  );
                                   
FlagRegister FR( .rst(rst),
                 .ALU_in(Flags),
                 .CL_f(cl_fr),
                 .cu_out(flag_cu)
                 
                );
                
InstructionRegister IR( .rst(rst),
                        .clk(clk),
                        .w_ir(w_ir),
                        .data(databus),
                        .out_ir(ir_out)
                        
                       );    
                       
ProgramCounter PC( .rst(rst),
                   .clk(clk),
                   .i_pc(i_pc), 
                   .i2_pc(i2_pc), 
                   .w_pc(w_pc), 
                   .r_pc(r_pc),
                   .address(addressbus),
                   .out(pc_out), 
                   .ar_out(pc_ar)   
                   
                  );  
                  
StackPointer SP( .clk(clk),
                 .rst(rst),
                 .I_sp(i_sp),
                 .D_sp(d_Sp),
                 .Mem_out(sp)  
                 
               );
               
RegisterArray RA( .rst(rst),
                  .data_in(databus),
                  .r_a(r_a),
                  .r_rn(r_rn),
                  .w_rn(w_rn),
                  .wa_rn(wa_rn),
                  .w_a(w_a),
                  .r_rp(r_rp),
                  .opcode(opcode),
                  .clk(clk),
                        //output reg [7:0] data_out, ac_out,
                  .data_out(r_out),
                  .addr_out(rp_out),
                  .ac_ALU(ac_ALU),
                  /*.rb(Rb),
                  .rc(Rc),
                  .rd(Rd),
                  .re(Re),
                  .rf(Rf),
                  .rg(Rg),
                  .rh(Rh),
                  .ri(Ri) */
                  
                  .rb(rbout),
                  .rc(rcout),
                  .rd(rdout),
                  .re(reout),
                  .rf(rfout),
                  .rg(rgout),
                  .rh(rhout),
                  .ri(riout) 
                        
                 );                                                    
                                                           
endmodule
