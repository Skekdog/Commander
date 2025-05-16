--[=[
MIT License

Copyright (c) 2022 JohnnyMorganz

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]=]

local AssetService = game:GetService("AssetService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ASSET_ID = 18845843214
local CREATOR_ID = 965735486

local plugin = ReplicatedStorage:FindFirstChild("Plugin")
if not plugin then
	error("Plugin not found in ReplicatedStorage")
end

type CreateAssetVersionAsync = (self: AssetService, object: Object, assetType: Enum.AssetType, assetId: number, options: {
	Name: string?,
	Description: string?,
	CreatorId: number, -- This is technically optional, but it is required for the Open Cloud Execution context (https://create.roblox.com/docs/reference/engine/classes/AssetService#CreateAssetVersionAsync)
	IsPackage: boolean?,
}) -> (Enum.CreateAssetResult, number)

local createAssetVersionAsync: CreateAssetVersionAsync = AssetService.CreateAssetVersionAsync :: any

print("Executing AssetService:CreateAssetVersionAsync")

local result, number = createAssetVersionAsync(AssetService, plugin, Enum.AssetType.Plugin, ASSET_ID, {
	CreatorId = CREATOR_ID,
})

print(result, number)