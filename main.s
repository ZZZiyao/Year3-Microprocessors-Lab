	#include <xc.inc>
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	clrf    TRISC,A ;clear
	goto	start
	; ******* My data and where to put it in RAM *
myTable:
	db 0b10101010
	db 0b01010101
	db 0b11110000
	db 0b00001111
	db 0b11001100
	db 0b00110011
	db 0b11111111
	db 0b00000000
	
	dataLength  EQU  8
	;myArray EQU 0x400	Address in RAM for data
	counter EQU 0x10	; Address of counter variable
	align	2		; ensure alignment of subsequent instructions 
	; ******* Main programme *********************
	
start:	
	;lfsr	0, myArray	Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH, A	; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	dataLength		; 8 bytes to read
	movwf 	counter, A	; our counter register
loop:
        tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, PORTC	; move read data from TABLAT to (FSR0), increment FSR0	
	
	movlw 0xFF
	movwf 0x10
	movlw 0xFF
	movwf 0x11
	
	call    bigdelay        ;will be defined later
	decfsz	counter, A	; count down to zero
	bra	loop		; keep going until finished
	
	goto	0
	

bigdelay:
    movlw    0x00               ;w=0

Dloop:
    decf 0x11,f,A
    subwfb 0x10,f,A
    bc Dloop               ;if carry, then loop again
    return
    
	end	main
