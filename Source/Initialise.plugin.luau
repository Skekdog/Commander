local Toolbar = require("./Plugin/Toolbar")

require("./Plugin/Core/ScriptFile") -- this is to load the toolbar buttons

local Widget = require("./Plugin/Widget")
Widget.ToggleWidget()

Toolbar.OnClick = function()
	local Widget = require("./Plugin/Widget")
	Widget.ToggleWidget()
end