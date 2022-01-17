
import re
import argparse
import os

def read_code_file(filename):
    if not os.path.isfile(filename):
        raise Exception("code file doesn't exists")
    return open(file=filename, mode="r")

def read_instrcution_memory_file(filename):
    if not os.path.isfile(filename):
        raise Exception("Can not proceed without instruction_memory.mem")
    
    file = open(file=filename, mode="r")
    lines = file.readlines()
    file.close()
    
    return lines


def replace_memory_cell_value(index, new_value, write32):
    global instruction_memory
    #print("new value is ", new_value)
    int_index = int(index, 16)
    
    if write32:
        #print('index in write 32 is ',index)
        instruction_memory[int_index+3] = f'    {index}: {new_value[:16]}\n'
        instruction_memory[int_index +
                           4] = f'    {hex(int_index+1)[2:]}: {new_value[16:]}\n'
    else:
        instruction_memory[int_index+3] = f'    {index}: {new_value}\n'


def regenrate_instruction_memory_file(filename, lines):
    try:
        instruction_memory_file = open(file=filename, mode="w")
    except:
        print("couldn't generate memory")
        return
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

def is_instruction(line):
    if line is None:
        return False
    line = line.strip().lower()
    parts = re.split(r'[-\(\),\s]\s*', line)
    instructions = ['nop', 'hlt', 'setc', 'not', 'inc', 'out', 'in', 'mov', 'add', 'sub', 'and', 'iadd', 'push','pop', 'ldm', 'ldd', 'std', 'jz', 'jn', 'jc', 'jmp', 'call', 'ret','int', 'rti']
    return parts[0] in instructions

def if_skip_line(line):
    if line is None:
        print("invalid instruction set")
        exit()
    line = line.strip()
    return len(line) == 0 or line[0] == '#'


def parse_code_file(file):
    global instruction_memory
    line = file.readline()
    code_start_index = 0
    instruction_number = 0
    while line:

        # skip comments or empty lines
        if if_skip_line(line):
            line = file.readline()
            continue
        line = line.strip()
        parts = re.split(r'[-\(\),\s]\s*', line)
        # check org instruction
        if parts[0] is not None and parts[0].lower() == ".org":
            index = parts[1]
            # get next line containing value to insert in memory
            line = file.readline()

            while if_skip_line(line):
                line = file.readline()

            # check validty of line value
            line = line.strip()

            pattern = re.compile(r"^\w+$")
            if pattern.search(line) and not is_instruction(line):
                new_value = f'{int(line, 16):032b}'
                replace_memory_cell_value(
                    index=index, new_value=new_value, write32=True)
                line = file.readline()
                continue
            else:
                code_start_index = int(index, 16)
                instruction_number = 0
                continue
        with_offset = False
        offset_val = ""
        opcode = ""
        rsrc1 = ""
        rsrc2 = ""
        rdst = ""
        if parts[0] is not None and parts[0].lower() == "nop":
            opcode = "00000"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif parts[0] is not None and parts[0].lower() == "hlt":
            opcode = "00001"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif parts[0] is not None and parts[0].lower() == "setc":
            opcode = "00010"
            rsrc1 = "000"
            rsrc2 = "000"
            rdst = "000"
        elif parts[0] is not None and parts[0].lower() == "not":
            opcode = "00011"
            rsrc1 = parse_register_name(parts[1])
            rsrc2 = rsrc1
            rdst = rsrc2
        elif parts[0] is not None and parts[0].lower() == "inc":
            opcode = "00100"
            rsrc1 = parse_register_name(parts[1])
            rsrc2 = rsrc1
            rdst = rsrc1
        elif parts[0] is not None and parts[0].lower() == "out":
            opcode = "00101"
            rsrc1 = parse_register_name(parts[1])
            rsrc2 = rsrc1
            rdst = rsrc1
        elif parts[0] is not None and parts[0].lower() == "in":
            opcode = "00110"
            rdst = parse_register_name(parts[1])
            rsrc1 = rdst
            rsrc2 = rdst
# ======= Two Operands========================================
        elif parts[0] is not None and parts[0].lower() == "mov":
            opcode = "01000"
            rsrc1 = parse_register_name(parts[1])
            rsrc2 = rsrc1
            rdst = parse_register_name(parts[2])
        elif parts[0] is not None and parts[0].lower() == "add":
            opcode = "01001"
            rdst = parse_register_name(parts[1])
            rsrc1 = parse_register_name(parts[2])
            rsrc2 = parse_register_name(parts[3])
        elif parts[0] is not None and parts[0].lower() == "sub":
            opcode = "01010"
            rdst = parse_register_name(parts[1])
            rsrc1 = parse_register_name(parts[2])
            rsrc2 = parse_register_name(parts[3])
        elif parts[0] is not None and parts[0].lower() == "and":
            opcode = "01011"
            rdst = parse_register_name(parts[1])
            rsrc1 = parse_register_name(parts[2])
            rsrc2 = parse_register_name(parts[3])
        elif parts[0] is not None and parts[0].lower() == "iadd":
            opcode = "01100"
            with_offset = True
            rdst = parse_register_name(parts[1])
            rsrc1 = parse_register_name(parts[2])
            rsrc2 = rsrc1
            offset_val = parts[3]
