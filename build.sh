NAME="calc"
nasm -f elf -o "${NAME}.o" "${NAME}.s" &&  ld -m elf_i386 "${NAME}.o" -o $NAME 
nasm -f elf -o "${NAME}_cmd.o" "${NAME}_cmd.s" &&  ld -m elf_i386 "${NAME}_cmd.o" -o main
