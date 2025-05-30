package getting_by

import rl "vendor:raylib"
import l "core:math/linalg"
import sa "core:container/small_array"
import "core:fmt"

WINDOW_WIDTH ::1920
WINDOW_HEIGHT :: 1080
RENDER_WIDTH :: 480
RENDER_HEIGHT :: 320

main :: proc() {
	// Parse command line arguments
	opt: Options
	parse_command_line_arguments(&opt)

	// Open the raylib window
	rl.InitWindow(WINDOW_WIDTH,WINDOW_HEIGHT, "Getting By")
	defer rl.CloseWindow()

	camera: rl.Camera = {
		position = {10,10,-10},
		up = {0,1,0},
		fovy = 45
	}

	world:= World {
		camera = camera
	}

	load_models()


	rt:= rl.LoadRenderTexture(RENDER_WIDTH,RENDER_HEIGHT)

	for !rl.WindowShouldClose() {

		// Editor Update
		if opt.editor {
			editor_update(&world)
		}
		frametime:= rl.GetFrameTime()

		player_movement(&world, frametime)
		rl.BeginTextureMode(rt)

		rl.BeginMode3D(world.camera)
		rl.ClearBackground(rl.WHITE)


		// Editor Render
		if opt.editor {
			rl.DrawGrid(10,1)
		}
		render_entities(world)
		render_player(world)

		// rl.DrawCube(a.translation, 2,2,2,rl.RED)

		rl.EndMode3D()
		rl.EndTextureMode()

		rl.BeginDrawing()
		rl.DrawTexturePro(rt.texture,{width = RENDER_WIDTH, height = -RENDER_HEIGHT}, {width = WINDOW_WIDTH, height = WINDOW_HEIGHT}, {0,0}, 0, rl.WHITE)
		rl.EndDrawing()
	}
	delete(model_index)
}
