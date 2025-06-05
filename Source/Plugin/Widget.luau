local ScriptEditorService = game:GetService("ScriptEditorService")
local GetPlugin = require("../Lib/GetPlugin")
local Execute = require("./Core/Execute")
local Presets = require("./Core/Presets")
local ActiveScripts = require("./Core/ActiveScripts")
local BackgroundFrame = require("./UI/BackgroundFrame")
local BaseGui = require("./UI/BaseGui")
local BaseText = require("./UI/BaseText")
local Prompt = require("./UI/Prompt")
local ScrollFrame = require("./UI/ScrollFrame")
local Style = require("./UI/Style")

local plugin = GetPlugin

local module = {}

local widget = plugin:CreateDockWidgetPluginGui("Commander", DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	true,
	800,
	400,
	600,
	350
	)
)

widget.Name = "Commander"
widget.Title = "Commander"
widget.ResetOnSpawn = false
widget.Enabled = false

local frame = BackgroundFrame({
	CornerRadius = UDim.new(0, 0),
	PaddingParams = {
		Left = UDim.new(0, 5),
		Right = UDim.new(0, 5),
		Top = UDim.new(0, 5),
		Bottom = UDim.new(0, 5),
	},

	Size = UDim2.fromScale(1, 1),

	Name = "MainFrame", -- we're hacking into the mainframe!!!
	Parent = widget,
})

local savedScriptsFrame = BackgroundFrame({
	PaddingParams = {
		Left = UDim.new(0, 5),
		Right = UDim.new(0, 5),
		Top = UDim.new(0, 5),
		Bottom = UDim.new(0, 5),
	},
	Size = UDim2.new(0.5, -5, 1, 0),

	AutomaticSize = Enum.AutomaticSize.Y,

	Name = "SavedScriptsFrame",
	Parent = frame :: Instance,
})

local addScriptButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(1, 0.1),
		Position = UDim2.fromScale(0, 0.9),

		Style = {
			BackgroundColor3 = {
				Color = Enum.StudioStyleGuideColor.MainButton,
			},
			TextColor3 = {
				Color = Enum.StudioStyleGuideColor.BrightText,
			},
		},

		Name = "AddScriptButton",
		Parent = savedScriptsFrame :: Instance,
	},

	Text = "+",
})

local savedScriptsScrollHolder = BackgroundFrame({
	PaddingParams = {
		Left = UDim.new(0, 2),
		Right = UDim.new(0, 0),
		Top = UDim.new(0, 2),
		Bottom = UDim.new(0, 2),
	},
	Size = UDim2.new(1, 0, 0.9, -5),
	Transparency = 1,

	Name = "SavedScriptsScrollHolder",
	Parent = savedScriptsFrame :: Instance,
})

savedScriptsScrollHolder.ClipsDescendants = true

local savedScriptsScroll = ScrollFrame({
	BaseGui = {
		Size = UDim2.fromScale(1, 1),

		Transparency = 1,

		Name = "SavedScriptsFrame",
		Parent = savedScriptsScrollHolder,
	},

	HorizontalScrollBarInset = Enum.ScrollBarInset.None,
})

savedScriptsScroll.ClipsDescendants = false

do
	local gridLayout = Instance.new("UIGridLayout")

	gridLayout.CellSize = UDim2.fromScale(1, 0.1)
	gridLayout.CellPadding = UDim2.fromOffset(5, 5)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

	gridLayout.Parent = savedScriptsScroll :: Instance
end

local RUN_ICON = Content.fromAssetId(8517323790)
local EDIT_ICON = Content.fromAssetId(15911231575)
local DELETE_ICON = Content.fromAssetId(11768918600)

type SavedScriptButton = TextButton & {
	["TitleLabel"]: TextLabel,
	["DeleteButton"]: ImageButton,
	["RunButton"]: ImageButton,
	["EditButton"]: ImageButton,
}

local savedScriptButton = (BaseText(Instance.new("TextButton"), {
	BaseGui = {
		PaddingParams = {
			Left = UDim.new(0, 1),
			Right = UDim.new(0, 1),
			Top = UDim.new(0, 1),
			Bottom = UDim.new(0, 1),
		}
	}
}) :: any) :: SavedScriptButton

