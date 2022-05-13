;---------------------------------------------------------------------
;
; Program:       Linkhll
;
; Function:      The linkhll subroutine will be passed four unsigned
;                words on the stack (these are passed by value).
;                Linkhll is to find the two largest unsigned values
;                and multiply them creating a 32 bit unsigned product.
;
; Owner:         Selena Chen (schen53)
;
; Date:          03/29/2020
;
; Changes:
; --------------------------
; 11/21/2016 Original version
; 03/27/2020 Completed version
;
;---------------------------------------
         .model    small               ;64k code and 64k data
         .8086                         ;only allow 8086 instructions
         public    _linkhll            ;allow extrnal programs to call
;---------------------------------------
         .code                         ;start the code segment
;---------------------------------------
_linkhll:                              ;
         push      bp                  ;save bp register
         mov       bp,sp               ;set up bp
;---------------------------------------
; Assumes v1 is max1 and v2 is max2
;---------------------------------------
         mov       ax,[bp + 4]         ;ax = v1
         mov       bx,[bp + 6]         ;dx = v2
;---------------------------------------
; Compares v1 and v2
;---------------------------------------
         cmp       ax,bx               ;if v1 >= v2
         jae       v3max1              ;compare with v3
         xchg      ax,bx               ;else swap v1 and v2
;---------------------------------------
; Compares max1 and v3
;---------------------------------------
v3max1:                                ;
         cmp       ax,[bp + 8]         ;if max1 >= v3
         jae       v3max2              ;compare v3 with max2
         xchg      bx,ax               ;else ax is max2
         xchg      ax,[bp + 8]         ;and v3 is max1
         jmp       v4max1              ;compare with v4
;---------------------------------------
; Compares max2 and v3
;---------------------------------------
v3max2:                                ;
         cmp       bx,[bp + 8]         ;if max2 >= v3
         jae       v4max1              ;compare with v4
         xchg      bx,[bp + 8]         ;else v3 is max2
;---------------------------------------
; Compares max1 and v4
;---------------------------------------
v4max1:                                ;
         cmp       ax,[bp + 10]        ;if max1 >= v4
         jae       v4max2              ;compare v4 with max2
         xchg      bx,ax               ;else ax is max2
         xchg      ax,[bp + 10]        ;and v4 is max1
         jmp       multiply            ;ready to multiply
;---------------------------------------
; Compares max2 and v4
;---------------------------------------
v4max2:                                ;
         cmp       bx,[bp + 10]        ;if max2 >= v4
         jae       multiply            ;ready to multiply
         xchg      bx,[bp + 10]        ;else v4 is max2
;---------------------------------------
; Multiplies the two largest values
;---------------------------------------
multiply:                              ;
         mul       bx                  ;multiply the 2 largest
;---------------------------------------
; Restore registers and return
;---------------------------------------
exit:                                  ;
         pop       bp                  ;retrieve bp register
         ret                           ;return
         end                           ;end source code
;---------------------------------------