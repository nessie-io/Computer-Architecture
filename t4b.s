main:
    li x5, 0x100
    li x6, 0x200
    li x7, 0x300

#1st instance
    lb x8, 0(x5)
    lh x9, 0(x6)

    add x10, x8, x9

    sw x10, 0(x7)

#2nd instance
    lb x8, 1(x5)
    lh x9, 2(x6)

    add x10, x8, x9

    sw x10, 4(x7)

#3rd instance
    lb x8, 2(x5)
    lh x9, 4(x6)

    add x10, x8, x9

    sw x10, 8(x7)

#4th instance
    lb x8, 3(x5)
    lh x9, 6(x6)

    add x10, x8, x9

    sw x10, 12(x7)

end:
    j end