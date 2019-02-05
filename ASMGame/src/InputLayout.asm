.model flat,stdcall
option casemap:none

include InputLayout.inc
include OpenGL.inc
include macros.asm

GL_FLOAT equ 1406h

.code

createInputLayout proc numElementsIn : dword, pInputLayoutElements : dword
	local layoutStride : dword
	xor esi, esi ; stride
	mov ecx, numElementsIn
	mov ebx, pInputLayoutElements
	.while ecx != 0
		mov eax, [ebx].InputLayoutElement.dataType
		switch eax
		case GL_FLOAT
			mov edi, 4
		endsw
		mov eax, [ebx].InputLayoutElement.number
		mul edi

		add esi, eax

		add ebx, SIZEOF InputLayoutElement
		sub ecx, 1
	.endw

	mov layoutStride, esi
	xor esi, esi
	xor ecx, ecx
	mov ebx, pInputLayoutElements
	.while ecx < numElementsIn
		push ecx
		push ecx
		GLCALL(glEnableVertexAttribArray)
		pop ecx

		push ecx

		push esi
		push layoutStride
		push dword ptr 0
		push [ebx].InputLayoutElement.dataType
		push [ebx].InputLayoutElement.number
		push ecx
		GLCALL(glVertexAttribPointer)

		pop ecx

		mov eax, [ebx].InputLayoutElement.dataType
		switch eax
		case GL_FLOAT
			mov edi, 4
		endsw
		mov eax, [ebx].InputLayoutElement.number
		mul edi

		add esi, eax

		add ebx, SIZEOF InputLayoutElement
		add ecx, 1
	.endw
	ret
createInputLayout endp

end
