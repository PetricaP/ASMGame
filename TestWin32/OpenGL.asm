include OpenGL.inc

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

.data
public glGenBuffers
glGenBuffers dword 0

public glBindBuffer
glBindBuffer dword 0

public glBufferData
glBufferData dword 0

public glGenVertexArrays
glGenVertexArrays dword 0

public glBindVertexArray
glBindVertexArray dword 0

public glEnableVertexAttribArray
glEnableVertexAttribArray dword 0

public glVertexAttribPointer
glVertexAttribPointer dword 0

public glCreateProgram
glCreateProgram dword 0

public glCreateShader
glCreateShader dword 0

public glShaderSource
glShaderSource dword 0

public glCompileShader
glCompileShader dword 0

public glAttachShader
glAttachShader dword 0

public glLinkProgram
glLinkProgram dword 0

public glValidateProgram
glValidateProgram dword 0

public glDeleteShader
glDeleteShader dword 0

public glGetShaderiv
glGetShaderiv dword 0

public glGetShaderInfoLog
glGetShaderInfoLog dword 0

public glUseProgram
glUseProgram dword 0

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
