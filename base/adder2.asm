	lui x3,0x00200
	sw x0,x3,0
	addi x4,x0,5
	addi x5,x0,0x11
loop:  lw x1,x3,8
		andi x1,x1,0xff
		bne x1,x4,loop
		addi x1,x0,0xff
		sw x1,x3,0x10
		addi x1,x0,0x56
		sw x1,x3,0x20
		lw x1,x3,0x30
		sw x0,x3,4
loop2:  lw x1,x3,8
		andi x1,x1,0xff
		bne x1,x5,loop2
loop3:  lw x1,x3,8
		andi x1,x1,0xff
		bne x1,x4,loop3
		addi x1,x0,0xff
		sw x1,x3,0x10
		addi x1,x0,0x56
		sw x1,x3,0x20
		lw x1,x3,0x30
		sw x1,x3,0x80
lend: beq x0,x0,lend
