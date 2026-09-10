.text
.globl main

main:
    li   x11, 0x100        # x11 = address of y (source) = 0x100
    li   x10, 0x106        # x10 = address of x (destination) = 0x106

    # Manually write "Hello\0" into memory starting at y (0x100)
    li   x5, 'H'
    sb   x5, 0(x11)
    li   x5, 'e'
    sb   x5, 1(x11)
    li   x5, 'l'
    sb   x5, 2(x11)
    sb   x5, 3(x11)         # second 'l', reuse x5
    li   x5, 'o'
    sb   x5, 4(x11)
    sb   x0, 5(x11)         # null terminator ('\0' == 0)

    jal  x1, strcpy
    j    end

strcpy:
    addi sp, sp, -8
    sw   x8, 0(sp)

    add  x8, x0, x0         # i = 0

while:
    add  x3, x8, x11        # x3 = address of y[i]
    lbu  x5, 0(x3)          # x5 = y[i]
    add  x4, x8, x10        # x4 = address of x[i]
    sb   x5, 0(x4)          # x[i] = y[i]
    beq  x5, x0, exit       # if y[i] == '\0', done
    addi x8, x8, 1
    j    while

exit:
    lw   x8, 0(sp)
    addi sp, sp, 8
    jr   x1

end:
