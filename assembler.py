
def read_code_file(filename):
    return open(file=filename, mode="r")


def parse_register_name(regName):
    if regName == "r1":
        return "000"
    if regName == "r2":
        return "001"
    if regName == "r3":
        return "010"
    if regName == "r4":
        return "011"
    if regName == "r5":
        return "100"
    if regName == "r6":
        return "101"
    if regName == "r7":
        return "110"
    else:
        return "111"


def parse_code_file(file):
    write_file = open("instruction_memory.txt", "w+")
    line = file.readline()

    while line:
        opcode = ""
        rsrc1 = ""
        rsrc2 = ""
        rdst = ""
        # offest = ""
        if "NOP" in line or "nop" in line:
            opcode = "00000"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif "HLT" in line or "hlt" in line:
            opcode = "00001"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif "SETC" in line or "setc" in line:
            opcode = "00010"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif "NOT" in line or "not" in line:
            opcode = "00011"
            reg = line.split(" ")[1]
            rsrc1 = parse_register_name(reg)
            rsrc2 = parse_register_name(reg)
            rdst = "000"
        elif "INC" in line or "inc" in line:
            opcode = "00100"
            reg = line.split(" ")[1]
            rsrc1 = parse_register_name(reg)
            rsrc2 = parse_register_name(reg)
            rdst = "000"
        elif "OUT" in line or "out" in line:
            opcode = "00101"
            reg = line.split(" ")[1]
            rsrc1 = parse_register_name(reg)
            rsrc2 = parse_register_name(reg)
            rdst = "000"
        elif "IN" in line or "in" in line:
            opcode = "00110"
            reg = line.split(" ")[1]
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = parse_register_name(reg)
        write_file.write(opcode + rsrc1 + rsrc2 + rdst + "00\n")
        line = file.readline()
    file.close()
    write_file.close()


if __name__ == "__main__":
    file = read_code_file("./code.txt")
    parse_code_file(file)