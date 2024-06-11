.data
string: .space 100      # Do dai 100
prompt: .asciiz "Nhap mot xau: "
result: .asciiz "Sau khi hieu chinh: "
.text
    li $s1, 10  # 10 la dau enter trong ascii
    # In ra man hinh promp
    li $v0, 4
    la $a0, prompt
    syscall
 
    # Doc xau
    li $v0, 8
    la $a0, string
    li $a1, 100
    syscall

    li $t1, 65  # 65 la 'A'
    li $t2, 90  # 90 la 'Z'
    li $t3, 97  # 97 la 'a'
    li $t4, 122  # 122 la 'z'
    la $a0, string

loop:
    lb $t0, 0($a0)    # Load byte
    beq $t0, $s1, end_loop  # Ket thuc khi gap enter
    # Kiem tra xem co phai chu hoa khong
    blt $t0, $t1, not_uppercase
    bgt $t0, $t2, not_uppercase
    # Chuyen sang chu thuong
    addi $t0, $t0, 32
    # Cat lai vao string
    sb $t0, 0($a0)
    j continue
not_uppercase:
    # Kiem tra xem co phai chu thuong khong
    blt $t0, $t3, continue
    bgt $t0, $t4, continue

    # Chuyen tu thuong sang hoa
    addi $t0, $t0, -32
 
    # Cat lai vao string
    sb $t0, 0($a0) 
continue:
    addi $a0, $a0, 1  # Chuyen sang byte tiep theo
    j loop            # Lap
end_loop:
 
    # In ra ket qua
    li $v0, 4
    la $a0, result
    syscall
 
    li $v0, 4
    la $a0, string
    syscall
 