do
	local deleteButton = BaseGui(Instance.new("ImageButton"), {
		CornerRadius = UDim.new(0, 0),
		Position = UDim2.fromScale(0.875, 0.5),
		Size = UDim2.fromScale(0.125, 1),

		AnchorPoint = Vector2.new(0, 0.5),

		Transparency = 1,

		Name = "DeleteButton",
		Parent = savedScriptButton,
	})

	deleteButton.ImageContent = DELETE_ICON
	deleteButton.ScaleType = Enum.ScaleType.Fit

	local runButton = BaseGui(Instance.new("ImageButton"), {
		CornerRadius = UDim.new(0, 0),
		Position = UDim2.fromScale(0.625, 0.5),
		Size = UDim2.fromScale(0.125, 1),

		AnchorPoint = Vector2.new(0, 0.5),

		Transparency = 1,

		Name = "RunButton",
		Parent = savedScriptButton,
	})

	runButton.ImageContent = RUN_ICON
	runButton.ScaleType = Enum.ScaleType.Fit

	local editButton = BaseGui(Instance.new("ImageButton"), {
		CornerRadius = UDim.new(0, 0),
		Position = UDim2.fromScale(0.75, 0.5),
		Size = UDim2.fromScale(0.125, 1),

		AnchorPoint = Vector2.new(0, 0.5),

		Transparency = 1,

		Name = "EditButton",
		Parent = savedScriptButton,
	})

	editButton.ImageContent = EDIT_ICON
	editButton.ScaleType = Enum.ScaleType.Fit

	BaseText(Instance.new("TextLabel"), {
		BaseGui = {
			CornerRadius = UDim.new(0, 0),
			Size = UDim2.fromScale(0.625, 1),
			PaddingParams = {
				Left = UDim.new(0, 4),
				Right = UDim.new(0, 4),
				Top = UDim.new(0, 0),
				Bottom = UDim.new(0, 0),
			},

			Transparency = 1,

			Name = "TitleLabel",
			Parent = savedScriptButton :: Instance,
		},

		TextXAlignment = Enum.TextXAlignment.Left,
	})
end

local codeActionsFrame = BackgroundFrame({
	PaddingParams = {
		Left = UDim.new(0, 5),
		Right = UDim.new(0, 5),
		Top = UDim.new(0, 5),
		Bottom = UDim.new(0, 5),
	},

	Size = UDim2.fromScale(0.5, 1),
	Position = UDim2.fromScale(0.5, 0),

	Name = "CodeActionsFrame",
	Parent = frame,
})

local editorTitle = BaseText(Instance.new("TextBox"), {
	BaseGui = {
		Size = UDim2.new(1, 0, 0.1, 8),

		PaddingParams = {
			Left = UDim.new(0, 0),
			Right = UDim.new(0, 0),
			Top = UDim.new(0, 5),
			Bottom = UDim.new(0, 5),
		},

		Name = "EditorTitle",
		Parent = codeActionsFrame,
	},

	Text = "Select a script",
	TextScaled = true,
})

editorTitle.PlaceholderText = "Enter a script name"
editorTitle.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
editorTitle.MultiLine = false
editorTitle.ClearTextOnFocus = false

local function setActiveScript(scriptFile: Script?): ()
	ActiveScripts.ActiveScript = scriptFile
	editorTitle.Text = if scriptFile then scriptFile.Name else "Select a script"
	editorTitle.TextEditable = scriptFile ~= nil
end

editorTitle.FocusLost:Connect(function()
	local scriptFile = ActiveScripts.ActiveScript
	if not scriptFile then
		return
	end

	local newName = editorTitle.Text
	if newName == "" or newName == "Select a script" or newName == scriptFile.Name or ActiveScripts.GetScripts()[newName] then
		editorTitle.Text = scriptFile.Name
		return
	end

	local button = savedScriptsScroll:FindFirstChild(scriptFile.Name .. "_SavedScriptButton") :: SavedScriptButton?
	if button ~= nil then
		button.Name = newName .. "_SavedScriptButton"
		button.TitleLabel.Text = newName
	end

	ActiveScripts.RenameScript(scriptFile, newName)
end)

