.data 
arr: .space 100
message: .asciiz "Nhap so phan tu cua mang: "
message1: .asciiz "Nhap M: "
message2: .asciiz "Nhap N: "
message3: .asciiz "So phan tu trong doan [M,N] la: "
.text
   li $v0, 4 
   la $a0, message
   syscall # In ra message
   
   li $v0, 5 # Nhap n
   syscall
   
   move $s0, $v0 # $s0 = n
   
   la $a0, arr # arr[0] = $a0
   li $t0, 0 # i = 0
   
loop: # Nhap vao cac phan tu cua mang
   li $v0, 5 
   syscall # Nhap phan tu vao $v0
   sw $v0, 0($a0)
   addi $t0, $t0, 1
   addi $a0, $a0, 4
   blt $t0, $s0, loop
end_loop:
# Input M, N
   li $v0, 4
   la $a0, message1  # In message1
   syscall
   
   li $v0, 5 # Nhap M
   syscall
   move $t1, $v0 # $t1 = M
   
   li $v0, 4
   la $a0, message2
   syscall # In message2
   
   li $v0, 5  # Nhap N
   syscall
   move $t2, $v0 # $t2 = N
   
   la $a0, arr # arr[0] = $a0
   li $t3, 0  # index = 0
   li $s2, 0  # ketqua = 0
   sll $s0, $s0, 2 # chuyen so phan tu thanh offset de so sanh
while:
   bge $t3, $s0, print # chuyen ve nhan print de in ket qua khi het phan tu
   add $t4, $a0, $t3 # lay dia chi phan tu arr[index]
   lw $s1, 0($t4) # load phan tu arr[index]
   jal compare
   addi $t3, $t3, 4  # chuyen sang phan tu tiep theo
   j while
end_while:

compare:
   blt $s1, $t1, end_compare  # neu arr[index] < M chuyen sang end_compare
   bgt $s1, $t2, end_compare  # neu arr[index] > N chuyen sang end_compare
   addi $s2, $s2, 1
end_compare:
   jr $ra
print:   
    li $v0, 4 
    la $a0, message3
    syscall # In ra message
    move $a0, $s2
    li $v0, 1
    syscall
end: