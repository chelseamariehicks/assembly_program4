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
;		This program implements procedures, loops, and utilizes 
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
isValid			DWORD	0				;variable to store confirmation of valid number
userInput		DWORD	?				;variable to store valid user input

;messages printed to screen to display composites and necessary variables 
resultsMsg		BYTE	" composite numbers on display:", 0
space			BYTE	"   ", 0

lineCount		DWORD	0				;variable to count composites printed on a line	
numsPrinted		DWORD	0				;variable to count numbers printed
currentNum		DWORD	4				;variable to track the current number being checked
compositeFlag	DWORD	0				;variable to store confirmation of composite

divisor			DWORD	?				;variable for the divisor in isComposite

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
	mov		eax, checkInput					;user input is valid
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
validate PROC USES edx
	cmp		checkInput, UPPER_LIMIT			;check that user input is not greater than 400
	jg		validationFail
	cmp		checkInput, LOWER_LIMIT			;check that user input is not less than 1 
	jl		validationFail
	mov		isValid, 1						;change isValid to 1 to represent true, valid number
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
; Procedure to display composite numbers, calls isComposite to calculate
; Receives: none
; Returns: none
; Registers changed: edx, eax, ecx
;-----------------------------------------------------------------------
showComposites PROC USES edx eax ecx
	mov		eax, userInput					;print message for numbers displaying
	call	WriteDec
	mov		edx, OFFSET resultsMsg
	call	WriteString
	call	Crlf
	call	Crlf

	mov		ecx, userInput					;loop counter equal to valid userInput

displayStart:
	call	isComposite
	cmp		compositeFlag, 1				;check if currentNum is composite using flag
	je		compositeValid					;if currentNum iscomposite, jump to compositeValid
	inc		currentNum						;if not composite, check next number
	jmp		displayStart

compositeValid:
	cmp		lineCount, 10					;check if lineCount is 10
	jne		displayComposite
	call	Crlf							;skip to next line and update lineCount
	mov		lineCount, 0

displayComposite:
	inc		lineCount						
	mov		eax, currentNum					;print current composite number
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	inc		numsPrinted						;increase numPrinted
	inc		currentNum						;increase currentNum
	loop	displayStart
	ret
showComposites ENDP

;-----------------------------------------------------------------------
; isComposite
;
; Procedure to determine if a number is composite or not
; Receives: currentNum
; Returns: compositeFlag
; Registers changed: edx, eax
;-----------------------------------------------------------------------
isComposite PROC USES edx eax
checkTwo:
	mov		divisor, 2						;check if currentNum can be divided by 2
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		checkThree
	mov		compositeFlag, 1
	jmp		composCheckComplete
checkThree:
	mov		divisor, 3						;check if currentNum can be divided by 3
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		checkFive
	mov		compositeFlag, 1
	jmp		composCheckComplete
checkFive:
	cmp		currentNum, 5
	je		compositeFailed
	mov		divisor, 5						;check if currentNum can be divided by 5
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		checkSeven
	mov		compositeFlag, 1
	jmp		composCheckComplete
checkSeven:
	cmp		currentNum, 7
	je		compositeFailed
	mov		divisor, 7						;check if currentNum can be divided by 7
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		checkEleven
	mov		compositeFlag, 1
	jmp		composCheckComplete
checkEleven:
	cmp		currentNum, 11
	je		compositeFailed
	mov		divisor, 11						;check if currentNum can be divided by 11
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		checkThirteen
	mov		compositeFlag, 1
	jmp		composCheckComplete
checkThirteen:
	cmp		currentNum, 13
	je		compositeFailed
	mov		divisor, 13						;check if currentNum can be divided by 13
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		checkSeventeen
	mov		compositeFlag, 1
	jmp		composCheckComplete
checkSeventeen:
	cmp		currentNum, 17
	je		compositeFailed
	mov		divisor, 17						;check if currentNum can be divided by 17
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		checkNineteen
	mov		compositeFlag, 1
	jmp		composCheckComplete
checkNineteen:
	cmp		currentNum, 19
	je		compositeFailed
	mov		divisor, 19						;check if currentNum can be divided by 19
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		checkTwentyThree
	mov		compositeFlag, 1
	jmp		composCheckComplete
checkTwentyThree:
	cmp		currentNum, 23
	je		compositeFailed
	mov		divisor, 23						;check if currentNum can be divided by 23
	mov		edx, 0
	mov		eax, currentNum
	div		divisor
	cmp		edx, 0							;if remainder is 0, it is composite
	jne		compositeFailed
	mov		compositeFlag, 1
	jmp		composCheckComplete

compositeFailed:
	mov		compositeFlag, 0
	
composCheckComplete:
	ret
isComposite ENDP


;-----------------------------------------------------------------------
; farewell
;
; Print a farewell message to the screen
; Receives: none
; Returns: none
; Registers changed: edx
;-----------------------------------------------------------------------
farewell PROC USES edx
	call	Crlf
	call	Crlf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	Crlf
	ret
farewell ENDP


END main
