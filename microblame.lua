VERSION = "1.0.0"

local micro = import("micro")
local os = import("os")
local filepath = import("path/filepath")
local shell = import("micro/shell")
local strings = import("strings")

function init()
    micro.SetStatusInfoFn("status.blame")
    config.AddRuntimeFile("microblame", config.RTHelp, "help/microblame.md")
end

function blame(b)
	local line = tostring(b:LinesNum())
	local _, fileName = filepath.Split(b.AbsPath)
	local sha = fetchSha(line, fileName)
	local blame = fetchLog(sha)
	return blame
end


function fetchLog(sha)
	local log, err = shell.ExecCommand("git", "--no-pager", "log", "-1", "--pretty=format:'%an (%cd) %s'", "--date=relative", sha)
	if err ~= nil then
		return ""
	end
end

function fetchSha(line, filename)
	local lineRange = strings.format("-L%s,%s", line, line)
	local sha, err = shell.ExecCommand("git", "--no-pager", "blame", filename, lineRange, "--porcelain")
	if err ~= nil then
		return ""
	end

	return sha 
end
