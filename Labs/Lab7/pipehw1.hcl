########## the PC and condition codes registers #############
register pP { pc:64 = 0; }
register cC { 
    SF:1 = 0;
    ZF:1 = 1;
}
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
	dstE:4 = REG_NONE;
	valA:64 = 0;
	valB:64 = 0;
	valC:64 = 0;
	srcA:4 = REG_NONE;
	srcB:4 = REG_NONE;
	Stat:3 = STAT_AOK;
}
register eM {
	icode:4 = NOP;
	dstE:4 = REG_NONE;
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
	dstE:4 = REG_NONE;
	valA:64 = 0;
	valB:64 = 0;
	valC:64 = 0;
	valE:64 = 0;
	Stat:3 = STAT_AOK;
}


########## Fetch #############
pc = P_pc;

f_icode = i10bytes[4..8];
f_ifun = i10bytes[0..4];
wire need_regs:1, need_immediate:1;

need_regs = f_icode in {RRMOVQ, IRMOVQ, OPQ, CMOVXX};
need_immediate = f_icode in {IRMOVQ};

f_rA = [
	need_regs: i10bytes[12..16];
	1: REG_NONE;
];
f_rB = [
	need_regs: i10bytes[8..12];
	1: REG_NONE;
];
f_valC = [
	need_immediate && need_regs : i10bytes[16..80];
	need_immediate : i10bytes[8..72];
	1 : 0;
];

# new PC (assuming there is no jump)
wire valP:64;
valP = [
	need_immediate && need_regs : pc + 10;
	need_immediate : pc + 9;
	need_regs : pc + 2;
	1 : pc + 1;
];

# pc register update
p_pc = [
	1 : valP;
];
f_Stat = [
	f_icode == HALT : STAT_HLT;
	f_icode in {NOP, RRMOVQ, IRMOVQ, OPQ, CMOVXX} : STAT_AOK;
	1 : STAT_INS;
];
stall_P = f_Stat != STAT_AOK; # so that we see the same final PC as the yis tool



########## Decode #############
d_icode = D_icode;
d_ifun = D_ifun;
d_valC = D_valC;

d_Stat = D_Stat;

# source selection
reg_srcA = [
	D_icode in {RRMOVQ, OPQ, CMOVXX} : D_rA;
	1 : REG_NONE;
];
d_srcA = reg_srcA;

reg_srcB = [
	D_icode in {OPQ} : D_rB;
	1 : REG_NONE;
];
d_srcB = reg_srcB;

# destination selection
d_dstE = [
	D_icode in {IRMOVQ, RRMOVQ, OPQ, CMOVXX} : D_rB;
	1 : REG_NONE;
];

//forwarding value
d_valA = [
	(d_srcA != REG_NONE) && (d_srcA == e_dstE) : e_valE;
	//has to forward from the Execute stage first it will be the newest value
	
	(d_srcA != REG_NONE) && (d_srcA == m_dstE) : m_valE;
	//if Execute stage is not involving the value of the register, then
	//we forward from the Memory stage which involves the register value
	
	((d_srcA != REG_NONE) && (d_srcA == reg_dstE)) : reg_inputE;
	//if non of the current execute stage nor memory stage involves this
	//value, we forward from the write back stage which involves the 
	//register value.
	
	1 : reg_outputA;
	//if no operations in the last 3 cycles involves the register value
	//we read directly from register file output
	
	
	/*
	eg:
	irmovq 1, rax	 F	D	E	M	W
	irmovq 2, rax		F	D	E	M	W
	addq   rax, rax			F	D	E	M	W
	rrmovq rax, rbx				F	D	E	M	W
	
	we want the last instruction rrmovq to read a newest rax into 
	decode stage valA.
	So the strategy is to look at the fifth cycle where rrmovq is 
	at decode. We first check the stage above, which is the Execute
	stage of addq, we see that the addq is actually writing a new
	value into rax, so we want to forward that value to rrmovq decode
	stage. We check the condition d_srcA == e_dstE satisfies, and then
	use the value to write in execute stage e_valE, which is the new
	rax value, to replace the d_valA in rrmovq
	
	Now suppose addq rax, rcx instead of addq rax,rax
	which means we have to forward rax value from irmovq 2, rax now
	and irmovq 2, rax is in memory stage, so we check the condition
	d_srcA == m_dstE satisfies, and use the input value for irmovq m_valE
	to forward to d_valA.
	Note that for different instructions, the forwarded value could 
	be different. Eg. for irmovq, we need the valC instead of valE
	Eg. for rrmovq, we need valA instead of valE and valC.
	For simplicity, I just let valE = valC
	for irmovq, and valE = valA for rrmovq
	
	now suppose that irmovq 2, rsi instead of irmovq 2, rax
	which means we have to forward rax value from irmovq 1, rax now
	and irmovq 1, rax is in write back stage, so we forward the
	value to write back reg_inputE to d_valA
	
	*/
];
d_valB = [
	(d_srcB != REG_NONE) && (d_srcB == e_dstE) : e_valE;
	(d_srcB != REG_NONE) && (d_srcB == m_dstE) : m_valE;
	((d_srcB != REG_NONE) && (d_srcB == reg_dstE)) : reg_inputE;
	1 : reg_outputB;
];


