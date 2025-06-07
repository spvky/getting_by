package getting_by

import "core:fmt"
import "core:math"
import "core:strings"
import "core:c"
import l "core:math/linalg"
import rl "vendor:raylib"

EditorState :: struct {
	camera_mode: EditorCameraMode,
	cursor_state: CursorState,
	active_toggle: c.int,
	selected_entity: Handle,
	selected_scene_collider: Maybe(Handle),
}

CursorState :: union {
	CursorPlacement,
	CursorSelection
}

CursorPlacement :: struct {
	position: Vec3
}

CursorSelection :: struct {
	
}

EditorCameraMode :: enum {
	Placement,
	Navigation
}

ColliderEdit :: struct {
	current_collider: Handle,
	current_index: int
}

EntityEdit :: struct {
	current_entity: Handle,
}

/// Editor Mode
// - Collider Edit
// - Entity Edit
// - Entity Placement
// - Collider Placement
//	Collider Edit
//	-

editor_state:= EditorState {
	cursor_state = CursorPlacement{}
}

editor_camera_movement :: proc(world: ^World) {
	mouse_delta:= rl.GetMouseDelta()
	frametime:= rl.GetFrameTime()

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
			if rl.IsKeyDown(.Q) {raw_movement.z += 1}
			if rl.IsKeyDown(.E) {raw_movement.z -= 1}
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
	editor_placement(world)
	switch &cs in editor_state.cursor_state {
		case CursorPlacement:
			position:= placement_cursor(world^)
			cs.position = position

		case CursorSelection:
	}
}

placement_cursor :: proc(world: World) -> Vec3 {
	snap_height:= math.round(world.camera.position.y - 10.0)
	stw_ray:= rl.GetScreenToWorldRay(rl.GetMousePosition(), world.camera)
	ray_collision:= rl.GetRayCollisionQuad(stw_ray,
		{-100,snap_height,-100},
		{100,snap_height,-100},
		{100,snap_height,100},
		{-100,snap_height,100},
	)
	return ray_collision.point
}


custom_grid :: proc(world: World) {
	snapped_height:= math.round(world.camera.position.y - 10.0)
	center:= Vec3{0,snapped_height,0}
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

test_box :: proc() {
	editor_window:= rl.Rectangle{1620,10,250, 800}
	rl.GuiWindowBox(editor_window, "Some Window")
	mode_string: cstring
	switch editor_state.active_toggle {
		case 0:
			mode_string = "Select"
		case 1:
			mode_string = "Placement"
		case 2:
			mode_string = "Secret Case"
	}
	rl.DrawText(mode_string, 1350, 200, 20,rl.BLACK)
	toggle_mode:= rl.GuiToggleGroup({1650, 100, 50,50}, "#068#;#070#;#073#", &editor_state.active_toggle)
}

draw_placement_cursor :: proc(position: Vec3) {
	rl.DrawSphere(position, 0.25, rl.Color{255,0,0,122})
}

// Collider Placement Take 1:
// 1.Clicking on  the grid sets a vertices
//	a. Create a new collider instance that contains the vertex
//	b. The vertex becomes the `Selected object in the editor
// 2. You can click commit
//	a. If the collider has 3 or more vertices
//	b. Calculate the convex hull if there are 5 or more vertices *
//	c. Save the collider instance to the scene
// 3. You can click the grid
//	a. This appends a vertex to the collider, and the new vertex is now selected

editor_placement :: proc(world: ^World) {
	if rl.IsMouseButtonPressed(.LEFT) {
		// Check if cursor is in the placement state
		if c_state, ok := editor_state.cursor_state.(CursorPlacement); ok {
			// Check if we have an existing handle to a scene collider
			if handle, h_ok := editor_state.selected_scene_collider.?; h_ok {
				// If we have a handle, get a pointer the handles object
				collider_ptr:= ha_get_ptr(world.scene_collision,handle)
				append(&collider_ptr.points, c_state.position)
			} else {
				sc: SceneCollider
				append(&sc.points, c_state.position)
				collider_handle :=  ha_add(&world.scene_collision, sc)
				editor_state.selected_scene_collider = collider_handle
			}
		}
	}
}

editor_picking :: proc(world: World) {
	if editor_state.active_toggle == 0 {
		// ray:= rl.GetScreenToWorldRay(rl.GetMousePosition(), world.camera)
	}
}

editor_style :: proc() {
	a: rl.GuiControl
	rl.GuiSetStyle(.TOGGLE,1,0x024658ff)
	// rl.GuiSetStyle(.TOGGLE,2,0x2fffffff)
	rl.GuiSetStyle(.TOGGLE,2,0xffffff)
	// rl.GuiLoadStyle()
}

editor_draw :: proc(world: World) {
	editor_style()
	switch editor_state.active_toggle {
		case 0:
		case 1:
			custom_grid(world)
		case 2:
	}

	switch cs in editor_state.cursor_state {
		case CursorSelection:
		case CursorPlacement:
			draw_placement_cursor(cs.position)
	}

	scene_collider_iter := ha_make_iter(world.scene_collision)
	for sc in ha_iter_ptr(&scene_collider_iter) {
		length := len(sc.points)
		for point,i in sc.points {
			if length > 1 && i+1 < length {
				rl.DrawLine3D(point, sc.points[i+1], rl.BLUE)
			}
			rl.DrawSphere(point, 0.5, rl.BLUE)
		}
		rl.DrawLine3D(sc.points[length - 1], sc.points[0], rl.BLUE)
	}

}

editor_ui :: proc() {
	test_box()
}

