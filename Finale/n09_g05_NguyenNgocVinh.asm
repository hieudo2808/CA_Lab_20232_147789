.data       
String1: .asciiz  "                                            *************        \n"
String2: .asciiz  "**************                             *3333333333333*       \n"
String3: .asciiz  "*222222222222222*                          *33333********        \n"
String4: .asciiz  "*22222******222222*                        *33333*               \n"
String5: .asciiz  "*22222*      *22222*                       *33333********        \n"
String6: .asciiz  "*22222*       *22222*      *************   *3333333333333*       \n"
String7: .asciiz  "*22222*       *22222*    **11111*****111*  *33333********        \n"
String8: .asciiz  "*22222*       *22222*  **1111**       **   *33333*               \n"
String9: .asciiz  "*22222*      *222222*  *1111*              *33333********        \n"
String10: .asciiz "*22222*******222222*  *11111*              *3333333333333*       \n"
String11: .asciiz "*2222222222222222*    *11111*               *************        \n"
String12: .asciiz "***************       *11111*                                    \n"
String13: .asciiz "      ---              *1111**                                   \n"
String14: .asciiz "    / o o \\             *1111****   *****                        \n"
String15: .asciiz "    \\   > /              **111111***111*                         \n"
String16: .asciiz "     -----                 ***********     dce.hust.edu.vn       \n"
EndString: .asciiz
Message0: .asciiz "------------SELECTION TABLE-----------\n"
Request1: .asciiz "1. Hien thi hinh anh\n"
Request2: .asciiz "2. In ra hinh anh chi co vien\n"
Request3: .asciiz "3. Hoan doi vi tri cac chu\n"
Request4: .asciiz "4. Doi mau chu\n"
Terminate: .asciiz "5. Thoat\n"
Choose: .asciiz "Choose your option: "
DColor: .asciiz "Nhap mau cho chu D (Tru ky tu '*'): "
CColor: .asciiz "Nhap mau cho chu C(Tru ky tu '*'): "
EColor: .asciiz "Nhap mau cho chu E(Tru ky tu '*'): "
newline: .asciiz "\n"
.text
main:
	la $t0, String1
	la $a1, EndString
	
	la $a0, Message0	
	li $v0, 4
	syscall
	la $a0, Request1	
	syscall
	la $a0, Request2	
	syscall
	la $a0, Request3	
	syscall
	la $a0, Request4	
	syscall
	la $a0, Terminate	
	syscall
	la $a0, Choose	
	syscall
	li $v0, 5
	syscall
	
Case1menu:
	li $v1, 1
	bne $v0, $v1, Case2menu
	j Print_Image
Case2menu:
	li $v1, 2
	bne $v0 $v1 Case3menu
	j Remove_Background
Case3menu:
	li $v1, 3
	bne $v0 $v1 Case4menu
	j Change_Position
Case4menu:
	li $v1, 4
	bne $v0 $v1 Case5menu
	j Fill_Color
Case5menu:
	li $v1, 5
	bne $v0 $v1 default
	j Termination
default:
	j main
	
Print_Image:
	beq $t0, $a1, end1
	lb $a0, 0($t0)
	li $v0, 11
	syscall
	addi $t0, $t0, 1
	j Print_Image
end1:
j main
Remove_Background:
	li $a0, ' '
    lb $t2, 0($t0)       
    beq $t0, $a1, end2    
    bge $t2, 48, check_upper_bound
    j print
check_upper_bound:
    ble $t2, 57, skip_char
print:
    move $a0, $t2         
skip_char:
    li $v0, 11         
    syscall
    addi $t0, $t0, 1   
    j Remove_Background  
end2:
j main
Change_Position:
	bge $t0, $a1, end3
	li $v0, 11
	addi $t3, $t0, 43
	li $t2, 17
	jal print_loop
	addi $t3, $t0, 22
	li $t2, 21
	jal print_loop
	addi $t3, $t0, 0
	li $t2, 21
	jal print_loop
	addi $t0, $t0, 0x43
	li $a0, '\n'
	syscall
	j Change_Position
print_loop:
	beqz $t2, end_print_loop
	lb $a0, 0($t3)
	syscall
	addi $t3, $t3, 1
	addi $t2, $t2, -1
	j print_loop
end_print_loop:
	jr $ra
end3:
j main
Fill_Color:
EnterDColor:		
	li $v0, 4		
	la $a0, DColor
	syscall
	li $v0, 12		# Lấy màu của ký tự D
	syscall
	beq $v0, 42, EnterDColor
	move $t3, $v0 # Luu mau D vao t3	
	li $v0, 4		
	la $a0, newline
	syscall
EnterCColor:
	li $v0, 4				
	la $a0, CColor
	syscall
	li 	$v0, 12		# Lấy màu của ký tự D
	syscall
	beq $v0, 42, EnterCColor
	move $t4, $v0 # Luu mau C vao t4
	li $v0, 4		
	la $a0, newline
	syscall
EnterEColor:
	li $v0, 4	
	la $a0, EColor
	syscall
	li $v0, 12		# Lấy màu của ký tự D
	syscall
	beq $v0, 42, EnterEColor
	move $t5, $v0 # Luu mau E vao t5
	li $v0, 4		
	la $a0, newline
	syscall
Redraw:
	beq $t0, $a1, end4
	lb $a0, 0($t0)
CheckDColor:
	bne $a0, '2', CheckCColor
	move $a0, $t3
	j print_color
CheckCColor:
	bne $a0, '1', CheckEColor
	move $a0, $t4
	j print_color
CheckEColor:
	bne $a0, '3', print_color
	move $a0, $t5
print_color:
	li $v0, 11
	syscall
	addi $t0, $t0, 1
	j Redraw
end4:
j main
Termination:
	li $v0, 10
	syscall 