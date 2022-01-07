import re


def read_code_file(filename):
    return open(file=filename, mode="r")


def read_instrcution_memory_file(filename):
    return open(file=filename, mode="r").readlines()


def replace_memory_cell_value(index, new_value, write32):
    global instruction_memory
    #print("index is ", index)
    #print("new value is ", new_value)
    int_index = int(index, 16)

    if write32:
        instruction_memory[int_index+3] = f'    {index}: {new_value[16:]}\n'
        instruction_memory[int_index +
                           4] = f'    {hex(int_index+1)[2:]}: {new_value[:16]}\n'
    else:
        instruction_memory[int_index+3] = f'    {index}: {new_value}\n'


def regenrate_instruction_memory_file(filename, lines):
    instruction_memory_file = open(file=filename, mode="w")
    instruction_memory_file.writelines(lines)
    instruction_memory_file.close()


def parse_register_name(regName):

    if regName is None:
        raise Exception("invalid register name")
    regName = regName.strip().lower()

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

def if_skip_line(line):
    if line is None:
        raise Exception("invalid instruction set")
    line = line.strip()
    return len(line) == 0 or line[0] == '#'

def parse_code_file(file):
    global instruction_memory
    write_file = open("instruction_memory.txt", "w+")
    line = file.readline()
    code_start_index = ""
    instruction_number = 0
    while line:

        # skip comments or empty lines
        if if_skip_line(line):
            line = file.readline()
            continue
        line = line.strip()
        # check org instruction
        if ".org" in line.lower():
            index = line.split(" ")[1]
            # get next line containing value to insert in memory
            line = file.readline()

            while if_skip_line(line):
                line = file.readline()

            # check validty of line value
            line = line.strip()
            pattern = re.compile(r"^\w+$")
            if pattern.search(line):
                #print("org line is ", line)
                new_value = f'{int(line, 16):032b}'
                replace_memory_cell_value(
                    index=index, new_value=new_value, write32=True)
                line = file.readline()
                continue
            else:
                code_start_index = int(index, 16)

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

        decoded_instruction = f'{opcode}{rsrc1}{rsrc2}{rdst}00'
        if with_offset:
            decoded_instruction = offset_val + decoded_instruction
        instruction_index = instruction_number + code_start_index
        instruction_number += 1
        #print("decoded instruction is ", decoded_instruction)
        replace_memory_cell_value(
            index=hex(instruction_index)[2:], new_value=decoded_instruction, write32=with_offset)

        line = file.readline()

    file.close()
    write_file.close()


if __name__ == "__main__":

    instruction_memory = read_instrcution_memory_file(
        filename='./instruction_memory.mem')

    file = read_code_file(filename="./code.txt")

    parse_code_file(file)

    regenrate_instruction_memory_file(
        filename='./instruction_memory2.mem', lines=instruction_memory)

