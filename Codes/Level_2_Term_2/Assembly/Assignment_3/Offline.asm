TITLE: BINOMIAL COEFFICIENTS

.MODEL SMALL

.STACK 100H 

.DATA
ANSWER DW ? 
MSG1 DB 'YES$'
MSG2 DB 'NO$'


.CODE

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
      
    CALL INDEC   
    MOV BX,AX 
     
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H  
    
    CALL INDEC
    MOV CX,AX;
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H
    
    PUSH BX
    PUSH CX
    CALL GEN_NUMBER 
    
    MOV ANSWER,AX  
    
    CALL OUTDEC  
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H
    
    CALL GET_UNIT  
    
    CMP DX,0
    JE PRINT_YES 
    LEA DX,MSG2
    MOV AH,9
    INT 21H 
    JMP END
    
    PRINT_YES:
    LEA DX,MSG1
    MOV AH,9
    INT 21H  
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H
    
    
    END:
    MOV AH,4CH
    INT 21H             ;DOS EXIT
    
    MAIN ENDP

GEN_NUMBER PROC NEAR
    PUSH BP
    MOV BP,SP
    MOV AX,[BP+6]       ;GET A 
    MOV BX,[BP+4]
    
    CMP AX,1       ;IF(A<=1)
    JLE A_EXIT     
    CMP BX,2       ;IF(B<=2)
    JLE B_EXIT
    JMP RECURSION      
    
    A_EXIT:
    MOV AX,2            
    JMP RETURN
    
    B_EXIT:
    MOV AX,3            
    JMP RETURN
  
  
    
    RECURSION: 
    
    ;COMPUTE GEN_NUMBER(A-1,B)             
    MOV CX,[BP+6]       ;GET A
    DEC CX              ;A-1
    PUSH CX             ;PUSH A-1
    PUSH [BP+4]         ;PUSH B
    CALL GEN_NUMBER       ;RESULT1 IN AX
    PUSH AX             ;SAVE RESULT1
        
        
    ;COMPUTE GEN_NUMBER(A,B-1) 
    PUSH [BP+6]   
    MOV CX,[BP+4]      ;GET B
    DEC CX             ;B-1
    PUSH CX 
    CALL GEN_NUMBER      ;RESULT2 IN AX
    
    ;COMPUTE GEN_NUMBER(A,B)
    POP BX             ;GET RESULT1
    ADD AX,BX          ;RESULT = RESULT1+RESULT2
    
    RETURN:
    POP BP             ;RESTORE BP
    RET 4              ;RETURN AND DISCARD A AND B
    GEN_NUMBER ENDP




INDEC PROC
;AX HOLDS THE INPUT


PUSH BX
PUSH CX
PUSH DX

@BEGIN:
MOV AH,2
MOV DL,'?'
INT 21H

XOR BX,BX

XOR CX,CX

MOV AH,1
INT 21H

CMP AL,'-'
JE @MINUS
CMP AL,'+'
JE @PLUS
JMP @REPEAT2

@MINUS:
MOV CX,1

@PLUS:
INT 21H

@REPEAT2:
CMP AL,'0'
JNGE @NOT_DIGIT
CMP AL,'9'
JNLE @NOT_DIGIT

AND AX,000FH
PUSH AX

MOV AX,10
MUL BX
POP BX
ADD BX,AX

MOV AH,1
INT 21H
CMP AL,0DH
JNE @REPEAT2

MOV AX,BX

OR CX,CX
JE @EXIT

NEG AX

@EXIT:
POP DX
POP CX
POP BX
RET

@NOT_DIGIT:
MOV AH,2
MOV DL,0DH
INT 21H
MOV DL,0AH
INT 21H
JMP @BEGIN
INDEC ENDP 

OUTDEC PROC
;INPUT AX
PUSH AX
PUSH BX
PUSH CX
PUSH DX
OR AX,AX
JGE @END_IF1
PUSH AX
MOV DL,'-'
MOV AH,2
INT 21H
POP AX
NEG AX

@END_IF1:
XOR CX,CX
MOV BX,10D

@REPEAT1:
XOR DX,DX
DIV BX
PUSH DX
INC CX
OR AX,AX
JNE @REPEAT1

MOV AH,2

@PRINT_LOOP:

POP DX
OR DL,30H
INT 21H
LOOP @PRINT_LOOP

POP DX
POP CX
POP BX
POP AX
RET
OUTDEC ENDP    


GET_UNIT PROC    
    XOR DX,DX
    XOR AX,AX
    MOV AX,ANSWER;
    MOV BX,10
    DIV BX
    RET
    
    
    ENDP GET_UNIT


END MAIN 