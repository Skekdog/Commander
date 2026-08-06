local fluid = require("../../../Packages/fluid")

local function ListLayout(props: {
	FillDirection: fluid.UsedAs<Enum.FillDirection>,
	HorizontalAlignment: fluid.UsedAs<Enum.HorizontalAlignment>,
	VerticalAlignment: fluid.UsedAs<Enum.VerticalAlignment>,
	Padding: fluid.UsedAs<UDim>?,

	HorizontalFlex: fluid.UsedAs<Enum.UIFlexAlignment>?,
	VerticalFlex: fluid.UsedAs<Enum.UIFlexAlignment>?,
})
	return fluid.create "UIListLayout" {
		FillDirection = props.FillDirection,
		HorizontalAlignment = props.HorizontalAlignment,
		VerticalAlignment = props.VerticalAlignment,
		Padding = props.Padding,

		HorizontalFlex = props.HorizontalFlex,
		VerticalFlex = props.VerticalFlex,

		SortOrder = Enum.SortOrder.LayoutOrder,
	}
end

return ListLayout