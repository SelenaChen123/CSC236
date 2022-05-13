;-------------------------------------------------------------------------------------
;  Program:      Run Length Coding
;
;  Function:     Decompresses 1 dimensional run lengths. This subroutine links with a
;                C main program. Run-length coding (RLC) is a form of data compression
;                for such data types in which runs of data are stored as a single data
;                value (black or white) and a count specifying the run length.
;
;  Input:        A pointer to the compressed data which consists of strings of runs
;                and features. A pointer to a buffer, into which RLC is to decompress
;                the data to recreate the original character array
;
;  Output:       The decompressed data is placed into the output buffer.
;
;  Owner:        Selena Chen (schen53)
;                Ayushi Verma (averma6)
;
;  Date:         04/08/20
;
;  Changes:      05/16/2017    Original version ... coded to spec design
;                04/05/2020    First draft
;                04/07/2020    Working draft
;                04/08/2020    Completed version
;-------------------------------------------------------------------------------------
         .model    small
         .8086
         public    _rlc
;-----------------------------------------------
         .data                                 ;start the data segment
;-----------------------------------------------
wh       db        32                          ;white ascii value
blk      db        219                         ;black ascii value
is_left  db        1                           ;is it left 4 bits of byte
pels     db        80                          ;number of pels left
;-----------------------------------------------
         .code                                 ;start the code segnment
;-----------------------------------------------
; Save the registers ... 'C' requires (bp,si,di)
; Access the input and output lists
;-----------------------------------------------
_rlc:                                          ;
         push      bp                          ;save 'C' register
         mov       bp,sp                       ;set bp to point to stack
         push      si                          ;save 'C' register
         push      di                          ;save 'C' register
         mov       si,[bp+4]                   ;si points to the input compressed data
         mov       di,[bp+6]                   ;di points to the empty output buffer
;-----------------------------------------------
; Sets up white as first color being used and
; initializes cx to 0
;-----------------------------------------------
         mov       bl,[wh]                     ;begin with white color
         mov       cx,0                        ;clears cx register
         cld                                   ;clears direction flag for load/store
;-----------------------------------------------
; Gets each byte from input buffer
;-----------------------------------------------
load:                                          ;
         lodsb                                 ;loads input byte into al
         cmp       al,00h                      ;checks if byte is 0
         je        exit                        ;if it is, exit
         mov       bh,al                       ;hold byte in bh register
         mov       cl,4                        ;hold bit shift value 4 in cl
         shr       al,cl                       ;shift al by 4 to get upper 4 bits
         mov       cl,al                       ;move this value into cl
         and       bh,0fh                      ;perform and to get lower 4 bits
         mov       [is_left],1                 ;process top 4 bits value first
;-----------------------------------------------
; Process the 4 bits of input byte and change
; color appropriately
;-----------------------------------------------
left_run:                                      ;
         mov       al,bl                       ;move color value into al for output
         cmp       cl,0fh                      ;is cl value 15
         je        hit_eol                     ;yes, jump to end of line code
         sub       [pels],cl                   ;total pels -= current count
         cmp       bl,[wh]                     ;is the color white
         jne       set_white                   ;if not jump to make it white
         mov       bl,[blk]                    ;change color to black
         jmp       print                       ;ready to print so jump to print
;-----------------------------------------------
; Process what happens when you hit the end of
; a line
;-----------------------------------------------
hit_eol:                                       ;
         mov       cl,[pels]                   ;move remaining pels to cl
         mov       [pels],80                   ;change pel count to 80 for new line
;-----------------------------------------------
; Set color to white
;-----------------------------------------------
set_white:                                     ;
         mov       bl,[wh]                     ;change color to white
;-----------------------------------------------
; Push byte value into output buffer
;-----------------------------------------------
print:                                         ;
         mov       dx,ds                       ;move ds contents into dx
         mov       es,dx                       ;move dx into es to copy ds into es
         rep       stosb                       ;store byte in output buffer
;-----------------------------------------------
; Continue processing values of input
;-----------------------------------------------
         cmp       [is_left],1                 ;check if we are processing left 4 bits
         jne       load                        ;jump to process next value
;-----------------------------------------------
; Process the lower 4 bits of input byte
;-----------------------------------------------
         mov       cl,bh                       ;move lower 4 bits into cl
         mov       [is_left],0                 ;we are not processing top 4 bits
         jmp       left_run                    ;process input
;-----------------------------------------------
; Restore registers and return
;-----------------------------------------------
exit:                                          ;
         pop       di                          ;restore 'C' register
         pop       si                          ;restore 'C' register
         pop       bp                          ;restore 'C' register
         ret                                   ;return
;-----------------------------------------------
         end                                   ;end
;-----------------------------------------------