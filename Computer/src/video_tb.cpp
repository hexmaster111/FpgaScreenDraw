#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <verilated.h>
#include <verilated_vcd_c.h>


#include "obj_dir/Vvideo_controller.h"
#include "obj_dir/Vvideo_controller___024root.h"

#define GRAPHICAL_TB

#ifdef GRAPHICAL_TB
#include <raylib.h>
// #define CIRCUIT_TOOLS_IMPL
// #include "circuit_tools.h"
#endif // GRAPHICAL_TB

int g_fontsize = 12;

#define RUNTIME (5000000)
#define rgb(r, g, b) (Color){r, g, b, 255}

void CreateWaveFormVcd(int argc, char *argv[])
{
	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	Vvideo_controller *m_dut = new Vvideo_controller;
	VerilatedVcdC *m_trace = new VerilatedVcdC;

	m_dut->trace(m_trace, 5);
	m_trace->open("waveform.vcd");

	m_dut->vid_ch_in = 'A';
	m_dut->vid_ch_addr = 0;
	m_dut->vid_mem_we = 1;

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


struct VgaTv
{
	int height, width;
	RenderTexture2D texture;
};

/* clocks_w, h are total size of screen, not just visable areia */
VgaTv new_tv(int clocks_w, int clocks_h)
{
	size_t sz = sizeof(Color) * (clocks_w * clocks_h);
	VgaTv ret = {
		.height = clocks_h,
		.width = clocks_w};

	ret.texture = LoadRenderTexture(clocks_w, clocks_h);
	return ret;
}

void DrawTv(VgaTv t, int px, int py)
{
	DrawRectangle(px, py, t.width, t.height, rgb(190, 190, 190));
	DrawTextureRec(t.texture.texture, (Rectangle){0, 0, (float)t.texture.texture.width, (float)-t.texture.texture.height}, (Vector2){px, py}, WHITE);
}

/* TODO: Update me to not rely on knowing internal vars of the simulation */
void CaptureTv(VgaTv *t, u_char clk, u_char r, u_char g, u_char b, int hc, int vc)
{
	DrawPixel(hc, vc, (Color){r, g, b, 255});
}

int main(int argc, char *argv[])
{
	CreateWaveFormVcd(argc, argv);

#ifdef GRAPHICAL_TB
	g_fontsize = 12;
	InitWindow(900, 700, "VTB");
	SetTargetFPS(60);

	VgaTv tv = new_tv(800, 521);
	Vvideo_controller *dut = new Vvideo_controller;

	// const char *clocking_in_word = "hello, world";

	u_char letter = 'A';
	uint position = 0;
	bool write = false;


	bool go = false;
	while (!WindowShouldClose())
	{
		if (IsKeyPressed(KEY_S) || IsKeyDown(KEY_SPACE) || IsKeyDown(KEY_F) || go)
		{
			BeginTextureMode(tv.texture);
			CaptureTv(&tv, dut->clk, dut->red * 4, dut->green * 4, dut->blue * 4, dut->dhc, dut->dvc);
			dut->eval();
			dut->clk = !dut->clk;

			EndTextureMode();
		}

		if (IsKeyDown(KEY_W))
		{
			BeginTextureMode(tv.texture);

			float doneat = GetTime() + 1.0f / 120.0f;
			for (size_t i = 0; i < (800 * 2) * 521; i++)
			{

				CaptureTv(&tv, dut->clk, dut->red * 4, dut->green * 4, dut->blue * 4, dut->dhc, dut->dvc);
				dut->eval();
				dut->clk = !dut->clk;

				if (GetTime() > doneat)
					break;
			}

			EndTextureMode();
		}

		if (IsKeyPressed(KEY_G))
			go = !go;

		BeginDrawing();

		ClearBackground(rgb(253, 246, 227));

		if (!IsKeyDown(KEY_F))
		{
			DrawTv(tv, 10, 48);
		}

		DrawText(TextFormat("Letter : %c, Pos : %4d, We : %d", letter, position, write), 0, 0, 16, BLACK);
		DrawText("o=toggle_write u=letter up j=letter down i=pos up k=posdown", 0, 16, 16, BLACK);

		if(IsKeyPressed(KEY_J) || IsKeyPressedRepeat(KEY_J)) letter -= 1;
		if(IsKeyPressed(KEY_U) || IsKeyPressedRepeat(KEY_U)) letter += 1;
		if(IsKeyPressed(KEY_K) || IsKeyPressedRepeat(KEY_K)) position -= 1;
		if(IsKeyPressed(KEY_I) || IsKeyPressedRepeat(KEY_I)) position += 1;
		if(IsKeyPressed(KEY_O)) write = !write;
	
		dut->vid_ch_in = letter;
		dut->vid_ch_addr = position;
		dut->vid_mem_we = write;



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
	delete dut;
#endif // GRAPHICAL_TP

	return 0;
}
