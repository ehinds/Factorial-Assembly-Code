;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

CLEAR	clr	R5
		clr	R6
		clr	R7

LAB3a	mov.w	#5, R4
		call #XCALC
		call #FCALC

LAB3b	mov.w	#6, R4
		call #XCALC
		call #FCALC

LAB3c	mov.w #-7, R4
		call #XCALC
		call #FCALC

Mainloop	jmp	Mainloop

XCALC	push R4
		push R6
		tst.w R4		;test R4
		jn ABSV			;if negative, jump to absolute value
Resume	call #Factorial	;call factorial subroutine
		rla R6			;factorial stores final value in R6. Double R6 (because 2 * (R6!))
		mov.w R6, R5	;store this value in R5

XLoop	dec.w R4		;decrease original R4 by 1
		jz	Xfinish		;if 0, jump to finish
		call #Factorial	;call factorial again
		rla R6			;double R6 again
		add.w R6, R5	;add this new value to R5 for summation equation
		jmp XLoop		;Repeat loop

ABSV	inv.w R4		;Inverse R4 since negative
		add.w #1, R4	;add 1
		jmp Resume		;jump back to resume

Xfinish	add.w #2, R5	;Function finish, but begins at i=0 so must add 2 (2 * 0!) = 2 * 1 = 2
		pop R6
		pop R4

		ret

FCALC	push R5
		add.w	#50, R5	;Add 50 to R5
		rra R5			;Divide by 2
		rra R5			;divide by 2 again
		mov.w R5, R7	;store F value in R7
		pop R5

		ret


Mult	push R4
		push R5
		push R8
		mov.w	#16, R5	;counter
		clr.w  R8

NextBit	rrc.w	R4
		jnc	Twice
		add.w	R6, R8

Twice	add.w	R6, R6
		dec.w	R5
		jnz	NextBit
		mov.w	R8, R6
		pop R8
		pop R5
		pop	R4

		ret

Factorial	push R4
			push R8
			tst	R4	;number to be factorialized
			jz	Zero
			jn	Negative
			mov.w	R4, R6

FactLoop	dec.w R4
			jz End
			call	#Mult
			jmp FactLoop

Zero		mov.w #1, R6
			jmp End

Negative	mov.w #0, R6

End			pop R8
			pop R4

			ret


;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
