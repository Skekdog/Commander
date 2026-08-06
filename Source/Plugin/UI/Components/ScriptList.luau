local fluid = require("../../../Packages/fluid")
local LayoutFrame = require("./LayoutFrame")
local ListLayout = require("./ListLayout")
local ScriptEntry = require("./ScriptEntry")

local function ScriptList(props: {
	Scripts: () -> {ModuleScript},
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>?,
	ActiveScript: fluid.Source<ModuleScript>,
})
	return LayoutFrame {
		Size = props.Size,
		Position = props.Position,

		Padding = 2,

		ListLayout {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 2)
		},

		fluid.for_keys(props.Scripts, function(instance, i)
			return ScriptEntry {
				Script = instance(),
				Activated = function()
					props.ActiveScript(instance())
				end,
			}
		end) :: any,
	}
end

return ScriptList