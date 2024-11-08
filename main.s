#include <xc.inc>
psect code, abs
 
main:
    org 0x0
    goto start             ; Jump to the main program start
 
    org 0x100              ; Main program code starts here at address 0x100
 
table:
    db 0x00, 0x20, 0x40, 0x60, 0x80, 0x60, 0x40, 0x20 ; Table with triangular wave data
counter EQU 0x10          ; Counter variable address
num     EQU 8             ; Number of values in the table
align 2                   ; Ensure alignment of instructions
 
start:
    clrf TRISD, A         ; Set PORTD as output
  
 
    ; Load the address of the table into the TBLPTR registers
    movlw low highword(table)   ; High word of table address
    movwf TBLPTRU, A            ; Load into TBLPTRU
    movlw high(table)           ; High byte of table address
    movwf TBLPTRH, A            ; Load into TBLPTRH
    movlw low(table)            ; Low byte of table address
    movwf TBLPTRL, A            ; Load into TBLPTRL
 
    ; Initialize counter
    movlw num                   ; Number of bytes to read from table
    movwf counter, A            ; Store in counter
 
loop:
    tblrd*+                     ; Read one byte from program memory to TABLAT, increment TBLPTR
    movff TABLAT, PORTD         ; Move read data from TABLAT to PORTD (output to DAC)
 
    ; Set up delay for timing control
    movlw 0xFF                  ; Load delay value
    movwf 0x20, A               ; Store delay value in address 0x20
    call delay                  ; Call delay subroutine
 
    ; Decrement counter to go through all table values
    decfsz counter, F, A        ; Decrement counter and skip next line if zero
    bra loop                    ; Loop back until counter reaches zero
 
    goto start                  ; Restart to continuously output the waveform
 
; Delay subroutine
delay:
    decfsz 0x20, F, A           ; Decrement delay counter until zero
    bra delay                   ; Loop for delay
    return                      ; Return from delay subroutine