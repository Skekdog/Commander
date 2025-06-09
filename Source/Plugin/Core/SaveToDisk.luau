local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")
local GetPlugin = require("../../Lib/GetPlugin")

local function SaveToDisk(name: string, code: string): ()
	local lastSelection = Selection:Get()

	local newScript = Instance.new("ModuleScript")
	newScript.Source = code
	newScript.Parent = RunService

	Selection:Set({newScript})
	GetPlugin:PromptSaveSelection(name)

	newScript:Destroy()
	Selection:Set(lastSelection)
end

return SaveToDisk