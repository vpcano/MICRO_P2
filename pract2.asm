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


    ;;  IDEA
    ;;  Usar BX, CX, y DX para guardar en sus partes altas y bajas los indices de los
    ;;  tres elementos de la matriz que se vayan a multiplicar

    mov bp, 0
    mov di, 0

    mov bx, 0                   ; A11
    mov cx, 0103h               ; A22
    mov dx, 0206h               ; A33
    call PROD
    add result, ax

    mov bx, 0006h               ; A13
    mov cx, 0100h               ; A21
    mov dx, 0203h               ; A32
    call PROD
    add result, ax

    mov bx, 0003h               ; A12
    mov cx, 0106h               ; A23
    mov dx, 0200h               ; A31
    call PROD
    add result, ax

    mov bx, 0006h               ; A13
    mov cx, 0103h               ; A22
    mov dx, 0200h               ; A31
    call PROD
    sub result, ax

    mov bx, 0000h               ; A11
    mov cx, 0106h               ; A23
    mov dx, 0203h               ; A32
    call PROD
    sub result, ax

    mov bx, 0006h               ; A12
    mov cx, 0100h               ; A21
    mov dx, 0206h               ; A33
    call PROD
    sub result, ax


    ; FIN DEL PROGRAMA
    MOV AX, 4C00H
    INT 21H
DET ENDP


PROD PROC

    mov BYTE PTR BP, BH
    mov BYTE PTR DI, BL
    mov al, matrixA[BP][DI]

    mov BYTE PTR BP, CH
    mov BYTE PTR DI, CL
    imul matrixA[BP][DI]

    mov BYTE PTR BP, DH
    mov BYTE PTR DI, DL
    imul matrixA[BP][DI]

    ret
PROD ENDP


IMPRIMIR PROC

    ret
IMPRIMIR ENDP


; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END DET
