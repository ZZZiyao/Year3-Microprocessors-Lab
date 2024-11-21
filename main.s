#include <xc.inc>

extrn	Keypad_Setup, Keypad_read_input, Keypad_decode  ; external subroutines
extrn	LCD_Setup, LCD_Write_Message, LCD_Send_Byte_D
	
psect	udata_acs   ; reserve data space in access ram
Keypad_result:  ds   1
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect main_code, class=CODE
    
Main_loop:
    call Keypad_Setup
    call LCD_Setup
    
Main_Loop_Start:
    call Keypad_read_input
    movf Keypad_result, W, A
    call LCD_Send_Byte_D
    movlw 0xFF
    movwf delay_count, A
    call delay
    goto Main_Loop_Start
    
    
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end