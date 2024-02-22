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
*  7th October 2023       Devyam Seal            default values were changed to ‘zzz’
*   
*  8th October 2023       Aditi Sharma           default cases were added to case 
*                                                statements                  
*                                      
*   
*/
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input clk,
    //input rst,
    output reg [7:0] Out, //ALU output
    output [3:0] Flag, // Flag register
    input [7:0] RN, // Register Number
    input [7:0] OD, // Operand
    input [7:0] AC, // Accumulator
    input [7:0] opcode // opcode
);

    reg [7:0] A, B; // Variables to assign RN/OD/AC
    reg [2:0] inst; // Instruction  
        
        

    parameter [2:0] CP = 3'b000; // Compare based on OPCODE
    parameter [2:0] AND = 3'b001; // AND based on OPCODE
    parameter [2:0] OR = 3'b010; // OR based on OPCODE
    parameter [2:0] XOR = 3'b011; // XOR based on OPCODE
    parameter [2:0] CM = 3'b100; // Complement based on OPCODE
    parameter [2:0] ADD = 3'b101; // ADD based on OPCODE
    parameter [2:0] SUB = 3'b110; // SUB based on OPCODE

reg Carry, Zero, Parity, Sign; // Flag bits

initial  // Initialising Flag bits
begin
    Carry <=0;
    Zero <= 0;
    Parity <= 0;
    Sign <= 0;
    Out <= 0;
end


always @(posedge clk)
    begin                            // Assigning opcode bits needed to decode instruction based on the type of instruction (One Register/Two Register/ Zero Register)
    if(opcode[7:3] == 5'b00001)
        begin
            inst <= opcode[2:0];
        end
        
    else if(opcode[7:6] == 2'b01)
        begin
            inst <= opcode[5:3]; 
        end
        
    else
        begin
            inst <= 3'bzzz;
        end

    
        if (opcode[7:3] == 5'b00001)  // Assigning variables to be used by ALU based on instruction
        begin
            A <= AC;
            B <= OD;
        end
        
     else if (opcode[7:5] == 3'b010)
        begin
            A <= RN;
            B <= AC;
        end
        
     else if (opcode[7:5] == 3'b011)
        begin
            A <= RN;
            B <= OD;
        end
        
     else
        begin
            A <= 8'b0;
            B <= 8'b0;
        end
end

always @(*)
begin

    $monitor("%t, ALU RN in = is %b" , $time, RN);
    $monitor("%t, ALU OD in = is %b" , $time, OD);
    $monitor("%t, ALU out = is %b" , $time, Out);
    

    Sign <= 1'b0;
 

    case (inst)  // Defining Instructions
        CM: 
            begin
                Out <= ~A;
                Carry <= 1'b0;
            end
        AND:
            begin
                Out <= A & B;
                Carry <= 1'b0;
            end
        OR: 
            begin
                Out <= A | B;
                Carry <= 1'b0;
            end
        XOR:
            begin
                Out <= A ^ B;
                Carry <= 1'b0;
            end
        ADD:
            begin
                {Carry, Out} <= A + B;
            end
        SUB:
            begin
                {Sign, Out} <= A - B;
            end
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
    endcase

    case (opcode[7:3])  // Defining ADIR
        5'b01111: Out <= RN + AC;
    endcase

    case (opcode)              // Defining Rotate instructions
        8'h6: Out <= AC << OD;
        8'h7: Out <= AC >> OD;
    endcase

    Parity <= ^Out;  // Defining parity
    Zero <= ~(|Out); // Defining Zero
    

end

    assign Flag = {Carry, Zero, Sign, Parity};  // Assigning Flag bits to Flag Register

endmodule
