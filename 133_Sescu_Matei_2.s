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

	intScanf: .asciz "%d"
    pairScanf: .asciz "%d %d"
	intPrintf: .asciz "%d "
	endlinePrintf: .asciz "\n"

	infile: .asciz "in.txt"
	outfile: .asciz "out.txt"
	readtype: .asciz "r"
	writetype: .asciz "w"
	inputpointer: .space 32
	outpointer: .space 32

.text

.global main

main:

	pushl $readtype
	pushl $infile
	call fopen
	popl %ebx
	popl %ebx

	movl %eax, inputpointer

    pushl $n
	pushl $m
	pushl $pairScanf
	pushl inputpointer
	call fscanf
	popl %edx
	popl %edx
    popl %edx
	popl %edx

	incl n
	incl n
	incl m

	pushl $p
	pushl $intScanf
	pushl inputpointer
	call fscanf
	popl %edx
	popl %edx
	popl %edx
	
	movl $1, index
    jmp readLoop
    readLoopExit:

    pushl $k
    pushl $intScanf
	pushl inputpointer
    call fscanf
    popl %edx
    popl %edx
	popl %edx

    movl $0, index
    jmp gameOfLife
    gameOfLifeExit:

    jmp printMatrix
    printMatrixExit:

    jmp etexit

readLoop:
	movl index, %ecx
	cmp %ecx, p
	jl readLoopExit

    pushl $column
	pushl $row
	pushl $pairScanf
	pushl inputpointer
	call fscanf 
	popl %edx
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
	
printMatrix:
	pushl $writetype
	pushl $outfile
	call fopen
	popl %ebx
	popl %ebx

	movl %eax, outpointer

	movl $1, row
	for_rows:
		movl row, %ecx
		cmp %ecx, m
		jle printMatrixExit
		
		movl $1, column
		for_columns:
			movl column, %ecx
			incl %ecx
			cmp %ecx, n
			jle for_columnsEXIT

			movl row, %eax
			movl $0, %edx
			mull n
			addl column, %eax
			
			lea matrix1, %edi
			movl (%edi, %eax, 4), %ebx
			
			pushl %ebx
			pushl $intPrintf
			pushl outpointer
			call fprintf
			popl %edx
			popl %edx
			popl %edx
			
			pushl $0
			call fflush
			popl %edx
			
			incl column
			jmp for_columns
		for_columnsEXIT:

		pushl $endlinePrintf
		pushl outpointer
		call fprintf
		popl %ebx
		popl %ebx
		
		pushl $0
		call fflush
		popl %edx

		incl row
		jmp for_rows

etexit:
	pushl $0
	call fflush
	popl %edx

	movl $1, %eax
	movl $0, %ebx
	int $0x80
