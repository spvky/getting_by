package getting_by

import "core:fmt"
import rl "vendor:raylib"

get_player :: proc(world: World) -> (player: ^Entity, ok: bool) {
	for &entity in world.scene.entities {
		if entity.tag == .Player {
			return &entity, true
		}
	}
	return nil, false
}

player_movement :: proc(world: ^World, frametime: f32) {
	if player,ok := get_player(world^); ok {

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
			player.velocity = frametime *  interpolated_vector
		} else {
			player.velocity = Vec3{}
		}
	}
}

update_player :: proc(world: ^World, frametime: f32) {
	player_movement(world, frametime)
}

