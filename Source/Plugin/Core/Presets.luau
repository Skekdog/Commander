local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local GetPlugin = require("../../Lib/GetPlugin")
local ActiveScripts = require("./ActiveScripts")

export type Presets = {
	[string]: string,
}

local plugin = GetPlugin

local module = {}

function module.GetPresets(): Presets
	local presets = plugin:GetSetting("Presets")
	if not presets then
		return {
			["Hello, World!"] = 'print("Hello, World!")',
		}
	end
	return HttpService:JSONDecode(plugin:GetSetting("Presets"))
end

function module.UpdatePreset(name: string, code: string): ()
	local presets = module.GetPresets()
	presets[name] = code

	plugin:SetSetting("Presets", HttpService:JSONEncode(presets))
end

function module.DeletePreset(name: string): ()
	local presets = module.GetPresets()
	presets[name] = nil

	plugin:SetSetting("Presets", HttpService:JSONEncode(presets))
end

function module.LoadPreset(name: string): string?
	local data = module.GetPresets()
	if not data then
		warn("Failed to load preset " .. name)
		return nil
	end

	local code = data[name]
	if not code then
		return nil
	end

	return code
end

for name, code in module.GetPresets() do
	ActiveScripts.AddScript(name, code)
end

plugin.Unloading:Connect(function()
	for _, scriptFile in ActiveScripts.GetScripts() do
		module.UpdatePreset(scriptFile.Name, ScriptEditorService:GetEditorSource(scriptFile))
	end
end)

return module