package getting_by

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import rl "vendor:raylib"

EditorState :: struct {
	camera_mode: EditorCameraMode,
}

EditorCameraMode :: enum {
	Navigation,
	Placement
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
			if rl.IsKeyDown(.W) {raw_movement.z += 1}
			if rl.IsKeyDown(.S) {raw_movement.z -= 1}
			if rl.IsKeyDown(.A) {raw_movement.x += 1}
			if rl.IsKeyDown(.D) {raw_movement.x -= 1}
			camera_movement:= l.normalize(raw_movement) * 10 * frametime
			// camera_rotation:= Vec3 {mouse_delta.x * frametime, mouse_delta.y * frametime, 0}
			rl.UpdateCameraPro(&world.camera,camera_movement, {0,0,0}, 0)
		case .Navigation:
			rl.UpdateCamera(&world.camera,.FREE)
			world.camera.up = {0,1,0}
	}
}

editor_update :: proc(world: ^World) {
	editor_camera_movement(world)
}


editor_draw :: proc(world: World) {
	
}
