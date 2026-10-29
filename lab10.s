.equ SW_ADDR,     0x100     
.equ LED_ADDR,    0x104     
.equ RST_ADDR,    0x108     
.equ STACK_TOP,   0x1F0     
.equ DELAY_SHIFT, 20        

main:
        addi sp, x0, STACK_TOP
        addi s0, x0, SW_ADDR
        addi s1, x0, LED_ADDR
        addi s2, x0, RST_ADDR

INPUT_WAITING:                      # state 1
        addi s4, x0, 0              
        addi s3, x0, 0              
        sw   x0, 0(s1)              
iw_poll:
        lw   t0, 0(s2)              
        bne  t0, x0, INPUT_WAITING
        lw   a0, 0(s0)              
        beq  a0, x0, iw_poll        

        addi s4, x0, 1              
        jal  ra, countdown          
        beq  x0, x0, INPUT_WAITING  


countdown:
        addi sp, sp, -8
        sw   ra, 4(sp)              
        sw   s3, 0(sp)              
        addi s3, a0, 0
cd_loop:
        beq  s3, x0, cd_done
        sw   s3, 0(s1)              
        jal  ra, delay              
        bne  a0, x0, cd_reset
        addi s3, s3, -1
        beq  x0, x0, cd_loop
cd_done:
        addi a0, x0, 0
        beq  x0, x0, cd_exit
cd_reset:
        addi a0, x0, 1
cd_exit:
        lw   s3, 0(sp)              
        lw   ra, 4(sp)
        addi sp, sp, 8
        jalr x0, 0(ra)              


delay:
        addi t1, x0, 1
        addi t2, x0, DELAY_SHIFT
        sll  t1, t1, t2             
d_loop:
        lw   t0, 0(s2)              
        bne  t0, x0, d_reset
        addi t1, t1, -1
        bne  t1, x0, d_loop
        addi a0, x0, 0
        jalr x0, 0(ra)
d_reset:
        addi a0, x0, 1
        jalr x0, 0(ra)