local function uiPromptDelete(scriptFile: Script): ()
	local name = scriptFile.Name
	local button = savedScriptsScroll:FindFirstChild(name .. "_SavedScriptButton")

	if not button then
		return
	end

	local response: boolean?
	Prompt.ShowConfirmationPrompt(widget, "Delete Script", name, function(confirmed)
		response = confirmed == "OK"
	end)

	while response == nil do
		task.wait()
	end

	if not response then
		return
	end

	ActiveScripts.RemoveScript(name)
	Presets.DeletePreset(name)
	button:Destroy()

	if ActiveScripts.ActiveScript == scriptFile then
		setActiveScript(nil)
	end
end

local function uiEdit(scriptFile: Script): ()
	plugin:OpenScript(scriptFile)
end

local function uiExecute(scriptFile: Script): ()
	Execute(ScriptEditorService:GetEditorSource(scriptFile))
end

local function addSavedScript(scriptFile: Script): ()
	local name = scriptFile.Name

	local button = savedScriptButton:Clone()

	button.TitleLabel.Text = name
	button.Name = name .. "_SavedScriptButton"

	button.Activated:Connect(function()
		if ActiveScripts.ActiveScript == scriptFile then
			uiEdit(scriptFile)
		end
		setActiveScript(scriptFile)
	end)

	button.DeleteButton.Activated:Connect(function()
		uiPromptDelete(scriptFile)
	end)

	button.RunButton.Activated:Connect(function()
		uiExecute(scriptFile)
	end)

	button.EditButton.Activated:Connect(function()
		uiEdit(scriptFile)
	end)

	Style(button)
	Style(button.TitleLabel)
	Style(button.DeleteButton, {
		ImageColor3 = {
			Color = Enum.StudioStyleGuideColor.ErrorText,
		}
	})
	Style(button.RunButton, {
		ImageColor3 = {
			Color = Enum.StudioStyleGuideColor.InfoText,
		}
	})
	Style(button.EditButton, {
		ImageColor3 = {
			Color = Enum.StudioStyleGuideColor.BrightText,
		}
	})
	button.Parent = savedScriptsScroll :: Instance
end

local UNTITLED_SCRIPT = "Untitled Script"
addScriptButton.Activated:Connect(function()
	local highestNumber: number?
	for _, v in ActiveScripts.GetScripts() do
		if v.Name:sub(1, #UNTITLED_SCRIPT) == UNTITLED_SCRIPT then
			local number = tonumber(v.Name:sub(#UNTITLED_SCRIPT + 1)) or 0
			if not highestNumber or number > highestNumber then
				highestNumber = number
			end
		end
	end

	local newScript = ActiveScripts.AddScript("Untitled Script" .. (if highestNumber then highestNumber + 1 else ""), "print(\"Hello, world!\")")
	addSavedScript(newScript)
	setActiveScript(newScript)
end)

local isFirst = true
for _, scriptFile in ActiveScripts.GetScripts() do
	addSavedScript(scriptFile)
	if isFirst then
		setActiveScript(scriptFile)
		isFirst = false
	end
end

local openButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(0.75, 0.1),
		Position = UDim2.new(0.5, 0, 0.4, 0),
		AnchorPoint = Vector2.new(0.5, 0),

		Name = "OpenButton",
		Parent = codeActionsFrame :: Instance,
	},

	Text = "Open",
})

openButton.Activated:Connect(function()
	if not ActiveScripts.ActiveScript then
		return
	end
	uiEdit(ActiveScripts.ActiveScript)
end)

local executeButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(0.75, 0.1),
		Position = UDim2.new(0.5, 0, 0.5, 5),
		AnchorPoint = Vector2.new(0.5, 0),

		Name = "ExecuteButton",
		Parent = codeActionsFrame :: Instance,

		Style = {
			BackgroundColor3 = {
				Color = Enum.StudioStyleGuideColor.MainButton,
			},
			TextColor3 = {
				Color = Enum.StudioStyleGuideColor.BrightText,
			},
		}
	},

	Text = "Execute!",
})

executeButton.Activated:Connect(function()
	if not ActiveScripts.ActiveScript then
		return
	end
	uiExecute(ActiveScripts.ActiveScript)
end)

frame.Parent = widget

function module.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled
end

module.Widget = widget

return module