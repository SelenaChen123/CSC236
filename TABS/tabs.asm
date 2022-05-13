;--------------------------------------------------------------------------
;   program:    TABS
;   function:   Reads lines from an ASCII input text file which is
;               redirected to the standard input, expands tabs (replace
;               tabs with the correct number of spaces) to create columns,
;               and writes the updated lines to an ASCII output text file
;               which is redirected from the standard output.
;   run:        Start the program, then give input from standard (keyboard
;               or a redirected ASCII text file).
;   messages:   N/A
;   return:     N/A
;   limits:     Only handles the printable ASCII characters in the range of
;               20h-7Fh along with the control characters tab (09h), line
;               feed (0Ah), carriage return (0Dh), and End Of File (1Ah).
;   owner:      Selena Chen
;   date:       2/25/2020
;   changes:    N/A
;----------------------------------------
        .model  small                   ;64k code and 64k data
        .8086                           ;only allow 8086 instructions
        .stack  256                     ;reserver 256 bytes for the stack
;----------------------------------------
        .code                           ;start the code segment
;----------------------------------------
start:                                  ;
        mov     bl,10                   ;set default tab stop position
        mov     cl,bl                   ;set cl to tab stop position
        cmp     byte ptr es:[80h], 0    ;access the CLP count
        je      read                    ;continue with the program
        mov     bl, byte ptr es:[82h]   ;parameter found, load al with char
        sub     bl,'0'
        mov     cl,bl                   ;set cl to CLP tab stop position
;----------------------------------------
; read a character
;----------------------------------------
read:                                   ;
        mov     ah,8                    ;set the dos code to read a char
        int     21h                     ;read the char
        cmp     al,09h                  ;was the char a tab
        je      expand                  ;yes, expand tab
;----------------------------------------
; write a character
;----------------------------------------
write:                                  ;
        sub     cl,1                    ;char read, decrement cl
        mov     dl,al                   ;move the char to be read
        mov     ah,2                    ;code to write char
        int     21h                     ;write the char
;----------------------------------------
; determine whether to reset counter
;----------------------------------------
        cmp     al,0Ah                  ;was the char a line feed
        je      reset                   ;yes, reset char count
        cmp     cl,0                    ;at tab stop position?
        je      reset                   ;yes, reset counter
        jmp     continue                ;no, continue reading
;----------------------------------------
; expand tabs
;----------------------------------------
expand:                                 ;
        mov     dl,' '                  ;move space to write
        mov     ah,2                    ;code to write char
        int     21h                     ;write char
        loop    expand                  ;continue loop
;----------------------------------------
; reset counter
;----------------------------------------
reset:                                  ;
        mov     cl,bl                   ;reset counter to CLP
;----------------------------------------
; continuation check
;----------------------------------------
continue:                               ;
        cmp     dl,1Ah                  ;was the char EOF
        jne     read                    ;no, read another char
;----------------------------------------
; terminate program execution
;----------------------------------------
exit:                                   ;
        mov     ax,4c00h                ;set dos code to terminate program
        int     21h                     ;return to dos
        end     start                   ;marks the end of the source code
                                        ;and specifies where you want the
                                        ;program to start execution
;----------------------------------------