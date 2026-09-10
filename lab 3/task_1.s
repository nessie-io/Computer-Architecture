#for me comments work with hashes
li x10,1 #a 
li x11,2 #b
jal x1, sum #jumps to sum
li x10, 1 #service number x10
ecall #prints(returns) the sum in terminal 
j exit

sum: 
add x11, x10, x11 #b = a+b
jalr x0, 0(x1) #jumps back to stored address
exit: