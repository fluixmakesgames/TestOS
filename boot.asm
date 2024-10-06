; boot.asm - Simple Bootloader
; Assembles with NASM: nasm -f bin boot.asm -o boot.bin
; This bootloader reads a kernel from disk and loads it at memory address 0x1000.

BITS 16
ORG 0x7C00  ; The bootloader is loaded at address 0x7C00 by the BIOS.

start:
    ; Set up stack
    cli                  ; Disable interrupts while setting up
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00       ; Set the stack pointer at 0x7C00
    sti                  ; Re-enable interrupts

    ; Print message
    mov si, msg_loading
    call print_string

    ; Load kernel (1 sector, starting at LBA 2, to address 0x1000)
    mov bx, 0x1000       ; ES:BX = 0x0000:0x1000 (where to load the kernel)
    mov ah, 0x02         ; BIOS function 02h - Read Sectors
    mov al, 1            ; Number of sectors to read
    mov ch, 0            ; Cylinder 0
    mov cl, 2            ; Sector 2 (start of the kernel)
    mov dh, 0            ; Head 0
    mov dl, 0            ; Drive 0 (usually the floppy disk)
    int 0x13             ; Call BIOS to read sector

    jc disk_error        ; Jump if the carry flag is set (error)

    ; Jump to kernel entry point at 0x1000
    jmp 0x1000

disk_error:
    ; Print disk error message
    mov si, msg_disk_error
    call print_string
    jmp $

print_string:
    ; Print string at DS:SI
    mov ah, 0x0E         ; BIOS teletype function
.next_char:
    lodsb                ; Load next character into AL
    or al, al            ; Check if null terminator
    jz .done             ; If zero, end of string
    int 0x10             ; Print character
    jmp .next_char
.done:
    ret

msg_loading db 'Loading kernel...', 0
msg_disk_error db 'Disk read error!', 0

times 510-($-$$) db 0  ; Pad the rest of the bootloader to 510 bytes
dw 0xAA55              ; Boot signature (0xAA55)
