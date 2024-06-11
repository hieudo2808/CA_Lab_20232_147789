.data
message: .asciiz "Nhap N: "
message1: .asciiz "Tong cac chu so nhi phan cua N la: "
.text
input: # Nhap N
	li $v0, 51
	la $a0, message
	syscall
	
	bltz $v0, input # n<0 thi nhap lai
	move $t0, $a0 # luu vao $t0
	
	li $s0, 2 
	li $s1, 0 # sum=0
	
loop:
	beqz $t0, done # if N==0 thi stop
	div $t0, $s0 
	mfhi $t1
	add $s1, $s1, $t1 # Cong phan bit (du) vao sum
	mflo $t0 # chuyen thuong thanh so bi chia va tiep tuc
	j loop
	
done: 	
	#print
	li $v0, 4
	la $a0, message1
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall