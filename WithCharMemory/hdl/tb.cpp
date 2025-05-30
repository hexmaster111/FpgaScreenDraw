#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "obj_dir/VWithCharMemory.h"
#include "obj_dir/VWithCharMemory___024root.h"

#define GRAPHICAL_TB

#ifdef GRAPHICAL_TB
#include <raylib.h>
// #define CIRCUIT_TOOLS_IMPL
// #include "circuit_tools.h"
#endif // GRAPHICAL_TB

#define RUNTIME (5000000)
#define rgb(r, g, b) (Color){r, g, b, 255}

void CreateWaveFormVcd(int argc, char *argv[])
{
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VWithCharMemory *m_dut = new VWithCharMemory;
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
}

float g_fontsize = 12;

struct VgaTv
{
	int height, width, counter, pixels_len;
	Color *pixels;
};

/* clocks_w, h are total size of screen, not just visable areia */
VgaTv new_tv(int clocks_w, int clocks_h)
{
	size_t sz = sizeof(Color) * (clocks_w * clocks_h);
	VgaTv ret = {
		.height = clocks_h,
		.width = clocks_w,
		.pixels_len = clocks_w * clocks_h,
		.pixels = (Color *)malloc(sz)};
	memset(ret.pixels, 0, sz);
	return ret;
}

void DrawTv(VgaTv t, int px, int py)
{
	DrawRectangle(px, py, t.width, t.height, rgb(190, 190, 190));

	for (size_t y = 0; y < t.height; y++)
		for (size_t x = 0; x < t.width; x++)
		{
			Color c = t.pixels[y * t.width + x];
			if (ColorIsEqual(c, BLANK))
				continue;

			DrawPixel(px + x, py + y, c);
		}
}

void CaptureTv(VgaTv *t, u_char clk, u_char r, u_char g, u_char b, int hc, int vc)
{
	// if (t->counter > t->pixels_len)
	// 	t->counter = 0;
	t->pixels[vc * t->width + hc] = (Color){r, g, b, 255};
	// t->counter += 1;
}

int main(int argc, char *argv[])
{
	CreateWaveFormVcd(argc, argv);

#ifdef GRAPHICAL_TB
	g_fontsize = 12;
	InitWindow(1000, 800, "VTB");
	SetTargetFPS(60);

	VgaTv tv = new_tv(800, 521);
	VWithCharMemory *dut = new VWithCharMemory;

	bool go = false;
	while (!WindowShouldClose())
	{

		if (IsKeyPressed(KEY_S) || IsKeyDown(KEY_SPACE) || IsKeyDown(KEY_F) || go)
		{
			CaptureTv(&tv, dut->clk, dut->red * 4, dut->green * 4, dut->blue * 4, dut->dhc, dut->dvc);
			dut->eval();
			dut->clk = !dut->clk;
		}

		if (IsKeyPressed(KEY_W))
		{
			for (size_t i = 0; i < (800 * 512) * 2; i++)
			{
				CaptureTv(&tv, dut->clk, dut->red * 4, dut->green * 4, dut->blue * 4, dut->dhc, dut->dvc);
				dut->eval();
				dut->clk = !dut->clk;
			}
		}

		if (IsKeyPressed(KEY_F))
		{
			SetTargetFPS(1000);
		}

		if (IsKeyReleased(KEY_F))
		{
			SetTargetFPS(60);
		}

		if (IsKeyPressed(KEY_G))
			go = !go;

		BeginDrawing();

		ClearBackground(rgb(253, 246, 227));

		if (!IsKeyDown(KEY_F))
		{
			DrawTv(tv, 10, 10);
		}

		// Toolbar
		DrawRectangle(0, GetScreenHeight() - g_fontsize, GetScreenWidth(), g_fontsize, rgb(238, 232, 213));
		DrawText(TextFormat("%d fps", GetFPS()),
				 GetScreenWidth() - g_fontsize * 6,
				 GetScreenHeight() - g_fontsize,
				 g_fontsize, BLACK);

		DrawText(TextFormat("r: %04x c: %1d", dut->red, dut->clk),
				 10,
				 GetScreenHeight() - g_fontsize,
				 g_fontsize, BLACK);

		//

		EndDrawing();
	}
	CloseWindow();
#endif // GRAPHICAL_TP

	return 0;
}
