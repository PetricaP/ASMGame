include windows.inc

IWINDOW textequ <dword>

create_window proto titleIn:LPCSTR, widthIn:dword, heightIn:dword
destroy_window proto windowIn:IWINDOW
swap_buffers proto windowIn:IWINDOW
poll_events proto windowIn:IWINDOW
should_close proto windowIn:IWINDOW
