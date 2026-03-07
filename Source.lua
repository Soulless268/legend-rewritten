-- Date Updated -- 12:20 AM -- 9/2/2026 -- DD/MM/YYYY

if not game:IsLoaded() then game.Loaded:Wait() end

local players = game:GetService("Players")
local tws = game:GetService("TweenService")
local rs = game:GetService("RunService")
local rp = game:GetService("ReplicatedStorage")

local plr = players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart") :: Part
local hum = char:WaitForChild("Humanoid") :: Humanoid

local ProximityPrompts_Screen = plr.PlayerGui:FindFirstChild("ProximityPrompts")

if not ProximityPrompts_Screen then
	ProximityPrompts_Screen = Instance.new("ScreenGui")
	ProximityPrompts_Screen.Name = "ProximityPrompts"
	ProximityPrompts_Screen.ResetOnSpawn = false
	ProximityPrompts_Screen.IgnoreGuiInset = true
	ProximityPrompts_Screen.Parent = plr.PlayerGui
end

local place_ids = {
	6198225400, --Main
	7816227995, -- Sea 1
	11650685514, -- Sea 2
	8793520828, -- Uruk Raid
	14375521811, -- Infinite Dungeon Raid
	88161518351947, -- Retake Wall Raid
	139887515865806 -- Gate Dungeon
}

local notraid = {
	6198225400, --Main
	7816227995, -- Sea 1
	11650685514, -- Sea 2
}

local lobby_id = {
	6198225400,
}

local islobby = false
local israid = false

local workspace_debug

if table.find(place_ids, game.PlaceId) then
	workspace_debug = workspace
	if not table.find(notraid, game.PlaceId) then
		israid = true
	end

	if table.find(lobby_id, game.PlaceId) then
		islobby = true
	end

else
	islobby = true
	israid = true
	workspace_debug = workspace:FindFirstChild("Simulate"):FindFirstChild("Legend Rewritten")
end

local gates_path = workspace_debug:FindFirstChild("Gates")
local plants_path = workspace_debug:FindFirstChild("Plants")
local ores_path = workspace_debug:FindFirstChild("Ores")
local mobs_path = workspace_debug:FindFirstChild("Mobs")
local drops_path = workspace_debug:FindFirstChild("Drops")
local chests_path = workspace_debug:FindFirstChild("Chests")
local spawnpoints_path = workspace_debug:FindFirstChild("SpawnPoints")

-----Settings-----
local Minimized = false
local DESTROYED = false
local current_catagory = nil
local chest_highlight = false
local clear_raid = false
local magnet_items = false
local unstunned = false
local auto_attack = false
local use_weapon_spec = true
local farming = false
local run_add_decent = true
local run_remove_decent = true
local target_mob = nil :: Model
local target_mob_raid = nil :: Model
local farming_type = "None"
local farming_function = function() end
local plants_list = {}
local ores_list = {}
local gates_list = {}
local gates_button_list = {}
local mobs_list = {}
local char_no_clip_list = {}
local mobs_button_list = {}
local frame_store = {}
local farming_type_lists = {
	["Sukuna Fingers"] = "Sukuna Fingers",
	["Chests"] = "Chests",
	["Plants"] = "Plants",
	["Mobs"] = "Mobs",
	["Ores"] = "Ores",
	["Raid"] = "Raid",
	["Drops Loot"] = "Drops Loot",
	["Everything"] = "Everything",
}
local items_to_sell_list = {
	"AdamantArrows",
	"AdamantHelmet",
	"AdamantLegplates",
	"AdamantLongSword",
	"AdamantPlate",
	"AdamantShield",

	"BronzeArrows",
	"BronzeHelmet",
	"BronzeLegplates",
	"BronzePlate",
	"BronzeSword",

	"BlackArrows",
	"BlackLongSword",

	"DarkScythe",
	"DarkStoneHelmet",
	"DarkStoneLegplates",
	"DarkStonePlate",

	"DemonBlade",
	"DemonSpear",

	"DragonScythe",
	"DragonStoneBattleAxe",
	"DragonGreatSword",
	"DragonStoneHelmet",
	"DragonStoneLegplates",
	"DragonStonePlate",
	"DragonStoneScythe",
	"DragonSwordReid",

	"FlameEnhancement",

	"IceEnhancement",

	"IronArrows",
	"IronShield",
	"IronSword",

	"LightningEnhancement",
	"LightEnhancement",

	"OakBow",

	"PoisonEnhancement",

	"RuinedKnightHelmet",
	"RuinedKnightLegplates",
	"RuinedKnightPlate",

	"RuneArrows",
	"RuneBow",
	"RuneHelmet",
	"RuneLegplates",
	"RuneLongSword",
	"RunePlate",
	"RuneShield",

	"RockKnightHelmet",
	"RockKnightLegplates",
	"RockKnightPlate",

	"SteelArrows",
	"SteelBow",
	"SteelHelmet",
	"SteelLegplates",
	"SteelPlate",
	"SteelShield",
	"SteelSword",

	"TanzakniteHelmet",
	"TanzakniteBlade",
	"TanzaknitePlate",
	"TanzakniteLegplates",

	"Volcano",
	"VolcanoCape"
}
local seasons_day = {
	[1] = "Summer",
	[2] = "Summer",
	[3] = "Fall",
	[4] = "Fall",
	[5] = "Winter",
	[6] = "Winter",
	[7] = "Spring",
	[8] = "Spring",
}
local spawn_points_ids = {
	[0] = "World 1 Boat",
	[1] = "Mihawk Colosseum",
	[2] = "Matsumae",
	[3] = "Sky Island",
	[4] = "Flower Village",
	[5] = "Mount Frenzy",
	[6] = "Ice Cap",
	[7] = "Time Island",

	[9] = "Shibuya",
}
local place_unlocked = {}
local click_sounds = "rbxassetid://103866342467024"
local background_image_id = "rbxassetid://86093393173023"
local truecolor = Color3.fromRGB(170, 170, 0)
local falsecolor = Color3.fromRGB(163, 162, 165)
-----Settings-----

local no_cliping : RBXScriptConnection
local runner_adddecen : RBXScriptConnection
local runner_removedecen : RBXScriptConnection
local runner_raid : RBXScriptConnection
local runner_unstunned : RBXScriptConnection
local runner_auto_attack : RBXScriptConnection

-----SetUp GUI-----
local screen = Instance.new("ScreenGui")
screen.Name = "NickMainLegend"
screen.ResetOnSpawn = false
screen.Parent = plr.PlayerGui

local sfx_click = Instance.new("Sound")
sfx_click.SoundId = click_sounds
sfx_click.Parent = screen
sfx_click.Volume = 0.5

local main_frame : Frame
local catagories_frame : Frame
local esp_frame : Frame
local settings_frame : Frame
local farming_frame : Frame
local acc_sets_frame : Frame
local misc_frame : Frame

local mobs_frame : Frame
local gates_frame : Frame
local ores_frame : Frame
local plants_frame : Frame
local farming_type_frame : Frame
local chests_frame : Frame
local server_info_frame : Frame
local spawn_points_frame : Frame

local mobs_list_search_bar
local gates_list_search_bar

local show_button : TextButton
local close_button : TextButton
local minimize_button : TextButton

local refresh_button : TextButton
local highlight_chests_button : TextButton
local esp_sukuna_fingers_button : TextButton
local magnet_items_button : TextButton
local show_mob_hp_button : TextButton
local show_gate_button : TextButton
local clear_raid_button : TextButton
local show_plants_button : TextButton
local show_ores_button : TextButton
local sell_useless_items_button : TextButton
local unstunned_button : TextButton
local auto_attack_button : TextButton
local auto_attack_value_button : TextButton
local farming_type_button : TextButton
local farming_button : TextButton
local server_info_button : TextButton
local spawn_points_button : TextButton
local add_decent_button : TextButton
local remove_decent_button : TextButton

--PreLoad Local Universals Function:
local function UiCorner(Parent, Ui)
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = Ui
	Corner.Parent = Parent
	return Corner
end

local function UiStroke(Parent)
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(255, 255, 255)
	Stroke.Thickness = 1
	Stroke.LineJoinMode = Enum.LineJoinMode.Miter
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Parent = Parent
	return Stroke
end

