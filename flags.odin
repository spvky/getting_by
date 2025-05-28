package getting_by

import "core:fmt"
import "core:os"
import "core:flags"

Options :: struct {
	editor: bool `args:"name=editor" usage:"Run the level editor"`
}

parse_command_line_arguments :: proc(opt: ^Options) {
	flags.parse_or_exit(opt, os.args)
}
