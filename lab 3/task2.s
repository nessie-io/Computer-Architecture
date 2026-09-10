main:
    li x10,10 #g
    li x11,11 #h
    li x12,12 #i
    li x13,13 #j
    

    jal x1, leaf
    #load  the values into memory 
    addi x7,x0, 0x100
    addi x7, x7, -16
    
    add x2, x0, x10
    sw x2, 0(x7)

    add x2, x0, x11
    sw x2, 4(x7)
    
    add x2, x0, x12
    sw x2, 8(x7)

    add x2, x0, x13
    sw x2, 12(x7)

    add x2, x0, x20
    sw x2, 16(x7)

    j exit
     
    leaf: 
    li x20,9 #f
    add x18, x10, x11 #g+h
    add x19, x12, x13 #i+j
    sub x20, x18, x19 #f = (g+h) - (i+j)
    jalr x0, 0(x1)
    exit:
