%if 0
# polyglot shellscript/nasm file. Just run it as a shellscript to assemble
#
# To add framebuffer permissions for current user:
# sudo usermod -a -G video $(whoami)
# And then log out and in again
#
DUMP="--no-addresses -Mintel"
. ./asmlib2/build.sh
%endif

%ifndef EXTOPEN
%assign EXTOPEN 0		; open via shell? (./foo <>/dev/fb0)
%endif

%assign GREEN	0		; green leaf on top?
%assign SMALL	0


%if SMALL
	%assign GREEN 1
%endif

;%define LINCOM 1
%include "main.mac"		; main library
;%define REG_ASSERT 1
;%define stack_cleanup 0
;%define zero_seg 0
%if ELF_CUSTOM
	%if EXTOPEN
		elf 0x05405000
		rset    eax, 5
	%else
		elf 0x68c0b000
		rset	eax, 0xc0
	%endif
%else
	rinit
	%if EXTOPEN
		push0
		set	eax, 5
	%else
		set	eax, 0xc0
	%endif
%endif

_open:
%if !EXTOPEN
	pop	ecx
	bswap	ecx
	taint	ecx
	%define FD STDIN
%else
	set	sc_arg2, O_WRONLY
	set	sc_arg3, PROT_READ|PROT_WRITE

	push	'/fb0'
	ELF_PHDR 1
	push	'/dev'
	open	esp, O_WRONLY
	ychg	sc_arg5, sc_ret
	shl	ecx, 24
	%define FD x
%endif
_mmap:
edi :=	mmap	x, x, PROT_WRITE, MAP_SHARED, FD, 0

%if SMALL
	ELF_PHDR 1, 0x2d
%elif GREEN
	ELF_PHDR 1, 0xd
%else
	ELF_PHDR 1
%endif

rdump
_write:
set	ecx, sc_arg2			; nop

%if SMALL
	rep	stosd
%else
.loop:
	dec	eax
	;rdtsc
	stosd
jmp	.loop
%endif

%include "regdump2.mac"
