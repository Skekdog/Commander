local Selection = game:GetService("Selection")
local GetPlugin = require("../../Lib/GetPlugin")

local function SaveToDisk(scriptFile: ModuleScript): ()
	local lastSelection = Selection:Get()

	Selection:Set({scriptFile})
	GetPlugin:PromptSaveSelection(scriptFile.Name)

	Selection:Set(lastSelection)
end

return SaveToDisk