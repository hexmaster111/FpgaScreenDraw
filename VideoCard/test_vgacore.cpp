#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "obj_dir/VVgaCore.h"
#include "obj_dir/VVgaCore___024root.h"

#define RUNTIME (50000000)

int main(int argc, char *argv[])
{
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VVgaCore *m_dut = new VVgaCore;
	VerilatedVcdC *m_trace = new VerilatedVcdC;

	m_dut->trace(m_trace, 5);
	m_trace->open("waveform.vcd");

	printf("Generating for %lu steps\n", RUNTIME);

	for (size_t i = 0; i < RUNTIME; i++)
	{
		if ((i % 50000) == 0)
		{
			printf("On step %d of %lu\n", i, RUNTIME);
		}

		m_dut->eval();
		m_trace->dump(i);

		m_dut->i_n_reset = i < .01 * RUNTIME ? 0 : 1;
		m_dut->i_clk_50mhz = !m_dut->i_clk_50mhz;
	}
	printf("Simulation Compleate\n", RUNTIME);


	m_trace->close();

	delete m_dut;
	delete m_trace;
}
