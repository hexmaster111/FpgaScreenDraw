#include <stdio.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "obj_dir/VFPGAScreenDraw.h"
#include "obj_dir/VFPGAScreenDraw___024root.h"

#define RUNTIME (5000000)

int main(int argc, char *argv[])
{
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VFPGAScreenDraw *m_dut = new VFPGAScreenDraw;
	VerilatedVcdC *m_trace = new VerilatedVcdC;

	m_dut->trace(m_trace, 5);
	m_trace->open("waveform.vcd");

	for (size_t i = 0; i < RUNTIME; i++)
	{
		m_dut->eval();
		m_trace->dump(i);
		m_dut->clk = !m_dut->clk;
	}

	m_trace->close();

	delete m_dut;
	delete m_trace;
	return 0;
}
