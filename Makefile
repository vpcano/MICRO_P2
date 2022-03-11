all: pract2.exe

pract2.obj: pract2.asm
	tasm /zi pract2.asm

pract2.exe: pract2.obj
	tlink /v pract2.obj

clean:
	del pract2.exe
	del pract2.obj