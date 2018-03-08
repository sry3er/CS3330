# -*-sh-*- # this line enables partial syntax highlighting in emacs

######### The PC #############
register xF { pc:64 = 0; }
register fD {
	icode:4 = NOP;
	ifun :4 = 0;
	valC:64 = 0;
    rA:4 = REG_NONE;
    rB:4 = REG_NONE;
	Stat:3 = STAT_AOK;
}
register dE {
	icode:4 = NOP;
	ifun :4 = 0;
	dstM:4 = REG_NONE;
	valA:64 = 0;
	valB:64 = 0;
	valC:64 = 0;
	srcA:4 = REG_NONE;
	srcB:4 = REG_NONE;
	Stat:3 = STAT_AOK;
}
register eM {
	icode:4 = NOP;
	dstM:4 = REG_NONE;
	valA:64 = 0;
	valB:64 = 0;
	valC:64 = 0;
	valE:64 = 0;
	srcA:4 = REG_NONE;
	srcB:4 = REG_NONE;
	Stat:3 = STAT_AOK;
}
register mW {
	icode:4 = NOP;
	dstM:4 = REG_NONE;
	valA:64 = 0;
	valB:64 = 0;
	valC:64 = 0;
	valE:64 = 0;
	valM:64 = 0;
	Stat:3 = STAT_AOK;
}
########## Fetch #############
pc = F_pc;

wire loadUse:1;
loadUse = (E_icode == MRMOVQ && (E_dstM == d_srcA || E_dstM == d_srcB));

stall_F = loadUse;
f_icode = i10bytes[4..8];
f_ifun = i10bytes[0..4];
f_rA = i10bytes[12..16];
f_rB = i10bytes[8..12];

f_valC = [
	f_icode in { JXX } : i10bytes[8..72];
	1 : i10bytes[16..80];
];

wire offset:64, valP:64;
offset = [
	f_icode in { HALT, NOP, RET } : 1;
	f_icode in { RRMOVQ, OPQ, PUSHQ, POPQ } : 2;
	f_icode in { JXX, CALL } : 9;
	1 : 10;
];
valP = F_pc + offset;
f_Stat = [
	f_icode == HALT : STAT_HLT;
	f_icode > 0xb : STAT_INS;
	x_pc > 0xfff : STAT_ADR;
	1 : STAT_AOK;
];

########## Decode #############
stall_D = loadUse;


d_icode = D_icode;
d_ifun = D_ifun;
d_valC = D_valC;

d_Stat = D_Stat;

reg_srcA = [
	D_icode in {RMMOVQ} : D_rA;
	1 : REG_NONE;
];
reg_srcB = [
	D_icode in {RMMOVQ, MRMOVQ} : D_rB;
	1 : REG_NONE;
];
d_dstM = [ 
	D_icode in {MRMOVQ} : D_rA;
	1: REG_NONE;
];

d_valA = [
	reg_srcA == REG_NONE : 0;
	reg_srcA == m_dstM : m_valM;
	reg_srcA == W_dstM : W_valM;
	1 : reg_outputA;
];
d_valB = [
	reg_srcB == REG_NONE : 0;
	reg_srcB == m_dstM : m_valM;
	reg_srcB == W_dstM : W_valM;
	1 : reg_outputB;
];

d_srcA = reg_srcA;
d_srcB = reg_srcB;

########## Execute #############

bubble_E = loadUse;

e_icode = E_icode;
e_Stat = E_Stat;
e_dstM = E_dstM;
e_valC = E_valC;
e_srcA = E_srcA;
e_srcB = E_srcB;
e_valA = E_valA;
e_valB = E_valB;

wire operand1:64, operand2:64;

operand1 = [
	e_icode in { MRMOVQ, RMMOVQ } : e_valC;
	1: 0;
];
operand2 = [
	e_icode in { MRMOVQ, RMMOVQ } : e_valB;
	1: 0;
];

e_valE = [
	E_icode in { MRMOVQ, RMMOVQ } : operand1 + operand2;
	1 : 0;
];



########## Memory #############
m_icode = M_icode;

m_valC = M_valC;
m_valE = M_valE;
m_valA = M_valA;
m_valB = M_valB;

m_dstM = M_dstM;
m_Stat = M_Stat;

mem_readbit = m_icode in { MRMOVQ };
mem_writebit = m_icode in { RMMOVQ };
mem_addr = [
	m_icode in { MRMOVQ, RMMOVQ } : m_valE;
];
mem_input = [
	m_icode in { RMMOVQ } : m_valA;
];
m_valM = [
	m_icode in {MRMOVQ} : mem_output;
	1 : 0;
];
########## Writeback #############

reg_dstM = W_dstM;
reg_inputM = [
	W_icode in {MRMOVQ} : W_valM;
];


Stat = W_Stat;

x_pc = valP;


