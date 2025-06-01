package getting_by

import l "core:math/linalg"
import brag "shared:bragi"

detect_collisions :: proc(world: ^World) {
	// Broad phase algorithm
	// Need to add a broad phase to bragi and run it here
	// --Add all possible collision pairs (static and dynamic) to a temp dynamic array
	//
	// Narrow phase
	// -- Detect collisions between possible collision pairs
	// - Save all collisions to a temp array inside of world
}
