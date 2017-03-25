# Factorial-Assembly-Code
This is an assembly language program designed to calculate the summation from 0 to the absolute value of (a) for the formula 2(x!) where (a) is the value stored in register 4 (R4). The value for the summation once calculated is stored in R5 and an additional formula is calculated using R5 which is  (R5 + 50)/4 and this value is stored in R7. Because the MSP430G2553 is a 16 bit processor, this program can only accurately calculate up to 7 for R4 because anything further will exceed the storage space of FFFF, or 16^4