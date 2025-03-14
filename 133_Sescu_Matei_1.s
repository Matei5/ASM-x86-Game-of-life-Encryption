.data

	matrix1: .space 1600
	matrix2: .space 1600

	index: .space 4
    row: .space 4
	column: .space 4

    m: .space 4 # numar de linii
	n: .space 4 # numar de coloane
	p: .space 4
    k: .space 4

	nr0: .long 0
	count: .space 4
	size: .space 4

	intScanf: .asciz "%d"
    pairScanf: .asciz "%d %d"
	strScanf: .asciz "%s"
	intPrintf: .asciz "%d"
	strPrintf: .asciz "%s"
	hexPrintf: .asciz "0x"
	endlinePrintf: .asciz "\n"

	option: .space 4
	crypt: .space 26
	letter: .space 4
	cheie: .space 4
	length: .space 4
	i: .long 0

.text

.global main

main:
	hide_part_0x00: 
		pushl $n
		pushl $m
		pushl $pairScanf
		call scanf
		popl %edx
		popl %edx
		popl %edx

		incl n
		incl n
		incl m

		pushl $p
		pushl $intScanf
		call scanf
		popl %edx
		popl %edx
		
		movl $1, index
		jmp readLoop
		readLoopExit:

		pushl $k
		pushl $intScanf
		call scanf
		popl %edx
		popl %edx

		movl $0, index
		jmp gameOfLife
		gameOfLifeExit:

	pushl $option
	pushl $intScanf
	call scanf
	popl %edx
	popl %edx

	pushl $crypt
	pushl $strScanf
	call scanf
	popl %edx
	popl %edx

	pushl $crypt
	call strlen
	popl %edx
	movl %eax, length

	movl m, %eax
	incl %eax
	movl $0, %edx
	mull n
	movl %eax, size

	movl option, %ebx
	cmp %ebx, nr0
	je criptare
	jmp decriptare
	ex1EXIT:

    jmp etexit

criptare:

	movl $4, %eax
	movl $1, %ebx
	movl $hexPrintf, %ecx
	movl $3, %edx
	int $0x80

	movl $0, index
	movl $0, count
	movl $0, cheie
	for0:
		movl count, %ecx
		cmp %ecx, size
		jle for0EXIT

		movl i, %ecx
		cmp %ecx, length
		jle ex1EXIT

		movl count, %eax
		lea matrix1, %edi
		movl (%edi, %eax, 4), %ebx

		shll cheie
		addl %ebx, cheie

		incl index
		movl $8, %eax
		cmpl %eax, index
		je xoring0
		xoring0EXIT:

		incl count
		jmp for0
	for0EXIT:

	movl $0, count
	jmp for0

xoring0:
	movl i, %eax
	lea crypt, %edi
    movb (%edi, %eax, 1), %bl
	incl i
	
	xorb cheie, %bl
	movb %bl, letter

	printPart0:
		movb letter, %bl

		shlw %bx
		shlw %bx
		shlw %bx
		shlw %bx

		shrb %bl
		shrb %bl
		shrb %bl
		shrb %bl

		movb %bh, letter

		movl $10, %eax
		cmp %eax, letter
		jl skip01

		addl $55, letter
		jmp skip02
		skip01:

		addl $48, letter
		skip02:

		pushl $letter
		pushl $strPrintf
		call printf
		popl %edx
		popl %edx

		pushl $0
		call fflush
		popl %edx

		movb %bl, letter

		movl $10, %eax
		cmp %eax, letter
		jl skip03

		addl $55, letter
		jmp skip04
		skip03:

		addl $48, letter
		skip04:

		pushl $letter
		pushl $strPrintf
		call printf
		popl %edx
		popl %edx

		pushl $0
		call fflush
		popl %edx

	movl $0, index
	movl $0, cheie
	jmp xoring0EXIT

decriptare:

	addl $1, i

	movl $0, index
	movl $0, count
	movl $0, cheie
	for1:
		movl count, %ecx
		cmp %ecx, size
		jle for1EXIT

		movl i, %ecx
		shll %ecx
		cmp %ecx, length
		jle ex1EXIT

		movl count, %eax
		lea matrix1, %edi
		movl (%edi, %eax, 4), %ebx

		shll cheie
		addl %ebx, cheie

		incl index
		movl $8, %eax
		cmpl %eax, index
		je xoring1
		xoring1EXIT:

		incl count
		jmp for1
	for1EXIT:

	movl $0, count
	jmp for1
	
xoring1:
	movl i, %eax
	lea crypt, %edi
    movw (%edi, %eax, 2), %bx
	addl $1, i

	bh:
		movb $10, %ah

		subb $48, %bh
		cmp %ah, %bh
		jl skip11
		
		subb $7, %bh
		skip11:

	bl:
		movb $10, %al

		subb $48, %bl
		cmp %al, %bl
		jl skip12

		subb $7, %bl
		skip12:

	movb %bl, %al
	movb %bh, %bl
	movb %al, %bh

	shlb %bl
	shlb %bl
	shlb %bl
	shlb %bl

	shrw %bx
	shrw %bx
	shrw %bx
	shrw %bx

	xorb cheie, %bl

	movb %bl, letter

	pushl $letter
	pushl $strPrintf
	call printf
	popl %edx
	popl %edx

	pushl $0
	call fflush
	popl %edx


	movl $0, index
	movl $0, cheie
	jmp xoring1EXIT

