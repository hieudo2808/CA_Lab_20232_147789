.eqv SEVENSEG_RIGHT 0xFFFF0010 # Dia chi cua den led 7 doan phai.
.eqv SEVENSEG_LEFT 0xFFFF0011  # Dia chi cua den led 7 doan trai
.eqv KEY_CODE 0xFFFF0004       # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000      # =1 if has a new keycode ?
.eqv DISPLAY_CODE 0xFFFF000C   # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008  # =1 if the display has already to do
.data
default_mess: .asciiz "if i can stop one heart from breaking"
message1: .asciiz "Thoi gian hoan thanh: "
message2: .asciiz "(s) \nToc do go trung binh cua ban la: "
message3: .asciiz " ky tu/s \n"
ask_again: .asciiz "Ban muon thu lai lan nua khong?"
.text
main:
    li $k0, KEY_CODE
    li $k1, KEY_READY
    li $s0, DISPLAY_CODE
    li $s1, DISPLAY_READY
    
    li $s2, 37 # length = 37
    la $s3, default_mess
    li $t4, 0 # count_correct = 0
	li $t3, 0 # set i = 0 
	li $s5, 0 # time_index, $s5 = 1000 => 1s
	li $s6, 0 # time (s)
loop:
	beq $t3, $s2, Print_SoKyTu
WaitForKey: 
	lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
	teqi $t1, 1 # if $t0 = 1 then raise an Interrupt
	nop
	li $v0, 32
	li $a0, 4 # sleep 4ms
	syscall
	blt	$s5, 250, continue # Slepp 4ms 250 lan -> 1s
	li $s5, -1 # Du 1s gan s5 = -1
	addi $s6, $s6, 1 # Tang bien thoi gian len 1
continue:
	addi $s5, $s5, 1 
 	j loop
.ktext 0x80000180
ReadKey: 
	lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
WaitForDis: 
	lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
 	beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling 
Encrypt: 
    add $t6, $s3, $t3 # Dia chi ky tu $t6 = dia chi co so $s3 + offset $t3
    lb $s4, 0($t6)
    addi $t3, $t3, 1 # Tang offset them 1
    bne $s4, $t0, ShowKey # Neu ky tu nhap vao so voi goc khong dung thi khong tang bien count
    addi $t4, $t4, 1
ShowKey: 
	sw $t0, 0($s0) # show key
 	nop 
next_pc:
	mtc0 $zero, $13 # Clear interrupt cause
 	mfc0 $at, $14 # $at <= Coproc0.$14 = Coproc0.epc
 	addi $at, $at, 4 # $at = $at + 4 (next instruction) 
 	mtc0 $at, $14 # Coproc0.$14 = Coproc0.epc <= $at 
	eret # Return from exception

Print_SoKyTu:
	li $t1, 0xA # Dua dau \n de man hinh display co xuong dong sau moi lan nhap
    sw $t1, 0($s0)
	move $s0, $t4
    li $t2, 10 
    div $s0, $t2 # Thuc hien phep chia 10 thi thanh ghi hi chua so ben phai va thanh lo la so ben trai
    mfhi $t1 
    jal num_0 # Kiem tra tu 0-9
    nop 
    jal SHOW_7SEG_RIGHT # show so ra thanh ghi led phai 
    nop 
    mflo $t1 
    jal num_0 
    nop 
    jal SHOW_7SEG_LEFT # show so ra thanh ghi led trai
    nop 
    j speed_calc
num_0: # Kiem tra co phai so 0 khong
    bne $t1, $zero, num_1 # Nhay sang kiem tra so 1
    li $a0, 0x3F 
    jr $ra 
num_1: # Kiem tra so 1
    li $s1, 1 
    bne $t1, $s1, num_2 
    li $a0, 0x6 
    jr $ra 
num_2: # Kiem tra so 2
    li $s1, 2 
    bne $t1, $s1, num_3 
    li $a0, 0x5B 
    jr $ra 
num_3: # Kiem tra so 3
    li $s1, 3 
    bne $t1, $s1, num_4 
    li $a0, 0x4F 
    jr $ra 
num_4: # Kiem tra so 4
    li $s1, 4 
    bne $t1, $s1, num_5 
    li $a0, 0x66 
    jr $ra 
num_5: # Kiem tra so 5
    li $s1, 5 
    bne $t1, $s1, num_6 
    li $a0, 0x6D 
    jr $ra 
num_6: # Kiem tra so 6
    li $s1, 6 
    bne $t1, $s1, num_7 
    li $a0, 0x7D 
    jr $ra 
num_7: # Kiem tra so 7 
    li $s1, 7 
    bne $t1, $s1, num_8 
    li $a0, 0x7 
    jr $ra 
num_8: # Kiem tra so 8
    li $s1, 8 
    bne $t1, $s1, num_9 
    li $a0, 0x7F 
    jr $ra 
num_9: # Kiem tra so 9
    li $s1, 9 
    li $a0, 0x6F 
    jr $ra 

SHOW_7SEG_LEFT: 
    li $t0, SEVENSEG_LEFT # assign port's address
    sb $a0, 0($t0) # assign new value
    nop
    jr $ra
    nop

SHOW_7SEG_RIGHT: 
    li $t0, SEVENSEG_RIGHT # assign port's address
    sb $a0, 0($t0) # assign new value
    nop
    jr $ra
    nop
speed_calc: # Tinh toan thoi gian hoan thanh va trung binh
	mtc1 $s6, $f1 # Dua thoi gian vao thanh ghi f1
	cvt.s.w $f1, $f1 # Chuyen doi sang dau phay dong chinh xac don
	mul $s5, $s5, 4 # Lay time_index nhan 4 vi 1 lan sleep la 4ms
	mtc1 $s5, $f3 # Dua vao f3
	cvt.s.w $f3, $f3
	li $s5, 1000 # Gan 1000 de chuyen doi ms -> s
	mtc1 $s5, $f5 
	cvt.s.w $f5, $f5
	div.s $f3, $f3, $f5 # Chuyen sang (s)
	add.s $f1, $f1, $f3  # Cong lai -> $f1 la thoi gian go phim
	mtc1 $s2, $f3
	cvt.s.w $f3, $f3
	div.s $f3, $f3, $f1 # $f3 la so ky tu tren 1s
exit: 
	li $v0, 4
	la $a0, message1 # Syscall hien thi thong bao 1
	syscall
	li $v0, 2
	mov.s $f12, $f1 # In ra thoi gian hoan thanh
	syscall
	li $v0, 4
	la $a0, message2 # Syscall hien thi thong bao 2
	syscall
	li $v0, 2
	mov.s $f12, $f3 # In ra thoi gian trung binh
	syscall
	li $v0, 4
	la $a0, message3 # Syscall hien thi thong bao 3
	syscall
	la $a0, ask_again # Hoi lai xem co thuc hien tiep hay khong
	li $v0, 50
	syscall
	beq $a0, $zero, main
    li $v0, 10
    syscall
endmain:
