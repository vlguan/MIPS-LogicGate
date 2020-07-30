##########################################################################
# Created by:  Guan, Vince
#              vlguan
#              15 February 2019
#
# Assignment:  Lab 3: MIPS Looping ASCII Art
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2019
#
# Description: This program creates triangles based on user input.
#
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################


.text
                                                   #Prompt askes for number of legs
     li          $t0, 0                            #number of triangles
     li          $t1, 0                            #legs
     li          $t2, 0                            #row check
     li          $t4, 0                            #space check
     li          $t5, 0                            #number of triangles check
     
     
     li          $v0, 4                            #prints the first question
     la          $a0, Userinput1
     
     syscall
     
     li          $v0, 5                            #get leg number
     
     syscall
     
     move        $t1, $v0                          #transfer the register
    
     li          $v0, 4                            #prints the second question
     la          $a0, Userinput2
     
     syscall
     
     li          $v0, 5                            #get number of triangles from user
     
     syscall
     
     move        $t0, $v0                          #transfer the register
     
     sub         $t0, $t0, 1                       #subtract 1 from the number of triangles needed to create a loop
     
LOOP:                                              #MasterLoop

     li          $v0, 11
     lb          $a0, newLine                      #Makes a new line
  
     syscall

     la          $t4, ($t2)                        #loads $t2 into $t4
     
          LOOP1:
     	    
            bnez        $t4, else                  #checks if $t4 is zero and skips to backslashes if $t4 is zero
                
               
                
                b LOOP2                            #loops to backslashes
                
                else:                              #creates spaces if the $t4 is greater or 1
        
                li          $a0, 32                #spaces
                li          $v0, 11
        
                syscall
                
                sub         $t4, $t4, 1            #row-1 = number of spaces required
                
                b LOOP1                            #loops back to check if $t4 is equal to zero
     
          LOOP2:
                li          $v0, 4                 #creates backslashes
                la          $a0, backslash
     
                syscall
     
                addi        $t2, $t2, 1
                bge         $t2, $t1, INVERSE      #compares $t2 to $t1
     
                b LOOP
      
INVERSE:
     li          $v0, 11
     lb          $a0, newLine                      #Makes a new line
     
     syscall
     
     la          $t4, ($t2)                        #loads $t2 into $t4
     
          LOOP3:
                
                 beq         $t4, 1, else1         #checks if $t4 is at 1 
                 
                 li          $a0, 32               #adds a space when $t4 doesn't equal 1
                 li          $v0, 11 
                 
                 syscall
                 
                 sub         $t4, $t4, 1
                 
                 b LOOP3                          #loops back to loop3 if not equal to 1
                 
                 else1:                           #if it is equal to 1 it will create a slash
                 
                 b LOOP4
                 
          LOOP4:
                li          $v0, 4                #creates slashes
                la          $a0, a
     
                syscall
                
                sub         $t2, $t2, 1
                bgt         $t2, $zero, INVERSE   #compares $t2 to zero
                
                beq         $t5, $t0, END         #end the code if the number of triangles is correct
                addi        $t5, $t5, 1
                
                b LOOP
                
                      END:
                
                             li         $v0, 10
                
                             syscall
                
         
.data
Userinput1:     .asciiz      "Enter the length of one of the triangle legs: "
Userinput2:     .asciiz      "Enter the number of triangles to print: "
newLine:        .ascii       "\n"
backslash:      .asciiz      "\\"
a:              .ascii       "/"


