#include <xc.inc>
extrn    LCD_Setup, LCD_Write_Message, LCD_Send_Byte_D
call LCD_Setup
 
movlw 'H'
call LCD_Send_Byte_D
movlw 'e'
call LCD_Send_Byte_D
movlw 'l'
call LCD_Send_Byte_D
movlw 'l'
call LCD_Send_Byte_D
movlw 'o'
call LCD_Send_Byte_D
 
end


