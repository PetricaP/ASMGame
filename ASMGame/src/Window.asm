.model flat,stdcall 
option casemap:none 

include Window.inc

include user32.inc 
include gdi32.inc
include msvcrt.inc
include opengl32.inc
include kernel32.inc 

HGLRC textequ <dword>

Window struct
	hwnd HWND 0
	hdc HDC 0
	rdc HGLRC 0
	ShouldClose byte 0
Window ends

.data
ClassName db "SimpleWinClass", 0

.code

createWindow proc titleIn:LPCSTR, widthIn:dword, heightIn:dword
	local wc:WNDCLASSEX											
	local hwnd:HWND
	local dc:HDC
	local pfd:PIXELFORMATDESCRIPTOR
	local rdc:HGLRC

	mov   wc.cbSize,SIZEOF WNDCLASSEX				   
	mov   wc.style, CS_HREDRAW or CS_VREDRAW 
	mov   wc.lpfnWndProc, offset WndProc 
	mov   wc.cbClsExtra, NULL 
	mov   wc.cbWndExtra, NULL 
	mov   wc.hInstance, NULL
	mov   wc.hbrBackground, COLOR_WINDOW + 1
	mov   wc.lpszMenuName, NULL 
	mov   wc.lpszClassName, offset ClassName 
	invoke LoadIcon, NULL, IDI_APPLICATION 
	mov   wc.hIcon, eax 
	mov   wc.hIconSm, eax 
	invoke LoadCursor,NULL,IDC_ARROW 
	mov   wc.hCursor, eax 
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

	push dword ptr sizeof(Window)
	call crt_malloc
	add esp, 4
	mov ebx, hwnd
	mov [eax].Window.hwnd, ebx
	mov ebx, dc
	mov [eax].Window.hdc, ebx
	mov ebx, rdc
	mov [eax].Window.rdc, ebx
	mov [eax].Window.ShouldClose, 0

	ret
createWindow endp

swapBuffers proc windowIn:dword
	mov ebx, windowIn
	mov ebx, [ebx].Window.hdc
	invoke SwapBuffers, ebx
	ret
swapBuffers endp

destroyWindow proc windowIn:dword
	mov ebx, windowIn
	invoke wglMakeCurrent, NULL, [ebx].Window.rdc
	invoke wglDeleteContext, [ebx].Window.rdc
	invoke DestroyWindow, [ebx].Window.hwnd
	push windowIn
	call crt_free
	add esp, 4
	ret
destroyWindow endp

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

pollEvents proc windowIn:dword
	local msg:MSG 

	mov ebx, windowIn
	invoke GetMessage, addr msg,NULL,0,0 
	mov cl, [ebx].Window.ShouldClose
	.if eax == 0
		xor cl, 1
		mov [ebx].Window.ShouldClose, cl
	.endif
	invoke TranslateMessage, addr msg 
	invoke DispatchMessage, addr msg 
	ret
pollEvents endp

shouldClose proc windowIn:dword
	mov ebx, windowIn
	xor eax, eax
	mov al, [ebx].Window.ShouldClose
	ret
shouldClose endp

end

