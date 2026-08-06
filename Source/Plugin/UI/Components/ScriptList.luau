local fluid = require("../../../Packages/fluid")
local OpenScript = require("../../Core/OpenScript")
local LayoutFrame = require("./LayoutFrame")
local ListLayout = require("./ListLayout")
local ScriptEntry = require("./ScriptEntry")

local function ScriptList(props: {
	Scripts: fluid.Source<{ModuleScript}>,
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

		fluid.for_values(props.Scripts, function(instance)
			return ScriptEntry {
				Script = instance,
				Activated = function()
					if props.ActiveScript() == instance then
						return OpenScript(instance)
					end
					props.ActiveScript(instance)
				end,
			}
		end) :: any,
	}
end

return ScriptList