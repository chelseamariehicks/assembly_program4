TITLE Programming Assignment #4     (prog04.asm)

; Author: Chelsea Marie Hicks
; OSU email address: hicksche@oregonstate.edu
; Course number/section: CS271-400
; Project Number: Program #4        Due Date: Sunday, February 16th by 11:59 PM
;
; Description: Program calculates and displays all of the composite numbers
;		up to and including the nth composite, n being a user selected term
;		in the range of [1...400]. A number is considered composite if it
;		can be factored into a product of smaller integers. Note that every
;		integer greater than one is either composite or prime; one is not a
;		composite.
;
;		This program implements procedures, loops, and utrilizes 
;		data validation to verify that the user entered a number
;		within the range of [1...400] and repeatedly prompts user to enter
;		a number within the range until they do so.

INCLUDE Irvine32.inc

UPPER_LIMIT		EQU		400				;defines upper limit as constant = 400
LOWER_LIMIT		EQU		1				;defines lower limit as constant = 1

.data

;messages printed to screen in introduction
progTitle		BYTE	"Composite Numbers Display", 0
authName		BYTE	"Written by Chelsea Marie Hicks", 0
instruc1		BYTE	"Enter the number of composite numbers you would like to see.", 0
instruc2		BYTE	"I can print up to 400 composites!", 0

;messages printed to screen to get user data and variables to store data
numPrompt		BYTE	"Enter the number of composites to display [1...400]: ", 0
errMsg			BYTE	"The number you entered is out of range! Try again.", 0

checkInput		DWORD	?				;temp variable to store user input to be checked
isValid			DWORD	?				;variable to store confirmation of valid number
userInput		DWORD	?				;variable to store valid user input

;messages printed to screen to display composites and necessary variables 
resultsMsg		BYTE	" composite numbers on display:", 0
space			BYTE	"   ", 0

count			DWORD	0				;variable to count composites printed on a line						

;message printed to screen for farewell
goodbye			BYTE	"Farewell my mathematical friend. Results certified by Chelsea.", 0

.code
main PROC
;display introduction including title, programmer, and user instructions
	call	introduction

;acquire user data and validate input 
	call	getUserData

;calculate and display requested number of composite numbers
	call	showComposites

;display farewell message
	call	farewell

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

;-----------------------------------------------------------------------
; introduction
;
; Procedure introduces the program, programmer, and displays instructions
; Receives: none
; Returns: none
; Registers changed: edx
;-----------------------------------------------------------------------
introduction PROC USES edx
	mov		edx, OFFSET progTitle			;print title
	call	WriteString
	call	Crlf
	mov		edx, OFFSET authName			;print programmer
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx, OFFSET instruc1			;print initial instructions
	call	WriteString
	call	Crlf
	mov		edx, OFFSET instruc2
	call	WriteString
	call	Crlf
	call	Crlf
	ret
introduction ENDP


;-----------------------------------------------------------------------
; getUserData
;
; Procedure to acquire an integer from the user for the number of composites
; Receives: none
; Returns: none
; Registers changed: edx
;-----------------------------------------------------------------------
getUserData PROC USES edx eax
dataLoop:
	mov		edx, OFFSET numPrompt			;prompt user to enter integer from [1...400]
	call	WriteString
	call	ReadInt
	mov		checkInput, eax

	call	validate
	cmp		isValid, 1
	je		validInput

invalidInput:
	mov		edx, OFFSET errMsg				;print error message and require user to enter new int
	call	WriteString
	call	Crlf
	jmp		dataLoop

validInput:
	mov		eax, checkInput
	mov		userInput, eax
	call	Crlf
	ret
getUserData ENDP

;-----------------------------------------------------------------------
; validate
;
; Validates that user input is in the range of [1...400]
; Receives: none
; Returns: none
; Registers changed: edx
;-----------------------------------------------------------------------
validate PROC 
	cmp		checkInput, UPPER_LIMIT
	jg		validationFail
	cmp		checkInput, LOWER_LIMIT
	jl		validationFail
	mov		isValid, 1
	jmp		validationComplete

validationFail:
	mov		isValid, 0
	jmp		validationComplete

validationComplete:
	ret
validate ENDP

;-----------------------------------------------------------------------
; showComposites
;
; Procedure to calculate and display composite numbers
; Receives: none
; Returns: none
; Registers changed: edx, eax, ebx
;-----------------------------------------------------------------------
showComposites PROC
	mov		edx, OFFSET userInput
	call	WriteInt
	mov		edx, OFFSET resultsMsg
	call	WriteString
	call	Crlf

	ret
showComposites ENDP


;-----------------------------------------------------------------------
; farewell
;
; Print a farewell message to the screen
; Receives: none
; Returns: none
; Registers changed: edx
;-----------------------------------------------------------------------
farewell PROC USES edx
	mov		edx, OFFSET goodbye
	call	WriteString
	call	Crlf
	ret
farewell ENDP


END main
