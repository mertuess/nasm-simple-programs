; Register output program
; mertuess 2025-11-22 16:36

section .data
  hex_digits db '0123456789ABCDEF'  ; Symbol table for output
  newline db 10                     ; New line symbol (ASCII 10 = \n)
  prefix db 'Register value: 0x'    ; Prefix text for output
  prefix_len equ $ - prefix         ; Prefix lenght ($ - prefix: 17 symbols)
  buffer times 16 db 0              ; Output buffer (16 byte)

section .text
  global _start

; Print register function
print_register:
  ; Hold values on stack memory
  push rax
  push rbx
  push rcx
  push rdx
  push rsi

  ; Print prefix (default is 'Register value: 0x')
  mov rax, 1            ; sys_write
  mov rdi, 1            ; stdout
  mov rsi, prefix       ; Pointer on string for out
  mov rdx, prefix_len   ; String lenght for out 
  syscall               ; System call

  ; Get register value
  mov rax, [rsp + 48]   ; In macro we push this value in stack (push %1)

  ; Parse to hex format
  mov rcx, 16           ; Counter 16 bytes for Hex format value
  mov rsi, buffer + 16  ; Pointer on end of buffer
  mov byte [rsi], 0     ; Write zero terminator
  
; Loop mark
.convert_loop:
  dec rsi               ; Move backward in buffer
  mov rbx, rax          ; Copy RAX to RBX
  and rbx, 0xF          ; Leave only 4 bits
  mov dl, [hex_digits + rbx] ; Get a needed HEX symbol
  mov [rsi], dl         ; Save symbol in buffer
  shr rax, 4            ; Move RAX 4 bits to right
  loop .convert_loop    ; Repeat 16 times

  ; Print value
  mov rax, 1            ; sys_write
  mov rdi, 1            ; stdout
  lea rsi, [buffer]     ; Pointer to buffer start
  mov rdx, 16           ; Lenght
  syscall               ; System call

  ; New line
  mov rax, 1            ; sys_write
  mov rdi, 1            ; stdout
  mov rsi, newline      ; Pointer to newline
  mov rdx, 1            ; Lenght = 1 symbol
  syscall               ; System call

  ; Restore registers values
  pop rsi
  pop rdx
  pop rcx
  pop rbx
  pop rax
  ret                   ; Return

; Macro for give argument to function
%macro print_reg 1
  push %1               ; Push register value to stack
  call print_register   ; Call print function
  add rsp, 8            ; Clear stack (delete argument)
%endmacro

_start:
  mov rax, 0x0123456789ABCDEF0
  print_reg rax

  mov rbx, 0xB2EAD
  print_reg rbx

  mov rax, 0x123
  print_reg rax

  ; Exit
  mov rax, 60
  xor rdi, rdi
  syscall

