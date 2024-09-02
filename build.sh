NAME="calc"
nasm -f elf -o "${NAME}.o" "${NAME}.s" &&  ld -m elf_i386 "${NAME}.o" -o $NAME 
