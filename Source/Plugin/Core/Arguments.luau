
local module = {}

export type ArgumentValue = string | number | boolean

export type Argument = {
	Name: string,
	Default: ArgumentValue,
}

local function parseLine(line: string): Argument?
	local originalLine = line
	line = line:gsub("^%s+", "")
	if line:sub(1, 13) ~= "-- COMMANDER " then
		return nil
	end

	line = line:sub(14)

	local name, default = line:match("(%S+)%s+(%S+)")

	if not name then
		warn("Argument definition missing name: '" .. originalLine .. "'")
		warn("Expected format: '-- COMMANDER NAME DEFAULT'")
		return nil
	end

	if not default then
		warn("Argument definition missing default: '" .. originalLine .. "'")
		warn("Expected format: '-- COMMANDER NAME DEFAULT'")
		return nil
	end

	local success, err: string? = pcall(function()
		Instance.new("ModuleScript"):SetAttribute(name, false)
		return nil
	end)

	if not success then
		warn("Invalid argument name: '" .. originalLine .. "'")
		warn(err)
		return nil
	end

	if default == "true" or default == "false" then
		default = default == "true"
	elseif tonumber(default) then
		default = tonumber(default) :: number
	end

	return {
		Name = name,
		Default = default,
	}
end

function module.GetDefinedArguments(source: string): {Argument}
	local arguments: {Argument} = {}

	local lines = source:split("\n")
	for _, line in lines do
		table.insert(arguments, parseLine(line))
	end

	return arguments
end

return module