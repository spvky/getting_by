package getting_by

import rl "vendor:raylib"

player_movement :: proc(world: ^World, frametime: f32) {
	player := &world.scene.player
	
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
		interpolated_vector:= interpolate_vector(world^,movement_vector)
		player.translation += frametime *  interpolated_vector
	}
}

render_player :: proc(world: World) {
	player := world.scene.player
	if player_model, ok := model_index[player.tag]; ok {
		rl.DrawModelEx(player_model,player.translation, {0,1,0}, player.rotation, {1,1,1}, rl.WHITE)
	}
}
