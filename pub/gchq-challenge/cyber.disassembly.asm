00000000 EB 04                        	jmp	0x00000006
00000002 AF                           	scas	eax, es:[edi]
00000003 C2 BF A3                     	ret	0xA3BF
00000006 81 EC 00 01 00 00            	sub	esp, 0x00000100
0000000C 31 C9                        	xor	ecx, ecx
0000000E 88 0C 0C                     	mov	[esp+ecx], cl
00000011 FE C1                        	inc	cl
00000013 75 F9                        	jnz	0x0000000E
00000015 31 C0                        	xor	eax, eax
00000017 BA EF BE AD DE               	mov	edx, 0xDEADBEEF
0000001C 02 04 0C                     	add	al, [esp+ecx]
0000001F 00 D0                        	add	al, dl
00000021 C1 CA 08                     	ror	edx, 0x08
00000024 8A 1C 0C                     	mov	bl, [esp+ecx]
00000027 8A 3C 04                     	mov	bh, [esp+eax]
0000002A 88 1C 04                     	mov	[esp+eax], bl
0000002D 88 3C 0C                     	mov	[esp+ecx], bh
00000030 FE C1                        	inc	cl
00000032 75 E8                        	jnz	0x0000001C
00000034 E9 5C 00 00 00               	jmp	0x00000095
00000039 89 E3                        	mov	ebx, esp
0000003B 81 C3 04 00 00 00            	add	ebx, 0x00000004
00000041 5C                           	pop	esp
00000042 58                           	pop	eax
00000043 3D 41 41 41 41               	cmp	eax, 0x41414141
00000048 75 43                        	jnz	0x0000008D
0000004A 58                           	pop	eax
0000004B 3D 42 42 42 42               	cmp	eax, 0x42424242
00000050 75 3B                        	jnz	0x0000008D
00000052 5A                           	pop	edx
00000053 89 D1                        	mov	ecx, edx
00000055 89 E6                        	mov	esi, esp
00000057 89 DF                        	mov	edi, ebx
00000059 29 CF                        	sub	edi, ecx
0000005B F3 A4                        	repz movs	es:[edi], ds:[esi]
0000005D 89 DE                        	mov	esi, ebx
0000005F 89 D1                        	mov	ecx, edx
00000061 89 DF                        	mov	edi, ebx
00000063 29 CF                        	sub	edi, ecx
00000065 31 C0                        	xor	eax, eax
00000067 31 DB                        	xor	ebx, ebx
00000069 31 D2                        	xor	edx, edx
0000006B FE C0                        	inc	al
0000006D 02 1C 06                     	add	bl, [esi+eax]
00000070 8A 14 06                     	mov	dl, [esi+eax]
00000073 8A 34 1E                     	mov	dh, [esi+ebx]
00000076 88 34 06                     	mov	[esi+eax], dh
00000079 88 14 1E                     	mov	[esi+ebx], dl
0000007C 00 F2                        	add	dl, dh
0000007E 30 F6                        	xor	dh, dh
00000080 8A 1C 16                     	mov	bl, [esi+edx]
00000083 8A 17                        	mov	dl, [edi]
00000085 30 DA                        	xor	dl, bl
00000087 88 17                        	mov	[edi], dl
00000089 47                           	inc	edi
0000008A 49                           	dec	ecx
0000008B 75 DE                        	jnz	0x0000006B
0000008D 31 DB                        	xor	ebx, ebx
0000008F 89 D8                        	mov	eax, ebx
00000091 FE C0                        	inc	al
00000093 CD 80                        	int	0x80
00000095 90                           	nop	
00000096 90                           	nop	
00000097 E8 9D FF FF FF               	call	0x00000039
0000009C 41                           	inc	ecx
0000009D 41                           	inc	ecx
0000009E 41                           	inc	ecx
0000009F 41                           	inc	ecx
