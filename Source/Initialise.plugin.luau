local Toolbar = require("./Plugin/Toolbar")

require("./Plugin/Core/ScriptFile")

Toolbar.OnClick = function()
	local Widget = require("./Plugin/Widget")
	Widget.ToggleWidget()
end