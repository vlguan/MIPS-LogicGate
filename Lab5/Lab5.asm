##########################################################################
#Created by:  Guan, Vince
#              vlguan
#              12 March 2019
#
# Assignment:  Lab 5: Caesar Cipher
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2019
#
# Description: This program encrypts and decrypts words based on a key.
#
# Notes:       This program is intended to be run from the MARS IDE and used in tandem with Lab5Main.asm. 
##########################################################################
.text 
#-------------------------------------------------------------------- 
# 
# This function should print the string in $a0 to the user, store the user’s input in 
# an array, and return the address of that array in $v0. Use the prompt number in $a1 
# to determine which array to store the user’s input in. ?Include error checking? for 
# the first prompt to see if user input E, D, or X if not print error message and ask 
# again. 
# 
# arguments:  $a0 - address of string prompt to be printed to user 
#             $a1 - prompt number (0, 1, or 2) 
# 
# note:prompt 0: Do you want to (E)ncrypt, (D)ecrypt, or e(X)it? 
#prompt 1: What is the key? 
#prompt 2: What is the string? 
# 
# return:     $v0 - address of the corresponding user input data 
#-------------------------------------------------------------------- 
give_prompt:
         beq $a1, 0, return                                     #checks if it is the first prompt or not
         nop     
         b aprompt1                                             #jumps to print the first prompt
         
         return:
              li  $v0, 4                                        #prints prompt1
              syscall
              again:                                            #checks if the input is correct
                   la  $a1, 99
                   li  $v0, 8
                   la  $a0, string_array 
                   syscall
                   
                   lb  $t0, ($a0)
                   
                   beq $t0, 0x045,  correct                     #checks if it is E
                   nop
                   beq $t0, 0x044,  correct                     #D
                   nop
                   beq $t0, 0x058, correct                      #or X
         
                   b erMsg                                      #if not send errormessage
         
                   erMsg:
                        li  $v0, 4                              #error message and askes for Input Again
                        la  $a0, errorPrompt
         
                        syscall
         
                        b again
        
              correct:
                   la $v0, string_array                         #sets string array for prompts
                   jr $ra
         aprompt1:
              beq  $a1, 1, return1                              #checks if prompt2 is called
              nop
              b aprompt2
              
              return1:
                   li $v0, 4                                    #writes prompt2 and askes for user input
                   syscall
                   la $a1, 99
                   la $a0, string_array1
                   li $v0, 8
                   syscall
                   
                   la $v0, string_array1                        #stores user input
                   jr $ra
                   
         aprompt2:                                              #writes final prompt
              li $v0, 4                                         #askes for user input
              syscall
              la $a1, 99
              la $a0, string_array2
              li $v0, 8
              syscall
              
              
              la $v0, string_array2                             #stores user string
              jr $ra                                            #returns to the main
              
              
                             
#-------------------------------------------------------------------- 
# Calls compute_checksum and encrypt or decrypt depending on if the user input E or 
# D. The numerical key from compute_checksum is passed into either encrypt or decrypt 
# 
# note: this should call compute_checksum and then either encrypt or decrypt 
# 
# arguments:  $a0 - address of E or D character 
#             $a1 - address of key string 
#             $a2 - address of user input string 
# 
# return:     $v0 - address of resulting encrypted/decrypted string 
#-------------------------------------------------------------------- 

cipher:
    subi $sp, $sp, 12                                           #saves the return address to main
    sw   $ra, 0($sp)                                            #saves $ra
    
    jal compute_checksum                                        #jumps to compute_checksum
    
    move  $t0, $a0                                              #move the E or D to $t0
    lb    $t5, 0($t0)                                           #load first byte to $t5
    move  $t3, $v0                                              #load the checksum to $t3 for later use
    move  $t1, $a1                                              #loads the address of the key to $t1
    move  $t2, $a2                                              #loads the address of the user string into $t2
    sw    $t2, 4($sp)                                           #saves $t2 and $t5 for late use
    sw    $t5, 8($sp)
    
    encryptordecrypt:
         move $a0, $t2                                          #saves $t2 to $a0 to use in other processes
         move $a1, $t3                                          #saves $a1 to $t3 to use in other processes
         move $t1, $a0                                          #save register for later use
         move $t3, $a1                                          #save register for later use
         la   $s6, encrypted_array                              #load $s6 with array address
        
         loop3:
              beq   $t5, 0x045, encryptjal                      #checks to encrypt or to decrypt
              nop
              
              b decryptjal                                      #goes to decrypt process
              
              encryptjal:                                       #encrypt process
                   lb   $t0, 0($t1)                             #loads the first byte of $t1 to $t0
                   addi $t1, $t1, 1                             #moves address
                   beq  $t0, 10, loop3exit                      #checks if it is new line
                   nop
                   jal encrypt                                  #jump to encrypt process
                   sb   $v0, ($s6)                              #store the character into $s6
                   addi $s6, $s6, 1                             #add to address to shift
                   
                   b encryptjal
                   
              decryptjal: 
                   lb   $t0, 0($t1)                             #same as encrypt process
                   addi $t1, $t1, 1
                   beq  $t0, 10, loop3exit
                   nop
                   jal decrypt
                   sb   $v0, ($s6)
                   addi $s6, $s6, 1
                   b decryptjal     
         loop3exit:                                             #Goes back to main
              addi $s6, $s6, 1                                  #adds a nullpointer
              addi $t6, $zero, 0                                #so it wont print more than needed
              sb   $t6, ($s6)                                   #stores the zero at the end
              la   $s6, encrypted_array                         #reloads address
              move $v0, $s6                                     #moves the $s6 to $v0
              lw   $ra, 0($sp)                                  #reloading process
              lw   $s2, 4($sp)
              lw   $s0, 8($sp)
              addi $sp, $sp, 4
              jr   $ra  

