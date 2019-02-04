include windows.inc

IWindow textequ <dword>

create_window proto titleIn:LPCSTR, widthIn:dword, heightIn:dword
destroy_window proto windowIn:IWindow
swap_buffers proto windowIn:IWindow
poll_events proto windowIn:IWindow
should_close proto windowIn:IWindow
