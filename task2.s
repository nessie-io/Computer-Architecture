main:
    addi x10, x0, 4     # num = 4
    jal x1, ntri        

    addi x17, x0, 1     # print result 
    ecall
    addi x17, x0, 10    # exit program
    ecall

ntri:
    addi sp, sp, -8     # initializing stack
    sw x1, 4(sp)        # save return address
    sw x10, 0(sp)       # save current num

    addi x5, x0, 1      
    bgt x10, x5, L1     # if num > 1, do recursive step

    # Base case
    addi x10, x0, 1     # return 1
    lw x1, 4(sp)        # restore return address
    addi sp, sp, 8      # pop stack
    jalr x0, 0(x1)      # return to caller

L1:
    # Recursive step
    addi x10, x10, -1   # num - 1
    jal x1, ntri        # call ntri(num - 1)

    addi x6, x10, 0     # save result in x6
    
    lw x10, 0(sp)       # restore original num
    lw x1, 4(sp)        # restore return address
    addi sp, sp, 8      # pop stack

    add x10, x10, x6    # return num + ntri(num - 1)
    jalr x0, 0(x1)