
local function AddCorners<T>(instance: T & Instance, radius: UDim?): T
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = radius or UDim.new(0, 8)
	uiCorner.Parent = instance
	return instance
end

return AddCorners