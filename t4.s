main:
    li x10, 0x78786464
    li x11, 0xA8A81919

    sw x10, 0x100(x0) #store is from register to memory ->
    #lx x10, 0x100(x0) load is from memory to register <-
    #format is the same, register is before the comma and location
    #is after the comma
    sw x11, 0x1F0(x0)
    lhu x12, 0x100(x0)
    lh x13, 0x1F0(x0)
    lb x14, 0x1F0(x0)
end:    