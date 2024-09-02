
section .data
	err db "Error: Not int",0
	len equ $ - err
	inp db "Enter Number 1: ",0
	inp_len equ $ - inp
	inp2 db "Enter Number 2: ",0
	inp2_len equ $ - inp2
	ans_txt db "Ans: ",0
	ans_txt_len equ $ - ans_txt
	op_list db "1. Add",0xa,"2. Sub",0xa,"3. Mul",0xa,"4. Div",0xa,"Chocice: "
	op_len equ $ -	op_list	 
	err2 db "Invalid choice",0xa
	err2_len equ $ - err2
	num1 dd 0
	num2 dd 0
	choice db 0
	ans dd 0
	num_len equ 32
section .bss
	num resb num_len
section .text
global _start

_start:

	; input num 1
	push inp_len
	push inp 
	call print
	push num_len
	push num
	call input
	call toint
	mov [num1],eax
	; input num 2
	push inp2_len
	push inp2 
	call print
	push num_len
	push num
	call input
	call toint
	mov [num2],eax
	;print choice list and take input	
	push op_len
	push op_list
	call print
	push num_len
	push num
	call input
	call toint

	;operations
	cmp eax,1
	je .add
	cmp eax,2
	je .sub
	cmp eax,3
	je .mul
	cmp eax,4
	je .div
	push err2_len
	push err2
	call print
	jmp exit
	.add:
		mov eax,[num1]
		add eax,[num2]
		jmp .done
	.sub:
		mov eax,[num1]
		sub eax,[num2]
		jmp .done
	.mul:
		mov eax,[num1]
		mov ebx, [num2]
		imul ebx
		jmp .done
	.div:
		mov eax,[num1]
		mov ebx,[num2]
		cmp eax,0
		jl .l1
		jmp .l2
		.l1:
			mov edx,-1
			imul edx
			push eax
			mov eax,ebx
			mov edx,-1
			imul edx
			mov ebx,eax
			pop eax
			
					
		.l2:
			xor edx,edx	
			idiv ebx
		jmp .done

	.done:
		mov [ans],eax
		push ans_txt_len
		push ans_txt
		call print
		push dword [ans]
		mov dword [num], 0
		call tostr
		push eax
		call print
	jmp exit
exit:
		mov eax,1
		mov ebx,1
		int 0x80

tostr:
	push ebp
	mov ebp ,esp
	mov eax,[ebp+0x8]
	lea edi, [num + 15]
    	mov byte [edi], 0x0A
	cmp eax,0
	jl .negative
	push 1
	jmp .loop
	.negative:
		mov edx,-1
		imul edx
		push -1

	.loop:
		dec edi
		xor edx, edx
    		mov ecx, 10
    		div ecx
    		add dl, '0'
    		mov [edi], dl
    		test eax, eax
    		jnz .loop	
		
	.done:
		pop edx
		cmp edx,-1
		je .l3
		jmp .l4
		.l3:	
			dec edi
			mov byte [edi] ,'-'
		.l4:
			mov eax,edi
			mov esp,ebp
			pop ebp
			ret 
	
toint:
	push ebp
	mov ebp,esp
	mov ebx,[ebp+0x8]			
	mov edx,0
	cmp byte [ebx],'-'
	jne .branch
	mov ecx,-1
	inc bl
	jmp .loop2
	.branch:
		mov ecx,1
	.loop2:
		cmp byte [ebx],0xa
		je .done
		mov eax,[ebx]
		sub al,'0'
		cmp al,0
		jl .error	
		cmp al,9
		jg .error
		imul edx,10
		add dl,al
		inc bl
		jmp .loop2
	.error:
		push len
		push err
		call print
		call printn
		mov esp ,ebp
		pop ebp
		jmp exit		
	
	.done:
		imul edx,ecx
		mov eax,edx
		mov esp,ebp
		pop ebp
		ret	
	

input: 
	push ebp
	mov ebp,esp
	mov ecx,[ebp+0x8]
	mov edx,[ebp+0xc]
	mov eax,3
	mov ebx,0
	int 0x80
	pop ebp
	ret


print:
	push ebp
	mov ebp,esp
	mov ecx,[ebp+0x8]
	mov edx,[ebp+12]
	mov eax,4
	mov ebx,1
	int 0x80
	pop ebp
	ret
printn:
	push 0xa
	mov eax, 4
	mov ebx, 1
	mov edx, 1
	mov ecx,esp
	int 0x80
	pop ecx
	ret
