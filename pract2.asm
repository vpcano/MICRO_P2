;**************************************************************************
; SBM 2022. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT

matrixA db 3, 2, -3, 7, -1, 0, 2, -4, 5

fSup    db 23 dup(' '), "      | $"
fMed	db 10,13,23 dup(' '),"|a| = | $"
fInf	db 10,13,23 dup(' '),"      | $"
igual   db " = $"

opts    db "Selecciona una de las siguientes opciones:",10,13
        db 9,"1. Calcular el determiante con los valores por defecto.",10,13
        db 9,"2. Introducir los valores por teclado manualmente.",10,13
        db "Introduce un numero (1 o 2): $"

opcion  db 2, ?, 0, 0

sp_aux  dw ?

DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT

result DW 0

EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
MAIN PROC
    ; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
    MOV AX, DATOS
    MOV DS, AX
    MOV AX, PILA
    MOV SS, AX
    MOV AX, EXTRA
    MOV ES, AX
    MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
    ; FIN DE LAS INICIALIZACIONES
    ; COMIENZO DEL PROGRAMA

    call clear
    pedir_opcion:
        ; Imprimir opciones
        lea dx, opts
        mov ah, 09h
        int 21h
        ; Leer opcion
        lea dx, opcion
        mov ah, 0ah
        int 21h
        ; Ejecutar opcion
        cmp opcion[2], '1'
        je calcular_det
        cmp opcion[2], '2'
        je pedir_valores
        jmp pedir_opcion

    pedir_valores:
        call clear
        ; Pedir matriz por teclado

    calcular_det:
        call clear
        call determinante
        call imprimir_resultado

    ; FIN DEL PROGRAMA
    MOV AX, 4C00H
    INT 21H

    clear:
        mov cx, 40
        linea:
            mov dl, 10
            mov ah, 02h
            int 21h
            loop linea
        mov dl, 13
        mov ah, 02h
        int 21h
        ret

    ; Usa la regla de Sarrus
    determinante:
        mov ax, 0
        mov cx, 0
        mov al, matrixA[0][0]       ; A11
        mov bl, matrixA[1][3]       ; A22
        mov ch, matrixA[2][6]       ; A33
        call prod
        add result, ax

        mov ax, 0
        mov cx, 0
        mov al, matrixA[2][0]       ; A13
        mov bl, matrixA[0][3]       ; A21
        mov ch, matrixA[1][6]       ; A32
        call prod
        add result, ax

        mov ax, 0
        mov cx, 0
        mov al, matrixA[1][0]       ; A12
        mov bl, matrixA[2][3]       ; A23
        mov ch, matrixA[0][6]       ; A31
        call prod
        add result, ax

        mov ax, 0
        mov cx, 0
        mov al, matrixA[2][0]       ; A13
        mov bl, matrixA[1][3]       ; A22
        mov ch, matrixA[0][6]       ; A31
        call prod
        sub result, ax

        mov ax, 0
        mov cx, 0
        mov al, matrixA[0][0]       ; A11
        mov bl, matrixA[2][3]       ; A23
        mov ch, matrixA[1][6]       ; A32
        call prod
        sub result, ax

        mov ax, 0
        mov cx, 0
        mov al, matrixA[1][0]       ; A12
        mov bl, matrixA[0][3]       ; A21
        mov ch, matrixA[2][6]       ; A33
        call prod
        sub result, ax

        ret
    
        ; Producto de los tres numeros almacenados en AL, BL, y CL.
        ; El resultado se guarda en DX
        prod:
            imul bl     ; AX = AL * BL
            mov cl, 8   ; Extension de signo
            sar cx, cl  ; Extension de signo
            imul cx     ; AX = AX * CX
            ret


    imprimir_resultado:

        ; Fila superior
        lea dx, fSup
        mov ah, 09h
        int 21h
        mov si, 0
        mov bp, 0
        call imprimir_fila

        ; Fila del medio
        lea dx, fMed
        mov ah, 09h
        int 21h
        mov si, 0
        mov bp, 3
        call imprimir_fila_medio

        ; Fila inferior
        lea dx, fInf
        mov ah, 09h
        int 21h
        mov si, 0
        mov bp, 6
        call imprimir_fila

        ; Saltos de linea
        mov cx, 10
        n_linea:
            mov dl, 10
            mov ah, 02h
            int 21h
            loop n_linea
        mov dl, 13
        mov ah, 02h
        int 21h

        ret

        imprimir_numero:
            ; Guardamos el puntero a pila para recuperarlo despues
            mov sp_aux, sp

            ; Si es negativo...
            mov bx, 8000h
            and bx, ax
            cmp bx, 8000h
            jne bin_a_ascii

            negativo:
                mov bx, -1
                imul bx
                mov bx, ax
                mov dl, '-'
                mov ah, 02h
                int 21h
                mov ax, bx
                dec cx

            bin_a_ascii:
                mov dx, 0
                mov bx, 10
                div bx
                push dx
                cmp ax, 0
                jne bin_a_ascii

            imprimir_pila:
                pop dx 
                add dl, 48
                mov ah, 02h
                int 21h
                dec cx
                cmp sp, sp_aux  ; Vacio la pila
                jne imprimir_pila

            ret


        imprimir_fila:
            mov ah, matrixA[si][bp]
            mov cl, 8   ; Extension de signo
            sar ax, cl  ; Extension de signo

            ; Hay 5 espacios para imprimir. Para alinear imprimeremos
            ; espacios hasta que CX = 0.
            mov cx, 5
            call imprimir_numero

            cmp cx, 0
            je siguiente_fila

            imprimir_espacio:
                mov dl, ' '
                mov ah, 02h
                int 21h
                loop imprimir_espacio

            siguiente_fila:
                inc si
                cmp si, 3
                jne imprimir_fila

            mov dl, '|'
            mov ah, 02h
            int 21h
            ret


        imprimir_fila_medio:
            call imprimir_fila

            lea dx, igual
            mov ah, 09h
            int 21h

            mov ax, result
            call imprimir_numero

            ret



MAIN ENDP



    


; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END MAIN