local function create_button_catagory(parent, name: string, frame)
	local button = Instance.new("TextButton")
	button.Text = name
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextScaled = true
	button.TextStrokeTransparency = 0
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.Parent = parent
	UiStroke(button)

	button.Activated:Connect(function()
		sfx_click:Play()
		if current_catagory and current_catagory ~= frame then
			current_catagory.Visible = false
			current_catagory = frame
			current_catagory.Visible = true
		else
			current_catagory = frame
			current_catagory.Visible = true
		end
	end)


	return button
end

local function create_frame(parent, title: string, description: string, value: any, extra_value: any)
	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
	frame.Parent = parent
	UiStroke(frame)

	local title_label = Instance.new("TextLabel")
	title_label.Text = title
	title_label.TextColor3 = Color3.fromRGB(255, 255, 255)
	title_label.TextStrokeTransparency = 0
	title_label.TextXAlignment = Enum.TextXAlignment.Left
	title_label.BackgroundTransparency = 1
	title_label.RichText = true
	title_label.TextScaled = true
	title_label.Position = UDim2.new(0,0,0,0)
	title_label.Size = UDim2.new(.75,0,.6,0)
	title_label.Parent = frame

	local description_label

	if description then
		description_label = Instance.new("TextLabel")
		description_label.Text = description
		description_label.TextColor3 = Color3.fromRGB(200, 200, 200)
		description_label.TextXAlignment = Enum.TextXAlignment.Left
		description_label.BackgroundTransparency = 1
		description_label.RichText = true
		description_label.TextScaled = true
		description_label.Position = UDim2.new(0,0,.6,0)
		description_label.Size = UDim2.new(.75,0,.4,0)
		description_label.Parent = frame
	end

	local function make_value(value)
		local button
		if value == nil then return end

		if typeof(value) == "boolean" then
			button = Instance.new("TextButton")
			button.Text = "  "
			button.BackgroundColor3 = if value then truecolor else falsecolor
		elseif typeof(value) == "number" then
			button = Instance.new("TextBox")
			button.Text = tostring(value)
		end

		if value == "Click" then
			button = Instance.new("TextButton")
			button.Text = ">"
			button.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			button.TextScaled = true
		elseif value == "Select" then
			button = Instance.new("TextButton")
			button.Text = "None"
			button.TextScaled = true
			button.TextWrapped = true
		end

		return button
	end

	local e1 = make_value(value)
	local e2 = make_value(extra_value)

	if e2 then
		title_label.Size = UDim2.new(.5,0,.6,0)
		if description_label then
			description_label.Size = UDim2.new(.5,0,.4,0)
		end

		e1.Position = UDim2.new(.75,0,0,0)
		e1.Size = UDim2.new(.25,0,1,0)
		e1.Parent = frame

		e2.Position = UDim2.new(.5,0,0,0)
		e2.Size = UDim2.new(.25,0,1,0)
		e2.Parent = frame
		return e1, e2
	else
		title_label.Size = UDim2.new(.75,0,.6,0)

		if description_label then
			description_label.Size = UDim2.new(.75,0,.4,0)
		end

		e1.Position = UDim2.new(.75,0,0,0)
		e1.Size = UDim2.new(.25,0,1,0)
		e1.Parent = frame
		return e1
	end
end

local function prefix_name(name)
	--local prefix = string.match(name, "^(%a+)")
	local prefix = string.match(name, "^([^%d#]+)")

	return prefix
end

local function number_format(number)
	local formatted = tostring(number)
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then
			break
		end
	end
	return formatted
end

local function character_available()
	local available = false
	char = plr.Character
	if not char then return available end
	hrp = char:FindFirstChild("HumanoidRootPart") :: Part
	hum = char:FindFirstChildOfClass("Humanoid") :: Humanoid
	local ingame_hp = char:FindFirstChild("Health")
	if not ingame_hp or ingame_hp.Value <= 0 then return available end
	
	if hrp and hum then
		available = true
	end
	
	return available
	
end

local function nocliping()
	if not character_available() then return end

	for _, child in pairs(char:GetDescendants()) do
		if child:IsA("BasePart") and child.CanCollide == true then
			char_no_clip_list[child] = child.CanCollide
			child.CanCollide = false
		end
	end

end

local function cliping()
	if not character_available() then return end

	if no_cliping then
		no_cliping:Disconnect()
		no_cliping = nil
	end

	for i,v in pairs(char_no_clip_list) do
		i.CanCollide = v
	end

	char_no_clip_list = {}
end

local function go_to_pos(pos : CFrame|Vector3, magnitude : number)
	if not character_available() then return end

	local speed = 200
	local minTime = 0.01
	local maxTime = 15

	local distance = magnitude

	local time_ = distance / speed

	time_ = math.clamp(time_, minTime, maxTime)

	if typeof(pos) == "Vector3" then
		pos = CFrame.new(pos)
	elseif typeof(pos) == "CFrame" then
		pos = pos
	end

	local tween = tws:Create(hrp, TweenInfo.new(time_), {CFrame = pos})
	tween:Play()

	tween.Completed:Once(function()
		if hrp then
			hrp.Anchored = false
		end
	end)

end

local function get_nearest_enemy()
	local nearest = nil
	local shortestDistance = math.huge

	local target_part

	for _, mob in ipairs(mobs_path:GetChildren()) do
		local mobHRP = mob:FindFirstChild("HumanoidRootPart")
		if mobHRP then
			local distance = (hrp.Position - mobHRP.Position).Magnitude

			if distance < shortestDistance then
				shortestDistance = distance
				nearest = mob
				target_part = mobHRP
			end
		end
	end

	if not target_part then return end

	return nearest, target_part.Position
end

--Preload InGame Function:
local function equip_tool(slot : number) -- Max has Tool7
	task.spawn(function()
		local tool = plr.Data:FindFirstChild("Tool"..tostring(slot))
		if char:FindFirstChildOfClass("Humanoid") then
			char.Humanoid:EquipTool(plr.Backpack:FindFirstChild(tool.Value))
		end
	end)
end

local function unequip_tool(slot : number) -- Max has Tool7
	task.spawn(function()
		local tool = plr.Data:FindFirstChild("Tool"..tostring(slot))
		if char:FindFirstChildOfClass("Humanoid") and char:FindFirstChild(tool.Value) then
			char.Humanoid:UnequipTools(char:FindFirstChild(tool.Value))
		end
	end)
end

local function use_weapon_special()
	if not character_available() then return end
	if not char:FindFirstChildOfClass("Tool") then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool:FindFirstChild("SwordScript") then return end
	
	local nearest, pos = get_nearest_enemy()

	if not nearest then return end
	
	local parkour_ui = plr.PlayerGui:FindFirstChild("Parkour")

	task.spawn(function()
		if nearest:FindFirstChild("Head") then
			pos = nearest.Head.Position
		elseif nearest:FindFirstChild("HumanoidRootPart") then
			pos = pos
		end
		
		if not use_weapon_spec then return end
		if parkour_ui:FindFirstChildOfClass("Script"):FindFirstChild(tool.Name) then
			parkour_ui:FindFirstChildOfClass("Script"):FindFirstChild(tool.Name):FireServer(pos)
		end
	end)
end

local function create_acc_sets(parent, SetName, acc_name1, acc_name2)
	
	local button = create_frame(parent, SetName, acc_name1.." | "..acc_name2, "Click")
	
	button.Activated:Connect(function()
		sfx_click:Play()
		task.spawn(function()
			if not plr.Data:FindFirstChild(acc_name1) then return end
			if plr.Data[acc_name1].Value <= 0 then return end
			rp.Remotes.EquipAccessory1:FireServer(acc_name1)
		end)

		task.spawn(function()
			if not plr.Data:FindFirstChild(acc_name2) then return end
			if plr.Data[acc_name2].Value <= 0 then return end
			if acc_name1 == acc_name2 and plr.Data[acc_name2].Value <= 1 then return end
			rp.Remotes.EquipAccessory2:FireServer(acc_name2)
		end)
	end)
end

local function resigter_plants(name)
	if not plants_list[name] then

		local function empty_func() end

		local b = Instance.new("TextButton")
		b.Text = name
		b.Name = name
		b.TextScaled = true
		b.Parent = plants_frame:FindFirstChildOfClass("ScrollingFrame")

		plants_list[name] = {
			activated = false,
			button = b,
			button_func_true = empty_func,
			button_func_false = empty_func,
		}

		b.Activated:Connect(function()
			sfx_click:Play()
			local t = plants_list[name]
			t.activated = not t.activated
			b.BackgroundColor3 = t.activated and truecolor or falsecolor

			if t.activated then
				t.button_func_true()
			else
				t.button_func_false()
			end
		end)

	end
end

