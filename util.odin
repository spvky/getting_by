package getting_by

import "core:testing"
import "core:math"
import l "core:math/linalg"
import rl "vendor:raylib"

Vec3 :: [3]f32
Matrix :: #column_major matrix[4, 4]f32

extend :: proc(v: Vec3, w: f32) -> [4]f32 {
	return {v.x,v.y,v.z,w}
}

interpolate_vector :: proc(world: World, vector: Vec3) -> Vec3 {
	camera_matrix:= Matrix(rl.GetCameraMatrix(world.camera))
	r: [4]f32 = extend(vector, 1) * camera_matrix
	final: Vec3 ={r.x,0,r.z}
	return l.normalize(final)
}
