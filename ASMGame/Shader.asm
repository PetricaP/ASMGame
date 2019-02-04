include OpenGL.inc

include opengl32.inc

compile_shader proto shaderSource:dword, shaderType:dword

.data

extern glGenBuffers:dword
extern glBindBuffer:dword
extern glBufferData:dword
extern glGenVertexArrays:dword
extern glBindVertexArray:dword
extern glEnableVertexAttribArray:dword
extern glVertexAttribPointer:dword
extern glCreateProgram:dword
extern glCreateShader:dword
extern glShaderSource:dword
extern glCompileShader:dword
extern glAttachShader:dword
extern glLinkProgram:dword
extern glValidateProgram:dword
extern glDeleteShader:dword
extern glGetShaderiv:dword
extern glGetShaderInfoLog:dword
extern glUseProgram:dword

.code
compile_shader proc shaderSource:dword, shaderType:dword
	LOCAL result:dword
	LOCAL loglen:dword

	push ebx
	push esi
	push edi

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

	pop edi
	pop esi
	pop ebx

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

	mov eax, ebx
	ret
create_shader endp

end