# ======= Memory Operations========================================
        elif parts[0] is not None and parts[0].lower() == "push":
            opcode = "10000"
            rsrc1 = parse_register_name(parts[1])
            rsrc2 = rsrc1
            rdst = rsrc1
        elif parts[0] is not None and parts[0].lower() == "pop":
            opcode = "10001"
            rsrc1 = parse_register_name(parts[1])
            rsrc2 = rsrc1
            rdst = rsrc1
        elif parts[0] is not None and parts[0].lower() == "ldm":
            opcode = "10010"
            with_offset = True
            offset_val = parts[2]
            rdst = parse_register_name(parts[1])
            rsrc1 = rdst
            rsrc2 = rdst
        elif parts[0] is not None and parts[0].lower() == "ldd":
            opcode = "10011"
            with_offset = True
            rdst = parse_register_name(parts[1])
            offset_val = parts[2]
            rsrc1 = parse_register_name(parts[3])
            rsrc2 = rsrc1
        elif parts[0] is not None and parts[0].lower() == "std":
            opcode = "10100"
            with_offset = True
            rsrc1 = parse_register_name(parts[1])
            rdst = rsrc1
            offset_val = parts[2]
            rsrc2 = parse_register_name(parts[3])
# ======= Branch and Change of Control Operations========================================
        elif parts[0] is not None and parts[0].lower() == "jz":
            opcode = "11000"
            rdst = parse_register_name(parts[1])
            rsrc1 = rdst
            rsrc2 = rdst
        elif parts[0] is not None and parts[0].lower() == "jn":
            opcode = "11001"
            rdst = parse_register_name(parts[1])
            rsrc1 = rdst
            rsrc2 = rdst
        elif parts[0] is not None and parts[0].lower() == "jc":
            opcode = "11010"
            rdst = parse_register_name(parts[1])
            rsrc1 = rdst
            rsrc2 = rdst
        elif parts[0] is not None and parts[0].lower() == "jmp":
            opcode = "11011"
            rdst = parse_register_name(parts[1])
            rsrc1 = rdst
            rsrc2 = rdst
        elif parts[0] is not None and parts[0].lower() == "call":
            opcode = "11100"
            rdst = parse_register_name(parts[1])
            rsrc1 = rdst
            rsrc2 = rdst
        elif parts[0] is not None and parts[0].lower() == "ret":
            opcode = "11101"
            rdst = "000"
            rsrc1 = rdst
            rsrc2 = rdst
        elif parts[0] is not None and parts[0].lower() == "int":
            opcode = "11110"
            with_offset = True
            offset_val = parts[1]
            rdst = "000"
            rsrc1 = rdst
            rsrc2 = rdst
        elif parts[0] is not None and parts[0].lower() == "rti":
            opcode = "11111"
            rdst = "000"
            rsrc1 = rdst
            rsrc2 = rdst

# ================== Write decoded instruction ==============
        decoded_instruction = f'{opcode}{rsrc1}{rsrc2}{rdst}{1 if with_offset else 0}0'
        instruction_index = instruction_number + code_start_index
        if with_offset:
            decoded_instruction += f'{int(offset_val, 16):016b}'
            instruction_number += 1
        instruction_number += 1
        replace_memory_cell_value(
            index=hex(instruction_index)[2:], new_value=decoded_instruction, write32=with_offset)

        line = file.readline()

    file.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Assembler to decode .asm files and output .mem file to fill modelsim memory module')
    parser.add_argument("code_file", help="path to .asm file to be decoded")
    args = parser.parse_args()
    try:
        instruction_memory = read_instrcution_memory_file(
        filename='.\Assembler\instruction_memory_template.mem')
    except Exception as e:
        print(e)
        exit()

    try:
        file = read_code_file(filename=args.code_file.split("=")[1])
    except Exception as e:
        print(e)
        exit()
    try:
        parse_code_file(file)
    except Exception as e:
        print('Couldn\'t parse code file')
        print(e)
        exit()
    try:
        regenrate_instruction_memory_file(
        filename='instruction_memory.mem', lines=instruction_memory)
        print("memory file generated successfully")
    except Exception as e:
        print(e)