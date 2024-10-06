org 0x1000
start:
    call newline
mov ah, 0x0e
mov al, '$'
int 0x10
   jmp $
newline:
mov  bx, 0007h  ; BH is DisplayPage, BL is GraphicsColor
mov  ax, 0E0Dh  ; AH is Teletype, AL is CarriageReturn
int  10h
mov  al, 0Ah    ; AL is Linefeed 
int  10h
mov  cx, 80     ; Length of the row (assuming screen is 80x25)
mov  bx, 0007h  ; BH is DisplayPage, BL is ColorAttribute
mov  ax, 0920h  ; AH is WriteCharacter, AL is SpaceCharacter
int  10h
ret
times 512-($-$$) db 0
