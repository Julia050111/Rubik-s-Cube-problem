.data
cube: .word 1,1,1,1,1,1,1,1,1   # U face (0-8)
      .word 2,2,2,2,2,2,2,2,2   # D face (9-17)
      .word 3,3,3,3,3,3,3,3,3   # F face (18-26)
      .word 4,4,4,4,4,4,4,4,4   # B face (27-35)
      .word 5,5,5,5,5,5,5,5,5   # L face (36-44)
      .word 6,6,6,6,6,6,6,6,6   # R face (45-53)
student_id:    .asciz "s1121553\nInitial\n"
prompt:     .asciz "Input operator: "
newline:    .asciz "\n"
face_labels: .byte 'U','D','F','B','L','R'
CUBE_string: .asciz "U:111111111\nD:222222222\nF:333333333\nB:444444444\nL:555555555\nR:666666666\n"
.text
.global __start
__start:
    li a7, 4           # syscall 4: print string
    la a0, student_id    
    ecall
    li a7, 4           # syscall 4: print string
    la a0, CUBE_string    
    ecall
input_loop:
    # 印出提示
    li a7, 4
    la a0, prompt
    ecall

    # 讀入一個字元
    li a7, 12    # syscall 12 = read char
    ecall
    mv s0, a0    # 將輸入字元存入 t6
    li t0, 'U'
    beq s0, t0, rotate_U

    li t0, 'D'
    beq s0, t0, rotate_D

    li t0, 'F'
    beq s0, t0, rotate_F

    li t0, 'B'
    beq s0, t0, rotate_B

    li t0, 'L'
    beq s0, t0, rotate_L

    li t0, 'R'
    beq s0, t0, rotate_R

    j end_program
rotate_U:#chatgpt
    la t0, cube           # base address of cube
    li t1, 0              # U face offset為 0
    add t1, t0, t1        # U face base address

    # 讀取 U 面資料（9 格）
    lw t2,  0(t1)         # U[0]
    lw t3,  4(t1)         # U[1]
    lw t4,  8(t1)         # U[2]
    lw t5, 12(t1)         # U[3]
    lw t6, 16(t1)         # U[4]
    lw a0, 20(t1)         # U[5]
    lw a1, 24(t1)         # U[6]
    lw a2, 28(t1)         # U[7]
    lw a3, 32(t1)         # U[8]

    # 寫回旋轉後的 U 面
    sw a1,  0(t1)         # U[0] = U[6]
    sw t5,  4(t1)         # U[1] = U[3]
    sw t2,  8(t1)         # U[2] = U[0]
    sw a2, 12(t1)         # U[3] = U[7]
    sw t6, 16(t1)         # U[4] = U[4]
    sw t3, 20(t1)         # U[5] = U[1]
    sw a3, 24(t1)         # U[6] = U[8]
    sw a0, 28(t1)         # U[7] = U[5]
    sw t4, 32(t1)         # U[8] = U[2]

    # ---------- 邊塊旋轉 ----------
    # F[0,1,2] -> 暫存 s1~s3
    lw s1, 72(t0)         # F[0]
    lw s2, 76(t0)         # F[1]
    lw s3, 80(t0)         # F[2]

    # R[0,1,2] -> F[0,1,2]
    lw t1, 180(t0)        # R[0]
    lw t2, 184(t0)        # R[1]
    lw t3, 188(t0)        # R[2]
    sw t1, 72(t0)         # F[0]
    sw t2, 76(t0)         # F[1]
    sw t3, 80(t0)         # F[2]

    # B[0,1,2] -> R[0,1,2]
    lw t1, 108(t0)        # B[0]
    lw t2, 112(t0)        # B[1]
    lw t3, 116(t0)        # B[2]
    sw t1, 180(t0)        # R[0]
    sw t2, 184(t0)        # R[1]
    sw t3, 188(t0)        # R[2]

    # L[0,1,2] -> B[0,1,2]
    lw t1, 144(t0)        # L[0]
    lw t2, 148(t0)        # L[1]
    lw t3, 152(t0)        # L[2]
    sw t1, 108(t0)        # B[2]
    sw t2, 112(t0)        # B[1]
    sw t3, 116(t0)        # B[0]

    # s1~s3 -> L[0,1,2]
    sw s1, 144(t0)        # L[0]
    sw s2, 148(t0)        # L[1]
    sw s3, 152(t0)        # L[2]
    
    la t0, cube
    li t1, 0          # index
    li t2, 0          # face counter
    j print_face_loop

