        .MODEL TINY
_TEXT   SEGMENT PUBLIC 'CODE'

        .CODE
video_base      EQU 0B800h

        PUBLIC _char_address
_char_address PROC
        push    BP
        mov     BP, SP

        mov     AL, byte ptr SS:[BP + 6]        ;AL = y
        xor     AH, AH
        mov     DL, 160                         ;DL = 80 * 2
        mul     DL                              ;AX = 80 * 2 * y
        mov     DL, byte ptr SS:[BP + 4]        ;DL = x
        xor     DH, DH
        add     AX, DX                          ;AX = 80 * 2 * y + x

        mov     DX, video_base

        pop     BP
        retn
_char_address ENDP

        PUBLIC _save_region
_save_region PROC
        push    BP
        mov     BP, SP

        push    SI
        push    DI
        push    DS
        push    ES
        push    DS
        pop     ES      ; ES = DS

        mov     AX, video_base
        mov     DS, AX				; segment of char on screen

        xor     CX, CX				; rows iterator
        mov     CL, byte ptr SS:[BP + 12]       ; h

        mov     DI, word ptr SS:[BP + 4]        ; dst

_save_region_loop:
        mov     AL, byte ptr SS:[BP + 8]        ; y
        push    AX
        mov     AL, byte ptr SS:[BP + 6]        ; x
        push    AX

        call    _char_address

        add     SP, 4
        mov     SI, AX				; offset of char on screen

        push    CX				; save rows iterator

        ; Iterate w
        xor     CX, CX
        mov     CL, byte ptr SS:[BP + 10]       ; w

        cld
        rep movsw
        ; end Iterate w

        mov     AL, byte ptr SS:[BP + 8]        ; y
        inc     AL                              ; =
        mov     byte ptr SS:[BP + 8], AL        ; y + 1

        pop     CX				; restore rows iterator
        loop    _save_region_loop

        pop     ES
        pop     DS
        pop     DI
        pop     SI

        pop     BP
        retn
_save_region ENDP


        PUBLIC _restore_region
_restore_region PROC
        push    BP
        mov     BP, SP

        push    SI
        push    DI
        push    DS
        push    ES

        mov     AX, video_base
        mov     ES, AX				; segment of char on screen

        xor     CX, CX				; rows iterator
        mov     CL, byte ptr SS:[BP + 10]       ; h

        mov     SI, word ptr SS:[BP + 12]       ; src

_restore_region_loop:
        mov     AL, byte ptr SS:[BP + 6]        ; y
        push    AX
        mov     AL, byte ptr SS:[BP + 4]        ; x
        push    AX

        call    _char_address

        add     SP, 4
        mov     DI, AX				; offset of char on screen

        push    CX				; save rows iterator

        ; Iterate w
        xor     CX, CX
        mov     CL, byte ptr SS:[BP + 8]        ; w

        cld
        rep movsw
        ; end Iterate w

        mov     AL, byte ptr SS:[BP + 6]        ; y
        inc     AL                              ; =
        mov     byte ptr SS:[BP + 6], AL        ; y + 1

        pop     CX				; restore rows iterator
        loop    _restore_region_loop

        pop     ES
        pop     DS
        pop     DI
        pop     SI

        pop     BP
        retn
_restore_region ENDP

_TEXT   ENDS
        END