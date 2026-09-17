main: 
    li sp, 0x100
    li x10, 5
    li x11, 0               
    
    # Stack setup in main
    addi sp, sp, -8
    sw x1, 4(sp)
    sw x10, 0(sp) 
    
    jal x1, sum              # Call the function
    
    
    li x17, 10
    ecall

sum:
    ble x10, x0, sum_exit    # if n <= 0, exit
    add x11, x11, x10        # acc = acc + n
    addi x10, x10, -1        # n = n - 1
    jal x0, sum              # loop (jump without saving return address)

sum_exit:
    addi x12, x11, 0         # return acc (stored in x12)
    jalr x0, 0(x1)           # return to caller (main)

 

    

    
