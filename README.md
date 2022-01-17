# MIPS Processor(Harvard Architecture)

<div>

 <img src="./images/cpu.png" align="left" width="200" style="padding-right:30px">

  [![Star on GitHub](https://img.shields.io/github/stars/Passant-Abdelgalil/MIPS-Processor-Harvard-Architecture.svg?style=social)]("https://github.com/Passant-Abdelgalil/MIPS-Processor-Harvard-Architecture/stargazers")
    [![Fork on GitHub](https://img.shields.io/github/forks/Passant-Abdelgalil/MIPS-Processor-Harvard-Architecture.svg?style=social)]("https://github.com/Passant-Abdelgalil/MIPS-Processor-Harvard-Architecture/network/members")
 [![Watch on GitHub](https://img.shields.io/github/watchers/Passant-Abdelgalil/MIPS-Processor-Harvard-Architecture?style=social)]("https://github.com/Passant-Abdelgalil/MIPS-Processor-Harvard-Architecture/watchers")

<h4>A Simple 5-stage 32-bit pipelined processor with Harvard architecture and a RISC-like instruction set architecture. <br/>
 <br/>
In addition to an assembler to decode assembly code files to fill the instruction memory with the right data </h4>
</div>

<br><br>

## ⚙ ISA Specifications

<ol>
  <li>
<b>Registers:</b><br/>
<ul>
  <li><b>R[0:7]</b>: Eight <b>16-bit</b> general purpose registers</li>
  <li><b>PC</b>: <b>32-bit</b> program counter register</li>
  <li><b>SP</b>: <b>32-bit</b> Stack Pointer register</li>
  <li><b>EPC</b>: <b>32-bit</b> Exception Program Counter register</li>
  <li><b>CCR</b>: Condition Code Register
    <ul>
      <li>Z: zero flag</li>
      <li>N: negative flag</li>
      <li>C: carry flag</li>
    </ul>
  </li>
</ul>
</li>
    <li>
      <b>Ports:</b><br/>
      <ul>
        <li><b>IN</b> port: <b>16-bit</b> data input port</li>
        <li><b>OUT</b> port: <b>16-bit</b> data output port</li>
      </ul>
</li>
   </ol>

### 📋 Instruction Set
| One Operand Instructions | Two Operand Instructions  |  Memory Instructions |  Branch Instructions |
|---|---|---|---|
| NOP  |  MOV Rsrc, Rdst |  PUSH Rsrc |  JZ Rdst |
| HLT  | ADD Rdst, Rsrc1, Rsrc2  |  POP Rdst |  JC Rdst |
|  SETC |SUB Rdst, Rsrc1, Rsrc2   | LDM Rdst, Imm  | JN Rdst  |
|  NOT Rdst| AND Rdst, Rsrc1, Rsrc2  | LDD Rdst, offset(Rsrc)  | JMP Rdst  |
|  INC Rdst|  IADD Rdst, Rsrc1, Imm | STD Rsrc1, offset(Rsrc2)  | CALL Rdst  |
|  OUT Rsrc | -  | -  | RET  (for call)|
|  IN Rdst |   - | -  |  INT index |
| - |  - | -  |  RTI (for interrupt)|

### Instruction
| 5-bit Opcode | 3-bit src1 register address |  3-bit src2 register address |  3-bit dst register address | 1-bit for hlt |  1-bit (not yet used) | 16-bit offset|
|---|---|---|---|---|---|---|

## 🎗 Features

- reset signal

- Successful hazards detection and handling (using full forwarding)

- Successful Interrupts calling

- Successful Exceptions handling
  
  - Exception 1: empty stack
  
  - Exception 2: invalid addess  
  
## 🔄 Pipeline Stages

<div>
<ul>
<li>
<h3> 1️⃣ <b>Fetch Stage</b></h3>
<img src="./images/fetch_stage.png" width=70% height=650 alt="fetch stage schematic"/>
</li>
<br>

<li>
<h3> 2️⃣ <b>Decode Stage</b></h3>
<img src="./images/decode_stage.png" width=70% height=650 alt="decode stage schematic"/>
</li>

<li>
<h3> 2️⃣ <b>Execute Stage</b></h3>
<img src="./images/execute_stage.png" width=70% height=650 alt="decode stage schematic"/>
</li>
</ul>
</div>

## Run
1. cd to where you want to clone the repo
2. run `git clone https://github.com/Passant-Abdelgalil/MIPS-Processor-Harvard-Architecture.git`
3. run `cd MIPS-Processor-Harvard-Architecture`
4. to run the assembler with your file, run `python ./Assembler/assembler.py code_file="./Test_Cases/branch_code.asm"`
5. Create a project in modelsim, [Tutorial](https://www.nandland.com/vhdl/tutorials/tutorial-modelsim-simulation-walkthrough.html)
6. To run Do files, in the transcript window run `do ./Do_files/<do file name you want to run>`
7. Or start your own simulation :)

 <h2> <img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/apple/285/military-medal_1f396-fe0f.png" width=45px  alt="" align="center"/> Contributors  
 </h2>

<div align="center">
<table>
  <tr>
    <td align="center"><a href="https://github.com/mohamed99akram"><img src="https://avatars.githubusercontent.com/u/69890013?v=4" width="100px;" alt=""/><br /><sub><b>Mohamed Akram</b></sub></a><br/>
    </td>
    <td align="center"><a href="https://github.com/Passant-Abdelgalil"><img src="https://avatars.githubusercontent.com/u/69261710?v=4" width="100px;" alt=""/><br /><sub><b>Passant Abdelgalil</b></sub></a><br />
    </td><td align="center"><a href="https://github.com/mariamashraf00"><img src="https://avatars.githubusercontent.com/u/80390555?v=4" width="100px;" alt=""/><br /><sub><b>Mariam Ashraf</b></sub></a><br />
    </td><td align="center"><a href="https://github.com/esraagamal23"><img src="https://avatars.githubusercontent.com/u/69439108?v=4" width="100px;" alt=""/><br /><sub><b>Esraa Gamal</b></sub></a><br />
    </td>
    </tr>
  </table>
</div>
