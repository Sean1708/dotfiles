import REPL
import REPL.LineEdit

status = let
	# TODO: Make this not a module, and use only functions (no types).
	include("status.jl")

	function (verbose=false)
		if verbose
			display(__Status.System())
		else
			println(__Status.System())
		end
	end
end


let
	init_file = "_init.jl"

	if isfile(init_file)
		include(joinpath(pwd(), init_file))
	end
end
