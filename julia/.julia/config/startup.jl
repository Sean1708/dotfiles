if VERSION < v"0.7"
	import Base.REPL
	import Base.REPL.LineEdit
else
	import REPL
	import REPL.LineEdit
end

include("status.jl")

const extra_repl_keymap = Dict{Any, Any}(
	'#' => function (s, _, c)
		if isempty(s)
			println(Status.System())
			# HINT: Needed so that the prompt appears. Root cause unknown.
			LineEdit.edit_insert(s, '\n')
			LineEdit.edit_clear(s)
		else
			LineEdit.edit_insert(s, c)
		end
	end,
	'~' => function (s, _, c)
		if isempty(s)
			println()
			display(Status.System())
			# HINT: Needed so that the prompt appears. Root cause unknown.
			LineEdit.edit_insert(s, '\n')
			LineEdit.edit_clear(s)
		else
			LineEdit.edit_insert(s, c)
		end
	end,
)

atreplinit(repl -> repl.interface = REPL.setup_interface(repl, extra_repl_keymap = extra_repl_keymap))


const INIT_FILE = "_init.jl"
if isfile(INIT_FILE)
	include(joinpath(pwd(), INIT_FILE))
end
