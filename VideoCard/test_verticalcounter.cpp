

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "obj_dir/VVerticalCounter.h"
#include "obj_dir/VVerticalCounter___024root.h"

#define RUNTIME (5000)

int main(int argc, char *argv[])
{
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VVerticalCounter *m_dut = new VVerticalCounter;
	VerilatedVcdC *m_trace = new VerilatedVcdC;

	m_dut->trace(m_trace, 5);
	m_trace->open("waveform.vcd");

	for (size_t i = 0; i < RUNTIME; i++)
	{
		m_dut->eval();
		m_trace->dump(i);
		m_dut->i_n_reset = i < .1 * RUNTIME ? 0 : 1;
		m_dut->i_pixelClock = !m_dut->i_pixelClock;

		if(i == 300) m_dut->i_enable = 1;
		if(i == 302) m_dut->i_enable = 0;
	
		if(i == 700) m_dut->i_enable = 1;
		if(i == 702) m_dut->i_enable = 0;
	
		if(i == 1000) m_dut->i_enable = 1;
		if(i == 1002) m_dut->i_enable = 0;
	}

	m_trace->close();

	delete m_dut;
	delete m_trace;
}
