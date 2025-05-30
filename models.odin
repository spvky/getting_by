package getting_by

import rl "vendor:raylib"

ModelTag :: enum {
	Player,
	Desk,
}

model_index: map[ModelTag]rl.Model

load_models :: proc() {
	model_index[.Player] = rl.LoadModel("./assets/models/salary.glb")
}
