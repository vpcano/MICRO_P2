;**************************************************************************
; SBM 2022. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT

matrixA db 3, 2, -3, 7, -1, 0, 2, -4, 5

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
DET PROC
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

    mov ax, 0
    mov cx, 0
    mov al, matrixA[0][0]       ; A11
    mov bl, matrixA[1][3]       ; A22
    mov ch, matrixA[2][6]       ; A33
    call PROD
    add result, ax

    mov ax, 0
    mov cx, 0
    mov al, matrixA[2][0]       ; A13
    mov bl, matrixA[0][3]       ; A21
    mov ch, matrixA[1][6]       ; A32
    call PROD
    add result, ax

    mov ax, 0
    mov cx, 0
    mov al, matrixA[1][0]       ; A12
    mov bl, matrixA[2][3]       ; A23
    mov ch, matrixA[0][6]       ; A31
    call PROD
    add result, ax

    mov ax, 0
    mov cx, 0
    mov al, matrixA[2][0]       ; A13
    mov bl, matrixA[1][3]       ; A22
    mov ch, matrixA[0][6]       ; A31
    call PROD
    sub result, ax

    mov ax, 0
    mov cx, 0
    mov al, matrixA[0][0]       ; A11
    mov bl, matrixA[2][3]       ; A23
    mov ch, matrixA[1][6]       ; A32
    call PROD
    sub result, ax

    mov ax, 0
    mov cx, 0
    mov al, matrixA[1][0]       ; A12
    mov bl, matrixA[0][3]       ; A21
    mov ch, matrixA[2][6]       ; A33
    call PROD
    sub result, ax


    ; FIN DEL PROGRAMA
    MOV AX, 4C00H
    INT 21H
DET ENDP


PROD PROC

    ;; Producto de los tres numeros almacenados en AL, BL, y CL.
    ;; El resultado se guarda en DX

    imul bl     ; AX = AL * BL
    mov cl, 8   ; Extension de signo
    sar cx, cl  ; Extension de signo
    imul cx     ; AX = AX * CX

    ret
PROD ENDP


IMPRIMIR PROC

    ret
IMPRIMIR ENDP


; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END DET
