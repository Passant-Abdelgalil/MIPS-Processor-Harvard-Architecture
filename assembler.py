import re


def read_code_file(filename):
    return open(file=filename, mode="r")


def parse_register_name(regName):
    regName = regName.strip()
    if regName == "r0":
        return "000"
    if regName == "r1":
        return "001"
    if regName == "r2":
        return "010"
    if regName == "r3":
        return "011"
    if regName == "r4":
        return "100"
    if regName == "r5":
        return "101"
    if regName == "r6":
        return "110"
    if regName == "r7":
        return "111"
    return "-111"


def parse_code_file(file):
    write_file = open("instruction_memory.txt", "w+")
    line = file.readline()

    while line:
        with_offset = False
        offset_val = ""
        opcode = ""
        rsrc1 = ""
        rsrc2 = ""
        rdst = ""
        # offest = ""
        if "nop" in line.lower():
            opcode = "00000"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif "hlt" in line.lower():
            opcode = "00001"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif "setc" in line.lower():
            opcode = "00010"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif "not" in line.lower():
            opcode = "00011"
            reg = line.split(" ")[1]
            rsrc1 = parse_register_name(reg)
            rsrc2 = rsrc1
            rdst = rsrc2
        elif "inc" in line.lower():
            opcode = "00100"
            reg = line.split(" ")[1]
            rsrc1 = parse_register_name(reg)
            rsrc2 = rsrc1
            rdst = rsrc1
        elif "out" in line.lower():
            opcode = "00101"
            reg = line.split(" ")[1]
            rsrc1 = parse_register_name(reg)
            rsrc2 = rsrc1
            rdst = rsrc1
        elif "in" in line.lower():
            opcode = "00110"
            reg = line.split(" ")[1]
            rdst = parse_register_name(reg)
            rsrc1 = rdst
            rsrc2 = rdst
# ======= Two Operands========================================
        elif "mov" in line.lower():
            opcode = "01000"
            regs = line.split(" ")
            rsrc1 = parse_register_name(regs[1][:-2])
            rsrc2 = rsrc1
            rdst = parse_register_name(regs[2].strip())
        elif "add" in line.lower():
            opcode = "01001"
            regs = line.split(" ")
            rdst = parse_register_name(regs[1][:-2])
            rsrc1 = parse_register_name(regs[2][:-2])
            rsrc2 = parse_register_name(regs[3])
        elif "sub" in line.lower():
            opcode = "01010"
            regs = line.split(" ")
            rdst = parse_register_name(regs[1][:-2])
            rsrc1 = parse_register_name(regs[2][:-2])
            rsrc2 = parse_register_name(regs[3])
        elif "and" in line.lower():
            opcode = "01011"
            regs = line.split(" ")
            rdst = parse_register_name(regs[1][:-2])
            rsrc1 = parse_register_name(regs[2][:-2])
            rsrc2 = parse_register_name(regs[3])
        elif "iadd" in line.lower():
            opcode = "01100"
            wih_offset = True
            regs = line.split(" ")
            rdst = parse_register_name(regs[1][:-2])
            rsrc1 = parse_register_name(regs[2][:-2])
            rsrc2 = rsrc1
            offset_val = regs[3][1:]
# ======= Memory Operations========================================
        elif "push" in line.lower():
            opcode = "10000"
            reg = line.split(" ")[1]
            rsrc1 = parse_register_name(reg)
            rsrc2 = rsrc1
            rdst = rsrc1
        elif "pop" in line.lower():
            opcode = "10001"
            reg = line.split(" ")[1]
            rsrc1 = parse_register_name(reg)
            rsrc2 = rsrc1
            rdst = rsrc1
        elif "ldm" in line.lower():
            opcode = "10010"
            with_offset = True
            regs = line.split(" ")
            offset_val = regs[2]
            rdst = parse_register_name(regs[1][:-2])
            rsrc1 = rdst
            rsrc2 = rdst
        elif "ldd" in line.lower():
            opcode = "10011"
            with_offset = True
            regs = line.split(" ")
            rdst = parse_register_name(regs[1][:-2])
            offset_val = regs[2].split("(")[0]
            rsrc1 = regs[2].split("(")[1][:-2]
            rsrc2 = rsrc1
        elif "std" in line.lower():
            opcode = "10100"
            with_offset = True
            regs = line.split(" ")
            rsrc1 = parse_register_name(regs[1][:-2])
            rdst = rsrc1
            offset_val = regs[2].split("(")[0]
            rsrc2 = regs[2].split("(")[1][:-2]
# ======= Branch and Change of Control Operations========================================
        elif "jz" in line.lower():
            opcode = "11000"
            rdst = line.split(" ")[1]
            rsrc1 = rdst
            rsrc2 = rdst
        elif "jn" in line.lower():
            opcode = "11001"
            rdst = line.split(" ")[1]
            rsrc1 = rdst
            rsrc2 = rdst
        elif "jc" in line.lower():
            opcode = "11010"
            rdst = line.split(" ")[1]
            rsrc1 = rdst
            rsrc2 = rdst
        elif "jmp" in line.lower():
            opcode = "11011"
            rdst = line.split(" ")[1]
            rsrc1 = rdst
            rsrc2 = rdst
        elif "call" in line.lower():
            opcode = "11100"
            rdst = line.split(" ")[1]
            rsrc1 = rdst
            rsrc2 = rdst
        elif "ret" in line.lower():
            opcode = "11101"
            rdst = "000"
            rsrc1 = rdst
            rsrc2 = rdst
        elif "int" in line.lower():
            opcode = "11110"
            with_offset = True
            offset_val = line.split(" ")[1]
            rdst = "000"
            rsrc1 = rdst
            rsrc2 = rdst
        elif "rti" in line.lower():
            opcode = "11111"
            rdst = "000"
            rsrc1 = rdst
            rsrc2 = rdst

# ================== Write decoded instruction ==============
        write_file.write(opcode + rsrc1 + rsrc2 + rdst + "00\n")
        if with_offset:
            write_file.write(offset_val)
        line = file.readline()
    file.close()
    write_file.close()


if __name__ == "__main__":
    file = read_code_file("./code.txt")
    parse_code_file(file)
