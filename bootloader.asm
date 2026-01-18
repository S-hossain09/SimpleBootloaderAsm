use16
org 0x7C00      ; It loads the first 512 bytes (one sector) from that device into memory at address 0x7C00

; Constants
VIDEO_MODE_TEXT     = 0x03      ; 80x25 text mode, 16 colors
BIOS_VIDEO          = 0x10      ; BIOS video services interrupt
FUNC_SET_VIDEO_MODE = 0x00      ; Set video mode function
FUNC_TELETYPE       = 0x0E      ; Teletype output function
STACK_START         = 0x7C00    ; Stack pointer position
NULL_TERMINATOR     = 0         ; String end marker


; Macros
macro clear_screen 
{
    mov ah, FUNC_SET_VIDEO_MODE
    mov al, VIDEO_MODE_TEXT
    int BIOS_VIDEO
}

macro print_char 
{
    mov ah, FUNC_TELETYPE
    int BIOS_VIDEO
}


; Boot Entry Point
start:
    ; Initialize segment registers
    xor ax, ax
    mov ds, ax              ; Data segment = 0
    mov es, ax              ; Extra segment = 0
    mov ss, ax              ; Stack segment = 0
    ;; data segment needs to be 0 because there can be other values assigned in ds, es, ss
    
    ; Setup stack
    mov sp, STACK_START
    
    ; Clear the screen
    clear_screen
    
    ; Load message address
    mov si, banner

; Print Loop
print_loop:
    lodsb                   ; Load byte from [SI] into AL, increment SI
    cmp al, NULL_TERMINATOR ; Check if end of string
    jz done                 ; If zero, we're done
    
    print_char              ; Print character in AL
    jmp print_loop          ; Repeat for next character


; Done - Infinite Loop
done:
    cli                     ; Clear interrupts
    hlt                     ; Halt CPU
    jmp done                ; In case of NMI, jump back


; Data Section
banner:
    db "  ____                 _    _                    _             ", 13, 10
    db " |  _ \               | |  | |                  | |            ", 13, 10
    db " | |_) |  ___    ___  | |_ | |  ___    __ _   __| |  ___   ___ ", 13, 10
    db " |  _ <  / _ \  / _ \ | __ | | / _ \  / _` | / _` | / _ \ | __|", 13, 10
    db " | |_) || (_) || (_) || |_ | || (_) || (_| || (_| ||  __/ | |   ", 13, 10
    db " |____/  \___/  \___/  \__||_| \___/  \__,_| \__,_| \___| |_|   ", 13, 10
    db 13, 10
    db "                   Written in Assembly Language!", 0


; Boot Signature
rb 510 - ($ - $$)           ; Pad to 510 bytes
dw 0xAA55                   ; Boot signature