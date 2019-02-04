include windows.inc

IWindow textequ <dword>

createWindow proto titleIn:LPCSTR, widthIn:dword, heightIn:dword
destroyWindow proto windowIn:IWindow
swapBuffers proto windowIn:IWindow
pollEvents proto windowIn:IWindow
shouldClose proto windowIn:IWindow
