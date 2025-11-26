; Global (main) file of nasm program
; mertuess 2025-11-26 15:42

section .data
  newline db 10 ; This needed for all includes
  msg_0 db "Welcome to my global program!", 0
  msg_1 db "Print function is simple to use", 0
  msg_2 db "Just add a new message in data section to use it!", 0
  msg_3 db "Also you can out a register value: print_reg <register>", 0

section .text
  %INCLUDE "print_register.asm" ; includes
  %INCLUDE "print.asm"
  global _start

_start:
  mov rax, 0xDEADBEEF

  println msg_0
  println msg_1
  println msg_2
  println msg_3

  print_reg rax
  
  ; Exit
  mov rax, 60
  xor rdi, rdi
  syscall
