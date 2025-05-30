local ChangeHistoryService = game:GetService("ChangeHistoryService")
local HttpService = game:GetService("HttpService")
local GetPlugin = require("../Lib/GetPlugin")
local Highlighter = require(script.Parent.Parent.Lib.Highlighter) -- Luau lsp doesn't correctly handle string requires with rojo projects yet (init files?) correctly yet

Highlighter.matchStudioSettings()

local plugin = GetPlugin

local module = {}

local colourSyncTargets: {GuiObject | UIStroke} = {}

local widget = plugin:CreateDockWidgetPluginGui("Commander", DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	true,
	800,
	350,
	600,
	350
	)
)

widget.Name = "Commander"
widget.Title = "Commander"
widget.ResetOnSpawn = false
widget.Enabled = false

local executeButton: TextButton

-- This is not a comprehensive function and it should be updated if new ui objects are added
local function syncOne(v: GuiObject | UIStroke, theme: any, noSyncPrimarySelection: boolean?)
	if v:IsA("UIStroke") then
		v.Color = theme:GetColor(Enum.StudioStyleGuideColor.Border)
	elseif v:IsA("GuiObject") then
		if v == executeButton and v:IsA("TextButton") then
			v.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Disabled)
			v.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.ButtonText, Enum.StudioStyleGuideModifier.Disabled)
		elseif v:IsA("TextBox") then
			v.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground)
			v.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText)
			v.PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText)
		elseif v:IsA("TextLabel") then
			v.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText)
		elseif v:IsA("TextButton") then
			v.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button)
			v.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.ButtonText)
		elseif v:IsA("ScrollingFrame") then
			v.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
			v.BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border)
			v.ScrollBarImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border) -- there is a dedicated ScrollBar colour, but it's no good on light mode.
		else
			v.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
		end
	end
end

local frame = Instance.new("Frame")
frame.BackgroundTransparency = 1
frame.Size = UDim2.fromScale(1, 1)

local codeBoxFrame = Instance.new("ScrollingFrame")
codeBoxFrame.Name = "CodeScroll"

codeBoxFrame.Position = UDim2.new(0.2, 4, 0, 4)
codeBoxFrame.Size = UDim2.new(0.8, -8, 0.8, -8)

codeBoxFrame.ClipsDescendants = true
codeBoxFrame.BackgroundTransparency = 1
codeBoxFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
codeBoxFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
codeBoxFrame.AutomaticCanvasSize = Enum.AutomaticSize.XY
codeBoxFrame.ScrollBarThickness = 4
codeBoxFrame.CanvasSize = UDim2.new()

do
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 2)
	uiPadding.PaddingRight = UDim.new(0, 2)
	uiPadding.PaddingTop = UDim.new(0, 2)
	uiPadding.PaddingBottom = UDim.new(0, 2)
	uiPadding.Parent = codeBoxFrame
end

table.insert(colourSyncTargets, codeBoxFrame)

codeBoxFrame.Parent = frame

local codeBox = Instance.new("TextBox")
codeBox.Name = "Code"

codeBox.TextColor3 = Color3.new(1, 1, 1)
codeBox.TextSize = 18

codeBox.Font = Enum.Font.RobotoMono
codeBox.PlaceholderText = ""
codeBox.Text = ""

codeBox.Size = UDim2.fromScale(1, 1)

codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.AutomaticSize = Enum.AutomaticSize.XY

codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true

Highlighter.highlight({
	textObject = codeBox,
})

do
    local uiCorner = Instance.new("UICorner")
    uiCorner.Parent = codeBox

    local uiStroke = Instance.new("UIStroke")
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(colourSyncTargets, uiStroke)
    uiStroke.Parent = codeBox

    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 8)
    uiPadding.PaddingTop = UDim.new(0, 8)
	uiPadding.Parent = codeBox
end

table.insert(colourSyncTargets, codeBox)
codeBox.Parent = codeBoxFrame

do
	local warningLabel = Instance.new("TextLabel")
	warningLabel.Name = "WarningLabel"

	warningLabel.Font = Enum.Font.SourceSans
	warningLabel.Text = "NOTE: Be careful when using Instance:Destroy(), as it is not possible to undo this! Instead, consider using Instance.Parent = nil."
	warningLabel.TextScaled = true

	warningLabel.Position = UDim2.new(0, 4, 0.825, 0)
	warningLabel.Size = UDim2.new(0.55, -8, 0.15, -4)

	warningLabel.BackgroundTransparency = 1

	warningLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	table.insert(colourSyncTargets, warningLabel)
	warningLabel.Parent = frame
end

executeButton = Instance.new("TextButton")
executeButton.Name = "Execute"

executeButton.BackgroundColor3 = Color3.fromRGB(0, 197, 23)

executeButton.Font = Enum.Font.SourceSans
executeButton.Text = "▶ Execute"
executeButton.TextColor3 = Color3.new(1, 1, 1)

executeButton.Size = UDim2.fromScale(0.2, 0.15)
executeButton.Position = UDim2.new(0.8, -4, 0.9, 0)
executeButton.AnchorPoint = Vector2.new(0, 0.5)
executeButton.TextScaled = true

