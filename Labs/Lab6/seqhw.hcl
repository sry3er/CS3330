# An example file in our custom HCL variant, with lots of comments

register pP {  
    # our own internal register. P_pc is its output, p_pc is its input.
	pc:64 = 0; # 64-bits wide; 0 is its default value.
	
	# we could add other registers to the P register bank
	# register bank should be a lower-case letter and an upper-case letter, in that order.
	
	# there are also two other signals we can optionally use:
	# "bubble_P = true" resets every register in P to its default value
	# "stall_P = true" causes P_pc not to change, ignoring p_pc's value
} 

# condition codes for seqlab
register cC {
    SF:1 = 0;
    ZF:1 = 1;
}

# "pc" is a pre-defined input to the instruction memory and is the 
# address to fetch 6 bytes from (into pre-defined output "i10bytes").
pc = P_pc;



/* we could also have done i10bytes[4..8] directly, but I wanted to
 * demonstrate more bit slicing... and all 3 kinds of comments      */
// this is the third kind of comment

# named constants can help make code readable
const TOO_BIG = 0xC; # the first unused icode in Y86-64

# some named constants are built-in: the icodes, ifuns, STAT_??? and REG_???

# Stat is a built-in output; STAT_HLT means "stop", STAT_AOK means 
# "continue".  The following uses the mux syntax described in the 
# textbook
Stat = [
	icode == HALT		: STAT_HLT;
	icode >= TOO_BIG	: STAT_INS;
	icode == NOP		: STAT_AOK;
	icode == RRMOVQ		: STAT_AOK;
	icode == RMMOVQ		: STAT_AOK;
	icode == MRMOVQ		: STAT_AOK;
	icode == IRMOVQ		: STAT_AOK;
	icode == OPQ		: STAT_AOK;
	icode == JXX		: STAT_AOK;
	icode == CMOVXX		: STAT_AOK;
	icode == CALL		: STAT_AOK;
	icode == RET		: STAT_AOK;
	icode == PUSHQ		: STAT_AOK;
	icode == POPQ		: STAT_AOK;
	1           		: STAT_INS;
];


// Fetching


# we can define our own input/output "wires" of any number of 0<bits<=80
wire opcode:8, icode:4, ifun:4;

# the x[i..j] means "just the bits between i and j".  x[0..1] is the 
# low-order bit, similar to what the c code "x&1" does; "x&7" is x[0..3]

opcode = i10bytes[0..8];   # first byte read from instruction memory
icode = opcode[4..8];      # top nibble of that byte
ifun = opcode[0..4];  

wire rA:4, rB:4, valC:64, valE:64;
rA = [
	icode == RRMOVQ : i10bytes[12..16];
	icode == OPQ	: i10bytes[12..16];
	icode == CMOVXX	: i10bytes[12..16];
	icode == RMMOVQ : i10bytes[12..16];
	icode == MRMOVQ : i10bytes[8..12];
	icode == PUSHQ  : i10bytes[12..16];
	icode == POPQ   : i10bytes[12..16];
	icode == CALL   : REG_RSP;
	icode == RET    : REG_RSP;
	1				: REG_NONE;
];
rB =  [
	icode == IRMOVQ : i10bytes[8..12];
	icode == RRMOVQ : i10bytes[8..12];
	icode == OPQ	: i10bytes[8..12];
	icode == CMOVXX	: i10bytes[8..12];
	icode == RMMOVQ	: i10bytes[8..12];
	icode == MRMOVQ	: i10bytes[12..16];
	icode == PUSHQ  : REG_RSP;
	icode == POPQ   : REG_RSP;
	1				: REG_NONE;
];
valC = [
	icode == IRMOVQ : i10bytes[16..80];
	icode == JXX    : i10bytes[8..72];
	icode == RMMOVQ : i10bytes[16..80];
	icode == MRMOVQ : i10bytes[16..80];
	icode == CALL   : i10bytes[8..72];
	1 : 0;
];

# deal with JXX, RRmovq and cmovXX, set conditionsMet

wire conditionsMet:1, isRRmovq:1, iscmovXX:1, isJXX:1;
isRRmovq = icode == RRMOVQ && ifun == 0;
iscmovXX = icode == CMOVXX && ifun != 0;
isJXX	 = icode == JXX;
conditionsMet = [
	iscmovXX && ifun == LE : C_SF || C_ZF;
	iscmovXX && ifun == GE : (0==C_SF) || C_ZF;
	iscmovXX && ifun == 3  : C_ZF;    # E not defined, use 3
	iscmovXX && ifun == 6  : (0==C_SF) && (0==C_ZF);	# G -- 6
	iscmovXX && ifun == 2  : C_SF;						# L -- 2
	iscmovXX && ifun == NE : 0==C_ZF;
	isJXX	 && ifun == LE : C_SF || C_ZF;
	isJXX	 && ifun == GE : (0==C_SF) || C_ZF;
	isJXX	 && ifun == 3  : C_ZF;  					# E -- 3
	isJXX	 && ifun == 6  : (0==C_SF) && (0==C_ZF);	# G -- 6
	isJXX	 && ifun == 2  : C_SF;						# L -- 2
	isJXX	 && ifun == NE : 0==C_ZF;
	isJXX	 && ifun == 0  : 1;			# jmp
	1					   : 0; 
];


