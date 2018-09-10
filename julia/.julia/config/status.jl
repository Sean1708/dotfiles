module Status

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

const ACTIONS1 = Dict(
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

const ACTIONS2 = Dict(
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

	field(buffer, delim=' ') = strip(readuntil(buffer, delim), delim)

	function entry!(buffer, status)
		marker = field(buffer)

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
		typ = field(buffer, '.')
		if typ != "branch"
			warn("Unknown header type: $typ")
			readuntil(buffer, '\0')
			return
		end

		key = field(buffer)
		if key == "oid"
			branch!(buffer, status)
		elseif key == "head"
			warn("Expected `branch.head` to have come after `branch.oid`.")
		elseif key == "ab"
			for delim in (' ', '\0')
				ab = field(buffer, delim)

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
		commit = field(buffer, '\0')

		marker = field(buffer)
		if marker != "#"
			warn("Expected `branch.oid` to be followed by `#`: $marker")

			seek(buffer, position(buffer) - length(marker) - 1)
			write(buffer, marker, ' ')
			seek(buffer, position(buffer) - length(marker) - 1)

			return
		end

		typ = field(buffer, '.')
		if typ != "branch"
			warn("Expected `branch.oid` to be followed by another `branch`: $typ")

			seek(buffer, position(buffer) - length(typ) - 1)
			write(buffer, typ, '.')
			seek(buffer, position(buffer) - length(typ) - 1)

			return
		end

		key = field(buffer)
		if key != "head"
			warn("Expected `branch.oid` to be followed by `branch.head`: $key")

			seek(buffer, position(buffer) - length(key) - 1)
			write(buffer, marker, ' ')
			seek(buffer, position(buffer) - length(key) - 1)

			return
		end

		branch = field(buffer, '\0')
		if branch == "(detached)"
			commit = chomp(readstring(`git rev-parse --short $commit`))
			status[:branch] = "(detached:$commit)"
		else
			status[:branch] = branch
		end
	end

	function changed1!(buffer, status)
		state = field(buffer)

		_submodule = field(buffer)
		_mode_head = field(buffer)
		_mode_indx = field(buffer)
		_mode_tree = field(buffer)
		_name_head = field(buffer)
		_name_indx = field(buffer)

		path = field(buffer, '\0')

		key = get(ACTIONS1, state, :ERROR)
		if key === :ERROR
			warn("Unrecognised state ($(stacktrace()[1].func)): $state")
		elseif key !== :UNCHANGED
			push!(status[key], path)
		end
	end

	function changed2!(buffer, status)
		state = field(buffer)

		_submodule = field(buffer)
		_mode_head = field(buffer)
		_mode_indx = field(buffer)
		_mode_tree = field(buffer)
		_name_head = field(buffer)
		_name_indx = field(buffer)
		_sim_score = field(buffer)

		target = field(buffer, '\0')
		source = field(buffer, '\0')

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
		_state = field(buffer)
		_submodule = field(buffer)
		_mode_stage1 = field(buffer)
		_mode_stage2 = field(buffer)
		_mode_stage3 = field(buffer)
		_name_stage1 = field(buffer)
		_name_stage2 = field(buffer)
		_name_stage3 = field(buffer)

		path = field(buffer, '\0')
		push!(status[:unmerged], path)
	end

	function untracked!(buffer, status)
		push!(status[:untracked], field(buffer, '\0'))
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

	print_with_color(:yellow, io, status.branch)

	if status.ahead > 0 || status.behind > 0
		print(io, " ")
		print_with_color(:green, io, SYMBOLS[:ahead], status.ahead)
		print_with_color(:red, io, SYMBOLS[:behind], status.behind)
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
			print_with_color(colour, io, SYMBOLS[field])
		end
	end
end

function Base.show(io::IO, ::MIME"text/plain", status::Git)
	for (field, colour) in zip(
			[:branch, :ahead, :behind, :added, :copied, :deleted, :modified, :renamed, :unmerged, :untracked],
			[:yellow, :green, :red, :red, :yellow, :green, :cyan, :blue, :magenta, :white],
	)
		# TODO: Print the sets as an indented, ordered list.
		name = String(field)
		print_with_color(colour, io, SYMBOLS[field], " ", titlecase(name), " ", " " ^ (9 - length(name)), getfield(status, field), '\n')
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
	pwd = if status.pwd == homedir() || status.pwd == readlink(homedir())
		"~"
	elseif startswith(status.pwd, homedir())
		joinpath("~", relpath(status.pwd, homedir()))
	elseif startswith(status.pwd, readlink(homedir()))
		joinpath("~", relpath(status.pwd, readlink(homedir())))
	else
		status.pwd
	end

	user_colour = status.root ? :red : :green
	user_symbol = status.root ? :ROOT : :USER

	print(io, "[")

	print_with_color(user_colour, io, status.user)
	print(io, SYMBOLS[:HOST])
	print_with_color(:magenta, io, status.host)
	print(io, SYMBOLS[:DIRECTORY])
	print_with_color(:blue, io, pwd)

	if isrepo(status.git)
		print(io, " | git:", status.git)
	end

	print(io, "] ")

	print_with_color(user_colour, io, SYMBOLS[user_symbol])
end

function Base.show(io::IO, m::MIME"text/plain", status::System)
	if status.root
		print_with_color(:red, io, SYMBOLS[:ROOT], " Username ", " " ^ 9, status.user, '\n')
	else
		print_with_color(:green, io, SYMBOLS[:USER], " Username ", " " ^ 9, status.user, '\n')
	end

	print_with_color(:magenta, io, SYMBOLS[:HOST], " Hostname ", " " ^ 9, status.host, '\n')
	print_with_color(:blue, io, SYMBOLS[:DIRECTORY], " Working Directory ", status.pwd, '\n')

	b = IOBuffer()
	Base.show(b, m, status.git)
	seekstart(b)
	git = readlines(b)

	println(io, "Git:")
	for line in git
		println(io, '\t', line)
	end
end

end
