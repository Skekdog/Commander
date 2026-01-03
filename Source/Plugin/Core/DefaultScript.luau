local Arguments = require("./Arguments")
local ToolbarButton = require("./ToolbarButton")

export type ScriptData = {
	Source: string,
	Arguments: {[string]: Arguments.ArgumentValue},
	ToolbarButton: ToolbarButton.Parameters?,
}

local helloWorldSource = [[
-- You can use comments in this format to add arguments to your script
-- Value can be a string, number, or boolean
-- COMMANDER Name DefaultValue

-- Arguments can then be retrieved using GETARG("Name")
print(GETARG("Name"))
]]

local helloWorldArguments: {[string]: Arguments.ArgumentValue} = {
	Name = "Hello, World!",
}

local DefaultScript: ScriptData & {Name: string} = {
	Name = "Hello, World!",
	Source = helloWorldSource,
	Arguments = helloWorldArguments,
}

return DefaultScript