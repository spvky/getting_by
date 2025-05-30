package getting_by

import rl "vendor:raylib"

Entity :: struct {
	using translation: Vec3,
	rotation: f32,
	tag: EntityTag
}

StaticEntity :: struct {
	using translation: Vec3,
	size: Vec3,
	rotation: f32,
	tag: StaticEntityTag
}

EntityTag :: enum {
	Player,
	Desk,
}

StaticEntityTag :: enum {
	Block
}

render_entities :: proc(world: World) {
	for entity in world.scene.entities {
		if entity_model, ok := model_index[entity.tag]; ok {
			rl.DrawModelEx(entity_model,entity.translation, {0,1,0}, entity.rotation, {1,1,1}, rl.WHITE)
		}
	}

	for entity in world.scene.static_entities {
			switch entity.tag {
			case .Block:
			rl.DrawCubeV(entity.translation, entity.size,rl.GRAY)
			
		}
	}
}