#--------------------------------------------------------------------
# Computes the checksum by xor’ing each character in the key together. Then, 
# use mod 26 in order to return a value between 0 and 25. 
# 
# arguments:  $a0 - address of key string 
# 
# return:     $v0 - numerical checksum result (value should be between 0 - 25) 
#-------------------------------------------------------------------- 
compute_checksum:
    subi $sp, $sp, 4                                            #saves the address
    sw   $ra, 0($sp)
    move $t0, $a1
    lb   $t3, 0($t0)                                            #xors the first two letters 
    lb   $t4, 1($t0)
    xor  $t9, $t3, $t4
    add  $t0, $t0, 2
    
    looop1:
         lb  $t1, 0($t0)                                        #xors the key word until there is a newLine
         beq $t1, 10, mod26
         nop
         add $t0, $t0, 1
         xor $t9, $t9, $t1
         
         b looop1
         
    mod26:                                                      #process moves and then divides $v0 by 26 ro get the remainder, which is stored in the $v0 for later use
         move $v0, $t9
         div  $v0, $v0, 26
         mfhi $v0
         lw   $ra, 0($sp)
         addi $sp, $sp, 4
         jr   $ra
              
#-------------------------------------------------------------------- 
# Uses a Caesar cipher to encrypt a character using the key returned from 
# compute_checksum. This function should call check_ascii. 
# 
# arguments:  $a0 - character to encrypt 
#             $a1 - checksum result 
# 
# return:     $v0 - encrypted character 
#-------------------------------------------------------------------- 
encrypt:
    subi $sp, $sp, 4                                            #saves address
    sw   $ra, 0($sp) 
    loop1:
         jal check_ascii                                        #jumps to check ascii to see if its uppercase or lowercase
         beq  $t4, -1, noncharacter                             #goes to non character if its not a character
         nop 
         beqz $t4, uppercase1                                   #goes to uppercase if its uppercase
         nop    
         add  $t0, $t0, $t3                                     #add the check sum to the number
         bge  $t0, 0x7a, overflow                               #check for "overflow"
         nop
         move $v0, $t0                                          #move finished value to $v0
         lw   $ra, 0($sp)                                       #reloading process
         addi $sp, $sp, 4
         jr   $ra                                               #returns to cipher with one encrypted character
         overflow:                                              #subtracts 26 from the $t0 to return to characters
              sub  $t0, $t0, 0x1A                               
              move $v0, $t0
              lw   $ra, 0($sp)                                  #reloading process
              addi $sp, $sp, 4 
              jr   $ra                                          #returns to cipher with one encrypted character
         uppercase1:
              add $t0, $t0, $t3                                 #same overflow process but with the values for an uppercase character
              bge $t0, 0x5B, overflow
              nop
              move $v0, $t0
              lw   $ra, 0($sp)
              addi $sp, $sp, 4    
              jr   $ra
         noncharacter:                                          #does nothing to the $t0 because there is nothing to do
              move $v0, $t0
              lw   $ra, 0($sp)                                  #reloading process
              addi $sp, $sp, 4 
              jr   $ra                                          #returns to cipher without a encrypted character
         
#--------------------------------------------------------------------          
# Uses a Caesar cipher to decrypt a character using the key returned from 
# compute_checksum. This function should call check_ascii. 
# 
# arguments:  $a0 - character to decrypt 
#             $a1 - checksum result 
# 
# return:     $v0 - decrypted character 
#--------------------------------------------------------------------

 
decrypt:
    subi $sp, $sp, 4                                            #same process as encrypted
    sw   $ra, 0($sp) 
    loop2:
         jal check_ascii
         
         beq  $t4, -1, noncharacter2
         nop 
         beqz $t4, uppercase2
         nop    
         sub  $t0,  $t0, $t3                                    #instead of adding we subtract
         blt  $t0, 0x60, overflow1                              #to check overflow we do less than
         nop
         move $v0, $t0 
         lw   $ra, 0($sp)
         addi $sp, $sp, 4
         jr $ra
         overflow1:
              add  $t0, $t0, 0x1A                               #instead of subtracting 26 we add 26
              move $v0, $t0
              lw   $ra, 0($sp)
              addi $sp, $sp, 4 
              jr   $ra
         uppercase2:
              sub $t0, $t0, $t3
              ble $t0, 0x41, overflow1
              nop
              move $v0, $t0
              lw   $ra, 0($sp)
              addi $sp, $sp, 4    
              jr   $ra
         noncharacter2:
              move $v0, $t0
              lw   $ra, 0($sp)
              addi $sp, $sp, 4 
              jr   $ra  
