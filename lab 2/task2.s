Main:
    li x20, 1
    li x22, 2
    li x23, 3

    li x5, 1
    beq x20, x5, case1

    li x5, 2
    beq x20, x5, case2

    li x5, 3
    beq x20, x5, case3

    li x5, 4
    beq x20, x5, case4

    beq x0, x0, Default

    case1: add x21, x22, x23
    beq x0, x0, Exit

    case2: sub x21, x22, x23
    beq x0, x0, Exit

    case3: slli x21, x22, 1
    beq x0, x0, Exit

    case4: srai x21, x22, 1
    beq x0, x0, Exit

    Default: li x21, 0
    Exit:
end: j end