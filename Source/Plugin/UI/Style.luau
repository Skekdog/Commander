
local styleTargets: {[StyleTarget]: Style} = {}

export type StyleTarget = GuiObject | UIStroke
export type Style = "Default" | {[string]: {Color: Enum.StudioStyleGuideColor, Modifier: Enum.StudioStyleGuideModifier?}}

local function sync(gui: StyleTarget, style: Style, theme: StudioTheme): ()
	if gui:IsA("UIStroke") then
		gui.Color = theme:GetColor(Enum.StudioStyleGuideColor.Border)
	elseif gui:IsA("TextBox") then
		gui.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground)
		gui.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText)
		gui.PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText)
	elseif gui:IsA("TextLabel") then
		gui.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	elseif gui:IsA("TextButton") then
		gui.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button)
		gui.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.ButtonText)
	elseif gui:IsA("ScrollingFrame") then
		gui.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
		gui.BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border)
		gui.ScrollBarImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border) -- there is a dedicated ScrollBar colour, but it's no good on light mode.
	else
		gui.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
	end

	if style ~= "Default" then
		for k, v in style do
			(gui :: any)[k] = theme:GetColor(v.Color, v.Modifier)
		end
	end
end

local function syncAll(): ()
	local theme = settings().Studio.Theme
	for gui, style in styleTargets do
		sync(gui, style :: Style, theme)
	end
end

syncAll()
settings().Studio.ThemeChanged:Connect(syncAll)

local function Style(gui: StyleTarget, style: Style?): ()
	styleTargets[gui] = style or "Default" :: "Default"
	sync(gui, style or "Default" :: "Default", settings().Studio.Theme)

	gui.Destroying:Connect(function()
		styleTargets[gui] = nil
	end)
end

return Style