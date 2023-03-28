VERSION = "1.0.0"

local micro = import("micro")
local config = import("micro/config")
local filepath = import("path/filepath")
local shell = import("micro/shell")

function init()
    micro.SetStatusInfoFn("microblame.blame")
    config.AddRuntimeFile("microblame", config.RTHelp, "help/microblame.md")
end

function blame(b)
	local line = tostring(b:GetActiveCursor().Y + 1)
	local _, fileName = filepath.Split(b.AbsPath)
	local sha = fetchSha(line, fileName)
	local blame = fetchLog(sha)
	return blame
end


function fetchLog(sha)
	if sha == "0000000000000000000000000000000000000000" then
		return "Not Committed Yet"
	end

	local log, err = shell.ExecCommand("git", "--no-pager", "log", "-1", "--pretty=format:'%an (%cd) %s'", "--date=relative", sha)
	if err ~= nil then
		return ""
	end
	return log
end

function fetchSha(line, filename)
	local lineRange = string.format("-L%d,%d", line, line)
	local blame, err = shell.ExecCommand("git", "--no-pager", "blame", filename, lineRange, "-l")
	if err ~= nil then
		return ""
	end

	local sha = strSplit(" ", blame)[1]
	return sha
end


function strSplit(delimiter, str)
    local splitTable = {}
    local delimiterPattern = string.format("[^%s]*", delimiter)

    for substr in string.gmatch(str, delimiterPattern) do
        if substr ~= nil and string.len(substr) > 0 then
            table.insert(splitTable, substr)
        end
    end

    return splitTable
end