local function resigter_ores(name)
	if not ores_list[name] then

		local function empty_func() end

		local b = Instance.new("TextButton")
		b.Text = name
		b.Name = name
		b.TextScaled = true
		b.Parent = ores_frame:FindFirstChildOfClass("ScrollingFrame")

		ores_list[name] = {
			activated = false,
			button = b,
			button_func_true = empty_func,
			button_func_false = empty_func,
		}

		b.Activated:Connect(function()
			sfx_click:Play()
			local t = ores_list[name]
			t.activated = not t.activated
			b.BackgroundColor3 = t.activated and truecolor or falsecolor

			if t.activated then
				t.button_func_true()
			else
				t.button_func_false()
			end
		end)

	end
end

local function resigter_gate(v)
	if not gates_list[v] then

		local part = v:FindFirstChild("Gate")
		if not part then return end
		local level = part:FindFirstChild("Level")
		local rank = part:FindFirstChild("Rank")
		local MapName = part:FindFirstChild("MapName")
		local boss = part:FindFirstChild("Boss")

		gates_list[v] = {
			show_location = false,
			location_bil = nil,
			level = level.Value,
			rank = rank.Value,
			type_ = v.Name,
			map_name = MapName.Value,
			boss = boss.Value,
		}
	end
end

local function make_button_for_gate()
	for i,v in pairs(gates_list) do
		if not gates_button_list[i] then
			local button = Instance.new("TextButton")
			button.Text = i.Name .. " " .. v.rank
			button.Name = i.Name
			button.TextScaled = true
			button.Parent = gates_frame:FindFirstChildOfClass("ScrollingFrame")

			gates_button_list[i] = button

			button.Activated:Connect(function()
				sfx_click:Play()
				v.show_location = not v.show_location
				button.BackgroundColor3 = v.show_location and truecolor or falsecolor

				if v.show_location then
					if not v.location_bil then
						v.location_bil = Instance.new("BillboardGui")
						v.location_bil.Name = "Location_Bil"
						v.location_bil.Size = UDim2.new(0, 200, 0, 200)
						v.location_bil.StudsOffset = Vector3.new(0, 0, 0)
						v.location_bil.AlwaysOnTop = true
						v.location_bil.Parent = i:FindFirstChild("Gate")

						local title = Instance.new("TextLabel")
						title.Text = v.type_.." Lvl: "..tostring(v.level)
						title.Size = UDim2.new(1, 0, .1, 0)
						title.BackgroundTransparency = 1
						title.TextColor3 = Color3.fromRGB(255, 255, 255)
						title.TextStrokeTransparency = 0
						title.TextScaled = true
						title.Parent = v.location_bil

						local text_label = Instance.new("TextLabel")
						text_label.Text = "Rank: " .. tostring(v.rank) .. " Map: " .. tostring(v.map_name)
						text_label.Position = UDim2.new(0, 0, .1, 0)
						text_label.Size = UDim2.new(1, 0, .9, 0)
						text_label.TextColor3 = Color3.fromRGB(255, 255, 255)
						text_label.TextStrokeTransparency = 0
						text_label.BackgroundTransparency = 1
						text_label.TextScaled = true
						text_label.Parent = v.location_bil

						if v.boss ~= nil or v.boss ~= " " then
							text_label.Size = UDim2.new(1, 0, .5, 0)

							local text_label2 = Instance.new("TextLabel")
							text_label2.Text = "Boss: " .. tostring(v.boss)
							text_label2.Position = UDim2.new(0, 0, .5, 0)
							text_label2.Size = UDim2.new(1, 0, .5, 0)
							text_label2.TextColor3 = Color3.fromRGB(255, 255, 255)
							text_label2.TextStrokeTransparency = 0
							text_label2.BackgroundTransparency = 1
							text_label2.TextScaled = true
							text_label2.Parent = v.location_bil
						end

					end
				else
					if v.location_bil then
						v.location_bil:Destroy()
						v.location_bil = nil
					end
				end
			end)

		end
	end
end

local function resigter_mob(v)
	if not mobs_list[v] then
		mobs_list[v] = {
			show_hp = false,
			hp_bil = nil,
			hp_detect = nil,
		}
	end
end

local function make_button_for_mob()
	for i,v in pairs(mobs_list) do
		if not mobs_button_list[i] then
			local button = Instance.new("TextButton")
			button.Text = i.Name
			button.Name = i.Name
			button.TextScaled = true
			button.Parent = mobs_frame:FindFirstChildOfClass("ScrollingFrame")

			mobs_button_list[i] = button

			button.Activated:Connect(function()
				sfx_click:Play()
				v.show_hp = not v.show_hp
				button.BackgroundColor3 = v.show_hp and truecolor or falsecolor

				if v.show_hp then
					if not v.hp_bil then
						local enemy = i:FindFirstChild("Head") or i

						if enemy:FindFirstChild("HPBil") then
							v.hp_bil = enemy:FindFirstChild("HPBil")
						else
							v.hp_bil = Instance.new("BillboardGui")
							v.hp_bil.Name = "HPBil"
							v.hp_bil.Size = UDim2.new(0, 200, 0, 25)
							v.hp_bil.StudsOffset = Vector3.new(0, 5, 0)
							v.hp_bil.AlwaysOnTop = true
							v.hp_bil.Parent = enemy
						end

						local text

						if v.hp_bil:FindFirstChild("TextLabel") then
							text = v.hp_bil:FindFirstChild("TextLabel")
						else
							text = Instance.new("TextLabel")
							text.Text = i.Name .. ": " .. number_format(i:FindFirstChild("Health").Value) .. " / " .. number_format(i:FindFirstChild("MaxHealth").Value)
							text.Size = UDim2.new(1, 0, 1, 0)
							text.TextScaled = true
							text.TextColor3 = Color3.new(1, 0, 0)
							text.BackgroundTransparency = 1 
							text.TextStrokeTransparency = 0
							text.Parent = v.hp_bil
						end

						v.hp_detect = i:FindFirstChild("Health").Changed:Connect(function()
							if not button then
								v.hp_detect:Disconnect()
								v.hp_detect = nil
							end
							text.Text = i.Name .. ": " .. number_format(i:FindFirstChild("Health").Value) .. " / " .. number_format(i:FindFirstChild("MaxHealth").Value)
						end)

					end
				else
					if v.hp_bil then
						v.hp_bil:Destroy()
						v.hp_bil = nil
					end

					if v.hp_detect then
						v.hp_detect:Disconnect()
						v.hp_detect = nil
					end
				end
			end)

		end
	end
end

