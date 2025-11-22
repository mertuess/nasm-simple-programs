; Hello, World! nasm program
; mertuess 2025-11-22 19:34

section .data
  msg db "Hello, World!"   ; Set message
  msg_len equ $ - msg      ; Message lenght calculate

section .text
  global _start

_start:
  ; Print "Hello, World"
  mov rax, 1            ; sys_write
  mov rdi, 1            ; stdout
  mov rsi, msg          ; Pointer on string for out
  mov rdx, msg_len      ; String lenght for out 
  syscall               ; System call
  
  ; Exit
  mov rax, 60
  xor rdi, rdi
  syscall
