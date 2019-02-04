.model flat,stdcall 
option casemap:none 

include Window.inc

include user32.inc 
include gdi32.inc
include msvcrt.inc
include opengl32.inc
include kernel32.inc 

HGLRC textequ <dword>

WINDOW struct
	hwnd HWND 0
	hdc HDC 0
	rdc HGLRC 0
	ShouldClose byte 0
WINDOW ends

.data
ClassName db "SimpleWinClass", 0

r real4 0.6f
g real4 0.3f
b real4 0.2f
a real4 1.0f

.code

create_window proc titleIn:LPCSTR, widthIn:dword, heightIn:dword
	local wc:WNDCLASSEX											
	local hwnd:HWND
	local dc:HDC
	local pfd:PIXELFORMATDESCRIPTOR
	local rdc:HGLRC

	mov   wc.cbSize,SIZEOF WNDCLASSEX				   
	mov   wc.style, CS_HREDRAW or CS_VREDRAW 
	mov   wc.lpfnWndProc, OFFSET WndProc 
	mov   wc.cbClsExtra,NULL 
	mov   wc.cbWndExtra,NULL 
	mov   wc.hInstance, NULL
	mov   wc.hbrBackground,COLOR_WINDOW+1
	mov   wc.lpszMenuName,NULL 
	mov   wc.lpszClassName,OFFSET ClassName 
	invoke LoadIcon,NULL,IDI_APPLICATION 
	mov   wc.hIcon,eax 
	mov   wc.hIconSm,eax 
	invoke LoadCursor,NULL,IDC_ARROW 
	mov   wc.hCursor,eax 
	invoke RegisterClassEx, addr wc					   
	invoke CreateWindowEx,
		NULL,\ 
		addr ClassName,\ 
		titleIn,\ 
		WS_OVERLAPPEDWINDOW,\ 
		CW_USEDEFAULT,\ 
		CW_USEDEFAULT,\ 
		widthIn,\ 
		heightIn,\ 
		NULL,\ 
		NULL,\ 
		NULL,\ 
		NULL 

	mov hwnd,eax 

	invoke ShowWindow, hwnd, 1			   
	invoke UpdateWindow, hwnd								 

	invoke GetDC, hwnd
	mov dc, eax

	mov pfd.nSize, sizeof(PIXELFORMATDESCRIPTOR)
	mov pfd.nVersion, 1
	mov eax, 0
	or eax, PFD_DRAW_TO_WINDOW
	or eax, PFD_SUPPORT_OPENGL
	or eax, PFD_DOUBLEBUFFER
	mov pfd.dwFlags, eax
	mov pfd.iPixelType, PFD_TYPE_RGBA
	mov pfd.cColorBits, 32
	mov pfd.cRedBits, 0
	mov pfd.cRedShift, 0
	mov pfd.cGreenBits, 0
	mov pfd.cGreenShift, 0
	mov pfd.cBlueBits, 0
	mov pfd.cBlueShift, 0
	mov pfd.cAlphaBits, 0
	mov pfd.cAlphaShift, 0
	mov pfd.cAccumBits, 0
	mov pfd.cAccumRedBits, 0
	mov pfd.cAccumGreenBits, 0
	mov pfd.cAccumBlueBits, 0
	mov pfd.cAccumAlphaBits, 0
	mov pfd.cDepthBits, 24
	mov pfd.cStencilBits, 8
	mov pfd.cAuxBuffers, 0
	mov pfd.iLayerType, PFD_MAIN_PLANE
	mov pfd.bReserved, 0
	mov pfd.dwLayerMask, 0
	mov pfd.dwVisibleMask, 0
	mov pfd.dwDamageMask, 0

	invoke ChoosePixelFormat, dc, addr pfd

	mov ebx, eax 
	invoke SetPixelFormat, dc, ebx, addr pfd

	invoke wglCreateContext, dc
	mov rdc, eax

	invoke wglMakeCurrent, dc, rdc

	invoke glClearColor, r, g, b, a

	push dword ptr sizeof(WINDOW)
	call crt_malloc
	add esp, 4
	mov ebx, hwnd
	mov [eax].WINDOW.hwnd, ebx
	mov ebx, dc
	mov [eax].WINDOW.hdc, ebx
	mov ebx, rdc
	mov [eax].WINDOW.rdc, ebx
	mov [eax].WINDOW.ShouldClose, 0

	ret
create_window endp

swap_buffers proc windowIn:dword
	mov ebx, windowIn
	mov ebx, [ebx].WINDOW.hdc
	invoke SwapBuffers, ebx
	ret
swap_buffers endp

destroy_window proc windowIn:dword
	mov ebx, windowIn
	invoke wglMakeCurrent, NULL, [ebx].WINDOW.rdc
	invoke wglDeleteContext, [ebx].WINDOW.rdc
	invoke DestroyWindow, [ebx].WINDOW.hwnd
	push windowIn
	call crt_free
	add esp, 4
	ret
destroy_window endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
	.IF uMsg==WM_DESTROY						   
		invoke PostQuitMessage,NULL			 
	.ELSE 
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam	 
		ret 
	.ENDIF 
	xor eax,eax 
	ret 
WndProc endp

poll_events proc windowIn:dword
	local msg:MSG 

	mov ebx, windowIn
	invoke GetMessage, addr msg,NULL,0,0 
	mov cl, [ebx].WINDOW.ShouldClose
	.if eax == 0
		xor cl, 1
		mov [ebx].WINDOW.ShouldClose, cl
	.endif
	invoke TranslateMessage, addr msg 
	invoke DispatchMessage, addr msg 
	ret
poll_events endp

should_close proc windowIn:dword
	mov ebx, windowIn
	xor eax, eax
	mov al, [ebx].WINDOW.ShouldClose
	ret
should_close endp

end

