
main:
    li x1, 5 #x1 is a

    addi x2, x0, 0 #x2 is b
    addi x1, x2, 32
    add x4, x1, x2 #x4 is d
    addi x4, x4, -5
    sub x5, x1, x4 # x5 is e
    sub x30, x2, x1 #x30 is temp
    add x5, x5, x30
    add x5, x4, x5 #final value of e
    #last line addition
    add x7, x1, x2 #x7 is temp
    add x7, x7, x4
    add x5,x7,x5



end:
    j end
