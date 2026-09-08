main: 
li x10, 4096        # base address, way past where your instructions live
li x5, 10 
li x6, 10 
li x7, 0
li x29,0
li x9, 0 

Loop1: bge x7, x5, Exit1
    Loop2: bge x29, x6, Exit2
        slli x24, x29, 4
        add x24, x24, x10
        add x9, x7, x29
        sw x9, 0(x24)
        addi x29, x29, 1  
        beq x0, x0, Loop2
    Exit2:
        li x29, 0
        addi x7, x7, 1
        beq x0, x0, Loop1
Exit1: 
end: j end