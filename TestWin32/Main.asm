.model flat,stdcall 
option casemap:none 

include Window.inc

include opengl32.inc
includelib opengl32.lib

include OpenGL.inc

include kernel32.inc 
includelib kernel32.lib

create_shader proto vertexShaderSource:dword, fragmanetShaderSource:dword

.DATA
AppName db "Hello MASM", 0
vertices real4 -0.3, -0.3, 0.0, 0.3f, 0.3f, -0.3f
aa dword 16 dup(20h)
vbo dword 0
vao dword 0

vertexShader db\
"#version 330 core", 10,\
10,\
"layout(location = 0) in vec4 position;", 10,\
10,\
"void main() {", 10,\
"	gl_Position = position;", 10,\
"}", 10,
10, 0

fragmentShader db\
"#version 330 core", 10,\
10,\
"out vec4 color;", 10,\
10,\
"void main() {", 10,\
"	color = vec4(0.2f, 0.0f, 0.5f, 1.0f);", 10,\
"}", 10,\
10, 0

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

.CODE
start:
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
	LOCAL window:WINDOWPTR

	invoke create_window, addr AppName, 640, 480
	mov window, eax

	invoke init_gl

	push offset vao
	push dword ptr 1
	call glGenVertexArrays
	invoke glGetError

	push vao
	call glBindVertexArray
	invoke glGetError

	push offset vbo
	push dword ptr 1
	mov eax, glGenBuffers
	call glGenBuffers
	invoke glGetError

	push vbo
	push dword ptr GL_ARRAY_BUFFER
	call glBindBuffer
	invoke glGetError

	push dword ptr GL_STATIC_DRAW
	push offset vertices
	push dword ptr SIZEOF vertices
	push dword ptr GL_ARRAY_BUFFER
	call glBufferData
	invoke glGetError

	push dword ptr 0
	call glEnableVertexAttribArray
	invoke glGetError

	push dword ptr 0
	push dword ptr 8
	push dword ptr 0
	push dword ptr GL_FLOAT
	push dword ptr 2
	push dword ptr 0
	call glVertexAttribPointer
	invoke glGetError

	push offset fragmentShader
	push offset vertexShader
	call create_shader	

	push eax
	call glUseProgram
	invoke glGetError

	xor eax, eax
    .while eax == 0
		invoke swap_buffers, window

		invoke glClear, GL_COLOR_BUFFER_BIT

		push dword ptr 3
		push dword ptr 0
		push dword ptr GL_TRIANGLES
		call glDrawArrays

		invoke poll_events, window

		invoke should_close, window
   .endw 

    invoke destroy_window, window
    xor eax, eax
	invoke ExitProcess, 0
    ret 
WinMain endp

end start

