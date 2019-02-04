.model flat,stdcall 
option casemap:none 

include Window.inc
include OpenGL.inc
include Shader.inc

include opengl32.inc
includelib opengl32.lib

include kernel32.inc 
includelib kernel32.lib

include msvcrt.inc 
includelib msvcrt.lib

.DATA
AppName db "Hello MASM", 0
vertices real4 -0.3, -0.3, 0.0, 0.3, 0.3, -0.3
aa dword 16 dup(20h)

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

.code
start:
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
	LOCAL window:IWINDOW
	LOCAL vbo:dword
	LOCAL vao:dword
	LOCAL shader:ISHADER

	;invoke AllocConsole
	;invoke GetCurrentProcessId
	;invoke AttachConsole, eax

	invoke create_window, addr AppName, 640, 480
	mov window, eax

	invoke init_gl

	lea eax, vao
	push eax
	push dword ptr 1
	GLCALL(glGenVertexArrays)

	push vao
	GLCALL(glBindVertexArray)

	lea eax, vbo
	push eax
	push dword ptr 1
	mov eax, glGenBuffers
	GLCALL(glGenBuffers)

	push vbo
	push dword ptr GL_ARRAY_BUFFER
	GLCALL(glBindBuffer)

	push dword ptr GL_STATIC_DRAW
	push offset vertices
	push dword ptr SIZEOF vertices
	push dword ptr GL_ARRAY_BUFFER
	GLCALL(glBufferData)

	push dword ptr 0
	GLCALL(glEnableVertexAttribArray)

	push dword ptr 0
	push dword ptr 8
	push dword ptr 0
	push dword ptr GL_FLOAT
	push dword ptr 2
	push dword ptr 0
	GLCALL(glVertexAttribPointer)

	invoke create_shader, addr vertexShader, addr fragmentShader
	mov shader, eax

	invoke use_shader, shader

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

	invoke destroy_shader, shader
	invoke destroy_window, window

	xor eax, eax
	invoke ExitProcess, 0
	ret 
WinMain endp

end start

