include opengl32.inc

GL_ARRAY_BUFFER equ 8892h
GL_STATIC_DRAW equ 88E4h
GL_FRAGMENT_SHADER equ 8B30h
GL_VERTEX_SHADER equ 8B31h
GL_COMPILE_STATUS equ 8B81h
GL_INFO_LOG_LENGTH equ 8B84h

initGL proto
handleGLError proto code:dword

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
extern glDeleteProgram:dword
extern glDeleteBuffers:dword

GLCALL macro X
	call X
	invoke glGetError
	.if eax != 0
		; An error occured
	.endif
endm

