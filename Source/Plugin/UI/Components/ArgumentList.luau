local fluid = require("../../../Packages/fluid")
local Arguments = require("../../Core/Arguments")
local BooleanArgument = require("./BooleanArgument")
local LayoutFrame = require("./LayoutFrame")
local ListLayout = require("./ListLayout")
local NumberArgument = require("./NumberArgument")
local Padding = require("./Padding")
local StringArgument = require("./StringArgument")

local function ArgumentList(props: {
	Position: fluid.UsedAs<UDim2>?,
	Size: fluid.UsedAs<UDim2>,
	AutomaticSize: fluid.UsedAs<Enum.AutomaticSize>?,
	Arguments: fluid.UsedAs<{Arguments.Argument}>,

	[number]: Instance,
})
	return LayoutFrame {
		Position = props.Position,
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,

		Padding(6),

		ListLayout {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Vertical,
		},

		fluid.for_keys(props.Arguments, function(argumentSource, i)
			local argument: Arguments.Argument = argumentSource()
			if typeof(argument.Default) == "string" then
				return StringArgument {
					Name = fluid.source(argument.Name),
					Value = fluid.source(argument.Default),
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
				}
			elseif typeof(argument.Default) == "number" then
				return NumberArgument {
					Name = fluid.source(argument.Name),
					Value = fluid.source(argument.Default),
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
				}
			elseif typeof(argument.Default) == "boolean" then
				return BooleanArgument {
					Name = fluid.source(argument.Name),
					Value = fluid.source(argument.Default),
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
				}
			end
			return nil :: any
		end) :: any,

		table.unpack(props),
	}
end

return ArgumentList