; Print nasm program
; mertuess 2025-11-22 19:45
  
section .text
  global _start

print:
  ; Save registers in stack
  push rax
  push rdi
  push rsi
  push rdx
  push rcx

  mov rdx, 0 ; Set zero to lenght counter

; Find lenght loop
.find_len:
  cmp byte [rsi + rdx], 0 ; If RSI (Message) + RDX (Lenght counter) equal zero - Lenght is right
  je .print_now           ; Print if equal
  inc rdx                 ; If else increase lenght
  jmp .find_len           ; Check again

.print_now:
  ; If lenght > 0 - out
  test rdx, rdx   ; Check lenght
  jz .done        ; If zero flag is 1 - exit
  ; Else - call stdout
  mov rax, 1      ; sys_write
  mov rdi, 1      ; stdout
  syscall

.done: ; End mark
  ; Return regitsers values
  pop rcx
  pop rdx
  pop rsi
  pop rdi
  pop rax
  ret

println:
  call print ; Print message

  ; Again save values in stack
  push rax
  push rdi
  push rsi
  push rdx

  ; Print new line
  mov rax, 1            ; sys_write
  mov rdi, 1            ; stdout
  mov rsi, newline      ; New line poiner (In main file needed to add 'newline db 10' in data section!!!)
  mov rdx, 1            ; Lenght = 1 symbol
  syscall               ; System call

  ; Return values from stack
  pop rdx
  pop rsi
  pop rdi
  pop rax

  ret ; Return

; Print macros (syntax is 'print <message in data>')
%macro print 1
    mov rsi, %1 ; Move message in RSI register
    call print  ; Call function
%endmacro

; Print with new line macros
%macro println 1
    mov rsi, %1   ; Move message in RSI register
    call println  ; Call function
%endmacro
