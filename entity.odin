package getting_by

import rl "vendor:raylib"

Entity :: struct {
	translation: Vec3,
	rotation: f32,
	model_tag: ModelTag
}

render_entities :: proc(world: World) {
	for entity in world.scene.entities {
		if entity_model, ok := model_index[entity.model_tag]; ok {
			rl.DrawModelEx(entity_model,entity.translation, {0,1,0}, entity.rotation, {1,1,1}, rl.WHITE)
		}
	}
}
