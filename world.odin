package getting_by

import "core:slice"
import "core:fmt"
import rl "vendor:raylib"

Scene :: struct {
	entities: [dynamic]Entity,
	scene_collision: Handle_Array(SceneCollider, Handle),
}

World :: struct {
	camera: rl.Camera,
	camera_angle: f32,
	using scene: Scene,
	using physics_world: PhysicsWorld,
}

PhysicsWorld :: struct {
	gravity: Vec3,
	possible_collision_pairs: [dynamic]int,
	actual_collision_pairs: [dynamic]int,
}

cleanup_scene :: proc(world: World) {
	delete(world.scene.entities)
	ha_delete(world.scene.scene_collision)
}
