##########################################################################
# Created by:  Guan, Vince
#              vlguan
#              20 February 2019
#
# Assignment:  Lab 4: ASCII Conversion
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2019
#
# Description: This program adds and .
#
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################
#Make $t0-$t10 = 0
#Ask for user input 
#convert ascii to hexa or binary
#add together
#put sum into register
#divide decimals by 4 
#loop until no more quotient remains
#use address to display sum
#put $t0 into $t1-4
#take the remainders and put them in 4 different registers
#display #t1-4 in order
#characters subtract by 55 numbers subtract by 48
.text
li       $s0, 0              
li       $s1, 0
li       $s2, 0
li       $t0, 0
li       $t1, 0
li       $t2, 0
li       $t3, 0
li       $t4, 0
li       $t5, 0
li       $t6, 0
li       $t7, 0
li       $t8, 0

li $v0, 4
la $a0, Output1
         
syscall
         
li $v0, 11
lb $a0, newLine
         
syscall

lw       $a0, ($a1)
li       $v0, 4

syscall

li          $a0, 32                    #spaces
li          $v0, 11

syscall

lw       $a0, 4($a1)
li       $v0, 4

syscall

li $v0, 11
lb $a0, newLine
         
syscall
lw       $s1,  ($a1)                             #loads the program argument into $s1
lw       $s2, 4($a1)                             #loads the program argument into
lb       $t0, 1($s1)                             #loads the byte to check for later
lb       $t1, 1($s2)                             #same as above
addi     $s1, $s1, 2                             #shifts address over two the cut out 0b or 0x
addi     $s2, $s2, 2                             #same for the next address
move     $t5, $s1                     
move     $t6, $s2
lb       $t3, 0($t5)







Check1:                                          #checks the first string
         beq $t0, 098, loop                      #compares the second bit
         nop
         
         b else                                  #goes to the next compare or convert from hex
         
         loop:                                   #converts ascii to binary
              
              lb   $t3, 0($t5)                   #load byte from program arguments
              sll  $t7, $t7, 1                   #shift left
              sub  $t3, $t3, 48                  #subtracts ascii from ascii to create binary
              add  $t7, $t3, $t7                 #adds to $t7
              add  $t5, $t5, 1                   #add 1 to the address to shift left
              beq  $t4,   7, loopexit            #check if the end of the binary is here
              nop
              add  $t4, $t4, 1                   #counter
              
              j loop
              
          loopexit:                              #jumps to the next check
          
          j Check2
       
         else:                                   #checks if it is hex
         
              beq $t0, 120, loop1                #compares the prefix see if its hex
              nop
              b else3                             
              
              loop1:
                   
                   bge $t3, 065, loop2           #compares the character to see if its a number or character
                   
                   b else1
                   
                   loop2: 
                        lb  $t3, 0($t5)
                        sll $t7, $t7, 4          #shifts left
                        sub $t3, $t3, 55         #subtracts the character by a set ascii value
                        add $t7, $t3, $t7
                        add $t5, $t5, 1 
                        beq $t4,   1, loopexit1  #check counter
                        nop
                        add $t4, $t4, 1          #the counter
                        j loop1
                        
                   else1:                        #converts non characters
                        lb  $t3, 0($t5)
                        sll $t7, $t7, 4          #shifts left
                        sub $t3, $t3, 48         #subtracts the character by a set ascii value
                        add $t7, $t3, $t7
                        add $t5, $t5, 1 
                        beq $t4,   1, loopexit1  #check counter
                        nop
                        add $t4, $t4, 1          #the counter
                        
                        
                        j loop1
              
              loopexit1:
                        b Check2
              else3:                             #decimals 
                   li   $s6, 10                  #set $s6 to 10
                   subi $t5, $s1, 2              #move the address over 2 again
                   lb   $t3, 0($t5)              #load $t3 for first byte
                   beq  $t3, 45, neg1            #check if its negative
                   nop
                   
                   nneg:                         #not negative
                   lb   $t3, 0($t5)              #load $t3 first byte
                   beqz $t3, negativecheck       #if last value is null go to negative check with $s7 value
                   nop                
                   mult $t7, $s6                 #multiply by 10 to move over 1
                   mflo $t7                      #store product from mult
                   sub  $t3, $t3, 48             #subtract number with ascii
                   add  $t7, $t3, $t7            #store the value into $t7
                   add  $t5, $t5, 1              #shift counter over 1
                   
                   
                   
                   
                   j nneg
                   
                   negativecheck:
                   
                   beq  $s7, 1, neg2             #check if $s7 is 1
                   
                   j Check2
                   
                   neg1:
                        li  $s7, 1               #will set $s7 to 1 to activate negative check
                        add $t5, $t5, 1          #shift counter 1 
                        
                        j nneg
                   neg2:
                        not $t7, $t7             #$t7 inverted
                        add $t7, $t7, 1          #add 1 to my $t7
                        
                        j Check2
                           
                        
