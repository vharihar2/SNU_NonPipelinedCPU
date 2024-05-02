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
*            Date                       By                                Change Notes
* ----------------------- ---------------------- ------------------------------------------
*  7th October 2023       Devyam Seal            default values were changed to 'zzz'
*   
*  8th October 2023       Aditi Sharma           default cases were added to case 
*                                                statements                  
*                                      
*  22nd February 2024     Aditi Sharma           Made calculations asynchronous
*/
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input clk,
    //input rst,
    output [7:0] Out,
    output [3:0] Flag,
    input [7:0] RN,
    input [7:0] OD,
    input [7:0] AC,
    input [7:0] opcode,
    input [2:0] stage
);

reg [7:0] A, B;
reg [3:0] inst;  
        
        

parameter [3:0] CP = 4'b0000;
parameter [3:0] AND = 4'b0001;
parameter [3:0] OR = 4'b0010;
parameter [3:0] XOR = 4'b0011;
parameter [3:0] CM = 4'b0100;
parameter [3:0] ADD = 4'b0101;
parameter [3:0] SUB = 4'b0110;
parameter [3:0] ADDR = 4'b0111;
parameter [3:0] SUBR = 4'b1001;

reg Carry, Zero, Parity, Sign; 
wire carry2;
wire [7:0] outFF;

initial
begin
    Carry <= 1'b0;
    Zero <= 1'b0;
    Parity <= 1'b0;
    Sign <= 1'b0;
    //Out <= 0;
end

assign outFF = (stage == 3'b000)? Out : outFF;

always @(posedge clk)
begin

    /*$monitor("%t, ALU RN in = is %b" , $time, RN);
    $monitor("%t, ALU OD in = is %b" , $time, OD);
    $monitor("%t, ALU out = is %b" , $time, Out);
    $monitor("%t, carry = is %b" , $time, carry2);
    $monitor("%t, inst = is %b" , $time, inst);
    $monitor("%t, A = is %b" , $time, A);
    $monitor("%t, B = is %b" , $time, B);*/
   
    
    
    Sign <= 1'b0;
    
    if(opcode[7:3] == 5'b00001)
        begin
            inst <= opcode[2:0];
        end
        
    else if(opcode[7:6] == 2'b01)
        begin
            inst <= opcode[5:3]; 
        end 
    else if(opcode[7:3] == 5'b10011)
        begin
            inst <= opcode[7:4];
        end           
        
    else
        begin
            inst <= 3'bzzz;
        end

    
     if (opcode[7:3] == 5'b00001)
        begin
            A <= AC;
            B <= OD;
        end
        
     else if (opcode[7:5] == 3'b010)
        begin
            A <= RN;
            B <= AC;
        end
        
     else if ((opcode[7:3] == 5'b01101) || (opcode[7:3] == 5'b01110) )
        begin
            A <= RN;
            B <= OD;
        end
        
     else if ((opcode[7:3] == 5'b01111) || (opcode[7:3] == 5'b10011))
        begin
            A <= RN;
            B <= AC;
        end
                  
     else
        begin
            A <= 8'b0;
            B <= 8'b0;
        end
        
        
     case (inst)
        
        CP:
            begin
                if(B<A)
                    begin
                        Carry <= 1'b1;
                        Sign <= 1'b0;
                    end
                else if(A==B)
                    begin
                        Sign <= 1'b1;
                        Carry <= 1'b0;
                    end
                else
                    begin
                        Sign <= 1'b0;
                        Carry <= 1'b0;
                    end
            end
            
      default :   $monitor("%t, ALU outFF = is %b" , $time, outFF);
    endcase

    Parity <= ^outFF;
    Zero <= ~(|outFF);
    
end       

 assign {carry2,Out}=  (inst == CM) ? {1'b0,~A} : (
                       (inst == AND)? {1'b0,A & B} : (
                       (inst == OR) ? {1'b0,A | B} : (
                       (inst == XOR)? {1'b0,A ^ B} : (
                       ((inst == ADD) || (inst == ADDR))?  (A + B) : (
                       ((inst == SUB) || (inst == SUBR))?  (A - B) : (
                       (opcode[7:3] == 5'b01111)? {1'b0,RN + AC} : (
                       (opcode == 8'b00000110)? {1'b0,AC << OD} : (
                       (opcode == 8'b00000111)? {1'b0,AC >> OD} : {1'b0,Out} ))))))));
                                              

assign Flag = {(Carry||carry2), Zero, Sign, Parity};

endmodule