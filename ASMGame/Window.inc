include windows.inc

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
create_window proto titleIn:LPCSTR, widthIn:dword, heightIn:dword
destroy_window proto windowIn:dword
swap_buffers proto windowIn:dword
poll_events proto windowIn:dword
should_close proto windowIn:dword

WINDOWPTR textequ <dword>
