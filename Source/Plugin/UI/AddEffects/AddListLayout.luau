
export type ListLayoutParams = {
	Padding: UDim,
	FillDirection: Enum.FillDirection,
	HorizontalFlex: Enum.UIFlexAlignment?,
	VerticalFlex: Enum.UIFlexAlignment?,
	HorizontalAlignment: Enum.HorizontalAlignment,
	VerticalAlignment: Enum.VerticalAlignment,
}

local function AddListLayout<T>(instance: T & Instance, params: ListLayoutParams): T
	local listLayout = Instance.new("UIListLayout")

	listLayout.Padding = params.Padding
	listLayout.FillDirection = params.FillDirection
	listLayout.HorizontalFlex = params.HorizontalFlex or Enum.UIFlexAlignment.None
	listLayout.VerticalFlex = params.VerticalFlex or Enum.UIFlexAlignment.None
	listLayout.HorizontalAlignment = params.HorizontalAlignment
	listLayout.VerticalAlignment = params.VerticalAlignment
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	listLayout.Parent = instance

	return instance
end

return AddListLayout