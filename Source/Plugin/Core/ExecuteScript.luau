local ScriptEditorService = game:GetService("ScriptEditorService")
local Execute = require("./Execute")

local function ExecuteScript(script: ModuleScript): ()
	Execute(ScriptEditorService:GetEditorSource(script), script:GetAttributes(), script.Name)
end

return ExecuteScript