Check2:
         li  $t3, 0
         li  $t4, 0
         li  $s7, 0
         lb  $t3, 0($t6)
    
         beq $t1, 098, loop3                     #compares the second bit
         nop
         b else4                                 #goes to the next compare or convert from hex
         
         loop3:                                  #converts ascii to binary
              
              lb   $t3, 0($t6)                   #load byte from program arguments
              sll  $t8, $t8, 1                   #shift left
              sub  $t3, $t3, 48                  #subtracts ascii from ascii to create binary
              add  $t8, $t3, $t8                 #adds to $t7
              add  $t6, $t6, 1                   #add 1 to the address to shift left
              beq  $t4,   7, loopexit2           #check if the end of the binary is here
              nop
              add  $t4, $t4, 1                   #counter
              
              j loop3
              
         loopexit2:                              #jumps to the next check
          
          j Add
       
         else4:                                  #checks if it is hex
         
              beq      $t1, 120, loop4           #compares the prefix see if its hex
              nop
              b else9                             
              
              loop4:
                   
                   bge $t3, 065, loop5           #compares the character to see if its a number or character
                   
                   b else5
                   
                   loop5: 
                        lb  $t3, 0($t6)
                        sll $t8, $t8, 4          #shifts left
                        sub $t3, $t3, 55         #subtracts the character by a set ascii value
                        add $t8, $t3, $t8
                        add $t6, $t6, 1 
                        beq $t4,   1, loopexit3  #check counter
                        nop
                        add $t4, $t4, 1          #the counter
                        j loop4
                        
                   else5:                        #converts non characters
                        lb  $t3, 0($t6)
                        sll $t8, $t8, 4          #shifts left
                        sub $t3, $t3, 48         #subtracts the character by a set ascii value
                        add $t8, $t3, $t8
                        add $t6, $t6, 1 
                        beq $t4,   1, loopexit3  #check counter
                        nop
                        add $t4, $t4, 1          #the counter
                        
                        
                        j loop4
                        
              loopexit3:
              
              j Add
              
              else9:                             #decimals 
                                                 
                   li   $s6, 10                  #set $s6 as 10
                   subi $t6, $s2, 2              #shift $s2 over 2
                   lb   $t3, 0($t6)              #load byte into $t3
                   beq  $t3,  45, neg3           #compare to see if its negative
                   nop
                   
                   nneg1:                        #same as nneg
                   lb   $t3, 0($t6)
                   beqz $t3, negativecheck2
                   nop
                   mult $t8, $s6
                   mflo $t8
                   sub  $t3, $t3, 48
                   add  $t8, $t3, $t8
                   add  $t6, $t6, 1
                   
                   j nneg1
                   
                   negativecheck2:               #same as negativecheck
                   
                   beq  $s7, 1 neg4
                   
                   j Add
                   
                   neg3:                         #same as neg1
                        li   $s7, 1
                        add  $t6, $t6, 1
                        
                        j nneg1
                   neg4:                         #same as neg2
                        not  $t8, $t8
                        add  $t8, $t8, 1
                        
                        j Add
