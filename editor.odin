package getting_by

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import rl "vendor:raylib"

EditorState :: struct {
	camera_mode: EditorCameraMode,
}

EditorCameraMode :: enum {
	Placement,
	Navigation
}

editor_state: EditorState

editor_camera_movement :: proc(world: ^World) {
	mouse_delta:= rl.GetMouseDelta()
	frametime:= rl.GetFrameTime()

	// if rl.IsKeyPressed(.Z) {
	// 	switch editor_state.camera_mode {
	// 		case .Navigation:
	// 			editor_state.camera_mode = .Placement
	// 		case .Placement:
	// 			editor_state.camera_mode = .Navigation
	// 	}
	// }

	switch editor_state.camera_mode {
		case .Placement:
			world.camera.up = {0,1,0}
			raw_movement: Vec3
			// For some arcane reason the movement vector in Update camera is:
			// x -> z
			// y -> x
			// z -> y
			if rl.IsKeyDown(.W) {raw_movement.x += 1}
			if rl.IsKeyDown(.S) {raw_movement.x -= 1}
			if rl.IsKeyDown(.A) {raw_movement.y -= 1}
			if rl.IsKeyDown(.D) {raw_movement.y += 1}
			if raw_movement != {0,0,0} {
				scaled_vec:= l.normalize(raw_movement) * 10 * frametime
				rl.UpdateCameraPro(&world.camera,scaled_vec, {0,0,0}, 0)
			}
		case .Navigation:
			rl.UpdateCamera(&world.camera,.FREE)
			world.camera.up = {0,1,0}
	}
}

editor_update :: proc(world: ^World) {
	editor_camera_movement(world)
}


custom_grid :: proc(world: World) {
	center:= Vec3{0,world.camera.position.y - 10,0}
	grid_color:= rl.Color{255,255,255,122}
	iter:= 5
	f_iter:= f32(iter)

	for i in 0..<iter {
			f_i:= f32(i)
		if i == 0 {
			start:= center - {f_i,0,-f_iter}
			end:= center - {f_i,0,f_iter}
			rl.DrawLine3D(start, end, grid_color)

			h_start:= center - {-f_iter,0,f_i}
			h_end:= center - {f_iter,0,f_i}
			rl.DrawLine3D(h_start, h_end, grid_color)
		} else {
			// z-lines
			start:= center - {f_i,0,-f_iter}
			end:= center - {f_i,0,f_iter}
			rl.DrawLine3D(start, end, grid_color)
			n_start:= center - {-f_i,0,-f_iter}
			n_end:= center - {-f_i,0,f_iter}
			rl.DrawLine3D(n_start, n_end, grid_color)
			
			// x-lines
			h_start:= center - {-f_iter,0,f_i}
			h_end:= center - {f_iter,0,f_i}
			rl.DrawLine3D(h_start, h_end, grid_color)
			nh_start:= center - {-f_iter,0,-f_i}
			nh_end:= center - {f_iter,0,-f_i}
			rl.DrawLine3D(nh_start, nh_end, grid_color)
		}
	}
}

editor_draw :: proc(world: World) {
	custom_grid(world)
	if rl.GuiButton(
		{1700,-100, 200, 500},
		"Nice Button"
		) {
	}
	
}
