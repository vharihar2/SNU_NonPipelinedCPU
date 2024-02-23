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
* Revision History:
*            Date                       By                                Change Notes
* ----------------------- ---------------------- ------------------------------------------
*  8th October 2023         Aditi Sharma             #control bits changed
*   
*  13th October 2023        Aditi Sharma             Changed logic for 'stage'
*                                      
*  3rd November 2023        Aditi Sharma             Attempt to move the complexity of 
*                                                    register array to control unit
*
*  7th November 2023        Aditi Sharma             Control signals added for remaining        
*                           Devyam Seal              instructions
*
*  8th November 2023        Aditi Sharma             'Case' statements changed to 'casex'
*
*  20th February 2024       Aditi Sharma             Operand fetch and second execution 
*                                                    cycle decisions were made asynchronous
*/
//////////////////////////////////////////////////////////////////////////////////


module ControlUnit(rd, wr, rd_ab, wr_s, rd_s,r_or, w_or, 
                   w_ir,i_pc, i2_pc, w_pc, r_pc,p_ar, a_ar,r_a, r_rn, w_rn, 
                   r_rp, w_a, wa_rn, r_sp, i_sp, d_sp, cl_fr, E, IF, clk, opcode, rst, flags);


function [23:0] setBits; // Creating a function to set control bits 
    input integer a, b, c, d; 
        begin 
            setBits = 24'b0;
            
            setBits[a] = 1'b1;
            setBits[b] = 1'b1;
            setBits[c] = 1'b1;
            setBits[d] = 1'b1;
        end
endfunction
    
       
input clk;
input [3:0] flags;
input [7:0] opcode;
output rd, wr, rd_ab, wr_s, rd_s; // memory
output r_or, w_or; // operand register
output w_ir; // instruction register
output i_pc, i2_pc, w_pc, r_pc; // program counter
output p_ar, a_ar; //address register
output r_a, w_a, wa_rn;//register array
output r_rn, w_rn;
output r_rp;
output r_sp, i_sp, d_sp;//stack pointer
output reg [1:0] E, IF;//control unit
output cl_fr;
input rst;
wire fch, ex;

reg [2:0] stage;
reg [23:0] cb;

parameter [2:0] s0=3'b000; // IF state
parameter [2:0] s05=3'b001; // Operand Fetch
parameter [2:0] s052=3'b010; // State delay
parameter [2:0] s1=3'b011; // State delay
parameter [2:0] s2=3'b100; // Execute State 1
parameter [2:0] s3=3'b101; // Execute State 2


     
  assign {rd, wr, rd_ab, wr_s, rd_s,r_or, w_or,w_ir,i_pc, i2_pc, w_pc,
     r_pc,p_ar, a_ar,r_a, r_rn, w_rn, r_rp, w_a, wa_rn, r_sp, i_sp,
     d_sp, cl_fr} = cb; // Assigning values to signals based on 'cb' 
        
     
 
 

initial
begin
    stage = 2'b00;
    cb <= 24'b000000000000000000000000;
end

