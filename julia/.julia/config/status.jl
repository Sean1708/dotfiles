# TODO: Find a way to keep all of these outside of the global namespace (get rid of structs and make it not a module).
module __Status

const SYMBOLS = @static if uppercase(ENV["TERM"]) == "DUMB"
	Dict(
		:DIRECTORY => ':',
		:HOST => '@',
		:ROOT => '#',
		:USER => '$',
		:branch => 'Y',
		:ahead => '^',
		:behind => 'v',
		:added => '+',
		:copied => '=',
		:deleted => 'x',
		:modified => 'd',
		:renamed => '>',
		:unmerged => '!',
		:untracked => '?',
	)
else
	Dict(
		:DIRECTORY => ':',
		:HOST => '@',
		:ROOT => '\u26a1',
		:USER => '$',
		:branch => 'Y',
		:ahead => '\u2191',
		:behind => '\u2193',
		:added => '\u271a',
		:copied => '=',
		:deleted => '\u2716',
		:modified => '\u0394',
		:renamed => '\u2192',
		:unmerged => '\u2260',
		:untracked => '?',
	)
end

ACTIONS1 = Dict(
	"AD" => :UNCHANGED,
	".A" => :added,
	"A." => :added,
	"AM" => :added,
	".D" => :deleted,
	"D." => :deleted,
	"MD" => :deleted,
	".M" => :modified,
	"M." => :modified,
	"MM" => :modified,
)

ACTIONS2 = Dict(
	"CD" => :UNCHANGED,
	"CM" => :COPIED_MODIFIED,
	"RM" => :RENAMED_MODIFIED,
	".C" => :copied,
	"DC" => :copied,
	"RD" => :deleted,
	".R" => :renamed,
	"DR" => :renamed,
	"R." => :renamed,
)


struct Git
	branch::String

	ahead::Int
	behind::Int

	added::Set{String}
	copied::Set{Pair{String, String}}
	deleted::Set{String}
	modified::Set{String}
	renamed::Set{Pair{String, String}}
	unmerged::Set{String}
	untracked::Set{String}
end

Git(status) = Git(
	status[:branch],
	status[:ahead],
	status[:behind],
	status[:added],
	status[:copied],
	status[:deleted],
	status[:modified],
	status[:renamed],
	status[:unmerged],
	status[:untracked],
)

