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

result DW ?

EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC
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

    mov BX, 0
    mov DI, 2
    mov al, di
    mul 3
    mov di, al
    mov al, matrixA[BX][DI]
    mov BYTE PTR result[0], al

    mov BX, 2
    mov DI, 0
    mov al, di
    mul 3
    mov di, al
    mov al, matrixA[BX][DI]
    mov BYTE PTR result[1], al

    ; FIN DEL PROGRAMA
    MOV AX, 4C00H
    INT 21H
INICIO ENDP

IMPRIMIR PROC

    ret
IMPRIMIR ENDP

; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 