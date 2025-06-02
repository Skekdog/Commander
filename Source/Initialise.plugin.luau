local Toolbar = require("./Plugin/Toolbar")
local Widget = require("./Plugin/Widget2")

Toolbar.OnClick = function()
	Widget.ToggleWidget()
end