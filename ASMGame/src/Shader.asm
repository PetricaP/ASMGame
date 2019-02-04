.model flat,stdcall 

include OpenGL.inc
include Shader.inc

include msvcrt.inc

SHADER struct
	rendererID dword 0
SHADER ends

compile_shader proto shaderSource:dword, shaderType:dword

.code
compile_shader proc uses ebx edi shaderSource:dword, shaderType:dword
	local result:dword
	local loglen:dword

	push shaderSource
	push shaderType
	call glCreateShader
	mov ebx, eax
	call glGetError

	push dword ptr 0
	lea eax, shaderSource
	push eax
	push dword ptr 1
	push ebx
	call glShaderSource
	call glGetError

	push ebx
	call glCompileShader
	call glGetError

	lea eax, result
	push eax
	push dword ptr GL_COMPILE_STATUS
	push ebx
	call glGetShaderiv

	lea eax, loglen
	push eax
	push dword ptr GL_INFO_LOG_LENGTH
	push ebx
	call glGetShaderiv

	mov edi, esp
	sub esp, loglen
	lea esi, loglen
	push esp
	push esi
	push loglen
	push ebx
	call glGetShaderInfoLog
	mov esp, edi

	.if result == 0
		push ebx
		call glDeleteShader
		xor ebx, ebx
	.endif

	mov eax, ebx

	ret
compile_shader endp

create_shader proc uses ebx edi esi vertexShaderSource:dword, fragmentShaderSource:dword
	call glCreateProgram
	mov ebx, eax
	call glGetError

	push ebx
	call glLinkProgram
	call glGetError

	push ebx
	invoke compile_shader, vertexShaderSource, GL_VERTEX_SHADER
	push eax

	invoke compile_shader, fragmentShaderSource, GL_FRAGMENT_SHADER
	mov esi, eax
	pop edi
	pop ebx

	push edi
	push ebx
	call glAttachShader
	call glGetError

	push esi
	push ebx
	call glAttachShader
	call glGetError

	push ebx
	call glLinkProgram
	call glGetError

	push ebx
	call glValidateProgram
	call glGetError

	push esi
	call glDeleteShader
	call glGetError

	push edi
	call glDeleteShader
	call glGetError

	push dword ptr SIZEOF SHADER
	call crt_malloc
	add esp, 4

	mov [eax].SHADER.rendererID, ebx

	ret
create_shader endp

destroy_shader proc uses ebx shader_handle:ISHADER
	mov ebx, shader_handle
	push [ebx].SHADER.rendererID
	call glDeleteProgram
	
	push ebx
	call crt_free
	ret
destroy_shader endp

use_shader proc shader_handle:ISHADER
	mov eax, shader_handle
	mov ecx, [eax].SHADER.rendererID
	push ecx
	call glUseProgram
	ret
use_shader endp

end

