.model flat,stdcall

include VertexBuffer.inc
include OpenGL.inc
include msvcrt.inc

VertexBuffer struct
	rendererID dword 0
VertexBuffer ends

.code

createVertexBuffer proc dataIn:dword, sizeIn:dword, drawTypeIn:dword
	local id : dword

	lea eax, id
	push eax
	push dword ptr 1
	mov eax, glGenBuffers
	GLCALL(glGenBuffers)

	push id
	push dword ptr GL_ARRAY_BUFFER
	GLCALL(glBindBuffer)

	push drawTypeIn
	push dataIn
	push sizeIn
	push dword ptr GL_ARRAY_BUFFER
	GLCALL(glBufferData)

	push dword ptr SIZEOF VertexBuffer
	call crt_malloc
	add esp, 4

	mov ebx, id
	mov [eax].VertexBuffer.rendererID, ebx
	ret
createVertexBuffer endp

bindVertexBuffer proc vertexBufferIn:IVertexBuffer
	mov eax, vertexBufferIn
	mov eax, [eax].VertexBuffer.rendererID
	push eax
	push dword ptr GL_ARRAY_BUFFER
	GLCALL(glBindBuffer)
	ret
bindVertexBuffer endp

destroyVertexBuffer proc vertexBufferIn:IVertexBuffer
	mov eax, vertexBufferIn
	lea eax, [eax].VertexBuffer.rendererID
	push eax
	push dword ptr 1
	GLCALL(glDeleteBuffers)
	ret
destroyVertexBuffer endp

end
