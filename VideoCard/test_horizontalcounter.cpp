

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "obj_dir/VHorizontalCounter.h"
#include "obj_dir/VHorizontalCounter___024root.h"

#define RUNTIME (5000)

int main(int argc, char *argv[])
{
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VHorizontalCounter *m_dut = new VHorizontalCounter;
	VerilatedVcdC *m_trace = new VerilatedVcdC;

	m_dut->trace(m_trace, 5);
	m_trace->open("waveform.vcd");

	for (size_t i = 0; i < RUNTIME; i++)
	{
		m_dut->eval();
		m_trace->dump(i);
		m_dut->i_n_reset = i < .1 * RUNTIME ? 0 : 1;
		m_dut->i_pixelClock = !m_dut->i_pixelClock;
	}

	m_trace->close();

	delete m_dut;
	delete m_trace;
}