# TODO: Do the parsing better. Maybe move it into it's own module (i.e. not just a big bunch of closures inside this function).
# TODO: Can we use `LibGit2`?
# TODO: What other information is available?
#	- Upstream info.
function Git()
	status = Dict(
		:branch => "",
		:ahead => 0,
		:behind => 0,
		:added => Set(),
		:copied => Set(),
		:deleted => Set(),
		:modified => Set(),
		:renamed => Set(),
		:unmerged => Set(),
		:untracked => Set(),
	)

	if !success(`git rev-parse --is-in-work-tree`)
		return Git(status)
	end

	function entry!(buffer, status)
		marker = readuntil(buffer, ' ')

		if marker == "#"
			header!(buffer, status)
		elseif marker == "1"
			changed1!(buffer, status)
		elseif marker == "2"
			changed2!(buffer, status)
		elseif marker == "u"
			unmerged!(buffer, status)
		elseif marker == "?"
			untracked!(buffer, status)
		elseif marker == "!"
			ignored!(buffer, status)
		else
			warn("Unknown marker: $marker")
			readuntil(buffer, '\0')
		end
	end

	function header!(buffer, status)
		typ = readuntil(buffer, '.')
		if typ != "branch"
			warn("Unknown header type: $typ")
			readuntil(buffer, '\0')
			return
		end

		key = readuntil(buffer, ' ')
		if key == "oid"
			branch!(buffer, status)
		elseif key == "head"
			warn("Expected `branch.head` to have come after `branch.oid`.")
		elseif key == "ab"
			for delim in (' ', '\0')
				ab = readuntil(buffer, delim)

				key = if ab[1] == '+'
					:ahead
				elseif ab[1] == '-'
					:behind
				else
					warn("Unexpected symbol in `branch.ab`: $ab")
					break
				end

				value = parse(Int, ab[2:end])

				status[key] = value
			end
		else
			readuntil(buffer, '\0')
		end
	end

	function branch!(buffer, status)
		commit = readuntil(buffer, '\0')

		marker = readuntil(buffer, ' ')
		if marker != "#"
			warn("Expected `branch.oid` to be followed by `#`: $marker")

			seek(buffer, position(buffer) - length(marker) - 1)
			write(buffer, marker, ' ')
			seek(buffer, position(buffer) - length(marker) - 1)

			return
		end

		typ = readuntil(buffer, '.')
		if typ != "branch"
			warn("Expected `branch.oid` to be followed by another `branch`: $typ")

			seek(buffer, position(buffer) - length(typ) - 1)
			write(buffer, typ, '.')
			seek(buffer, position(buffer) - length(typ) - 1)

			return
		end

		key = readuntil(buffer, ' ')
		if key != "head"
			warn("Expected `branch.oid` to be followed by `branch.head`: $key")

			seek(buffer, position(buffer) - length(key) - 1)
			write(buffer, marker, ' ')
			seek(buffer, position(buffer) - length(key) - 1)

			return
		end

		branch = readuntil(buffer, '\0')
		if branch == "(detached)"
			commit = chomp(read(`git rev-parse --short $commit`, String))
			status[:branch] = "(detached:$commit)"
		else
			status[:branch] = branch
		end
	end

	function changed1!(buffer, status)
		state = readuntil(buffer, ' ')

		_submodule = readuntil(buffer, ' ')
		_mode_head = readuntil(buffer, ' ')
		_mode_indx = readuntil(buffer, ' ')
		_mode_tree = readuntil(buffer, ' ')
		_name_head = readuntil(buffer, ' ')
		_name_indx = readuntil(buffer, ' ')

		path = readuntil(buffer, '\0')

		key = get(ACTIONS1, state, :ERROR)
		if key === :ERROR
			warn("Unrecognised state ($(stacktrace()[1].func)): $state")
		elseif key !== :UNCHANGED
			push!(status[key], path)
		end
	end

	function changed2!(buffer, status)
		state = readuntil(buffer, ' ')

		_submodule = readuntil(buffer, ' ')
		_mode_head = readuntil(buffer, ' ')
		_mode_indx = readuntil(buffer, ' ')
		_mode_tree = readuntil(buffer, ' ')
		_name_head = readuntil(buffer, ' ')
		_name_indx = readuntil(buffer, ' ')
		_sim_score = readuntil(buffer, ' ')

		target = readuntil(buffer, '\0')
		source = readuntil(buffer, '\0')

		key = get(ACTIONS2, state, :ERROR)
		if key === :ERROR
			warn("Unrecognised state ($(stacktrace()[1].func)): $state")
		elseif key === :COPIED_MODIFIED
			push!(status[:copied], source => target)
			push!(status[:modified], target)
		elseif key === :RENAMED_MODIFIED
			push!(status[:renamed], source => target)
			push!(status[:modified], target)
		elseif key === :deleted
			push!(status[key], source)
		elseif key !== :UNCHANGED
			push!(status[key], source => target)
		end
	end

	function unmerged!(buffer, status)
		_state = readuntil(buffer, ' ')
		_submodule = readuntil(buffer, ' ')
		_mode_stage1 = readuntil(buffer, ' ')
		_mode_stage2 = readuntil(buffer, ' ')
		_mode_stage3 = readuntil(buffer, ' ')
		_name_stage1 = readuntil(buffer, ' ')
		_name_stage2 = readuntil(buffer, ' ')
		_name_stage3 = readuntil(buffer, ' ')

		path = readuntil(buffer, '\0')
		push!(status[:unmerged], path)
	end

	function untracked!(buffer, status)
		push!(status[:untracked], readuntil(buffer, '\0'))
	end

	function ignored!(buffer, status)
		error("Command line flag for ignored files should not have been set.")
	end

	output = IOBuffer(read(`git status --porcelain=v2 --branch -z`))
	while !eof(output)
		entry!(output, status)
	end

	Git(status)
end