// value of fch changes based on whether the instruction requires operand fetch
assign fch = ( (opcode == 8'b00000100) || (opcode == 8'b00000110) || (opcode == 8'b00000111) ||  
               (opcode == 8'b00001000) || (opcode == 8'b00001001) || (opcode == 8'b00001010) || 
               (opcode == 8'b00001011) || (opcode == 8'b00001101) || (opcode == 8'b00001110) || 
               (opcode[7:3] == 5'b01101) || (opcode[7:3] == 5'b01110) || (opcode == 8'b00010000) ||  
               (opcode == 8'b00010001) ||  (opcode ==8'b00010010) ||  (opcode == 8'b00010011) ||
               (opcode == 8'b00010100) || (opcode == 8'b00010101) ||  (opcode == 8'b00010110) ||  
               (opcode[7:3] == 5'b10000))? (1'b1) : 1'b0 ; 
               
// value of ex changes based on whether the instruction requires a second execution cycle                         
assign ex = ( (opcode[7:3] == 5'b00010) || (opcode == 8'b00011000) || (opcode[7:3] == 5'b01001) || 
              (opcode[7:3] == 5'b01010) || (opcode[7:3] == 5'b01011) || (opcode[7:5] == 3'b011) || 
              (opcode[7:6] == 2'b11))? 1'b1 : 1'b0 ;                         
                         
/*always @(posedge clk)
begin

    casex (opcode)
        8'b00000100: IF[0] <= 1'b1;
        8'b00000110: IF[0] <= 1'b1;
        8'b00000111: IF[0] <= 1'b1;
        8'b00001000: IF[0] <= 1'b1;
        8'b00001001: IF[0] <= 1'b1;
        8'b00001010: IF[0] <= 1'b1;
        8'b00001011: IF[0] <= 1'b1;
        8'b00001101: IF[0] <= 1'b1;
        8'b00001110: IF[0] <= 1'b1;
        8'b01101XXX: IF[0] <= 1'b1;
        8'b01110XXX: IF[0] <= 1'b1;
        8'b00010000: IF[0] <= 1'b1;
        8'b00010001: IF[0] <= 1'b1;
        8'b00010010: IF[0] <= 1'b1;
        8'b00010011: IF[0] <= 1'b1;
        8'b00010100: IF[0] <= 1'b1;
        8'b00010101: IF[0] <= 1'b1;
        8'b00010110: IF[0] <= 1'b1;
        8'b10000XXX: IF[0] <= 1'b1;
        default: IF[0] <= 1'b0; 
    endcase 

    casex (opcode)
        8'b00010XXX: E[0] <= 1'b1;
        8'b00011000: E[0] <= 1'b1;
        8'b01001XXX: E[0] <= 1'b1;
        8'b01010XXX: E[0] <= 1'b1;
        8'b01011XXX: E[0] <= 1'b1;
        8'b011XXXXX: E[0] <= 1'b1;
        8'b11XXXXXX: E[0] <= 1'b1;
        default: E[0] <= 1'b0;
    endcase       

end */


// can be put in the other 'always' block
always @(posedge clk)
  begin   
    if(rst == 1'b1)
    begin
        cb <= 0;
        E <= 0;
        IF <= 0;
    end 
  end  
  
  
always @(posedge clk)
begin  
    $monitor("%t, stage = %b" , $time, stage);
    $monitor("%t, opcode = %b" , $time, opcode);
    $monitor("%t, IF[0] = %b" , $time, fch);
    $monitor("%t, cb = %b " ,$time, cb);
    $monitor("%t, icontrol_pc = %b " ,$time, i_pc);
    
    // main logic of the control unit
     case (stage)
     s0: 
        begin
          IF[1] <= 1'b1;
          E[1] <= 1'b0;
           // cb = 24'b100000011000100000000000;
           cb <= setBits(11,15,16,23);
      
           stage <= s05;   
        end 
        
     s05: // extra clock cycle for fch & ex to change with IR
         begin 
            stage <= s052;
            cb <= 0;
         end        
            
     s052: // clock cycle for decisions
          begin
                 if(fch == 1)
                     stage <= s1;
                 else
                     stage <= s2;
          end           
                         
     s1: 
        begin
           if(opcode[7:3] == 5'b00010) //checking if conditions for jump are satisfied. If no, I2PC and move on to next instruction
           begin
                if(opcode[2:0] == 3'b001 && flags[3] == 1'b1 )
                begin
                    //cb = 24'b000000000100100000000000;
                    cb <= setBits(11,14,14,14); 
                    stage <= 2'b00; 
                end    
                else if(opcode[2:0] == 3'b010 && flags[2] == 1'b1 )
                begin
                    cb <= setBits(11,14,14,14);  
                    stage <= 2'b00;  
                end
                else if(opcode[2:0] == 3'b011 && flags[1] == 1'b1 )
                begin
                    cb <= setBits(11,14,14,14); 
                    stage <= 2'b00; 
                end
                else if(opcode[2:0] == 3'b100 && flags[3] == 1'b0 )
                begin
                    cb <= setBits(11,14,14,14); 
                    stage <= 2'b00; 
                end
                else if(opcode[2:0] == 3'b101 && flags[2] == 1'b0 )
                begin
                    cb <= setBits(11,14,14,14); 
                    stage <= 2'b00; 
                end
                else if(opcode[2:0] == 3'b110 && flags[3] == 1'b0 )
                begin
                    cb <=  setBits(11,14,14,14); 
                    stage <= 2'b00; 
                end
                
                else 
                begin
                    //cb = 24'b000000000100100000000100;
                      cb <= setBits(2,12,14,14); // if condition satisfied, ISP with I2PC
                    stage <= s2;
                end    
          end                            
                    
          else 
          begin
             //cb = 24'b100000101000100000000000; // Normal operand fetch,
             cb <= setBits(11,15,17,23);
             stage <= s2;
          end           
        end
     s2: 
        begin 
    
          E[1] <= 1'b1;
          IF[1] <= 1'b0;
        
            casex(opcode)
               // 8'b11xxxxxx : cb <= {15'b0, r_rn, w_rn, r_rp, 6'b0}  ;
                8'b11XXXXXX : cb <= setBits(6,10,10,10); 
                //cb <= 24'b000000000000010001000000; //both two register functions
                8'b10010XXX : cb <= setBits(5,8,8,8); 
                //cb <= 24'b000000000000000100100000;
                8'b10001XXX : cb <= setBits(7,9,9,9);
                //cb <= 24'b000000000000001010000000;
                8'b10000XXX : cb <= setBits(7,18,18,18);
                //cb <= 24'b000001000000000010000000; 
                8'b01000XXX : cb <= setBits(8,8,8,8); 
                //cb <= 24'b000000000000000100000000;
                8'b01001XXX : cb <= setBits(8,8,8,8);
                //cb <= 24'b000000000000000100000000;
                8'b01010XXX : cb <= setBits(8,8,8,8); 
                //cb <= 24'b000000000000000100000000;
                8'b01011XXX : cb <= setBits(8,8,8,8); 
                //cb <= 24'b000000000000000100000000;
                8'b01100XXX : cb <= setBits(8,8,8,8); 
                //cb <= 24'b000000000000000100000000;
                8'b01101XXX : cb <= setBits(8,8,8,8); 
                //cb <= 24'b000000000000000100000000;
                8'b01110XXX : cb <= setBits(8,8,8,8); 
                //cb <= 24'b000000000000000100000000;
                8'b01111XXX : cb <= setBits(8,8,8,8); 
                //cb <= 24'b000000000000000100000000;
                8'b00010XXX : cb <= setBits(20,12,12,12); 
                //cb <= 24'b000100000001000000000000; // all jump instructions no return
                8'b00011000 : cb <= setBits(13,19,19,19); 
                //cb <= 24'b000010000010000000000000;
                8'b00001XXX : cb <= setBits(5,5,5,5); 
                //cb <= 24'b000000000000000000100000;
                8'b00000111 : cb <= setBits(5,5,5,5);
                //cb <= 24'b000000000000000000100000;
                8'b00000110 : cb <= setBits(5,5,5,5);
                //cb <= 24'b000000000000000000100000;
                8'b00000101 : cb <= setBits(9,17,17,17);
                //cb <= 24'b000000100000001000000000;
                8'b00000100 : cb <= setBits(5,18,18,18); 
                //cb <= 24'b000001000000000000100000;
                8'b00000011 : cb <= setBits(0,0,0,0); 
                //cb <= 24'b000000000000000000000001;
                8'b00000000 : cb <= setBits(4,4,4,4);
                //cb <= 24'b000000000000000000010000;
           endcase     
          
           if(ex == 1'b1)
           begin
               stage <= s3;
           end
           
           else
           begin 
               stage <= 2'b00;
           end  
           
        end     
                    
     s3: 
        begin
            
            casex (opcode)
            
                8'b00010XXX : cb <= setBits(13,21,21,21); 
                //cb <= 24'b001000000010000000000000;
                8'b00011000 : cb <= setBits(1,1,1,1);
                //cb <= 24'b000000000000000000000010;
                8'b01001XXX : cb <= setBits(7,7,7,7); 
                //cb <= 24'b000000000000000010000000;
                8'b01010XXX : cb <= setBits(7,7,7,7);
                //cb <= 24'b000000000000000010000000;
                8'b01011XXX : cb <= setBits(7,7,7,7); 
                //cb <= 24'b000000000000000010000000;
                8'b011XXXXX : cb <= setBits(7,7,7,7); 
                //cb <= 24'b000000000000000010000000;
                8'b110XXXXX : cb <= setBits(22,9,9,9);
                //cb <= 24'b010000000000001000000000;
                8'b111XXXXX : cb <= setBits(23,5,5,5);
                //cb <= 24'b100000000000000000100000;
              
            endcase
            
            stage <= 2'b00;
            
       end   
       
     endcase  
     
  end          

endmodule
