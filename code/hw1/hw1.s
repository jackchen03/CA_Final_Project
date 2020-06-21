.data
    n: .word 20 # You can change this number
    
.text
.globl __start

FUNCTION:
    # Todo: define your own function in HW1

    # store x1, a0 on stack
    addi sp, sp, -16
    sw x1, 0(sp) # store x1 in 0(sp)
    sw a0, 8(sp) # store a0 in 8(sp)
    
    # base case -> go to Base
    srai a0, a0, 1 # n = n/2
    beq a0, x0, Base
    
    # else recurse
    jal x1, FUNCTION # recurse
    slli a0, a0, 2 # a0 = 4 * a0
    addi x6, a0, 0 # x6 = a0
    
    # restore a0, x1, pop stack
    lw a0, 8(sp) # a0 = n
    lw x1, 0(sp) # x1 = addr
    addi sp, sp, 16
    
    # compute result
    slli a0, a0, 1   # a0 = 2n
    add a0, a0, x6 # a0 = x6 + 2n
    
    # return
    jalr x0, 0(x1)
    
Base:
    # base case
    addi a0, x0, 1
    addi sp, sp, 16
    jalr x0, 0(x1)
    

# Do not modify this part!!! #
__start:                     #
    la   t0, n               #
    lw   x10, 0(t0)          #
    jal  x1,FUNCTION         #
    la   t0, n               #
    sw   x10, 4(t0)          #
    addi a0,x0,10            #
    ecall                    #
##############################