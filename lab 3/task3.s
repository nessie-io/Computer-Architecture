main:
    addi x7,x0, 0x100
    addi x7, x7, -8 #add to memory
    #storing temporary variables to test the code
    addi x4, x0, 2
    sw x4, 0(x7)
    addi x5, x0, 3
    sw x5, 4(x7)

    addi x10, x7, 0 #initializing v[]
    li x11, 0 #initilaizing k
    jal x1, swap

    addi x7, x7, 8 #pop
    j exit
     
    swap: 
    slli x14,x11,2
    add x14,x10,x14
    lw x20, 4(x14) #swapping occurs
    lw x21, 0(x14)
    sw x20, 0(x14)
    sw x21, 4(x14)
    

    jalr x0, 0(x1) #back to return address
    exit:
