local ScriptEditorService = game:GetService("ScriptEditorService")
local GetPlugin = require("../Lib/GetPlugin")
local Execute = require("./Core/Execute")
local ScriptFile = require("./Core/ScriptFile")
local Arguments = require("./Core/Arguments")
local CodeContainsDestroy = require("./Core/CodeContainsDestroy")
local DefaultScript = require("./Core/DefaultScript")
local ToolbarButton = require("./Core/ToolbarButton")
local AddAspectRatio = require("./UI/AddEffects/AddAspectRatio")
local AddListLayout = require("./UI/AddEffects/AddListLayout")
local BackgroundFrame = require("./UI/BackgroundFrame")
local BaseGui = require("./UI/BaseGui")
local BaseText = require("./UI/BaseText")
local InputUI = require("./UI/InputUI")
local Prompt = require("./UI/Prompt")
local ScrollFrame = require("./UI/ScrollFrame")
local Style = require("./UI/Style")

local plugin = GetPlugin

local module = {}

local activeScript: ModuleScript?

local widget = plugin:CreateDockWidgetPluginGuiAsync("Commander", DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	true,
	600,
	350,
	250,
	150
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

	LayoutOrder = -1,

	Name = "MainFrame", -- we're hacking into the mainframe!!!
	Parent = widget,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 4)
	listLayout.Parent = frame
end

local savedScriptsFrame = BackgroundFrame({
	PaddingParams = {
		Left = UDim.new(0, 5),
		Right = UDim.new(0, 5),
		Top = UDim.new(0, 5),
		Bottom = UDim.new(0, 5),
	},
	Size = UDim2.new(0.5, -5, 1, 0),

	Name = "SavedScriptsFrame",
	Parent = frame :: Instance,
})

local addScriptButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(1, 0.1),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),

		SizeConstraints = {
			Max = Vector2.new(math.huge, 40),
		},

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
		ZIndex = 2, -- Otherwise the button strokes overlap the scrollbar

		Transparency = 1,

		Name = "SavedScriptsFrame",
		Parent = savedScriptsScrollHolder :: Instance,
	},

	HorizontalScrollBarInset = Enum.ScrollBarInset.None,
})

savedScriptsScroll.ClipsDescendants = false

do
	local gridLayout = Instance.new("UIListLayout")

	gridLayout.Padding = UDim.new(0, 5)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

	gridLayout.Parent = savedScriptsScroll :: Instance
end

local RUN_ICON = Content.fromAssetId(8517323790)
local EDIT_ICON = Content.fromAssetId(15911231575)
local DELETE_ICON = Content.fromAssetId(11768918600)

type SavedScriptButton = {
	["TitleLabel"]: TextLabel,
	["DeleteButton"]: ImageButton,
	["RunButton"]: ImageButton,
	["EditButton"]: ImageButton,
} & TextButton

local savedScriptButton = (BaseText(Instance.new("TextButton"), {
	BaseGui = {
		PaddingParams = {
			Left = UDim.new(0, 1),
			Right = UDim.new(0, 9),
			Top = UDim.new(0, 1),
			Bottom = UDim.new(0, 1),
		},

		SizeConstraints = {
			Max = Vector2.new(math.huge, 35),
			Min = Vector2.new(0, 15),
		},

		Size = UDim2.fromScale(1, 0.1),
	}
}) :: any) :: SavedScriptButton

AddListLayout(savedScriptButton, {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	HorizontalFlex = Enum.UIFlexAlignment.Fill,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	Padding = UDim.new(0, 4),
})

do
	local deleteButton = BaseGui(Instance.new("ImageButton"), {
		CornerRadius = UDim.new(0, 0),
		Size = UDim2.fromScale(0.125, 1),

		LayoutOrder = 3,

		Transparency = 1,

		Name = "DeleteButton",
		Parent = savedScriptButton,
	})

	AddAspectRatio(deleteButton)

	deleteButton.ImageContent = DELETE_ICON
	deleteButton.ScaleType = Enum.ScaleType.Fit

	local runButton = BaseGui(Instance.new("ImageButton"), {
		CornerRadius = UDim.new(0, 0),
		Size = UDim2.fromScale(0.125, 1),

		LayoutOrder = 1,

		Transparency = 1,

		Name = "RunButton",
		Parent = savedScriptButton,
	})

	AddAspectRatio(runButton)

	runButton.ImageContent = RUN_ICON
	runButton.ScaleType = Enum.ScaleType.Fit

	local editButton = BaseGui(Instance.new("ImageButton"), {
		CornerRadius = UDim.new(0, 0),
		Size = UDim2.fromScale(0.125, 1),

		LayoutOrder = 2,

		Transparency = 1,

		Name = "EditButton",
		Parent = savedScriptButton,
	})

	AddAspectRatio(editButton)

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

	SizeConstraints = {
		Max = Vector2.new(250, math.huge),
	},

	Name = "CodeActionsFrame",
	Parent = frame,
})

