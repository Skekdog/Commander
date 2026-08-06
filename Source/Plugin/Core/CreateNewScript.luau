local ScriptEditorService = game:GetService("ScriptEditorService")
local DefaultScript = require("./DefaultScript")
local ScriptFile = require("./ScriptFile")

local UNTITLED_SCRIPT = "Untitled Script"

local function CreateNewScript()
	local highestNumber: number?
	for _, v in ScriptFile.GetScripts() do
		if v.Name:sub(1, #UNTITLED_SCRIPT) == UNTITLED_SCRIPT then
			local number = tonumber(v.Name:sub(#UNTITLED_SCRIPT + 1)) or 0
			if not highestNumber or number > highestNumber then
				highestNumber = number
			end
		end
	end

	local newScript = ScriptFile.AddScript("Untitled Script" .. (if highestNumber then highestNumber + 1 else ""), DefaultScript)

	ScriptEditorService:OpenScriptDocumentAsync(newScript)
end

return CreateNewScript