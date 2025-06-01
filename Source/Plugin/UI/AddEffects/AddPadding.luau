
export type PaddingParams = {
	Left: UDim,
	Right: UDim,
	Top: UDim,
	Bottom: UDim,
}

local function AddPadding<T>(instance: T & Instance, params: PaddingParams): T
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = params.Left
	padding.PaddingRight = params.Right
	padding.PaddingTop = params.Top
	padding.PaddingBottom = params.Bottom
	padding.Parent = instance
	return instance
end

return AddPadding