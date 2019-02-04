.model flat,stdcall 

include opengl32.inc
includelib opengl32.lib

include libc.inc
includelib libc.lib

.data
libraryStr db "opengl32.dll", 0
glGenBuffersStr db "glGenBuffers", 0
glBindBufferStr db "glBindBuffer", 0
glBufferDataStr db "glBufferData", 0
glGenVertexArraysStr db "glGenVertexArrays", 0
glBindVertexArrayStr db "glBindVertexArray", 0
glEnableVertexAttribArrayStr db "glEnableVertexAttribArray", 0
glVertexAttribPointerStr db "glVertexAttribPointer", 0
glCreateProgramStr db "glCreateProgram", 0
glCreateShaderStr db "glCreateShader", 0
glShaderSourceStr db "glShaderSource", 0
glCompileShaderStr db "glCompileShader", 0
glAttachShaderStr db "glAttachShader", 0
glLinkProgramStr db "glLinkProgram", 0
glValidateProgramStr db "glValidateProgram", 0
glDeleteShaderStr db "glDeleteShader", 0
glGetShaderivStr db "glGetShaderiv", 0
glGetShaderInfoLogStr db "glGetShaderInfoLog", 0
glUseProgramStr db "glUseProgram", 0
glDeleteProgramStr db "glDeleteProgram", 0
glDeleteBuffersStr db "glDeleteBuffers", 0

public glGenBuffers
public glBindBuffer
public glBufferData
public glGenVertexArrays
public glBindVertexArray
public glEnableVertexAttribArray
public glVertexAttribPointer
public glCreateProgram
public glCreateShader
public glShaderSource
public glCompileShader
public glAttachShader
public glLinkProgram
public glValidateProgram
public glDeleteShader
public glGetShaderiv
public glGetShaderInfoLog
public glUseProgram
public glDeleteProgram
public glDeleteBuffers

glBindBuffer dword 0
glGenBuffers dword 0
glBufferData dword 0
glGenVertexArrays dword 0
glBindVertexArray dword 0
glEnableVertexAttribArray dword 0
glVertexAttribPointer dword 0
glCreateProgram dword 0
glCreateShader dword 0
glShaderSource dword 0
glCompileShader dword 0
glAttachShader dword 0
glLinkProgram dword 0
glValidateProgram dword 0
glDeleteShader dword 0
glGetShaderiv dword 0
glGetShaderInfoLog dword 0
glUseProgram dword 0
glDeleteProgram dword 0
glDeleteBuffers dword 0

load_function proto funcname:dword, funcptr:dword

.code
init_gl proc
	invoke load_function, addr glGenBuffersStr, offset glGenBuffers
	invoke load_function, addr glBindBufferStr, offset glBindBuffer
	invoke load_function, addr glBufferDataStr, offset glBufferData
	invoke load_function, addr glBindVertexArrayStr, offset glBindVertexArray
	invoke load_function, addr glGenVertexArraysStr, offset glGenVertexArrays
	invoke load_function, addr glEnableVertexAttribArrayStr, offset glEnableVertexAttribArray
	invoke load_function, addr glVertexAttribPointerStr, offset glVertexAttribPointer
	invoke load_function, addr glCreateProgramStr, offset glCreateProgram
	invoke load_function, addr glCreateShaderStr, offset glCreateShader
	invoke load_function, addr glShaderSourceStr, offset glShaderSource
	invoke load_function, addr glCompileShaderStr, offset glCompileShader
	invoke load_function, addr glAttachShaderStr, offset glAttachShader
	invoke load_function, addr glLinkProgramStr, offset glLinkProgram
	invoke load_function, addr glValidateProgramStr, offset glValidateProgram
	invoke load_function, addr glDeleteShaderStr, offset glDeleteShader
	invoke load_function, addr glGetShaderivStr, offset glGetShaderiv
	invoke load_function, addr glGetShaderInfoLogStr, offset glGetShaderInfoLog
	invoke load_function, addr glUseProgramStr, offset glUseProgram
	invoke load_function, addr glDeleteProgramStr, offset glDeleteProgram
	invoke load_function, addr glDeleteBuffersStr, offset glDeleteBuffers
	ret
init_gl endp

load_function proc funcname:dword, funcptr:dword
	invoke wglGetProcAddress, funcname
	mov ebx, funcptr
	.if eax != 0
		mov [ebx], eax
	.else
		invoke LoadLibraryA, addr libraryStr
		mov esi, eax
		invoke GetProcAddress, esi, funcname
		mov [ebx], eax
	.endif
	ret
load_function endp

end