rotate_D:
    la t0, cube           # base address of cube
    li t1, 36             # D face offset = 9 * 4 = 36
    add t1, t0, t1        # D face base address

    # 讀取 D 面資料（9 格）
    lw t2,  0(t1)         # D[0]
    lw t3,  4(t1)         # D[1]
    lw t4,  8(t1)         # D[2]
    lw t5, 12(t1)         # D[3]
    lw t6, 16(t1)         # D[4]
    lw a0, 20(t1)         # D[5]
    lw a1, 24(t1)         # D[6]
    lw a2, 28(t1)         # D[7]
    lw a3, 32(t1)         # D[8]

    # 寫回旋轉後的 D 面
    sw a1,  0(t1)         # D[0] = D[6]
    sw t5,  4(t1)         # D[1] = D[3]
    sw t2,  8(t1)         # D[2] = D[0]
    sw a2, 12(t1)         # D[3] = D[7]
    sw t6, 16(t1)         # D[4] = D[4]
    sw t3, 20(t1)         # D[5] = D[1]
    sw a3, 24(t1)         # D[6] = D[8]
    sw a0, 28(t1)         # D[7] = D[5]
    sw t4, 32(t1)         # D[8] = D[2]

    # ---------- 邊塊旋轉 ----------
    # F[6,7,8] -> 暫存 s1~s3
    lw s1, 96(t0)         # F[6]
    lw s2, 100(t0)        # F[7]
    lw s3, 104(t0)        # F[8]

    # L[6,7,8] -> F[6,7,8]
    lw t1, 168(t0)        # L[6]
    lw t2, 172(t0)        # L[7]
    lw t3, 176(t0)        # L[8]
    sw t1, 96(t0)         # F[6]
    sw t2, 100(t0)        # F[7]
    sw t3, 104(t0)        # F[8]

    # B[6,7,8] -> L[6,7,8]
    lw t1, 132(t0)        # B[6]
    lw t2, 136(t0)        # B[7]
    lw t3, 140(t0)        # B[8]
    sw t1, 168(t0)        # L[6]
    sw t2, 172(t0)        # L[7]
    sw t3, 176(t0)        # L[8]

    # R[6,7,8] -> B[6,7,8]
    lw t1, 204(t0)        # R[6]
    lw t2, 208(t0)        # R[7]
    lw t3, 212(t0)        # R[8]
    sw t1, 132(t0)        # B[6]
    sw t2, 136(t0)        # B[7]
    sw t3, 140(t0)        # B[8]

    # s1~s3 -> R[6,7,8]
    sw s1, 204(t0)
    sw s2, 208(t0)
    sw s3, 212(t0)
    la t0, cube
    li t1, 0          # index
    li t2, 0          # face counter
    j print_face_loop

