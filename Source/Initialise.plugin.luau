local Toolbar = require("./Plugin/Toolbar")

Toolbar.OnClick = function()
	local Widget = require("./Plugin/Widget")
	Widget.ToggleWidget()
end