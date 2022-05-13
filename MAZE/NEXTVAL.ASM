;-------------------------------------------------------------------------
; Program:   nextval subroutine
;
; Function:  Find next mouse move in an array 15 by 30.
;            We can move into a position if its contents is blank ( 20h ).
;
; Input:     Calling sequence is:
;            x    pointer   si
;            y    pointer   di
;            dir  pointer   bx
;            maze pointer   bp
;
; Output:    x,y,dir modified in caller's data segment
;
; Owner:     Dana A. Lasher
;            Selena Chen (schen53)
;            Ayushi Verma (averma6)
;
; Date:      3/12/2020
;
; Changes:
; --------------------------
; 11/06/2016 Original version
; 03/11/2020 First draft
; 03/13/2020 Second draft
; 03/14/2020 Working draft
; 03/18/2020 Finalized version
;
;--------------------------------------------------
         .model    small                          ;64k code and 64k data
         .8086                                    ;only allow 8086 instructions
         public    nextval                        ;allow extrnal programs to call
;--------------------------------------------------
         .data                                    ;start the data segment
;--------------------------------------------------
xMax     db        30                             ;max width of maze
;--------------------------------------------------
         .code                                    ;start the code segment
;--------------------------------------------------
; Save any modified registers
;--------------------------------------------------
nextval:                                          ;
         push      ax                             ;save ax register
         push      si                             ;save si register
;--------------------------------------------------
; Calculate offset to current square: x-31
;--------------------------------------------------
         mov       al,[si]                        ;move x to al
         sub       al,31                          ;subtract 31 from x
         cbw                                      ;convert to byte
         mov       si,ax                          ;save x-31 to si
;--------------------------------------------------
; Calculate offset to current square: x-31 + y*30
;--------------------------------------------------
         mov       al,[di]                        ;move y to al
         mul       [xMax]                         ;multiply by 30
         add       si,ax                          ;accumulate total in si
;--------------------------------------------------
; Code to make 1 move in the maze
;--------------------------------------------------
         cmp       byte ptr [bx],2                ;if direction is south
         je        east                           ;try to move east
         cmp       byte ptr [bx],3                ;if direction is west
         je        south                          ;try to move south
         cmp       byte ptr [bx],4                ;if direction is north
         je        west                           ;try to move west
;--------------------------------------------------
; Try to move north
;--------------------------------------------------
north:                                            ;
         cmp       byte ptr ds:[bp + si - 30],' ' ;if square isn't empty
         jne       east                           ;try east
;--------------------------------------------------
; Move north if we can
;--------------------------------------------------
         dec       byte ptr [di]                  ;move north
         mov       byte ptr [bx],4                ;set direction to north
         pop       si                             ;retrieve si register
         jmp       exit                           ;exit after 1 move
;--------------------------------------------------
; If we cannot move north, try east
;--------------------------------------------------
east:                                             ;
         cmp       byte ptr ds:[bp + si + 1],' '  ;if square isn't empty
         jne       south                          ;try south
;--------------------------------------------------
; Move east if we can
;--------------------------------------------------
         pop       si                             ;retrieve si register
         inc       byte ptr [si]                  ;move east
         mov       byte ptr [bx],1                ;set direction to east
         jmp       exit                           ;exit after 1 move
;--------------------------------------------------
; If we cannot move east, try south
;--------------------------------------------------
south:                                            ;
         cmp       byte ptr ds:[bp + si + 30],' ' ;if square isn't empty
         jne       west                           ;try west
;--------------------------------------------------
; Move south if we can
;--------------------------------------------------
         inc       byte ptr [di]                  ;move south
         mov       byte ptr [bx],2                ;set direction to south
         pop       si                             ;retrieve si register
         jmp       exit                           ;exit ater 1 move
;--------------------------------------------------
; If we cannot move south, try west
;--------------------------------------------------
west:                                             ;
         cmp       byte ptr ds:[bp + si - 1],' '  ;if square isn't empty
         jne       north                          ;try north
;--------------------------------------------------
; Move west if we can
;--------------------------------------------------
         pop       si                             ;retrieve si register
         dec       byte ptr [si]                  ;move west
         mov       byte ptr [bx],3                ;set direction to west
;--------------------------------------------------
; Restore registers and return
;--------------------------------------------------
exit:                                             ;
         pop       ax                             ;retrieve ax register
         ret                                      ;return
;--------------------------------------------------
         end                                      ;end
;--------------------------------------------------