rotate_F:
    la t0, cube           # base address of cube
    addi t1, t0, 72       # F face base (18*4)

    # 讀取 F 面資料（9 格）進暫存區
    lw t2,  0(t1)         # F[0]
    lw t3,  4(t1)         # F[1]
    lw t4,  8(t1)         # F[2]
    lw t5, 12(t1)         # F[3]
    lw t6, 16(t1)         # F[4]
    lw a0, 20(t1)         # F[5]
    lw a1, 24(t1)         # F[6]
    lw a2, 28(t1)         # F[7]
    lw a3, 32(t1)         # F[8]

    # 寫回旋轉後的 F 面
    sw a1,  0(t1)         # F[0] = F[6]
    sw t5,  4(t1)         # F[1] = F[3]
    sw t2,  8(t1)         # F[2] = F[0]
    sw a2, 12(t1)         # F[3] = F[7]
    sw t6, 16(t1)         # F[4] = F[4]
    sw t3, 20(t1)         # F[5] = F[1]
    sw a3, 24(t1)         # F[6] = F[8]
    sw a0, 28(t1)         # F[7] = F[5]
    sw t4, 32(t1)         # F[8] = F[2]

    # ---------- 邊塊旋轉 ----------
    # U[6,7,8] -> 暫存 s1~s3
    lw s1, 24(t0)         # U[6]
    lw s2, 28(t0)         # U[7]
    lw s3, 32(t0)         # U[8]

    # L[8,5,2] -> U[6,7,8]
    lw t1, 176(t0)        # L[8]
    lw t2, 160(t0)        # L[5]
    lw t3, 144(t0)        # L[2]
    sw t1, 24(t0)         # U[6]
    sw t2, 28(t0)         # U[7]
    sw t3, 32(t0)         # U[8]

    # D[2,1,0] -> L[8,5,2]
    lw t1, 44(t0)        # D[2]
    lw t2, 40(t0)        # D[1]
    lw t3, 36(t0)         # D[0]
    sw t1, 176(t0)        # L[8]
    sw t2, 164(t0)        # L[5]
    sw t3, 152(t0)        # L[2]

    # R[0,3,6] -> D[2,1,0]
    lw t1, 180(t0)        # R[0]
    lw t2, 192(t0)        # R[3]
    lw t3, 204(t0)        # R[6]
    sw t1, 44(t0)        # D[2]
    sw t2, 40(t0)        # D[1]
    sw t3, 36(t0)         # D[0]

    # s1~s3 (原 U[6,7,8]) -> R[0,3,6]
    sw s1, 180(t0)
    sw s2, 192(t0)
    sw s3, 204(t0)

    la t0, cube
    li t1, 0          # index
    li t2, 0          # face counter
    j print_face_loop

rotate_B:
    la t0, cube           # base address of cube
    li t1, 108            # B face offset = 27 * 4 = 108
    add t1, t0, t1        # B face base address

    # 讀取 B 面資料（9 格）
    lw t2,  0(t1)         # B[0]
    lw t3,  4(t1)         # B[1]
    lw t4,  8(t1)         # B[2]
    lw t5, 12(t1)         # B[3]
    lw t6, 16(t1)         # B[4]
    lw a0, 20(t1)         # B[5]
    lw a1, 24(t1)         # B[6]
    lw a2, 28(t1)         # B[7]
    lw a3, 32(t1)         # B[8]

    # 寫回旋轉後的 B 面
    sw a1,  0(t1)         # B[0] = B[6]
    sw t5,  4(t1)         # B[1] = B[3]
    sw t2,  8(t1)         # B[2] = B[0]
    sw a2, 12(t1)         # B[3] = B[7]
    sw t6, 16(t1)         # B[4] = B[4]
    sw t3, 20(t1)         # B[5] = B[1]
    sw a3, 24(t1)         # B[6] = B[8]
    sw a0, 28(t1)         # B[7] = B[5]
    sw t4, 32(t1)         # B[8] = B[2]

    # ---------- 邊塊旋轉 ----------
    # D[6,7,8] -> 暫存 s1~s3
    lw s1, 60(t0)          
    lw s2, 64(t0)          
    lw s3, 68(t0)          

    # L[0,3,6] -> D[6,7,8] 
    lw t1, 144(t0)        # L[0]
    lw t2, 156(t0)        # L[3]
    lw t3, 168(t0)        # L[6]
    sw t1, 60(t0)          # D[6] = L[0]
    sw t2, 64(t0)          # D[7] = L[3]
    sw t3, 68(t0)          # D[8] = L[6]

    # U[2,1,0] -> L[0,3,6]
    lw t1, 8(t0)         # U[2]
    lw t2, 4(t0)         # U[1]
    lw t3, 0(t0)         # 0[0]
    sw t1, 144(t0)        # L[0] 
    sw t2, 156(t0)        # L[3] 
    sw t3, 168(t0)        # L[6] 

    # R[8,5,2] -> U[2,1,0]
    lw t1, 212(t0)        # R[8]
    lw t2, 200(t0)        # R[5]
    lw t3, 188(t0)        # R[2]
    sw t1, 8(t0)         # U[2] = R[8]
    sw t2, 4(t0)         # U[1] = R[5]
    sw t3, 0(t0)         # U[0] = R[2]

    # s1~s3 -> R[8,5,2]
    sw s1, 212(t0)        # R[8]
    sw s2, 200(t0)        # R[5]
    sw s3, 188(t0)        # R[2]
    
    la t0, cube
    li t1, 0          # index
    li t2, 0          # face counter
    j print_face_loop

