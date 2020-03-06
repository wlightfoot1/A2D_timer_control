;Main.s by Dallas LeGrande & Henry Cole
;4/15/2019
;program to implement keyboard interrupts. When button 1 is pushed it increments the PWM in CCW direction by 100 usec.  
;When button 2 is pressed it increments the PWM in the CW direction by 100 usec.
;LED1 flashes when the servo is at the max CW position or max CCW position
            
            INCLUDE 'derivative.inc'
            XDEF _Startup, main;, keyInterrupt          
            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack




keyPress equ $0060						;for holding the value of PTAD which tells you which button has been pushed
counter equ $0070						;used for the delay loop
insideDelayCounter equ $0071			;used for the delay loop
servoAngle equ $0080					;holds the angle of the servo

			org $E000
			
			
main:
_Startup:
            LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            TXS
			LDA SOPT1			;loads the watchdog into the accumulator
			EOR #%10000000		;changes the 7th bit to a 0 which turns the watchdog off
			STA SOPT1			;stores the watch dog back in its place
			
			LDA #%11000000		;setting PORT 6 & 7 to high makes LEDS 1 and 2 as outputs
			STA PTBDD			;sets LED1 and LED2 as outputs
					
			LDA #%00000000		
			STA PTADD			;sets sw1 and sw2 as inputs on port A
			
			LDA #%00100001
			STA ADCSC1			;enables adc1 as well as continuous conversion
			
			LDA #%00000000
			STA PTAPE			;Eliminates pullup resistors
			
			LDA #%11000000		;initializes the LEDS to be off
			STA PTBD
			
			;pin 1 (KBIE) enables interrupts, pin 2 (KBACK) when written to clears the interrupt flag
			;pins 3-7 are read-only. pin 0 controls whether interrupt is edge only or edge and level detection
			;LDA #%00000110		
			;STA KBISC			;enables interrupts, makes pta1 edge sensitive, and clears interrupt flag
			
			;LDA #%00000000		
			;STA KBIES			;set buttons to be falling edge sensitive
			
			;LDA #%00000010		;enable pin 1 as keyboard interrupts
			;STA KBIPE
			
			MOV #0, counter		;put the decimal number 0 into the counter for the outside delay loop
			MOV #0, insideDelayCounter		;put the decimal number 0 into the counter for the inside delay loop
			CLI					; enable interrupts
			
			;0-3 sets the divisor to 128
			;bit 4 selects the bus as the clock
			;bit 5 makes it center-aligned
			;6-7 inhibits interrupts and counter has not overflowed
			LDA #%00101111			
			STA TPMSC
			
			;0-1 read only
			;2-3 make it rising edge
			;4 doesn't matter
			;5 makes it edge aligned
			;6 disables interrupts
			;7 no input capture
			
			LDA #%00101000
			STA TPMC0SC
			
			;this is the modulo number we count up to (625 in this case) which is one period
			LDA #%00000010
			STA TPMMODH
			LDA #%01110001		;set to 625 between TPMMODH & TPMMODL
			STA TPMMODL					
			
			;sets the length of time that the pulse width is high
			;setting this to 33 between TPMC0VH & TPMC0VL sets PWM to ~2 ms
			;setting this to 24 sets it to 1.5 ms
			;setting this to 14 sets it to ~1 ms
			LDA #%00000000
			STA TPMC0VH
			LDA #%00011000			;initialized to 24 so that the PWM is 1.5 ms which is 90 degrees center on the servo
			STA TPMC0VL
			
			LDA #%00011000			;starts the servo at 90 degrees
			STA servoAngle
			
			
mainLoop:
			LDA #%00000000
			STA TPMC0VH
			CLRH
			LDA ADCRL
			STA servoAngle
			LDA servoAngle
			LDX #%00001101                ; .005
			DIV
			STA servoAngle
			LDA servoAngle
			ADD #%00001110
			STA servoAngle
			LDA servoAngle
			NOP
			NOP
			NOP
			STA TPMC0VL				;store the servo angle into the register to move the servo
			LDA #%00100001
			STA ADCSC1			;enables adc1 as well as continuous conversion
			CMP #33					;compare the servo angle to 33. 33 is the max value for counter clockwise rotation
			BEQ LED_ON
			CMP #14					;compare the servo angle to 14. 14 is the max value for clockwise rotation
			BEQ LED_ON
			LDA #%00000000		;turns LED1 off
			STA PTBD
;			LDA keyPress			;get the value of the last key pressed to determine which direction to move the servo
;			CMP #%00101000			;check to see if button 1 has been pressed
;      		BEQ SW1					;if SW1 has been pressed then branch to switch 1 sub-routine
;			CMP #%00100100			;check to see if button 2 has been pressed
;			BEQ SW2					;if SW2 has been pressed then branch to switch 2 sub-routine
;		BOB:
;			LDA #%00000000			;change the keyPress back to zero so that a button has to be pushed in order to move the servo
;			STA keyPress
;			LDA servoAngle			
;			CMP #33					;compare the servo angle to 33. 33 is the max value for counter clockwise rotation
;			BEQ LED_ON
;			CMP #14					;compare the servo angle to 14. 14 is the max value for clockwise rotation
;			BEQ LED_ON
;			LDA #%11000000			;turns LED 1 off once the value of the servo is not in either max range of the servo
;			STA PTBD       		
            BRA mainLoop
            
;when button 1 (SW1) is pressed turn the servo CCW
;ADC_VALUE:
    ;sets the length of time that the pulse width is high
			;setting this to 33 between TPMC0VH & TPMC0VL sets PWM to ~2 ms
			;setting this to 24 sets it to 1.5 ms
			;setting this to 14 sets it to ~1 ms
;			LDA #%00000000
;			STA TPMC0VH
;			LDA servoAngle		
;			CMP #33					;once the servo gets to the max rotation stop increasing the servo rotation angle
;			BEQ BOB
;			LDA servoAngle			;load the servo angle
;			INCA					;increment the angle by 1 which increase the angle by 100 usec
;			STA servoAngle
;			LDA servoAngle			
;			STA TPMC0VL				;store the servo angle into the register to move the servo
 ;   BRA	BOB

LED_ON:
	LDA #%10000000		;turns LED1 on
	STA PTBD
	BRA mainLoop

;when a button is pushed it fires this interrupt
;the button that is pushed is recorded in a variable so it is known which button has been pushed			
;keyInterrupt:
;	LDA PTAD
;	STA keyPress
;	LDA #%00000110			;clears the interrupt 
;	STA KBISC
;	RTI						;returns back to wherever the interrupt was triggered
