local GetPlugin = require("../../Lib/GetPlugin")

local function OpenScript(script: ModuleScript): ()
	GetPlugin:OpenScript(script)
end

return OpenScript