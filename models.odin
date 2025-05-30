package getting_by

import rl "vendor:raylib"

model_index: map[EntityTag]rl.Model

load_models :: proc() {
	model_index[.Player] = rl.LoadModel("./assets/models/salary.glb")
}
