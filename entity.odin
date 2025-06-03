package getting_by

import rl "vendor:raylib"

Entity :: struct {
	using translation: Vec3,
	velocity: Vec3,
	rotation: f32,
	tag: EntityTag
}

StaticEntity :: struct {
	using translation: Vec3,
	size: Vec3,
	rotation: f32,
	tag: StaticEntityTag
}

SceneCollider :: struct {
	points: [dynamic]Vec3
}

EntityTag :: enum {
	Player,
	Desk,
}

StaticEntityTag :: enum {
	Block
}

apply_entity_velocty :: proc(world: ^World) {
	for &entity in world.entities {
		if entity.velocity != {0,0,0} {
			entity.translation += entity.velocity
		}
	}
}

draw_entities :: proc(world: World) {
	for entity in world.entities {
		if entity_model, ok := model_index[entity.tag]; ok {
			rl.DrawModelEx(entity_model,entity.translation, {0,1,0}, entity.rotation, {1,1,1}, rl.WHITE)
		}
	}

	for entity in world.static_entities {
			switch entity.tag {
			case .Block:
			rl.DrawCubeV(entity.translation, entity.size,rl.GRAY)
			
		}
	}
}

update_entities :: proc(world: ^World) {
	apply_entity_velocty(world)
}
