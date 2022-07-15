.equ RAMEND, 0x4FF      ;Last On-Chip SRAM Location siehe C:\Users\fettinger\Desktop\arduino-1.0.6\hardware\tools\avr\avr\include\avr

.equ SREG, 0x3f ;liegt auf Adresse 3F

.equ SPL, 0x3d ;Stack Pointer Low Register

.equ SPH, 0x3e ;Stack Pointer High Register

.equ PORTB, 0x05 ;Port B Data Register

.equ DDRB, 0x04 ;Port B data direction register 1=output 0=input

.equ PINB, 0x03 ;Port B Input pins address

 

.org 0

   rjmp main

 

main:

   ldi r16,0 ; reset system status Wert 0 in Register R16

   out SREG,r16 ; init stack pointer Jetzt R16 Wert nach SREG

   ldi r16,lo8(RAMEND)

   out SPL,r16 ;Stack Pointer Low ramend

   ldi r16,hi8(RAMEND)

   out SPH,r16 ;Stack Pointer high ramend

 

   ldi r16,0x20 ; set port bits to output mode 0x20=DDB5 of DDRB

   out DDRB,r16

 

   clr r17

mainloop:

   eor r17,r16 ; invert output bit  r16 ist immer 1

   out PORTB,r17 ; write to port

   call wait ; wait some time

   rjmp mainloop ; loop forever

 

wait:

   push r16

   push r17

   push r18

 

   ldi r16,0x80 ; loop 0x400000 times

   ldi r17,0x00 ; ~12 million cycles

   ldi r18,0x00 ; ~0.7s at 16Mhz

_w0:

   dec r18

   brne _w0

   dec r17

   brne _w0

   dec r16

   brne _w0

 

   pop r18

   pop r17

   pop r16

   ret