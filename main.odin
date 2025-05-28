package getting_by

import rl "vendor:raylib"
import l "core:math/linalg"
import "core:fmt"

WINDOW_WIDTH ::1600
WINDOW_HEIGHT :: 900
RENDER_WIDTH :: 480
RENDER_HEIGHT :: 320

Entity :: struct {
	translation: Vec3
}

Vec3 :: [3]f32
Matrix :: #column_major matrix[4, 4]f32

World :: struct {
	camera: rl.Camera,
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
	rl.InitWindow(WINDOW_WIDTH,WINDOW_HEIGHT, "Getting By")

	defer rl.CloseWindow()

	a: Entity

	camera: rl.Camera = {
		position = {10,10,-10},
		up = {0,1,0},
		fovy = 90
	}

	world:= World {
		camera = camera
	}

	rt:= rl.LoadRenderTexture(RENDER_WIDTH,RENDER_HEIGHT)

	for !rl.WindowShouldClose() {
		frametime:= rl.GetFrameTime()
		movement_vector: Vec3
		if rl.IsKeyDown(.W) {
			movement_vector.z -= 1
		}
		if rl.IsKeyDown(.S) {
			movement_vector.z += 1
		}
		if rl.IsKeyDown(.D) {
			movement_vector.x += 1
		}
		if rl.IsKeyDown(.A) {
			movement_vector.x -= 1
		}
		
		if movement_vector != {0,0,0} {
			interpolated_vector:= interpolate_vector(world,movement_vector)
			a.translation += frametime *  interpolated_vector
		}
		rl.BeginTextureMode(rt)

		rl.BeginMode3D(world.camera)
		rl.ClearBackground(rl.WHITE)

		rl.DrawGrid(10,1)
		rl.DrawCube(a.translation, 2,2,2,rl.RED)

		rl.EndMode3D()
		rl.EndTextureMode()

		rl.BeginDrawing()
		rl.DrawTexturePro(rt.texture,{width = RENDER_WIDTH, height = -RENDER_HEIGHT}, {width = WINDOW_WIDTH, height = WINDOW_HEIGHT}, {0,0}, 0, rl.WHITE)
		rl.EndDrawing()
	}
}
