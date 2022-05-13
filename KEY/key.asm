;------------------------------------------------------------------
;   program:    KEY
;   function:   Reads printable characters from standard input
;               (keyboard or a redirected ASCII text file). If the
;               character is an upper case letter (A-Z) then write
;               it to the standard output. If the character is a
;               lower case letter (a-z) then convert it to upper
;               case and write it to the standard output. If the
;               character is a blank or period then write it to the
;               standard output. If the character is anything else
;               then do not write it to standard output, just throw
;               the character away. After processing the character,
;               if the character is a period then end the program’s
;               execution.
;   run:        Start the program, then give input from standard
;               (keyboard or a redirected ASCII text file).
;   messages:   N/A
;   return:     N/A
;   limits:     Only handles the printable ASCII characters in the
;               range of 20h-7Fh.
;   owner:      Selena Chen
;   date:       2/14/2000
;   changes:    N/A
;--------------------------------
        .model  small           ;64k code and 64k data
        .8086                   ;only allow 8086 instructions
        .stack  256             ;reserver 256 bytes for the stack
;--------------------------------
        .data                   ;start the data segment
;--------------------------------
tran    db      32  dup ('*')                   ;chars below blank
        db      20h                             ;blank character
        db      13  dup ('*')                   ;chars below period
        db      2Eh                             ;period character
        db      18  dup ('*')                   ;chars below 'A'
        db      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'    ;A-Z
        db      6   dup ('*')                   ;chars above 'Z'
        db      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'    ;a-z in uppercase
        db      133 dup ('*')                   ;chars above 'z'
period  db      2Eh                             ;period character
invalid db      '*'                             ;invalid character
;--------------------------------
        .code                   ;start the code segment
;--------------------------------
start:                          ;
        mov     ax,@data        ;establish addressability to the
        mov     ds,ax           ;data segment for this program
;--------------------------------
; reads a character
;--------------------------------
read:                           ;
        mov     bx,offset tran  ;bx points to the table
        mov     ah,8            ;set the dos code to read a char
        int     21h             ;read the char
;--------------------------------
; process a character
;--------------------------------
        xlat                    ;translate the char
        mov     dl,al           ;move char to dl
        cmp     dl,[invalid]    ;was the char invalid
        je      read            ;yes read another char
;--------------------------------
; writes a character
;--------------------------------
        mov     ah,2            ;no, code to write char
        int     21h             ;write the char
;--------------------------------
; continuation check
;--------------------------------
        cmp     dl,[period]     ;was the char a period
        jne     read            ;no, read another char
;--------------------------------
; terminate program execution
;--------------------------------
exit:                           ;
        mov     ax,4c00h        ;set dos code to terminate program
        int     21h             ;return to dos
        end     start           ;marks the end of the source code
                                ;and specifies where you want the
                                ;program to start execution
;--------------------------------