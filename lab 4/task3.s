#linear search
#int linearSearch(int arr[], int n, int target) {
#   for (int i = 0; i < n; i++) {
#        iif (arr[i] == target) return i; // found it, return the index
#   }
#    return -1; // not found
#}

main:
#array in x30 and len in x11
li x30, 0x100 #(array)
addi x30, x30, -16
li x20, 6
sw x20, 0(x30)
li x20, 1
sw x20, 4(x30)
li x20, 5
sw x20, 8(x30)
li x20, 3
sw x20, 12(x30)
li x20, 2

sw x20, 16(x30) #made an array with 5 numbers

li x11, 5 #the length of the array (len)
li x12, 3 #target

jal x1, search

li x17, 10
ecall  #code for ending the run

search:
    beq x30, zero, end  #if array == NULL
    beq x11, zero, end  #if  len == 0

    li x9, 0 #initializing i

    addi x23, x0, -1 

    for:
    bge x9, x11, endloop

    slli x5, x9, 2
    add x5, x30, x5  #calculating base address
    lw x21, 0(x5) #storing the value in array position a[i]

    beq x12, x21, pass #target found 

    addi x9, x9, 1  #incrementing 
    j for

    pass:

    addi x23, x0, 0

    endloop: 
   
    add x30, x0, x23   # move our result into x30 for printing
    li x17, 1          # print integer syscall is 1 (5 is read integer)
    ecall

    end: jalr x0, 0(x1)
