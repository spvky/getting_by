package getting_by

import rl "vendor:raylib"

Scene :: struct {
	player: Entity,
	entities: #soa [dynamic]Entity
}

World :: struct {
	using camera: rl.Camera,
	camera_angle: f32,
	scene: Scene,
}
