
local function AddSizeConstraints<T>(instance: T & Instance, min: Vector2?, max: Vector2?): T
	local uiSizeConstraint = Instance.new("UISizeConstraint")
	uiSizeConstraint.MinSize = min or Vector2.zero
	uiSizeConstraint.MaxSize = max or Vector2.one * math.huge
	uiSizeConstraint.Parent = instance
	return instance
end

return AddSizeConstraints