readLoop:
	movl index, %ecx
	cmp %ecx, p
	jl readLoopExit

    pushl $column
	pushl $row
	pushl $pairScanf
	call scanf 
	popl %edx
	popl %edx
    popl %edx
	
	movl row, %eax
    incl %eax
	movl $0, %edx
	mull n
	addl column, %eax
    incl %eax
	
	lea matrix1, %edi
	movl $1, (%edi, %eax, 4)

	incl index
	jmp readLoop

gameOfLife:
    movl index, %ecx
    cmp %ecx, k
    jle gameOfLifeExit

    movl $1, row
	GOF_rows:
		movl row, %ecx
		cmp %ecx, m
		jle GOF_rowsExit

		movl $1, column
		GOF_columns:
			movl column, %ecx
			cmp %ecx, n
			jle GOF_columnsExit
			
			movl $0, count
			jmp GOF_check1
			GOF_checkEXIT:

			incl column
			jmp GOF_columns

        GOF_columnsExit:

        incl row
		jmp GOF_rows
	GOF_rowsExit:

	
	movl $1, row
	MOV_rows:
		movl row, %ecx
		cmp %ecx, m
		jl MOV_rowsExit

		movl $1, column
		MOV_columns:
			movl column, %ecx
			cmp %ecx, n
			jl MOV_columnsExit
			
			movl row, %eax
			movl $0, %edx
			mull n
			addl column, %eax

			lea matrix2, %edi
			movl (%edi, %eax, 4), %ebx
			lea matrix1, %edi
			movl %ebx, (%edi, %eax, 4)

			incl column
			jmp MOV_columns

        MOV_columnsExit:

        incl row
		jmp MOV_rows
	MOV_rowsExit:

    incl index
    jmp gameOfLife

GOF_check:

	movl row, %eax
	movl $0, %edx
	mull n
	addl column, %eax

	lea matrix1, %edi
	movl (%edi, %eax, 4), %ebx

	cmp %ebx, nr0
	je GOF_case0

	jmp GOF_case1

GOF_case0:

	movl row, %eax
	movl $0, %edx
	mull n
	addl column, %eax

	lea matrix2, %edi
	movl $0, (%edi, %eax, 4)

	movl $3, %ebx
	cmp %ebx, count
	jne GOF_checkEXIT

	movl $1, (%edi, %eax, 4)

	jmp GOF_checkEXIT

GOF_case1:

	movl row, %eax
	movl $0, %edx
	mull n
	addl column, %eax

	lea matrix2, %edi
	movl $1, (%edi, %eax, 4)

	movl $2, %ebx
	cmp %ebx, count
	je GOF_checkEXIT
	
	movl $3, %ebx
	cmp %ebx, count
	je	GOF_checkEXIT

	movl $0, (%edi, %eax, 4)
	
	jmp GOF_checkEXIT

GOF_checks:
	GOF_check1:

		movl row, %eax
		decl %eax
		movl $0, %edx
		mull n
		addl column, %eax
		decl %eax

		lea matrix1, %edi
		movl (%edi, %eax, 4), %ebx

		cmp %ebx, nr0
		je GOF_check2

		incl count

		jmp GOF_check2

	GOF_check2:

		incl %eax
		movl (%edi, %eax, 4), %ebx

		cmp %ebx, nr0
		je GOF_check3
		
		incl count

		jmp GOF_check3

	GOF_check3:

		incl %eax
		movl (%edi, %eax, 4), %ebx

		cmp %ebx, nr0
		je GOF_check4

		incl count

		jmp GOF_check4

	GOF_check4:

		subl $2, %eax
		addl n, %eax
		movl (%edi, %eax, 4), %ebx

		cmp %ebx, nr0
		je GOF_check5
		
		incl count

		jmp GOF_check5

	GOF_check5:

		addl $2, %eax
		movl (%edi, %eax, 4), %ebx

		cmp %ebx, nr0
		je GOF_check6

		incl count

		jmp GOF_check6

	GOF_check6:

		subl $2, %eax
		addl n, %eax
		movl (%edi, %eax, 4), %ebx

		cmp %ebx, nr0
		je GOF_check7

		incl count

		jmp GOF_check7

	GOF_check7:

		incl %eax
		movl (%edi, %eax, 4), %ebx

		cmp %ebx, nr0
		je GOF_check8

		incl count

		jmp GOF_check8

	GOF_check8:

		incl %eax
		movl (%edi, %eax, 4), %ebx

		cmp %ebx, nr0
		je GOF_check

		incl count

		jmp GOF_check

etexit:
	pushl $endlinePrintf
	call printf
	popl %edx

	pushl $0
	call fflush
	popl %edx

	movl $1, %eax
	movl $0, %ebx
	int $0x80