do
    local uiCorner = Instance.new("UICorner")
    uiCorner.Parent = executeButton

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingBottom = UDim.new(0, 5)
	uiPadding.PaddingTop = UDim.new(0, 5)
	uiPadding.PaddingLeft = UDim.new(0, 5)
	uiPadding.PaddingRight = UDim.new(0, 5)
	uiPadding.Parent = executeButton
end

executeButton.Parent = frame

local presetsFrame = Instance.new("ScrollingFrame")
presetsFrame.Name = "Presets"

presetsFrame.ScrollBarThickness = 4
presetsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
presetsFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always

presetsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
presetsFrame.CanvasSize = UDim2.new()
presetsFrame.Size = UDim2.new(0.2, -8, 0.8, -8)
presetsFrame.Position = UDim2.fromOffset(4, 4)

do
	local uiCorner = Instance.new("UICorner")
	uiCorner.Parent = presetsFrame

	local uiGridLayout = Instance.new("UIGridLayout")
	uiGridLayout.CellSize = UDim2.fromScale(1, 0.2)
	uiGridLayout.Parent = presetsFrame

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 2)
	uiPadding.PaddingTop = UDim.new(0, 2)
	uiPadding.PaddingRight = UDim.new(0, 2)
	uiPadding.PaddingBottom = UDim.new(0, 2)
	uiPadding.Parent = presetsFrame
end

table.insert(colourSyncTargets, presetsFrame)
presetsFrame.Parent = frame

type Presets = {
	[string]: string?,
}

local function getPresets(): Presets
	local presets = plugin:GetSetting("Presets")
	if not presets then
		return {
			["Hello, World!"] = 'print("Hello, World!")',
		}
	end
	return HttpService:JSONDecode(plugin:GetSetting("Presets"))
end

local function updatePreset(name: string, code: string?): ()
	local presets = getPresets()
	presets[name] = code

	plugin:SetSetting("Presets", HttpService:JSONEncode(presets))
end

local function loadPreset(name: string): ()
	local data = getPresets()
	if not data then
		return warn("Failed to load preset " .. name)
	end

	local code = data[name]
	if not code then
		return warn("Failed to load preset " .. name)
	end

	local preset = code
	codeBox.Text = preset
end

local function createPresetButton(name: string): ()
	local button = Instance.new("TextButton")
	button.Name = "Preset_" .. name

	button.Font = Enum.Font.SourceSans
	button.Text = name
	
	button.TextScaled = true

	do
		local uiCorner = Instance.new("UICorner")
		uiCorner.Parent = button

		local uiStroke = Instance.new("UIStroke")
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		table.insert(colourSyncTargets, uiStroke)
		syncOne(uiStroke, settings().Studio.Theme)
		uiStroke.Parent = button
	end

	button.MouseButton1Click:Connect(function()
		loadPreset(name)
	end)

	button.MouseButton2Click:Connect(function()
		updatePreset(name, nil)
		button:Destroy()
	end)

	table.insert(colourSyncTargets, button)
	syncOne(button, settings().Studio.Theme)
	button.Parent = presetsFrame
end

local function saveAsPreset(name: string)
	if not getPresets()[name] then
		createPresetButton(name)
	end
	updatePreset(name, codeBox.Text)
end

for i in getPresets() do
	createPresetButton(i)
end

local saveAs = Instance.new("TextBox")
saveAs.Name = "SaveAs"

saveAs.Font = Enum.Font.SourceSans
saveAs.Text = ""
saveAs.PlaceholderText = "Save as..."

saveAs.AnchorPoint = Vector2.new(0, 0.5)
saveAs.Position = UDim2.new(0.575, -4, 0.9, 0)
saveAs.Size = UDim2.fromScale(0.2, 0.15)
saveAs.TextScaled = true

do
	local uiCorner = Instance.new("UICorner")
    uiCorner.Parent = saveAs

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingBottom = UDim.new(0, 5)
	uiPadding.PaddingTop = UDim.new(0, 5)
	uiPadding.PaddingLeft = UDim.new(0, 5)
	uiPadding.PaddingRight = UDim.new(0, 5)
	uiPadding.Parent = saveAs

	local uiStroke = Instance.new("UIStroke")
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(colourSyncTargets, uiStroke)
    uiStroke.Parent = saveAs
end

table.insert(colourSyncTargets, saveAs)
saveAs.Parent = frame

saveAs.FocusLost:Connect(function(enterPressed)
	if not enterPressed or saveAs.Text == "" then
		return
	end

	saveAsPreset(saveAs.Text)
end)

frame.Parent = widget

executeButton.Activated:Connect(function()
	local recording: string?
	
	recording = ChangeHistoryService:TryBeginRecording("Execute commander code")
	if not recording then
		return warn("Unable to create undo waypoint, possibly due to another execution already in progress. Execution aborted.")
	end

	local code = codeBox.Text

	local success, result = pcall(function(): (any, any)
		local exec, err = loadstring(code)
		if not exec then
			return error(err or "Unknown error occured")
		end
		return exec()
	end)

	if not success then
		warn(result)
	end

	if recording then
		ChangeHistoryService:FinishRecording(recording, if success then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
	end
end)

local function syncColours()
	local theme = settings().Studio.Theme
	for _, v in colourSyncTargets do
		syncOne(v, theme)
	end
end

syncColours()
settings().Studio.ThemeChanged:Connect(syncColours)

function module.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled

	if widget.Enabled then
		codeBox:CaptureFocus()
	end
end

module.Widget = widget

return module