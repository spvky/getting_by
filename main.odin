package getting_by

import rl "vendor:raylib"
import l "core:math/linalg"
import sa "core:container/small_array"
import "core:fmt"

WINDOW_WIDTH ::1920
WINDOW_HEIGHT :: 1080
RENDER_WIDTH :: 480
RENDER_HEIGHT :: 320

Vec3 :: [3]f32
Matrix :: #column_major matrix[4, 4]f32



Scene :: struct {
	entities: [dynamic]Entity
}

World :: struct {
	using camera: rl.Camera,
	camera_angle: f32,
	scene: Scene,
}

extend :: proc(v: Vec3, w: f32) -> [4]f32 {
	return {v.x,v.y,v.z,w}
}

interpolate_vector :: proc(world: World, vector: Vec3) -> Vec3 {
	camera_matrix:= Matrix(rl.GetCameraMatrix(world.camera))
	r: [4]f32 = extend(vector, 1) * camera_matrix
	final: Vec3 ={r.x,0,r.z}
	return l.normalize(final)
}

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
	append(&world.scene.entities, Entity{translation = {0,0,0}})

	load_models()


	rt:= rl.LoadRenderTexture(RENDER_WIDTH,RENDER_HEIGHT)

	for !rl.WindowShouldClose() {

		// Editor Update
		if opt.editor {
			editor_update(&world)
		}
		frametime:= rl.GetFrameTime()
		// movement_vector: Vec3
		// if rl.IsKeyDown(.W) {
		// 	movement_vector.z -= 1
		// }
		// if rl.IsKeyDown(.S) {
		// 	movement_vector.z += 1
		// }
		// if rl.IsKeyDown(.D) {
		// 	movement_vector.x += 1
		// }
		// if rl.IsKeyDown(.A) {
		// 	movement_vector.x -= 1
		// }
		
		// if movement_vector != {0,0,0} {
		// 	interpolated_vector:= interpolate_vector(world,movement_vector)
		// 	a.translation += frametime *  interpolated_vector
		// }
		rl.BeginTextureMode(rt)

		rl.BeginMode3D(world.camera)
		rl.ClearBackground(rl.WHITE)

		// Editor Render
		if opt.editor {
			rl.DrawGrid(10,1)
		}
		render_entities(world)

		// rl.DrawCube(a.translation, 2,2,2,rl.RED)

		rl.EndMode3D()
		rl.EndTextureMode()

		rl.BeginDrawing()
		rl.DrawTexturePro(rt.texture,{width = RENDER_WIDTH, height = -RENDER_HEIGHT}, {width = WINDOW_WIDTH, height = WINDOW_HEIGHT}, {0,0}, 0, rl.WHITE)
		rl.EndDrawing()
	}
	delete(model_index)
}
