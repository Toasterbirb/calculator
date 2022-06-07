section .text
	global _start


_start:
	; Ask for the first value
	mov eax, 4
	mov ebx, 1
	mov ecx, ask_first_value
	mov edx, ask_first_value_length
	int 0x80

	; Read and store the first value
	mov eax, 3
	mov ebx, 2
	mov ecx, val1
	mov edx, 4
	int 0x80

	; Convert the first value to decimal
	mov eax, [val1]
	sub eax, '0'
	mov [val1], eax



	; Ask for the second value
	mov eax, 4
	mov ebx, 1
	mov ecx, ask_second_value
	mov edx, ask_second_value_length
	int 0x80


	; Read and store the second value
	mov eax, 3
	mov ebx, 2
	mov ecx, val2
	mov edx, 4
	int 0x80

	; Convert the second value to decimal
	mov eax, [val2]
	sub eax, '0'
	mov [val2], eax


	; Print out all of the possible options
	mov eax, 4
	mov ebx, 1
	mov ecx, operation_list
	mov edx, operation_list_length
	int 0x80

	; Read in the chosen operation number
	mov eax, 3
	mov ebx, 2
	mov ecx, operation
	mov edx, 1
	int 0x80

	; Check what operation did the user select
	mov ecx, [operation]

	; Addition
	cmp ecx, '1'
	je addition

	; Subtraction
	cmp ecx, '2'
	je subtraction

	; Multiplication
	cmp ecx, '3'
	je multiplication

	; Division
	cmp ecx, '4'
	je division

	; If nothing was selected, just quit
	mov eax, 4
	mov ebx, 1
	mov ecx, error_text
	mov edx, error_text_length
	int 0x80
	jmp quit


	addition:
		mov eax, [val1]
		add eax, [val2]
		mov [result], eax
		jmp print_result

	subtraction:
		mov eax, [val1]
		sub eax, [val2]
		mov [result], eax
		jmp print_result

	multiplication:
		mov al, [val1]
		mov ah, [val2]
		mul al
		mov [result], ax
		jmp print_result

	division:
		; Coming soon
		mov eax, 4
		mov ebx, 1
		mov ecx, coming_soon
		mov edx, coming_soon_length
		int 0x80

		mov eax, 0x0
		mov [result], eax
		jmp print_result

	print_result:
		; Convert the result back to ASCII
		mov eax, [result]
		add eax, '0'
		mov [result], eax

		; Print the result text
		mov eax, 4
		mov ebx, 1
		mov ecx, result_text
		mov edx, result_text_length
		int 0x80

		; Print the resulting number
		mov eax, 4
		mov ebx, 1
		mov ecx, result
		mov edx, 4
		int 0x80

		; Print a newline
		mov eax, 4
		mov ebx, 1
		mov ecx, newline_char
		mov edx, 1
		int 0x80

		jmp quit


	quit:
		; Quit gracefully
		mov eax, 1
		mov ebx, 0
		int 0x80


section .bss
	val1: resb 4
	val2: resb 4
	operation: resb 1
	result: resb 4

section .data:
	ask_first_value: db "First value: "
	ask_first_value_length: equ $-ask_first_value

	ask_second_value: db "Second value: "
	ask_second_value_length: equ $-ask_second_value

	operation_list: db "Select operation:", 0xA, "1: +", 0xA, "2: -", 0xA, "3: *", 0xA, "4: /", 0xA, "> "
	operation_list_length: equ $-operation_list

	result_text: db "Result: "
	result_text_length: equ $-result_text

	error_text: db "No operation was selected...", 0xA
	error_text_length: equ $-error_text

	coming_soon: db "Coming soon(tm)", 0xA
	coming_soon_length: equ $-coming_soon

	newline_char: db 0xA
