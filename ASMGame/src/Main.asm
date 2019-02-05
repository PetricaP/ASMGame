.model flat,stdcall 
option casemap:none 

include Window.inc
include OpenGL.inc
include Shader.inc
include VertexBuffer.inc
include InputLayout.inc

include kernel32.inc 
include msvcrt.inc 

.data
AppName db "Hello MASM", 0
vertices real4 -0.3, -0.3, 0.7f, 0.2f, 0.1f,\
				0.0,  0.3, 0.8f, 0.3f, 0.2f,\
				0.3, -0.3, 0.6f, 0.1f, 0.3f
r real4 0.1f
g real4 0.3f
b real4 0.2f
a real4 1.0f

vsSource db\
"#version 330 core", 10,\
10,\
"layout(location = 0) in vec2 position;", 10,\
"layout(location = 1) in vec3 color;", 10,\
10,\
"out vec3 v_color;", 10,\
10,\
"void main() {", 10,\
"	gl_Position = vec4(position, 0.0f, 1.0f);", 10,\
"	v_color = color;", 10,\
"}", 10,
10, 0

fsSource db\
"#version 330 core", 10,\
10,\
"in vec3 v_color;", 10,\
10,\
"out vec4 color;", 10,\
10,\
"void main() {", 10,\
"	color = vec4(v_color, 1.0f);", 10,\
"}", 10,\
10, 0

.code
start:
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
	local window : IWindow
	local vbo : IVertexBuffer
	local vao : dword
	local shader : IShader
	local inputLayoutElements[2] : InputLayoutElement

	invoke createWindow, addr AppName, 640, 480
	mov window, eax

	invoke initGL

	lea eax, vao
	push eax
	push dword ptr 1
	GLCALL(glGenVertexArrays)

	push vao
	GLCALL(glBindVertexArray)

	invoke createVertexBuffer, addr vertices, SIZEOF vertices, GL_STATIC_DRAW
	mov vbo, eax

	lea eax, inputLayoutElements
	mov [eax].InputLayoutElement.dataType, GL_FLOAT
	mov [eax].InputLayoutElement.number, 2

	add eax, SIZEOF InputLayoutElement
	mov [eax].InputLayoutElement.dataType, GL_FLOAT
	mov [eax].InputLayoutElement.number, 3

	invoke createInputLayout, 2, addr inputLayoutElements

	invoke createShader, addr vsSource, addr fsSource
	mov shader, eax

	invoke bindShader, eax

	invoke glClearColor, r, g, b, a

	xor eax, eax
	.while eax == 0
		invoke swapBuffers, window

		invoke glClear, GL_COLOR_BUFFER_BIT

		push dword ptr 3
		push dword ptr 0
		push dword ptr GL_TRIANGLES
		call glDrawArrays

		invoke pollEvents, window

		invoke shouldClose, window
	.endw 

	invoke destroyVertexBuffer, vbo
	invoke destroyShader, shader
	invoke destroyWindow, window

	xor eax, eax
	invoke ExitProcess, 0
	ret 
WinMain endp

end start