wire valP:64;

valP = [
	icode == HALT 		: P_pc + 1; # you may use math ops directly...
	icode == NOP 		: P_pc + 1; 
	icode == RRMOVQ  	: P_pc + 2;
	icode == OPQ  		: P_pc + 2;
	icode == CMOVXX  	: P_pc + 2;
	icode == PUSHQ  	: P_pc + 2;
	icode == POPQ  		: P_pc + 2;
	icode == IRMOVQ 	: P_pc + 10;
	icode == MRMOVQ 	: P_pc + 10;
	icode == RMMOVQ 	: P_pc + 10;
	icode == JXX && conditionsMet   	: valC;
	icode == JXX && (0==conditionsMet)	: P_pc + 9;
	icode == CALL    	: valC;
	icode == RET    	: mem_output;
];


// Fetching end


// Decoding

reg_srcA = [
	icode == RRMOVQ : rA;
	icode == CMOVXX : rA;
	icode == OPQ	: rA;
	icode == RMMOVQ : rA;
	icode == MRMOVQ : rA;
	icode == PUSHQ  : rA;
	icode == POPQ   : rB;
	icode == CALL   : rA;
	icode == RET    : rA;
	1				: REG_NONE;
];

reg_srcB = [
	icode == OPQ	: rB;
	icode == RMMOVQ	: rB;
	icode == MRMOVQ	: rB;
	icode == PUSHQ  : rB;
	1				: REG_NONE;
];

// Decoding end

// Executing

# ALU to compute valE
valE = [
	icode == OPQ && ifun == XORQ : reg_outputA ^ reg_outputB;
	icode == OPQ && ifun == ANDQ : reg_outputA & reg_outputB;
	icode == OPQ && ifun == ADDQ : reg_outputA + reg_outputB;
	icode == OPQ && ifun == SUBQ : reg_outputB - reg_outputA;
	icode == CMOVXX              : reg_outputA;
	icode == RMMOVQ				 : reg_outputB + valC;
	icode == MRMOVQ				 : reg_outputA + valC;
	icode == PUSHQ				 : reg_outputB - 8;
	icode == POPQ				 : reg_outputA + 8;
	icode == CALL				 : reg_outputA - 8;
	icode == RET 				 : reg_outputA + 8;
];

# set condition codes

stall_C = (icode != OPQ);
c_ZF = (valE == 0);
c_SF = (valE >= 0x8000000000000000);


// Executing end

// Memory

mem_addr = [
	icode == RMMOVQ : valE;
	icode == MRMOVQ : valE;
	icode == PUSHQ  : valE;
	icode == POPQ   : reg_outputA;
	icode == CALL   : valE;
	icode == RET    : reg_outputA;
];

mem_readbit = [
	icode == RMMOVQ : 0;
	icode == MRMOVQ : 1;
	icode == PUSHQ  : 0;
	icode == POPQ	: 1;
	icode == CALL   : 0;
	icode == RET	: 1;
	1				: 0;
];

mem_writebit = [
	icode == RMMOVQ : 1;
	icode == MRMOVQ : 0;
	icode == PUSHQ  : 1;
	icode == POPQ	: 0;
	icode == CALL   : 1;
	icode == RET	: 0;
	1				: 0;
];

mem_input = [
	icode == RMMOVQ : reg_outputA;
	icode == PUSHQ  : reg_outputA;
	icode == CALL   : P_pc + 9;
];

wire valM:64;
valM = [
	icode == MRMOVQ : mem_output;
	icode == POPQ   : mem_output;
	icode == RET    : mem_output;
	1				: 0;
];

// Memory end


// Writing back

reg_dstE = [
	icode == IRMOVQ 			: rB;
	icode == OPQ 				: rB;
	isRRmovq					: rB;
	iscmovXX && conditionsMet	: rB;
	icode == MRMOVQ				: rB;
	icode == PUSHQ				: rB;
	icode == POPQ	        	: rA;
	icode == CALL				: rA;
	icode == RET				: rA;
	1							: REG_NONE;
];

reg_dstM = [
	icode == POPQ && rA!=REG_RSP: rB;
	1							: REG_NONE;
];

# and a value to write.  Let's decide what to do based on the ifun
reg_inputE = [
	icode == IRMOVQ : valC;
	icode == RRMOVQ : reg_outputA;	
	icode == OPQ	: valE;
	icode == CMOVXX	: valE;
	icode == MRMOVQ : valM;
	icode == PUSHQ	: valE;
	icode == POPQ	: valM;
	icode == CALL	: valE;
	icode == RET	: valE;
];

reg_inputM = [
	icode == POPQ	: valE;
];

// Writing back end


# to make progress, we have to update the PC...
p_pc = valP;