local function get_nearest_instance(child, pos_outcome)
	local nearest = nil
	local shortestDistance = math.huge

	if not next(child) then return end

	if not character_available() then return end

	local tt_part

	for _, v in ipairs(child) do

		local target_part = v:FindFirstChild("HumanoidRootPart")
			or v:FindFirstChild("Head")
			or v:FindFirstChildOfClass("Part")
			or v:FindFirstChildOfClass("MeshPart")
			or v:FindFirstChildOfClass("UnionOperation")

		if target_part then
			if not hrp then return end
			local distance = (hrp.Position - target_part.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				nearest = v
				tt_part = target_part
			end
		end
	end

	if not tt_part then return end

	if pos_outcome == "CFrame" then
		return nearest, tt_part.CFrame, tt_part
	elseif pos_outcome == "Position" then
		return nearest, tt_part.Position, tt_part
	else
		return nearest, tt_part.Position, tt_part
	end

end

local function get_behind()
	if not character_available() then return end
	if not target_mob_raid then return end
	local epart = target_mob_raid:FindFirstChild("HumanoidRootPart")
	local ehp = target_mob_raid:WaitForChild("Health")
	if not ehp then return end
	if ehp.Value <= 0 then return end

	local mag = (epart.Position - hrp.Position).Magnitude
	local target_pos = (epart.CFrame * CFrame.new(0,0,10))

	go_to_pos(target_pos, mag)
end

local function add_sukuna_finger_bilboard(v: Instance)
	if v:FindFirstChild("HighSFEdok") then return end
	local newhi = Instance.new("Highlight")
	newhi.Name = "HighSFEdok"
	newhi.Parent = v

	local bil = Instance.new("BillboardGui")
	bil.Size = UDim2.new(0,25,0,25)
	bil.AlwaysOnTop = true
	bil.Parent = v

	local t = Instance.new("TextLabel")
	t.Text = "Sukuna Finger"
	t.Size = UDim2.new(1,0,1,0)
	t.TextScaled = true
	t.Parent = bil

end

local function add_runner_add_decentdant()
	local runner = workspace.DescendantAdded:Connect(function(child)
		if not (child:IsDescendantOf(mobs_path)
			or  child:IsDescendantOf(gates_path)) then return end

		if mobs_path and child:IsDescendantOf(mobs_path) then
			if not child:IsA("Model") then return end
			if not child:FindFirstChild("Health") then return end
			if child:FindFirstChild("Health").Value <= 0 then return end

			resigter_mob(child)

			make_button_for_mob()

		end

		if gates_path and child:IsDescendantOf(gates_path) then
			if not child:IsA("Model") then return end

			resigter_gate(child)

			make_button_for_gate()
		end
	end)
	return runner
end

local function add_runner_remove_decendant()
	local runner = workspace.DescendantRemoving:Connect(function(child)
		if not (child:IsDescendantOf(mobs_path)
			or  child:IsDescendantOf(gates_path)) then return end

		if mobs_path and child:IsDescendantOf(mobs_path) then
			if not child:IsA("Model") then return end

			if mobs_list[child] then
				mobs_list[child] = nil
				mobs_button_list[child]:Destroy()
				mobs_button_list[child] = nil
			end
		end

		if gates_path and child:IsDescendantOf(gates_path) then
			if not child:IsA("Model") then return end

			if gates_list[child] then
				gates_list[child] = nil
				gates_button_list[child]:Destroy()
				gates_button_list[child] = nil
			end
		end
	end)
	return runner		
end

local function register_farming_type()
	
	local when_died = 0
	
	local function check_died()
		if when_died >= 100 then
			task.spawn(function()
				if not character_available() then return end
				unequip_tool(4)
				hum.Health = 0
				when_died = 0
			end)
			task.wait(players.RespawnTime+.5)
		elseif when_died <= 0 then
			when_died = 0
		end
		print(when_died)
	end
	
	local function Unlock_Map()
		
	end
	
	local function Farming_Sukuna_Finger()
		if farming then
			local list = {}

			for _,v in pairs(drops_path:GetChildren()) do
				if v.Name ~= "CursedFinger" then continue end
				if not farming then break end

				table.insert(list, v)
			end

			for _,v in pairs(list) do
				unequip_tool(4)
				local nearest, pos = get_nearest_instance(list)

				if nearest then
					while nearest:IsDescendantOf(drops_path) do
						if not farming then break end
						local mag = (hrp.Position - pos).Magnitude
						go_to_pos(pos, mag)
						task.wait(1)
					end
				end
			end
		end
	end
	
	local function Farming_Drops(magtitude : number)
		local list = {}
		if not character_available() then return end
		
		task.spawn(function()
			for _,v in pairs(drops_path:GetChildren()) do
				local part = v:FindFirstChildOfClass("Part")
					or v:FindFirstChildOfClass("MeshPart")
				if part then
					if (part.Position - hrp.Position).Magnitude < (magtitude or 2000) then
						table.insert(list, v)
					end
				end
			end
		end)
		
		task.wait(1)

		print("tween to drops loot")
		for _,v in pairs(list) do
			local nearest_drops, pos_drops = get_nearest_instance(list)

			if nearest_drops then
				while nearest_drops:IsDescendantOf(drops_path) do
					if not farming then break end
					if not character_available() then break end
					task.spawn(function()
						local mag = (hrp.Position - pos_drops).Magnitude
						go_to_pos(pos_drops, mag)
					end)
					task.wait(.5)
					when_died += math.random(1,5)
					check_died()
				end
				when_died += math.random(-20,0)
			end
		end
		
	end
	
	
	if farming_type == "None" then
		farming_function = function()

		end
	elseif farming_type == farming_type_lists["Drops Loot"] then
		farming_function = function()
			if farming then
				while farming do
					Farming_Sukuna_Finger()
					task.wait(30)
				end
			end
		end
	elseif farming_type == farming_type_lists.Plants then
		farming_function = function()
			local lists = {}
			local plants = {}

			if farming then
				for i,v in pairs(plants_list) do
					if v.activated then
						table.insert(lists, i)
					end
				end

				for _,pname in pairs(lists) do
					for _,v in pairs(plants_path:GetChildren()) do
						if v.Name ~= pname then continue end
						if not farming then break end

						for _,h in pairs(v:GetDescendants()) do
							if not farming then break end

							if h:IsA("BoolValue") and h.Name == "Collectable" then
								if not h.Value then continue end
								table.insert(plants, v)
							end
						end
					end
				end

				while farming do
					task.wait()

					local nearest, pos = get_nearest_instance(plants)

					for _,h in pairs(nearest:GetDescendants()) do
						if not farming then break end

						if h:IsA("BoolValue") and h.Name == "Collectable" then
							if not h.Value then continue end

							while h.Value do
								task.wait()
								if not farming then break end
								if not h.Value then break end

								local mag = (hrp.Position - pos).Magnitude
								if mag < 5 then continue end
								go_to_pos(pos, mag)
							end
							continue
						end
					end

					table.remove(plants, table.find(plants, nearest))

				end
			end
		end
	elseif farming_type == farming_type_lists.Chests then
		farming_function = function()
			local chests = {}

			for _,v in pairs(chests_path:GetChildren()) do
				if not farming then break end

				table.insert(chests, v)

			end

			while farming do
				if not farming then break end

				local nearest, pos = get_nearest_instance(chests)
				local mag = (hrp.Position - pos).Magnitude
				go_to_pos(pos, mag)
				task.wait(3)
			end
		end
	elseif farming_type == farming_type_lists.Ores then
		farming_function = function()
			local lists = {}
			local ores = {}

			if farming then
				for i,v in pairs(ores_list) do
					if v.activated then
						table.insert(lists, i)
					end
				end

				while farming do
					for _,p in pairs(lists) do
						for _,v in pairs(ores_path:GetChildren()) do
							if v.Name ~= p then continue end
							if not farming then break end

							table.insert(ores, v)
						end
					end

					for _,v in pairs(ores) do
						local nearest, pos = get_nearest_instance(ores)

						local interact = nearest:FindFirstChild("Interact")

						if interact and interact.Value then
							while interact.Value do
								task.wait(.05)
								if not farming then break end

								local target_part = nearest:FindFirstChild("Detect") or nearest:FindFirstChild("Main")

								if target_part then
									local mag = (target_part.Position - hrp.Position).Magnitude

									if mag > 5 then 
										go_to_pos(target_part.Position, mag)
									end
								end
							end
						end
					end

					task.wait(1)
				end
			end
		end
	elseif farming_type == farming_type_lists["Sukuna Fingers"] then
		farming_function = function()
			if farming then
				while farming do
					Farming_Sukuna_Finger()
					task.wait(30)
				end
			end
		end
	elseif farming_type == farming_type_lists.Everything then
		farming_function = function()
			if farming then
				when_died = 0

				while farming do
					task.wait(.25)
					local list = {}
					local sukuna_drops = {}
					local enemys = {}
					local drops_list = {}
					when_died += math.random(-10,2)

					if not character_available() then continue end
					
					-----// Scan if sukuna fingers spawn and tween plr to finger posiiotn	
					Farming_Sukuna_Finger()

					-----// Scan for mobs
					for _,v in pairs(mobs_path:GetChildren()) do
						if prefix_name(v.Name) == "Tanzaknite" then
							table.insert(enemys, v)
						end
					end

					local nearest, pos, part = get_nearest_instance(enemys)
					if not part then continue end
					local ori_tans = part.Transparency

					if nearest then
						while nearest:IsDescendantOf(mobs_path) do
							if not farming then break end
							if not nearest:IsDescendantOf(mobs_path) then break end
							if not part:IsDescendantOf(mobs_path) then break end
							if part.Transparency ~= ori_tans then break end
							if not character_available() then break end
							task.wait(1)
							if not char:FindFirstChildOfClass("Tool") then
								equip_tool(4)		
							end
							when_died += math.random(1,5)
							if not character_available() then break end
							check_died()
							if not hrp then continue end
							local mag = (hrp.Position - part.Position).Magnitude
							if mag < 5 then use_weapon_special() continue end
							if nearest:FindFirstChild("Health") and nearest:FindFirstChild("Health").Value <= 0 then break end

							go_to_pos(part.Position, mag)
						end
						
						task.wait(3)

						when_died += math.random(-20,2)
						
						Farming_Drops()
						
						when_died += math.random(-20,2)
					end

					check_died()
				end
			end
		end
	end
end

-----SetUp GUI:
do
	main_frame = Instance.new("Frame")
	main_frame.Draggable = true
	main_frame.Name = "Main"
	main_frame.Active = true
	main_frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	main_frame.AnchorPoint = Vector2.new(1, 0)
	main_frame.Position = UDim2.new(1, 0, 0.15, 0)
	main_frame.Size = UDim2.new(0.25, 0, 0.4, 0)
	main_frame.Parent = screen
	UiStroke(main_frame)

	back_ground_frame = Instance.new("ImageLabel")
	back_ground_frame.BackgroundTransparency = 1
	back_ground_frame.ImageTransparency = .75
	back_ground_frame.Image = background_image_id
	back_ground_frame.Position = UDim2.new(0, 0, 0.1, 0)
	back_ground_frame.Size = UDim2.new(1,0,0.9,0)
	back_ground_frame.Parent = main_frame

	do -----Main Frame

		close_button = Instance.new("TextButton")
		close_button.Text = "X"
		close_button.AnchorPoint = Vector2.new(1,0)
		close_button.BackgroundTransparency = 1
		close_button.TextScaled = true
		close_button.TextColor3 = Color3.fromRGB(255, 170, 0)
		close_button.Position = UDim2.new(1,0,0,0)
		close_button.Size = UDim2.new(0.05, 0,0.1, 0)
		close_button.Parent = main_frame

		minimize_button = Instance.new("TextButton")
		minimize_button.Text = "-"
		minimize_button.AnchorPoint = Vector2.new(1,0)
		minimize_button.BackgroundTransparency = 1
		minimize_button.TextScaled = true
		minimize_button.TextColor3 = Color3.fromRGB(255, 170, 0)
		minimize_button.Position = UDim2.new(.95,0,0,0)
		minimize_button.Size = UDim2.new(0.1,0,0.1,0)
		minimize_button.Parent = main_frame
		
		esp_frame = Instance.new("ScrollingFrame")
		esp_frame.Active = true
		esp_frame.Visible = true
		esp_frame.BackgroundTransparency = .25
		esp_frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		esp_frame.Position = UDim2.new(0.25, 0, 0.1, 0)
		esp_frame.Size = UDim2.new(.75,0,0.9,0)
		esp_frame.CanvasSize = UDim2.new(0,0,0,0)
		esp_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		esp_frame.ScrollBarThickness = 0
		esp_frame.Parent = main_frame
		UiStroke(esp_frame)

		do
			local grid = Instance.new("UIGridLayout")
			grid.CellPadding = UDim2.new(0,0,0,1)
			grid.CellSize = UDim2.new(1,0,.15,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
			grid.Parent = esp_frame

			refresh_button = create_frame(esp_frame, "Refresh", "Refresh", "Click")
			
			esp_sukuna_fingers_button = create_frame(esp_frame, "Sukuna Finger", "Find Sukuna Fingers around the map", "Click")
			
			show_mob_hp_button = create_frame(esp_frame, "Show Mob Health", "Show health of mobs", "Click")

			show_gate_button = create_frame(esp_frame, "Show Gates", "Show Gate that are Exist", "Click")

			show_plants_button = create_frame(esp_frame, "Show Plants", "Show Plants and Highlight", "Click")

			show_ores_button = create_frame(esp_frame, "Show Ores", "Show Ores and Highlight", "Click")
			
			highlight_chests_button = create_frame(esp_frame, "Highlight Chests", "Highlight chests", false)

		end
		
		farming_frame = Instance.new("ScrollingFrame")
		farming_frame.Active = true
		farming_frame.Visible = false
		farming_frame.BackgroundTransparency = .25
		farming_frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		farming_frame.Position = UDim2.new(0.25, 0, 0.1, 0)
		farming_frame.Size = UDim2.new(.75,0,0.9,0)
		farming_frame.CanvasSize = UDim2.new(0,0,0,0)
		farming_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		farming_frame.ScrollBarThickness = 0
		farming_frame.Parent = main_frame
		UiStroke(farming_frame)
		
		do
			local grid = Instance.new("UIGridLayout")
			grid.CellPadding = UDim2.new(0,0,0,1)
			grid.CellSize = UDim2.new(1,0,.15,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
			grid.Parent = farming_frame
			
			farming_button, farming_type_button  = create_frame(farming_frame, "Farming", "Farming all type of farm", false, "Click")
			
		end
		
		acc_sets_frame = Instance.new("ScrollingFrame")
		acc_sets_frame.Active = true
		acc_sets_frame.Visible = false
		acc_sets_frame.BackgroundTransparency = .25
		acc_sets_frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		acc_sets_frame.Position = UDim2.new(0.25, 0, 0.1, 0)
		acc_sets_frame.Size = UDim2.new(.75,0,0.9,0)
		acc_sets_frame.CanvasSize = UDim2.new(0,0,0,0)
		acc_sets_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		acc_sets_frame.ScrollBarThickness = 0
		acc_sets_frame.Parent = main_frame
		UiStroke(acc_sets_frame)
		
		do
			local grid = Instance.new("UIGridLayout")
			grid.CellPadding = UDim2.new(0,0,0,1)
			grid.CellSize = UDim2.new(1,0,.15,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
			grid.Parent = acc_sets_frame
			
			create_acc_sets(acc_sets_frame, "Full Counter Set", "DragonsWrathBracelet", "DragonsWrathBracelet")
			
			create_acc_sets(acc_sets_frame, "Sorcerers Set", "SorcerersBracelet", "SorcerersBracelet")
			
			create_acc_sets(acc_sets_frame, "Greed Items Set", "RingofGreed", "RingofGreed")
			
		end
		
		misc_frame = Instance.new("ScrollingFrame")
		misc_frame.Active = true
		misc_frame.Visible = false
		misc_frame.BackgroundTransparency = .25
		misc_frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		misc_frame.Position = UDim2.new(0.25, 0, 0.1, 0)
		misc_frame.Size = UDim2.new(.75,0,0.9,0)
		misc_frame.CanvasSize = UDim2.new(0,0,0,0)
		misc_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		misc_frame.ScrollBarThickness = 0
		misc_frame.Parent = main_frame
		UiStroke(misc_frame)

		do
			local grid = Instance.new("UIGridLayout")
			grid.CellPadding = UDim2.new(0,0,0,1)
			grid.CellSize = UDim2.new(1,0,.15,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
			grid.Parent = misc_frame

			if islobby then
				server_info_button = create_frame(misc_frame, "Check server season", "Check server season", "Click")
			end

			sell_useless_items_button = create_frame(misc_frame, "Sell Useless Items", "Sell useless items that are easy to get", "Click")

			auto_attack_button, auto_attack_value_button = create_frame(misc_frame, "Auto Attack", "Auto attack when equipped item", false, 1)
			
			if spawnpoints_path then
				spawn_points_button = create_frame(misc_frame, "Spawn Points", "Go to spawn points", "Click")
			end

			if israid then
				clear_raid_button = create_frame(misc_frame, "Clear Raid", "Get behind Mob and start clearing Raid", false)
			end
		end
		
		settings_frame = Instance.new("ScrollingFrame")
		settings_frame.Active = true
		settings_frame.Visible = false
		settings_frame.BackgroundTransparency = .25
		settings_frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		settings_frame.Position = UDim2.new(0.25, 0, 0.1, 0)
		settings_frame.Size = UDim2.new(.75,0,0.9,0)
		settings_frame.CanvasSize = UDim2.new(0,0,0,0)
		settings_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		settings_frame.ScrollBarThickness = 0
		settings_frame.Parent = main_frame
		UiStroke(settings_frame)

		do
			local grid = Instance.new("UIGridLayout")
			grid.CellPadding = UDim2.new(0,0,0,1)
			grid.CellSize = UDim2.new(1,0,.15,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
			grid.Parent = settings_frame

			add_decent_button = create_frame(settings_frame, "Detect instance", "Detect instance that got added", run_add_decent)

			remove_decent_button = create_frame(settings_frame, "Detect instance", "Detect instance that got removed", run_remove_decent)
		end
		
		catagories_frame = Instance.new("ScrollingFrame")
		catagories_frame.Active = true
		catagories_frame.BackgroundTransparency = .25
		catagories_frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		catagories_frame.Position = UDim2.new(0, 0, 0.1, 0)
		catagories_frame.Size = UDim2.new(.25,0,0.9,0)
		catagories_frame.CanvasSize = UDim2.new(0,0,0,0)
		catagories_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		catagories_frame.ScrollBarThickness = 0
		catagories_frame.Parent = main_frame
		UiStroke(catagories_frame)

		do
			local grid = Instance.new("UIGridLayout")
			grid.CellPadding = UDim2.new(0,0,0,1)
			grid.CellSize = UDim2.new(1,0,.15,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
			grid.Parent = catagories_frame

			current_catagory = esp_frame

			create_button_catagory(catagories_frame, "Esp", esp_frame)
			
			create_button_catagory(catagories_frame, "Farming", farming_frame)
			
			create_button_catagory(catagories_frame, "Accessories", acc_sets_frame)
			
			create_button_catagory(catagories_frame, "Misc", misc_frame)

			create_button_catagory(catagories_frame, "Settings", settings_frame)
		end
		
	end

	show_button = Instance.new("TextButton")
	show_button.Draggable = false
	show_button.Active = true
	show_button.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
	show_button.TextColor3 = Color3.fromRGB(255, 170, 0)
	show_button.Size = UDim2.new(0.05, 0, 0.085, 0)
	show_button.Text = "Show"
	show_button.Visible = false
	show_button.Parent = screen
	UiCorner(show_button, UDim.new(0.1,0))

	mobs_frame = Instance.new("Frame")
	mobs_frame.Draggable = true
	mobs_frame.Active = true
	mobs_frame.Visible = false
	mobs_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
	mobs_frame.Position = UDim2.new(0, 0, 0.7, 0)
	mobs_frame.Size = UDim2.new(.2,0,0.3,0)
	mobs_frame.Parent = screen

	do
		local scroll_frame = Instance.new("ScrollingFrame")
		scroll_frame.Active = true
		scroll_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
		scroll_frame.Position = UDim2.new(0, 0, 0.2, 0)
		scroll_frame.Size = UDim2.new(1,0,0.8,0)
		scroll_frame.CanvasSize = UDim2.new(0,0,0,0)
		scroll_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll_frame.ScrollBarThickness = 0
		scroll_frame.Parent = mobs_frame

		do
			local grid = Instance.new("UIGridLayout")
			grid.Parent = scroll_frame
			grid.CellPadding = UDim2.new(0,0,0,0)
			grid.SortOrder = Enum.SortOrder.Name
			grid.CellSize = UDim2.new(.5,0,.2,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
		end

		local title = Instance.new("TextLabel")
		title.Text = "Mobs"
		title.Position = UDim2.new(0,0,0,0)
		title.TextScaled = true
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.TextStrokeTransparency = 0
		title.Size = UDim2.new(1,0,0.1,0)
		title.BackgroundTransparency = 1
		title.Parent = mobs_frame

		mobs_list_search_bar = Instance.new("TextBox")
		mobs_list_search_bar.PlaceholderText = "Search"
		mobs_list_search_bar.Text = ""
		mobs_list_search_bar.TextColor3 = Color3.fromRGB(255, 255, 255)
		mobs_list_search_bar.Active = true
		mobs_list_search_bar.BackgroundColor3 = Color3.fromRGB(83, 71, 66)
		mobs_list_search_bar.Position = UDim2.new(0, 0, 0.1, 0)
		mobs_list_search_bar.Size = UDim2.new(1,0,0.1,0)
		mobs_list_search_bar.Parent = mobs_frame
	end

	gates_frame = Instance.new("Frame")
	gates_frame.Draggable = true
	gates_frame.Active = true
	gates_frame.Visible = false
	gates_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
	gates_frame.Position = UDim2.new(.2, 0, 0.7, 0)
	gates_frame.Size = UDim2.new(.2,0,0.3,0)
	gates_frame.Parent = screen

	do
		local scroll_frame = Instance.new("ScrollingFrame")
		scroll_frame.Active = true
		scroll_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
		scroll_frame.Position = UDim2.new(0, 0, 0.2, 0)
		scroll_frame.Size = UDim2.new(1,0,0.8,0)
		scroll_frame.CanvasSize = UDim2.new(0,0,0,0)
		scroll_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll_frame.ScrollBarThickness = 0
		scroll_frame.Parent = gates_frame

		do
			local grid = Instance.new("UIGridLayout")
			grid.Parent = scroll_frame
			grid.CellPadding = UDim2.new(0,0,0,0)
			grid.SortOrder = Enum.SortOrder.Name
			grid.CellSize = UDim2.new(.5,0,.2,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
		end

		local title = Instance.new("TextLabel")
		title.Text = "Gates"
		title.Position = UDim2.new(0,0,0,0)
		title.TextScaled = true
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.TextStrokeTransparency = 0
		title.Size = UDim2.new(1,0,0.1,0)
		title.BackgroundTransparency = 1
		title.Parent = gates_frame

		gates_list_search_bar = Instance.new("TextBox")
		gates_list_search_bar.PlaceholderText = "Search"
		gates_list_search_bar.Text = ""
		gates_list_search_bar.TextColor3 = Color3.fromRGB(255, 255, 255)
		gates_list_search_bar.Active = true
		gates_list_search_bar.BackgroundColor3 = Color3.fromRGB(83, 71, 66)
		gates_list_search_bar.Position = UDim2.new(0, 0, 0.1, 0)
		gates_list_search_bar.Size = UDim2.new(1,0,0.1,0)
		gates_list_search_bar.Parent = gates_frame
	end

	plants_frame = Instance.new("Frame")
	plants_frame.Draggable = true
	plants_frame.Active = true
	plants_frame.Visible = false
	plants_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
	plants_frame.Position = UDim2.new(0, 0, 0.4, 0)
	plants_frame.Size = UDim2.new(.2,0,0.3,0)
	plants_frame.Parent = screen

	do
		local scroll_frame = Instance.new("ScrollingFrame")
		scroll_frame.Active = true
		scroll_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
		scroll_frame.Position = UDim2.new(0, 0, 0.2, 0)
		scroll_frame.Size = UDim2.new(1,0,0.8,0)
		scroll_frame.CanvasSize = UDim2.new(0,0,0,0)
		scroll_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll_frame.ScrollBarThickness = 0
		scroll_frame.Parent = plants_frame

		do
			local grid = Instance.new("UIGridLayout")
			grid.Parent = scroll_frame
			grid.CellPadding = UDim2.new(0,0,0,0)
			grid.SortOrder = Enum.SortOrder.Name
			grid.CellSize = UDim2.new(.5,0,.2,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
		end

		local title = Instance.new("TextLabel")
		title.Text = "Plants"
		title.Position = UDim2.new(0,0,0,0)
		title.TextScaled = true
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.TextStrokeTransparency = 0
		title.Size = UDim2.new(1,0,0.1,0)
		title.BackgroundTransparency = 1
		title.Parent = plants_frame

		gates_list_search_bar = Instance.new("TextBox")
		gates_list_search_bar.PlaceholderText = "Search"
		gates_list_search_bar.Text = ""
		gates_list_search_bar.TextColor3 = Color3.fromRGB(255, 255, 255)
		gates_list_search_bar.Active = true
		gates_list_search_bar.BackgroundColor3 = Color3.fromRGB(83, 71, 66)
		gates_list_search_bar.Position = UDim2.new(0, 0, 0.1, 0)
		gates_list_search_bar.Size = UDim2.new(1,0,0.1,0)
		gates_list_search_bar.Parent = plants_frame
	end

	ores_frame = Instance.new("Frame")
	ores_frame.Draggable = true
	ores_frame.Active = true
	ores_frame.Visible = false
	ores_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
	ores_frame.Position = UDim2.new(.2, 0, 0.4, 0)
	ores_frame.Size = UDim2.new(.2,0,0.3,0)
	ores_frame.Parent = screen

	do
		local scroll_frame = Instance.new("ScrollingFrame")
		scroll_frame.Active = true
		scroll_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
		scroll_frame.Position = UDim2.new(0, 0, 0.2, 0)
		scroll_frame.Size = UDim2.new(1,0,0.8,0)
		scroll_frame.CanvasSize = UDim2.new(0,0,0,0)
		scroll_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll_frame.ScrollBarThickness = 0
		scroll_frame.Parent = ores_frame

		do
			local grid = Instance.new("UIGridLayout")
			grid.Parent = scroll_frame
			grid.CellPadding = UDim2.new(0,0,0,0)
			grid.SortOrder = Enum.SortOrder.Name
			grid.CellSize = UDim2.new(.5,0,.2,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
		end

		local title = Instance.new("TextLabel")
		title.Text = "Ores"
		title.Position = UDim2.new(0,0,0,0)
		title.TextScaled = true
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.TextStrokeTransparency = 0
		title.Size = UDim2.new(1,0,0.1,0)
		title.BackgroundTransparency = 1
		title.Parent = ores_frame

		gates_list_search_bar = Instance.new("TextBox")
		gates_list_search_bar.PlaceholderText = "Search"
		gates_list_search_bar.Text = ""
		gates_list_search_bar.TextColor3 = Color3.fromRGB(255, 255, 255)
		gates_list_search_bar.Active = true
		gates_list_search_bar.BackgroundColor3 = Color3.fromRGB(83, 71, 66)
		gates_list_search_bar.Position = UDim2.new(0, 0, 0.1, 0)
		gates_list_search_bar.Size = UDim2.new(1,0,0.1,0)
		gates_list_search_bar.Parent = ores_frame
	end

	farming_type_frame = Instance.new("Frame")
	farming_type_frame.Draggable = true
	farming_type_frame.Name = "Farming Type"
	farming_type_frame.Active = true
	farming_type_frame.Visible = false
	farming_type_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
	farming_type_frame.AnchorPoint = Vector2.new(1, 0)
	farming_type_frame.Position = UDim2.new(.5, 0, 0.15, 0)
	farming_type_frame.Size = UDim2.new(0.25, 0, 0.4, 0)
	farming_type_frame.Parent = screen

	do

		local scroll_frame = Instance.new("ScrollingFrame")
		scroll_frame.Active = true
		scroll_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
		scroll_frame.Position = UDim2.new(0, 0, 0.1, 0)
		scroll_frame.Size = UDim2.new(1,0,0.9,0)
		scroll_frame.CanvasSize = UDim2.new(0,0,0,0)
		scroll_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll_frame.ScrollBarThickness = 0
		scroll_frame.Parent = farming_type_frame

		do
			local grid = Instance.new("UIGridLayout")
			grid.CellPadding = UDim2.new(0,0,0,1)
			grid.CellSize = UDim2.new(1,0,.15,0)
			grid.FillDirection = "Horizontal"
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
			grid.Parent = scroll_frame

		end
	end

	spawn_points_frame = Instance.new("Frame")
	spawn_points_frame.Draggable = true
	spawn_points_frame.Name = "Spawn Points"
	spawn_points_frame.Active = true
	spawn_points_frame.Visible = false
	spawn_points_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
	spawn_points_frame.AnchorPoint = Vector2.new(1, 0)
	spawn_points_frame.Position = UDim2.new(.5, 0, 0.15, 0)
	spawn_points_frame.Size = UDim2.new(0.25, 0, 0.4, 0)
	spawn_points_frame.Parent = screen

	do

		local scroll_frame = Instance.new("ScrollingFrame")
		scroll_frame.Active = true
		scroll_frame.BackgroundColor3 = Color3.fromRGB(49, 42, 39)
		scroll_frame.Position = UDim2.new(0, 0, 0.1, 0)
		scroll_frame.Size = UDim2.new(1,0,0.9,0)
		scroll_frame.CanvasSize = UDim2.new(0,0,0,0)
		scroll_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll_frame.ScrollBarThickness = 0
		scroll_frame.Parent = spawn_points_frame

		do
			local grid = Instance.new("UIGridLayout")
			grid.CellPadding = UDim2.new(0,0,0,1)
			grid.CellSize = UDim2.new(1,0,.15,0)
			grid.FillDirection = "Horizontal"
			grid.SortOrder = Enum.SortOrder.LayoutOrder
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
			grid.VerticalAlignment = Enum.VerticalAlignment.Top
			grid.Parent = scroll_frame

		end
	end

end
-----Startup:
task.delay(.5, function()
	for _,v in pairs(plants_path:GetChildren()) do
		if plants_list[v.Name] then continue end
		resigter_plants(v.Name)
	end
end)

task.delay(.5, function()
	for _,v in pairs(ores_path:GetChildren()) do
		if ores_list[v.Name] then continue end
		resigter_ores(v.Name)
	end
end)

task.delay(.5, function()
	for _,v in pairs(mobs_path:GetChildren()) do
		if not v:FindFirstChild("Health") then continue end
		if v:FindFirstChild("Health").Value <= 0 then continue end
		resigter_mob(v)
	end

	make_button_for_mob()

end)

task.delay(.5, function()
	for _,v in pairs(gates_path:GetChildren()) do
		resigter_gate(v)
	end

	make_button_for_gate()

end)

task.delay(.5, function()
	for v,_ in pairs(farming_type_lists) do
		local button = Instance.new("TextButton")
		button.Text = v
		button.Name = v
		button.TextScaled = true
		button.Parent = farming_type_frame:FindFirstChildOfClass("ScrollingFrame")

		button.Activated:Connect(function()
			sfx_click:Play()
			farming_type = v
			farming_type_button.Text = v
			farming_type_frame.Visible = false

			register_farming_type()
		end)
	end
end)

task.delay(.5, function()
	for i,name in pairs(spawn_points_ids) do
		for _,v in pairs(spawnpoints_path:GetChildren()) do
			if not v:IsA("Model") then continue end

			local str = v:FindFirstChild("SpawnPos") :: StringValue
			if not str then continue end

			if v:FindFirstChild("SpawnID").Value == i then
				local x, y, z = str.Value:match("([^,]+),([^,]+),([^,]+)")
				local pos = Vector3.new(tonumber(x), tonumber(y), tonumber(z))

				if str then
					local button = Instance.new("TextButton")
					button.Text = name
					button.Name = name
					button.LayoutOrder = i
					button.TextScaled = true
					button.Parent = spawn_points_frame:FindFirstChildOfClass("ScrollingFrame")

					button.Activated:Connect(function()
						sfx_click:Play()
						if not character_available() then return end

						local mag = (char.HumanoidRootPart.Position - pos).Magnitude

						go_to_pos(pos, mag)
					end)
				end
			end
		end
	end
end)

--Function:
close_button.MouseButton1Down:Connect(function()
	sfx_click:Play()
	if runner_adddecen then
		runner_adddecen:Disconnect()
	end

	if runner_removedecen then
		runner_removedecen:Disconnect()
	end

	DESTROYED = true

	screen:Destroy()
end)

minimize_button.MouseButton1Click:Connect(function()
	sfx_click:Play()
	Minimized = true
	main_frame.Visible = false
	show_button.Visible = true

	for _,v in pairs(screen:GetChildren()) do
		if v == main_frame then continue end
		if v == show_button then continue end
		if frame_store[v] then continue end
		frame_store[v] = v.Visible
		v.Visible = false
	end
end)

show_button.Activated:Connect(function()
	sfx_click:Play()
	Minimized = false
	main_frame.Visible = true
	show_button.Visible = false

	for i,v in pairs(frame_store) do
		i.Visible = v
	end

	frame_store = {}
end)

refresh_button.Activated:Connect(function()
	sfx_click:Play()
	for i,v in pairs(mobs_button_list) do
		v:Destroy()
	end

	for i,v in pairs(gates_button_list) do
		v:Destroy()
	end

	for _,v in pairs(ores_list) do
		v.button:Destroy()
	end

	for _,v in pairs(plants_list) do
		v.button:Destroy()
	end

	mobs_list = {}
	gates_list = {}
	ores_list = {}
	plants_list = {}

	mobs_button_list = {}
	gates_button_list = {}

	for _,v in pairs(gates_path:GetChildren()) do
		resigter_gate(v)
	end

	for _,v in pairs(mobs_path:GetChildren()) do
		if not v:FindFirstChild("Health") then continue end
		if v:FindFirstChild("Health").Value <= 0 then continue end
		resigter_mob(v)
	end

	for _,v in pairs(plants_path:GetChildren()) do
		if plants_list[v.Name] then continue end
		resigter_plants(v.Name)
	end

	for _,v in pairs(ores_path:GetChildren()) do
		if not ores_list[v.Name] then
			resigter_ores(v.Name)
		end
	end

	make_button_for_gate()
	make_button_for_mob()

end)

show_mob_hp_button.Activated:Connect(function()
	sfx_click:Play()
	mobs_frame.Visible = not mobs_frame.Visible
	show_mob_hp_button.Text = mobs_frame.Visible and "<" or ">"
end)

show_gate_button.Activated:Connect(function()
	sfx_click:Play()
	gates_frame.Visible = not gates_frame.Visible
	show_gate_button.Text = gates_frame.Visible and "<" or ">"
end)

show_ores_button.Activated:Connect(function()
	sfx_click:Play()
	ores_frame.Visible = not ores_frame.Visible
	show_ores_button.Text = ores_frame.Visible and "<" or ">"

	for name,vv in pairs(ores_list) do
		vv.button_func_true = function()
			for _,v in pairs(ores_path:GetChildren()) do
				if v.Name ~= name then continue end
				if v:FindFirstChild("HighOresEdok") then continue end
				local newhi = Instance.new("Highlight")
				newhi.Name = "HighOresEdok"
				newhi.Parent = v
			end
		end

		vv.button_func_false = function()
			for _,v in pairs(ores_path:GetChildren()) do
				if v.Name ~= name then continue end
				if v:FindFirstChild("HighOresEdok") then
					v:FindFirstChild("HighOresEdok"):Destroy()
				end
			end
		end
	end



end)

show_plants_button.Activated:Connect(function()
	sfx_click:Play()
	plants_frame.Visible = not plants_frame.Visible
	show_plants_button.Text = plants_frame.Visible and "<" or ">"

	for i,vv in pairs(plants_list) do
		vv.button_func_true = function()
			print(i)
			for _,v in pairs(plants_path:GetChildren()) do
				if v.Name ~= i then continue end
				if v:FindFirstChild("HighPlantsEdok") then continue end

				local collect_able = false

				for _,c : Instance in pairs(v:GetDescendants()) do
					if c:IsA("ProximityPrompt") then
						c.HoldDuration = 0
					end
					if collect_able then continue end
					if c:IsA("BoolValue") and c.Name == "Collectable" then
						if c.Value then
							collect_able = true
						end
					end
				end

				local bv = v:FindFirstAncestorOfClass("BoolValue")

				if collect_able then
					local newhi = Instance.new("Highlight")
					newhi.Name = "HighPlantsEdok"
					newhi.Parent = v
				end
			end
		end

		vv.button_func_false = function()
			for _,v in pairs(plants_path:GetChildren()) do
				if v.Name ~= i then continue end
				if v:FindFirstChild("HighPlantsEdok") then
					v:FindFirstChild("HighPlantsEdok"):Destroy()
				end
			end
		end
	end

end)

sell_useless_items_button.Activated:Connect(function()
	sfx_click:Play()
	local sell_all = true

	task.spawn(function()
		for _,v in pairs(items_to_sell_list) do
			if plr.Data[v].Value <= 0 then continue end

			if sell_all then
				rp.Remotes.SellItem:FireServer(v, "Sell", true) -- Sell All
			else
				rp.Remotes.SellItem:FireServer(v, "Sell", false) -- Sell One
			end
			task.wait(.5)
		end
	end)
end)

esp_sukuna_fingers_button.Activated:Connect(function()
	sfx_click:Play()
	for _,v in pairs(drops_path:GetChildren()) do
		if v.Name ~= "CursedFinger" then continue end
		add_sukuna_finger_bilboard(v)
	end
end)

--[[magnet_items_button.Activated:Connect(function()
	magnet_items = not magnet_items
	
	magnet_items_button.BackgroundColor3 = magnet_items and truecolor or falsecolor
end)]]

auto_attack_button.Activated:Connect(function()
	sfx_click:Play()
	auto_attack = not auto_attack
	auto_attack_button.BackgroundColor3 = auto_attack and truecolor or falsecolor

	if auto_attack then
		runner_auto_attack = task.spawn(function()
			while auto_attack do
				task.wait(tonumber(auto_attack_value_button.Text) or 1)
				if not character_available() then continue end
				if not char:FindFirstChildOfClass("Tool") then continue end
				local tool = char:FindFirstChildOfClass("Tool")
				if not tool:FindFirstChild("SwordScript") then continue end

				local nearest, pos = get_nearest_enemy()

				if not nearest then continue end

				task.spawn(function()
					if nearest:FindFirstChild("Head") then
						pos = nearest.Head.Position
					elseif nearest:FindFirstChild("HumanoidRootPart") then
						pos = pos
					end
					
					if tool.SwordScript:FindFirstChild("Activate") then
						tool.SwordScript.Activate:FireServer(pos)
					elseif tool.SwordScript:FindFirstChild("Charge") then
						tool.SwordScript.Charge:FireServer(pos)
					end
				end)

			end
		end)
	end
end)

farming_type_button.Activated:Connect(function()
	sfx_click:Play()
	farming_type_frame.Visible = not farming_type_frame.Visible
end)

farming_button.Activated:Connect(function()
	sfx_click:Play()
	farming = not farming
	farming_button.BackgroundColor3 = farming and truecolor or falsecolor

	if farming then
		no_cliping = rs.Stepped:Connect(nocliping)
	else
		cliping()
	end

	farming_function()

end)

spawn_points_button.Activated:Connect(function()
	sfx_click:Play()
	spawn_points_frame.Visible = not spawn_points_frame.Visible
end)

highlight_chests_button.Activated:Connect(function()
	sfx_click:Play()
	chest_highlight = not chest_highlight

	highlight_chests_button.BackgroundColor3 = chest_highlight and truecolor or falsecolor

	if chest_highlight then
		for _,v in pairs(chests_path:GetChildren()) do
			if v:FindFirstChild("HighChestEdok") then continue end

			for _,c : Instance in pairs(v:GetDescendants()) do
				if c:IsA("ProximityPrompt") then
					c.HoldDuration = 0
				end
			end

			local newhi = Instance.new("Highlight")
			newhi.Name = "HighChestEdok"
			newhi.Parent = v
		end
	else
		for _,v in pairs(chests_path:GetChildren()) do
			if v:FindFirstChild("HighChestEdok") then
				v:FindFirstChild("HighChestEdok"):Destroy()
			end
		end
	end
end)

--///// Settings

add_decent_button.Activated:Connect(function()
	sfx_click:Play()
	run_add_decent = not run_add_decent
	add_decent_button.BackgroundColor3 = run_add_decent and truecolor or falsecolor

	if run_add_decent then
		if not runner_adddecen then
			runner_adddecen = add_runner_add_decentdant()
		end
	else
		if runner_adddecen then
			runner_adddecen:Disconnect()
			runner_adddecen = nil
		end
	end
end)

remove_decent_button.Activated:Connect(function()
	sfx_click:Play()
	run_remove_decent = not run_remove_decent
	remove_decent_button.BackgroundColor3 = run_remove_decent and truecolor or falsecolor

	if run_remove_decent then
		if not runner_removedecen then
			runner_removedecen = add_runner_remove_decendant()
		end
	else
		if runner_removedecen then
			runner_removedecen:Disconnect()
			runner_removedecen = nil
		end
	end
end)

if clear_raid_button then
	clear_raid_button.Activated:Connect(function()
		sfx_click:Play()
		clear_raid = not clear_raid

		if clear_raid then
			clear_raid_button.BackgroundColor3 = truecolor
			runner_raid = task.spawn(function()
				while clear_raid do
					if target_mob_raid and target_mob_raid:FindFirstChild("Health").Value <= 0 then
						target_mob_raid = nil
					else
						for _,v in pairs(mobs_path:GetChildren()) do
							if not v:IsA("Model") then continue end
							if not v:FindFirstChild("Health") then continue end
							if v:FindFirstChild("Health").Value <= 0 then continue end

							target_mob_raid = v
							break
						end
					end

					get_behind()
					task.wait(.5)
				end
			end)
		else
			clear_raid_button.BackgroundColor3 = falsecolor
			if runner_raid then
				runner_raid:Disconnect()
				runner_raid = nil
			end
		end
	end)
end

if server_info_button then
	server_info_button.Activated:Connect(function()
		sfx_click:Play()

		--season_day_formula = ((day - 1) % 8) + 1

		local server_lists = plr.PlayerGui:FindFirstChild("Opening"):FindFirstChild("Servers"):FindFirstChild("List")

		for _,v in pairs(server_lists:GetChildren()) do
			if not v:IsA("Frame") then continue end

			local day_text = v.days :: TextLabel
			local newtext = v.location:Clone() :: TextLabel
			newtext.Parent = v
			newtext.TextXAlignment = Enum.TextXAlignment.Right
			local season

			local day = string.split(day_text.Text, " ")[2]

			local calculate = ((tonumber(day) - 1) % 8) + 1
			season = seasons_day[calculate]

			newtext.Text = "(" .. season .. ")"

		end

	end)
end

-----Passive:
runner_adddecen = add_runner_add_decentdant()

runner_removedecen = add_runner_remove_decendant()