rotate_L:
    la t0, cube           # base address of cube
    li t1, 144            # L face offset = 27 * 4 = 108
    add t1, t0, t1        # L face base address

    # 讀取 L 面資料（9 格）
    lw t2,  0(t1)         # L[0]
    lw t3,  4(t1)         # L[1]
    lw t4,  8(t1)         # L[2]
    lw t5, 12(t1)         # L[3]
    lw t6, 16(t1)         # L[4]
    lw a0, 20(t1)         # L[5]
    lw a1, 24(t1)         # L[6]
    lw a2, 28(t1)         # L[7]
    lw a3, 32(t1)         # L[8]

    # 寫回旋轉後的 L 面
    sw a1,  0(t1)         # L[0] = L[6]
    sw t5,  4(t1)         # L[1] = L[3]
    sw t2,  8(t1)         # L[2] = L[0]
    sw a2, 12(t1)         # L[3] = L[7]
    sw t6, 16(t1)         # L[4] = L[4]
    sw t3, 20(t1)         # L[5] = L[1]
    sw a3, 24(t1)         # L[6] = L[8]
    sw a0, 28(t1)         # L[7] = L[5]
    sw t4, 32(t1)         # L[8] = L[2]

    # ---------- 邊塊旋轉 ----------
    # D[0,3,6] -> 暫存 s1~s3
    lw s1, 36(t0)          
    lw s2, 48(t0)          
    lw s3, 60(t0)          

    # F[0,3,6] -> D[0,3,6] 
    lw t1, 72(t0)        # F[0]
    lw t2, 84(t0)        # F[3]
    lw t3, 96(t0)        # F[6]
    sw t1, 36(t0)          # D[0] = F[0]
    sw t2, 48(t0)          # D[3] = F[3]
    sw t3, 60(t0)          # D[6] = F[6]

    # U[0,3,6] -> F[0,3,6]
    lw t1, 0(t0)         # U[0]
    lw t2, 12(t0)         # U[3]
    lw t3, 24(t0)         # U[6]
    sw t3, 72(t0)        # F[0] 
    sw t2, 84(t0)        # F[3] 
    sw t1, 96(t0)        # F[6] 

    # B[8,5,2] -> U[0,3,6]
    lw t1, 140(t0)        # B[8]
    lw t2, 128(t0)        # B[5]
    lw t3, 116(t0)        # B[2]
    sw t1, 0(t0)         # U[0] = B[8]
    sw t2, 12(t0)         # U[3] = B[5]
    sw t3, 24(t0)         # U[6] = B[2]

    # s1~s3 -> B[8,5,2]
    sw s1, 140(t0)        # R[8]
    sw s2, 128(t0)        # R[5]
    sw s3, 116(t0)        # R[2]
    
    la t0, cube
    li t1, 0          # index
    li t2, 0          # face counter
    j print_face_loop