#--------------------------------------------------------------------  
# This checks if a character is an uppercase letter, lowercase letter, or 
# not a letter at all. Returns 0, 1, or -1 for each case, respectively. 
# 
# arguments:  $a0 - character to check 
# !
# return:     $v0 - 0 if uppercase, 1 if lowercase, -1 if not letter 
#-------------------------------------------------------------------- 
check_ascii:                                                    #checks if the charcters are uppercase or lowercase or noncharacter
     subi $sp, $sp, 4
     sw   $ra, 0($sp)
     
     bge  $t0, 0x61, lowercase                                  #lowercase ascii are larger than 0x61
     nop
     
     uppercase:
         ble $t0, 0x5A, check                                   #if its less than 0x90 then it might be a noncharacter so we check again
         nop
         b nonletter
         check:
              bge $t0, 0x41, continue                           #check if its between A and Z
              
              b nonletter
              
               continue:                                        #sets $v0 to 0
                   li   $v0, 0
                   move $t4, $v0
                   lw   $ra, 0($sp)
                   addi $sp, $sp, 4
                   jr   $ra
         nonletter:                                             #sets $v0 to -1
              li   $v0, -1
              move $t4, $v0
              lw   $ra, 0($sp)
              addi $sp, $sp, 4
              jr   $ra
lowercase:                                                      #sets $v0 to 1
    ble $t0, 0x7A, continue1
    nop
    b nonletter
    continue1:
         li   $v0, 1
         move $t4, $v0
         lw   $ra, 0($sp)
         addi $sp, $sp, 4
         jr   $ra    
#-------------------------------------------------------------------- 
# Determines if user input is the encrypted or decrypted string in order 
# to print accordingly. Prints encrypted string and decrypted string. See 
# example output for more detail. 
# 
# arguments:  $a0 - address of user input string to be printed 
#             $a1 - address of resulting encrypted/decrypted string to be printed 
#             $a2 - address of E or D character 
# 
# return:     prints to console 
#-------------------------------------------------------------------- 
print_strings:                                                  #prints strings
    subi $sp, $sp, 4                                            #saves address
    sw   $ra, 0($sp)
    li   $v0, 4
    la   $a0, fprompt
    
    syscall
    
    li   $v0, 4                                                 #prints the first final prompt
    la   $a0, fprompt1
    
    syscall
    
    li   $a0, 32                                                #Creates spaces
    li   $v0, 11
     
    syscall
    
    beq  $a2, 0x45, Efinish                                      #checks if its Encrypt or Dcrypt
    nop
    
    b Dfinish
    
    Efinish:                                                     #prints the encrypt first
         li   $v0, 4
         la   $a0, ($a1)
    
         syscall
    
         li   $v0, 11
         lb   $a0, newLine                                      #Makes a new line
    
         syscall
    
         li   $v0, 4                                            #prints the 2nd final prompt
         la   $a0, fprompt2
    
         syscall
    
         li   $a0, 32                                           #Creates spaces
         li   $v0, 11
    
         syscall
         
         move $a0, $s2                                          #resest $a0
         li   $v0, 4
         la   $a0, ($a0)
    
         syscall
         lw   $ra, 0($sp)
         addi $sp, $sp, 4
         jr   $ra
    Dfinish:                                                    #prints the decrypt
         move $a0, $s2
         li   $v0, 4
         la   $a0, ($a0)
    
         syscall
    
         li   $v0, 4
         la   $a0, fprompt2
    
         syscall
    
         li   $a0, 32                                           #Creates spaces
         li   $v0, 11
    
         syscall
    
         li   $v0, 4
         la   $a0, ($a1)
    
         syscall
         lw   $ra, 0($sp)
         addi $sp, $sp, 4
         jr   $ra
    
.data
newLine:           .ascii  "\n"
errorPrompt:       .asciiz "Please enter the correct character \n"
fprompt:           .asciiz "Here is the encrypted and decrypted string\n"
fprompt1:          .asciiz "<Encrypted>"
fprompt2:          .asciiz "<Decrypted>"
string_array:      .space 100
string_array1:     .space 100
string_array2:     .space 100
encrypted_array:   .space 100

