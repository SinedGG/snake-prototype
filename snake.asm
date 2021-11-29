org 100h
mov al,3
int 16
mov cx,-1
push 0B800h
pop es
mov ax,255
rep stosw
mov [gs:1Ch*4+2],ds
mov word[gs:1Ch*4],main
    push ds
    pop fs
    push es
    pop gs
a:
    jmp a

quit:
    xor ax,ax
    int 21h

main: mov si,snake
    mov bp,[fs:snakelen]
    mov ax,[fs:bx+snake]
    add ax,[fs:step]
    mov di,[fs:snake+bp]
    mov byte[gs:di],255
    xchg ax,di
    cmp ax,di
    jne next
    add di,[fs:step]
    random:rdtsc
    and ax,4094
    cmp ax,3998
    ja random
    inc ax
     mov [fs:snake+bp+2],ax
    add [fs:snakelen],2

next:
    xor cx,cx
    mov ax,4000
    add di,ax
    cmp di,ax
    cmovl ax,cx
    sub di,ax
    cmp di,ax
    cmovl ax,cx
    sub di,ax
    inc bx
    inc bx
    cmp bx,bp
    cmove bx,cx
    xor byte[gs:di],255
    je quit
    xchg di,[fs:bx+snake]
    mov [gs:di],cx
    in al,60h
    cbw
    mov cx,ax
    shld bp,ax,17
    mov dx,[fs:move+bp-144]
    sub bp,144
    sub cx,81
    xor cx,bp
    cmovnl dx,[fs:step]
    mov [fs:step],dx
    dec ax
    
je quit
iret

step dw 2
move dw -160,0,0,-2,0,2,0,0,160

snakelen dw 6
snake dw 2005,2001,2003,2007