AddListLayout(codeActionsFrame, {
	Padding = UDim.new(0, 5),
	VerticalAlignment = Enum.VerticalAlignment.Top,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	FillDirection = Enum.FillDirection.Vertical,
	VerticalFlex = Enum.UIFlexAlignment.Fill,
})

local editorTitle = BaseText(Instance.new("TextBox"), {
	BaseGui = {
		Size = UDim2.new(1, 0, 0.1, 8),

		SizeConstraints = {
			Max = Vector2.new(math.huge, 50),
		},

		PaddingParams = {
			Left = UDim.new(0, 0),
			Right = UDim.new(0, 0),
			Top = UDim.new(0, 2),
			Bottom = UDim.new(0, 2),
		},

		Name = "EditorTitle",
		Parent = codeActionsFrame :: Instance,

		LayoutOrder = 1,
	},

	Text = "Select a script",
	TextScaled = true,
})

editorTitle.PlaceholderText = "Enter a script name"
editorTitle.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
editorTitle.MultiLine = false
editorTitle.ClearTextOnFocus = false

editorTitle.FocusLost:Connect(function()
	if not activeScript then
		return
	end

	local newName = editorTitle.Text
	if newName == "" or newName == "Select a script" or newName == activeScript.Name or ScriptFile.GetScript(newName) then
		editorTitle.Text = activeScript.Name
		return
	end

	local button = savedScriptsScroll:FindFirstChild(activeScript.Name .. "_SavedScriptButton") :: SavedScriptButton?
	if button ~= nil then
		button.Name = newName .. "_SavedScriptButton"
		button.TitleLabel.Text = newName
	end

	activeScript.Name = newName
end)

local argumentsHolder = BackgroundFrame({
	LayoutOrder = 3,

	Size = UDim2.fromScale(1, 1),

	PaddingParams = {
		Left = UDim.new(0, 8),
		Right = UDim.new(0, 8),
		Top = UDim.new(0, 8),
		Bottom = UDim.new(0, 8),
	},

	Name = "ArgumentsHolder",
	Parent = codeActionsFrame,
})

local argumentsFrame = ScrollFrame({
	BaseGui = {
		Size = UDim2.fromScale(1, 1),

		Name = "ArgumentsFrame",
		Parent = argumentsHolder :: Instance,

		NoStroke = true,
		CornerRadius = UDim.new(0, 0),
		Transparency = 1,
	}
})

local actionsFrame = BackgroundFrame({
	Transparency = 1,
	Size = UDim2.fromScale(1, 0.4),
	Position = UDim2.new(0, 0, 0.1, 16),

	SizeConstraints = {
		Max = Vector2.new(math.huge, 120),
	},

	LayoutOrder = 2,

	Name = "Actions",
	Parent = codeActionsFrame,
})

AddListLayout(actionsFrame, {
	Padding = UDim.new(0, 4),
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
})

local theToolbarButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(1, 0.3),

		Name = "TheToolbarButton",
		Parent = actionsFrame :: Instance,

		LayoutOrder = 1,
	},

	Text = "Add to Toolbar"
})

local function updateTheToolbarButton(): ()
	if not activeScript then
		theToolbarButton.Text = "Add to Toolbar"
		return
	end

	theToolbarButton.Text = if ToolbarButton.GetButton(activeScript.Name) then "Remove from Toolbar" else "Add to Toolbar"
end

theToolbarButton.Activated:Connect(function()
	if not activeScript then
		return
	end

	if ToolbarButton.GetButton(activeScript.Name) then
		Prompt.ShowConfirmationPrompt(widget, "Remove from Toolbar", "NOTE: Due to a Roblox bug, you must reload the plugin for this to take effect.", function(response)
			if response == "OK" then
				ToolbarButton.Remove(activeScript.Name)
				updateTheToolbarButton()
			end
		end)
	else
		local inputs = {
			Icon = "",
			Tooltip = "",
		}

		Prompt.ShowInputPrompt(widget, "Add to Toolbar", inputs, function(response)
			if response == "OK" then
				ToolbarButton.Add(activeScript, inputs)
				updateTheToolbarButton()
			end
		end)
	end
end)

