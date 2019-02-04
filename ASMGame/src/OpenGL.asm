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

loadGLFunction proto funcname:dword, funcptr:dword

.code
initGL proc
	invoke loadGLFunction, addr glGenBuffersStr, offset glGenBuffers
	invoke loadGLFunction, addr glBindBufferStr, offset glBindBuffer
	invoke loadGLFunction, addr glBufferDataStr, offset glBufferData
	invoke loadGLFunction, addr glBindVertexArrayStr, offset glBindVertexArray
	invoke loadGLFunction, addr glGenVertexArraysStr, offset glGenVertexArrays
	invoke loadGLFunction, addr glEnableVertexAttribArrayStr, offset glEnableVertexAttribArray
	invoke loadGLFunction, addr glVertexAttribPointerStr, offset glVertexAttribPointer
	invoke loadGLFunction, addr glCreateProgramStr, offset glCreateProgram
	invoke loadGLFunction, addr glCreateShaderStr, offset glCreateShader
	invoke loadGLFunction, addr glShaderSourceStr, offset glShaderSource
	invoke loadGLFunction, addr glCompileShaderStr, offset glCompileShader
	invoke loadGLFunction, addr glAttachShaderStr, offset glAttachShader
	invoke loadGLFunction, addr glLinkProgramStr, offset glLinkProgram
	invoke loadGLFunction, addr glValidateProgramStr, offset glValidateProgram
	invoke loadGLFunction, addr glDeleteShaderStr, offset glDeleteShader
	invoke loadGLFunction, addr glGetShaderivStr, offset glGetShaderiv
	invoke loadGLFunction, addr glGetShaderInfoLogStr, offset glGetShaderInfoLog
	invoke loadGLFunction, addr glUseProgramStr, offset glUseProgram
	invoke loadGLFunction, addr glDeleteProgramStr, offset glDeleteProgram
	invoke loadGLFunction, addr glDeleteBuffersStr, offset glDeleteBuffers
	ret
initGL endp

loadGLFunction proc funcname:dword, funcptr:dword
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
loadGLFunction endp

end

