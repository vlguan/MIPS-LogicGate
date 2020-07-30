
------------------------

Lab 4: ASCII (HEX or 2SC) to Base 4
CMPE 012 Winter 2019
Last Name, First Name
CruzID

-------------------------

What was your approach to converting each ASCII input to two’s complement
form?
I subtracted 30 from binary numbers to get 0 or 1. And I took the address
where the 'binary' was stored and moving it until I went through all the
digits of the 'binary'. I then stored each 0 or 1 in a register by shifting it
everytime I recieved a new number. For hex, I did a similar method, but with 
specific ascii numbers that give me the characters or numbers in hex. For decimal
I used the same method as hex, but I checked for negatives and only used 48 to subtract
the decimal to recieve the correct value.

What did you learn in this lab?
I learned how the shifting, rotating, and adding to addresses affect the way the 
number input on the address work. 

Did you encounter any issues? 
Were there parts of this lab you found
enjoyable?
Checking the test numbers, allowed me to revise my code to work with all the numbers
that maybe tests on my code. The most enjoyable part of the lab was working with mips
for extended amounts of time. 

How would you redesign this lab to make it better?
I would have not banned specific syscalled and somehow incorporated them into the 
lab, as in the real world you aren't banned from using specific functions. Limiting my
tool kit made me question the purpose of the lab multiple times. If there are functions
that can complete my 300+ lines of code in 10-15 lines of code, the work seems to be tedious.
And completing the lab was made less rewarding knowing that someone could recreate the program
with specific syscalls.

Did you collaborate with anyone on this lab? Please list who you collaborated
with and the nature of your collaboration.
No, I did not work with anyone on this lab.