rotate_R:
    la t0, cube           # base address of cube
    li t1, 180            # R face offset = 27 * 4 = 108
    add t1, t0, t1        # R face base address

    # 讀取 R 面資料（9 格）
    lw t2,  0(t1)         # R[0]
    lw t3,  4(t1)         # R[1]
    lw t4,  8(t1)         # R[2]
    lw t5, 12(t1)         # R[3]
    lw t6, 16(t1)         # R[4]
    lw a0, 20(t1)         # R[5]
    lw a1, 24(t1)         # R[6]
    lw a2, 28(t1)         # R[7]
    lw a3, 32(t1)         # R[8]

    # 寫回旋轉後的 R 面
    sw a1,  0(t1)         # R[0] = R[6]
    sw t5,  4(t1)         # R[1] = R[3]
    sw t2,  8(t1)         # R[2] = R[0]
    sw a2, 12(t1)         # R[3] = R[7]
    sw t6, 16(t1)         # R[4] = R[4]
    sw t3, 20(t1)         # R[5] = R[1]
    sw a3, 24(t1)         # R[6] = R[8]
    sw a0, 28(t1)         # R[7] = R[5]
    sw t4, 32(t1)         # R[8] = R[2]

    # ---------- 邊塊旋轉 ----------
    # B[0,3,6] -> 暫存 s1~s3
    lw s1, 108(t0)          
    lw s2, 120(t0)          
    lw s3, 132(t0)          

    # U[8,5,2] -> B[0,3,6] 
    lw t1, 32(t0)        # U[8]
    lw t2, 20(t0)        # U[5]
    lw t3, 8(t0)        # U[2]
    sw t1, 108(t0)          # B[0] = U[8]
    sw t2, 120(t0)          # B[3] = U[5]
    sw t3, 132(t0)          # B[6] = U[2]
    
    # F[8,5,2] -> U[8,5,2]
    lw t1, 104(t0)        # F[8]
    lw t2, 92(t0)        # F[5]
    lw t3, 80(t0)        # F[2]
    sw t1, 32(t0)         # U[8] = F[8]
    sw t2, 20(t0)         # U[5] = F[5]
    sw t3, 8(t0)         # U[2] = F[2]

    # D[8,5,2] -> F[8,5,2]
    lw t1, 68(t0)         # D[8]
    lw t2, 56(t0)         # D[5]
    lw t3, 44(t0)         # D[2]
    sw t3, 104(t0)        # F[8] 
    sw t2, 92(t0)        # F[5] 
    sw t1, 80(t0)        # F[2] 

    # s1~s3 -> D[8,5,2]
    sw s1, 68(t0)        # D[8]
    sw s2, 56(t0)        # D[5]
    sw s3, 44(t0)        # D[2]
    
    la t0, cube
    li t1, 0          # index
    li t2, 0          # face counter
    j print_face_loop
print_face_loop:
    li t3, 9
    li a7, 4
    # 印 face 標籤
    la a0, newline
    ecall
    la a1, face_labels    # face_labels 陣列 #456~460 chatgpt
    add a1, a1, t2        # a1 = face_labels + t2
    lbu a0, 0(a1)         # 讀取 face 名稱
    li a7, 11
    ecall
    li a7, 11
    li a0, ':'
    ecall

print_face_values:#chatgpt
    beq t3, zero, next_face
    lw t4, 0(t0)
    addi t4, t4, 48   # 轉成 ASCII 數字
    li a7, 11
    mv a0, t4
    ecall
    addi t0, t0, 4
    addi t3, t3, -1
    j print_face_values

next_face:
    addi t2, t2, 1
    li t5, 6
    blt t2, t5, print_face_loop
    li a7, 4           # syscall 4: print string
    la a0, newline    
    ecall

    j input_loop

end_program:
    li a7, 10
    ecall