Add:
         move $s1, $t7                           #set $t7 as the address
         move $s2, $t8                           #set $t8 as address
         add  $s0, $s2, $s1                      #the sum part
         b Convert         
Convert:
         li   $t0, 0
         li   $t1, 0
         li   $t2, 0
         li   $t3, 0
         li   $t4, 0
         li   $t5, 0
         li   $t6, 0
         li   $t7, 0
         li   $t8, 0
         li   $t9, 0
         move $t7, $s0                           #set $t7 as the sum
         sll  $t7, $t7, 24                       #shift the address over 24 bytes
         la   $t0, base4string                   #load the base4String into $t0
         move $t1, $s0                           #move $s0 into $t1
         and  $t1, $t1, 0x80                     #check if sum has negative
         beqz $t1, a                             #compares the first bit to see if there is a negative
         nop
          
         a1:                                     #if there is a negative load negative into first byte 
              li   $t2, 45                       #load the negative into $t2
              not  $t7, $t7                      #invert $t7
              addi $t7, $t7, 0x01000000          #add 1 to chance 2sc
              sb   $t2, 0($t0)                   #put byte into address
              addi $t0,  $t0, 1                  #shift to next memory
              
              j a
              
         a:                                      #no negative or lead zero so proceed dividing as usual
              rol  $t7,  $t7, 2                  #rotate left to get to first two bits
              divu $t8,  $t7, 4                  #divide by 4 to get base of 4 remainder
              mfhi $t4                           #load remainder
              abs  $t4, $t4                      #make sure remainder is positive
              subu $t7 ,$t7, $t4                 #subtract $t7 from $t4
              
              a2:                                #next part of the convert
                   
                   or    $t8, $t9, $t4           #'adds' $t9 and $t4 together
                   bnez  $t8, a3                 #checks if there is a leading zero
                   nop
                   j a4
                   
              a3:                                #no leading zero continue as normal
                   li   $t9, 1                   #load 1 in to $t9
                   addi $t4,  $t4, 0x30          #adds hex 30 to $t4
                   sb   $t4, ($t0)               #the ascii value of zero + number makes it ascii
                   addi $t0, $t0, 1              #move the memory up one
              
                   j a4
              a4:
                   beq  $t6, 3, Print            #checks the iterations passed
                   nop
                   add  $t6, $t6, 1              #counter
                    
                   j a	
Print:

         li   $v0, 4                             #prtints the output message
         la   $a0, Output2
         
         syscall
         
         li   $v0, 11                            #creates a new line
         lb   $a0, newLine
         
         syscall
         
         li   $v0, 4                             #prints the sum
         la   $a0, base4string
         
         syscall
         
         li   $t0, 0                             #everything below sign extends
         li   $t1, 0                             #by checking if the number requires sign extension
         li   $t2, 0                             #and then applying 0xFFFFFF00 to the number
         li   $t3, 0xFFFFFF00
         li   $t4, 0x80
         and  $t0, $s0, $t4
         bnez $t0, c
         nop
         j c1
         
         c:
              
              or $s0, $s0, $t3
              
              j c1
         c1: 
              and  $t1, $s1, $t4
              bnez $t1, c3
              nop
              j c2
              
              c3: 
                   or   $s1, $s1, $t3
                   j c2
                   
              c2:
                   and  $t2, $s2, $t4
                   bnez $t2, c5
                   nop
                   j c4
                   
              c4: 
                   or   $s2, $s2, $t3
                   
                   j c5
              c5: 
                   li   $v0, 10
                 
                   syscall
                 

.data
base4string: .space   6
Output1:     .asciiz                             "You entered the numbers:"
Output2:     .asciiz                             "The sum in base 4 is:"
newLine:     .ascii                              "\n"