########## Execute #############
e_icode = E_icode;
e_Stat = E_Stat;
e_valC = E_valC;
e_srcA = E_srcA;
e_srcB = E_srcB;
e_valA = [
	//we dont need forwarding here since all forwarding is done in decode stage
	//(e_srcA != REG_NONE) && (e_srcA == m_dstE) : m_valE;
	//(e_srcA != REG_NONE) && (e_srcA == reg_dstE) : reg_inputE;
	1 : E_valA;
];
e_valB = [
//we dont need forwarding here since all forwarding is done in decode stage
	//(e_srcB != REG_NONE) && (e_srcB == m_dstE) : m_valE;
	//(e_srcB != REG_NONE) && (e_srcB == reg_dstE) : reg_inputE;
	1 : E_valB;
];

e_valE = [
	E_icode == OPQ && E_ifun == XORQ : e_valA ^ e_valB;
	E_icode == OPQ && E_ifun == ANDQ : e_valA & e_valB;
	E_icode == OPQ && E_ifun == ADDQ : e_valA + e_valB;
	E_icode == OPQ && E_ifun == SUBQ : e_valB - e_valA;
	E_icode == IRMOVQ : e_valC;
	E_icode == RRMOVQ : e_valA;
	1 : 0;
];

wire conditionsNotMet: 1, isRRmovq:1, iscmovXX:1, isJXX:1;
isRRmovq = E_icode == RRMOVQ && E_ifun == 0;
iscmovXX = E_icode == CMOVXX && E_ifun != 0;
isJXX	 = E_icode == JXX;
conditionsNotMet = 
	(iscmovXX && E_ifun == LE && !C_SF && !C_ZF) ||
	(iscmovXX && E_ifun == GE && C_SF) ||
	(iscmovXX && E_ifun == 3  && !C_ZF ) || # E not defined, use 3
	(iscmovXX && E_ifun == 6  && (C_SF || C_ZF)) ||	# G -- 6
	(iscmovXX && E_ifun == 2  && !C_SF) ||		# L -- 2
	(iscmovXX && E_ifun == NE && C_ZF);
e_dstE = [
	conditionsNotMet : REG_NONE;
	1 :	E_dstE;
];

stall_C = (E_icode != OPQ);
c_ZF = (e_valE == 0);
c_SF = (e_valE >= 0x8000000000000000);

########## Memory #############
m_icode = M_icode;

m_valC = M_valC;
m_valE = M_valE;
m_valA = [
	//we dont need forwarding here since all forwarding is done in decode stage
	//(M_srcA != REG_NONE) && (M_srcA == reg_dstE) : reg_inputE;
	1:M_valA;
];
m_valB = [
	//we dont need forwarding here since all forwarding is done in decode stage
	//(M_srcB != REG_NONE) && (M_srcB == reg_dstE) : reg_inputE;
	1 : M_valB;
];

m_dstE = M_dstE;
m_Stat = M_Stat;


########## Writeback #############


reg_inputE = [ # unlike book, we handle the "forwarding" actions (something + 0) here
	W_icode == RRMOVQ : W_valA;
	W_icode in {IRMOVQ} : W_valC;
	W_icode in {OPQ} : W_valE;
];

reg_dstE = [
	1: W_dstE;
];


########## PC and Status updates #############

Stat = W_Stat;