function Base.show(io::IO, status::Git)
	if isempty(status.branch)
		return
	end

	printstyled(io, status.branch, color=:yellow)

	if status.ahead > 0 || status.behind > 0
		print(io, " ")
		printstyled(io, SYMBOLS[:ahead], status.ahead, color=:green)
		printstyled(io, SYMBOLS[:behind], status.behind, color=:red)
	end

	if !(
			isempty(status.added) &&
			isempty(status.copied) &&
			isempty(status.deleted) &&
			isempty(status.modified) &&
			isempty(status.renamed) &&
			isempty(status.unmerged) &&
			isempty(status.untracked)
	)
		print(io, " ")
	end

	for (field, colour) in zip(
			[:added, :copied, :deleted, :modified, :renamed, :unmerged, :untracked],
			[:red, :yellow, :green, :cyan, :blue, :magenta, :white],
	)
		if !isempty(getfield(status, field))
			printstyled(io, SYMBOLS[field], color=colour)
		end
	end
end

function Base.show(io::IO, ::MIME"text/plain", status::Git)
	_string(s::Set{Pair{String, String}}) = join(("\n\t$(el[1]) => $(el[2])" for el in s), "")
	_string(s::Set) = join(("\n\t$el" for el in s), "")
	_string(s) = string(s)

	fields = [:branch, :ahead, :behind, :added, :copied, :deleted, :modified, :renamed, :unmerged, :untracked]
	colours = [:yellow, :green, :red, :red, :yellow, :green, :cyan, :blue, :magenta, :white]
	width = maximum(length(String(field)) for field in fields)

	for (field, colour) in zip(fields, colours)
		name = String(field)
		printstyled(
			io,
			SYMBOLS[field],
			" ",
			titlecase(name),
			" ",
			" " ^ (width - length(name)),
			_string(getfield(status, field)),
			'\n',
			color=colour,
		)
	end
end

function isrepo(status::Git)
	!isempty(status.branch)
end


struct Job
	shell::UInt
	julia::UInt
end

Job() = Job(0, 0)


struct System
	host::String
	pwd::String
	root::Bool
	user::String

	git::Git
	jobs::Job
end

System() = System(
	gethostname(),
	pwd(),
	false,
	# TODO: Is there a better way to do this?
	ENV["USER"],
	Git(),
	Job(),
)

function Base.show(io::IO, status::System)
	pwd = if status.pwd == homedir() || (islink(homedir()) && status.pwd == readlink(homedir()))
		"~"
	elseif startswith(status.pwd, homedir())
		joinpath("~", relpath(status.pwd, homedir()))
	elseif islink(homedir()) && startswith(status.pwd, readlink(homedir()))
		joinpath("~", relpath(status.pwd, readlink(homedir())))
	else
		status.pwd
	end

	user_colour = status.root ? :red : :green
	user_symbol = status.root ? :ROOT : :USER

	print(io, "[")

	printstyled(io, status.user, color=user_colour)
	print(io, SYMBOLS[:HOST])
	printstyled(io, status.host, color=:magenta)
	print(io, SYMBOLS[:DIRECTORY])
	printstyled(io, pwd, color=:blue)

	if isrepo(status.git)
		print(io, " | git:", status.git)
	end

	print(io, "] ")

	printstyled(io, SYMBOLS[user_symbol], color=user_colour)
end

function Base.show(io::IO, m::MIME"text/plain", status::System)
	padding = length("Working Directory") - length("Username")

	user_colour = status.root ? :red : :green
	user_symbol = status.root ? :ROOT : :USER

	printstyled(
		io,
		SYMBOLS[user_symbol],
		" Username ",
		" " ^ padding,
		status.user,
		'\n',
		color=user_colour,
	)
	printstyled(
		io,
		SYMBOLS[:HOST],
		" Hostname ",
		" " ^ padding,
		status.host,
		'\n',
		color=:magenta,
	)
	printstyled(
		io,
		SYMBOLS[:DIRECTORY],
		" Working Directory ",
		status.pwd,
		'\n',
		color=:blue
	)

	b = IOBuffer()
	Base.show(IOContext(b, :color => true), m, status.git)
	seekstart(b)
	git = readlines(b)

	println(io, "Git:")
	for line in git
		println(io, '\t', line)
	end
end

end
