.section .data
result_msg: .asciz "n = %d\n"     
TRUE:      .asciz "true\n"        
FALSE:     .asciz "false\n"       

.section .text
.globl main

main:
    pushq %rbp                    
    movq %rsp, %rbp

    # Evaluate true && false (false)
    movl $1, %edi                 
    movl $0, %esi                 
    andl %esi, %edi               
    testl %edi, %edi              
    je print_false                
    mov $TRUE, %rdi               
    call printf                   
    jmp if_else_check             

print_false:
    mov $FALSE, %rdi              
    call printf                   
    jmp if_else_check             

# Evaluate if 3 <> 4 then 10 * 2 else 14
if_else_check:
    movl $3, %edi
    movl $4, %esi
    cmpl %esi, %edi                   
    je do_else
    movl $10, %edi
    imull $2, %edi
    jmp print_result

do_else:
    movl $14, %edi 

print_result:
    movl %edi, %esi               
    mov $result_msg, %rdi         
    call printf                   
    jmp or_check                  

# Evaluate 2 = 3 || 4 <= 2 * 3
or_check:
    movl $2, %edi                 
    movl $3, %esi                 
    cmpl %esi, %edi               
    je part_true                  

    movl $2, %edi                 
    imull $3, %edi                
    movl $4, %esi                 
    cmpl %edi, %esi               
    jle part_true                 

    mov $FALSE, %rdi              
    call printf                   
    jmp finish

part_true:
    mov $TRUE, %rdi               
    call printf                   

finish:
    movq %rbp, %rsp               
    popq %rbp
    movl $0, %eax                 
    ret
