
export type AspectRatioParams = {
	Ratio: number?,
	Axis: Enum.DominantAxis?,
	Type: Enum.AspectType?,
}

local function AddAspectRatio<T>(instance: T & Instance, params: AspectRatioParams?): T
	params = params or {} :: AspectRatioParams
	assert(params)

	local aspectRatio = Instance.new("UIAspectRatioConstraint")
	aspectRatio.AspectRatio = params.Ratio or 1
	aspectRatio.DominantAxis = params.Axis or Enum.DominantAxis.Width
	aspectRatio.AspectType = params.Type or Enum.AspectType.FitWithinMaxSize

	aspectRatio.Parent = instance

	return instance
end

return AddAspectRatio