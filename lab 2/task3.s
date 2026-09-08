main:
    li x22, 0 
    li x23, 0 
    li x24, 10 
    li x10, 0 
    li x25, 0 

    Loop1: bge x22, x24, Exit1
    slli x10, x22, 2
    add x10, x10, x25
    sw x22, 0(x10)
    addi x22, x22, 1
    beq x0, x0, Loop1
    Exit1:

    li x22, 0

    Loop2: bge x22, x24, Exit2
    slli x10, x22, 2
    add x10, x10, x25
    lw x9, 0(x10)
    add x23, x23, x9
    addi x22, x22, 1
    beq x0, x0, Loop2
    Exit2: end: j end


