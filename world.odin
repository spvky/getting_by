package getting_by

import "core:slice"
import "core:fmt"
import rl "vendor:raylib"

Scene :: struct {
	entities: [dynamic]Entity
}

World :: struct {
	using camera: rl.Camera,
	camera_angle: f32,
	scene: Scene,
}

cleanup_scene :: proc(world: World) {
	delete(world.scene.entities)
}
