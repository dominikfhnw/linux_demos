%if 0
# polyglot shellscript/nasm file. Just run it as a shellscript to assemble
#DUMP="--no-addresses -Mintel"
. ./asmlib2/build.sh
%endif

;%define LINCOM 1
%include "main.mac"		; main library
;%define REG_ASSERT 1
%define stack_cleanup 0
%define zero_seg 0
%if ELF_CUSTOM
	elf 0x3d429000
%else
	rinit
	set edx, 1
%endif
;[WARNING -label-orphan]

%assign SIZE 80
%define BASE esi
%assign INIT 0
%assign NEWL 0
%assign FOO  0

%assign RULE 126
%assign RULE 109
%assign RULE 30
%assign RULE 57
%assign RULE 105
%assign RULE 161
%assign RULE 105
%assign RULE 22
%assign RULE 126
;%assign RULE 18
;%assign RULE 122
;%assign RULE 140

%if INIT
	add	esp, -(SIZE+1)
	mov	BASE, esp
	inc	byte [BASE+(SIZE/2)]
%else
	mov	BASE, esp
%endif

;set	ebx, 1
%if INIT
	ELF_PHDR 1
%endif
rset	edx, 1

_outer:
; COLOR/ENDLESS
taint	ebx, ecx
rset	edi, -2
;rset	eax, -2
;taint	eax, ebx

set	edi, 0
rset	eax, 0
;bt	dword [BASE], edi


%if FOO
	%define ZERO 0
	push	ebp
	push	0x5000000
	mov	ebp, esp
%else
	%define ZERO ebp
%endif

;rcl	al, 1

	; XXX temp
	ELF_PHDR 1, 0xb9
	rset	ecx, 0x10020

_calc:
	inc	edi

	%if 1
		mov	bl, byte [BASE+edi]
		shr	bl,1
	%else
		bt	dword [BASE+edi], ZERO	; get LSB from buffer
	%endif
	;reg

	;ELF_PHDR 1, 0xb9
	;rset	ecx, 0x10020

	;rcl	al, 1
	rcl	eax, 1			; shift LSB into eax

	and	al, 7			; discard everything but last 3 bits
	;and	eax, 7			;+1
	taint	eax
	push	eax			; save 3bit history

	mov	cl, RULE
	taint8	ecx

	ychg	eax, ecx
	;shr	eax, cl			; get result for RULE
	ror	eax, cl			; get result for RULE

	upd:
	;mov	byte [BASE+edi-1], al
	mov	byte [BASE+edi-1], al
	taint	eax

	%if 1
	_print:
		and	al, 1		; normalize al to 0/1. XXX: why?
		or	al, 32		; 
		;mov	byte [BASE],al
		;test	al, 1
		;setnz	al
		;or	al, 32
		push	eax
		puts	esp, 1
		pop	eax
	%endif


_restore:
	pop	eax			; restore 3bit history
	rset	eax, -2

	cmp	edi, SIZE
jb	_calc
rset	edi, SIZE

%if NEWL
	nl:
	;puts	`\n\e[31m`
	puts	`\n`
	;taint	edx
	rset	eax, 1
%endif

%if 1
	;set	ecx, -1
	;set	ecx, 0xffff
	;loop	$
	%if 1
		reg
		rdump
		_usleep:
		%if 1
			shl	ebx, 26
			push	ebx
			push0

			syscall SYS_nanosleep, esp
			rset	eax, 0
		%else
			usleep	0x5000000

		%endif

	%else
		set	ecx, 40000000
		loop	$
	%endif
	jmp	_outer
%else
	inc	ebp
	cmp	ebp, SIZE
	;reg
	jb	_outer

_exit:
exit	x

%endif
	


%include "regdump2.mac"