local function setScriptArgument(scriptFile: ModuleScript, name: string, value: string | number | boolean): ()
	scriptFile:SetAttribute(name, value)
end

local function setEditorTitle(scriptFile: ModuleScript?): ()
	editorTitle.Text = if scriptFile then scriptFile.Name else "Select a script"
	editorTitle.TextEditable = scriptFile ~= nil
end

local function setArguments(scriptFile: ModuleScript?): ()
	for _, v in argumentsFrame:GetChildren() do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	if not scriptFile then
		return
	end

	local arguments = Arguments.GetDefinedArguments(ScriptEditorService:GetEditorSource(scriptFile))
	for _, argument in arguments do
		InputUI.CreateInput(argument.Name, scriptFile:GetAttribute(argument.Name), argument.Default, function(input)
			setScriptArgument(scriptFile, argument.Name, input)
		end, function(reason)
			if reason == "InvalidNumber" then
				Prompt.ShowConfirmationPrompt(widget, "Number expected", "Please enter a valid number", function(response) end)
			end
		end).Parent = argumentsFrame
	end
end

local function setActiveScript(scriptFile: ModuleScript?): ()
	activeScript = scriptFile
	setEditorTitle(scriptFile)
	setArguments(scriptFile)
	updateTheToolbarButton()
end

local function uiPromptDelete(scriptFile: ModuleScript): ()
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

	scriptFile:Destroy()
	button:Destroy()

	if activeScript == scriptFile then
		setActiveScript(nil)
	end
end

local function uiEdit(scriptFile: ModuleScript): ()
	plugin:OpenScript(scriptFile)
end

local function executeScript(scriptFile: ModuleScript): ()
	local code = ScriptEditorService:GetEditorSource(scriptFile)
	Execute(code, scriptFile:GetAttributes(), scriptFile.Name)
end

local function uiExecute(scriptFile: ModuleScript): ()
	local code = ScriptEditorService:GetEditorSource(scriptFile)
	if CodeContainsDestroy(code) then
		Prompt.ShowConfirmationPrompt(widget, "Warning", "Script contains possible usage of Instance:Destroy(), this cannot be undone! Consider using Instance.Parent = nil instead.", function(response)
			if response == "OK" then
				executeScript(scriptFile)
			end
		end, "Execute Anyway")
		return
	end
	executeScript(scriptFile)
end

local function addSavedScript(scriptFile: ModuleScript): ()
	local name = scriptFile.Name

	local button = savedScriptButton:Clone()

	button.TitleLabel.Text = name
	button.Name = name .. "_SavedScriptButton"

	button.Activated:Connect(function()
		if activeScript == scriptFile then
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
	for _, v in ScriptFile.GetScripts() do
		if v.Name:sub(1, #UNTITLED_SCRIPT) == UNTITLED_SCRIPT then
			local number = tonumber(v.Name:sub(#UNTITLED_SCRIPT + 1)) or 0
			if not highestNumber or number > highestNumber then
				highestNumber = number
			end
		end
	end

	local newScript = ScriptFile.AddScript("Untitled Script" .. (if highestNumber then highestNumber + 1 else ""), DefaultScript)
	addSavedScript(newScript)
	setActiveScript(newScript)

	ScriptEditorService:OpenScriptDocumentAsync(newScript)
end)

local isFirst = true
for _, scriptFile in ScriptFile.GetScripts() do
	addSavedScript(scriptFile)
	if isFirst then
		setActiveScript(scriptFile)
		isFirst = false
	end
end

local openButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(1, 0.3),

		Name = "OpenButton",
		Parent = actionsFrame :: Instance,
	},

	Text = "Open",
})

openButton.Activated:Connect(function()
	if not activeScript then
		return
	end
	uiEdit(activeScript)
end)

local executeButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(1, 0.3),

		Name = "ExecuteButton",
		Parent = actionsFrame :: Instance,

		LayoutOrder = 2,

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
	if not activeScript then
		return
	end
	uiExecute(activeScript)
end)

frame.Parent = widget

function module.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled
end

module.Widget = widget

return module