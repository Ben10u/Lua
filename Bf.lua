local FolderName = "Mukuro/"
local gameFolder = FolderName .. "BF/"
local checkName = gameFolder .. "Mastery/"
local FileName = checkName .. game.Players.LocalPlayer.Name .. "_" .. game.Players.LocalPlayer.UserId
if isfolder and makefolder and isfile and writefile and readfile then
	local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name:gsub(" ", "")
	if not isfolder(FolderName) then
		makefolder(FolderName)
	end 
	if not isfolder(gameFolder) then
		makefolder(gameFolder)
	end
	if not isfolder(gameFolder) then
		makefolder(gameFolder)
	end
	if not isfolder(checkName) then
		makefolder(checkName)
	end
	if not isfile(FileName .. ".json") then
		writefile(FileName .. ".json", game:GetService("HttpService"):JSONEncode({["Sword"] = {},["Gun"] = {}}))
	end
	function SaveData()
		if isfolder and makefolder and isfile and writefile and readfile then
            if not getgenv().Data then
                getgenv().Data = {
                    ["Sword"] = {},
                    ["Gun"] = {}
                }
            end
			writefile(FileName .. ".json", game:GetService("HttpService"):JSONEncode(getgenv().Data))
		end
	end
	function LoadData()
		if isfolder and makefolder and isfile and writefile and readfile then
            if readfile(FileName .. ".json") ~= "" then
                getgenv().Data = game:GetService("HttpService"):JSONDecode(readfile(FileName .. ".json"))
            else
                getgenv().Data = {
                    ["Sword"] = {},
                    ["Gun"] = {}
                }
            end
		end
	end
	LoadData()
end
function getWeapon(tooltype)
    local plr = game:GetService("Players").LocalPlayer
    if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").ToolTip == tooltype then return plr.Character:FindFirstChildOfClass("Tool") end
    if plr.Backpack:FindFirstChildOfClass("Tool") and plr.Backpack:FindFirstChildOfClass("Tool").ToolTip == tooltype then return plr.Backpack:FindFirstChildOfClass("Tool") end
    for i,v in pairs(plr.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == tooltype then
            return v
        end
    end
    for i,v in pairs(plr.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == tooltype then
            return v
        end
    end
end
function CheckMastery(name)
    local plr = game.Players.LocalPlayer
    plr.Character:WaitForChild("Humanoid")
    local Weapon;
    if plr.Backpack:FindFirstChild(name) then
        Weapon = plr.Backpack:FindFirstChild(name)
    elseif plr.Character:FindFirstChild(name) and plr.Character[name]:IsA("Tool") then
        Weapon = plr.Character:FindFirstChild(name)
    end
    if Weapon and Weapon:FindFirstChild("Level") then
        return Weapon.Level.Value
    end
    return "It Not Weapon"
end
local weaponInventoryPos = {
    [2753915549] = {
        CFrame.new(-2557.06934, 6.88557816, 2007.11084, 0.164521873, 0, -0.986373425, 0, 1, 0, 0.986373425, 0, 0.164521873),
        CFrame.new(1079.20862, 16.2993488, 1326.4375, 0.296664834, 3.01947587e-08, -0.954981625, -3.74777187e-08, 1, 1.99757153e-08, 0.954981625, 2.9864438e-08, 0.296664834),
        CFrame.new()
    },
    [4442272183] = {
        CFrame.new(121.456818, 19.302536, 2852.9292, 0.74582994, -1.06090354e-08, -0.666136384, 1.54483075e-08, 1, 1.37025213e-09, 0.666136384, -1.13126548e-08, 0.74582994),
        CFrame.new(-301.001404, 73.0459366, 296.746765, -0.0360476449, 3.09554231e-08, -0.999350131, 9.07025068e-08, 1, 2.77038161e-08, 0.999350131, -8.96449208e-08, -0.0360476449)
    },
    [7449423635] = {
        CFrame.new(-218.57724, 6.7557435, 5326.46631, 0.965900421, 4.29310809e-09, -0.258913875, 2.63394178e-08, 1, 1.14842678e-07, 0.258913875, -1.17746232e-07, 0.965900421),
        CFrame.new(-12572.0156, 336.940155, -7445.2876, -0.999886394, -2.8463397e-08, 0.0150734931, -2.85671771e-08, 1, -6.66960975e-09, -0.0150734931, -7.09945924e-09, -0.999886394)
    }
}
function closetInventory()
    local plr = game.Players.LocalPlayer
    local Pos, distance = nil, math.huge
    for i,v in pairs(weaponInventoryPos[game.PlaceId]) do
        if (v.Position - plr.Character.HumanoidRootPart.Position).Magnitude < distance then
            Pos = v
            distance = (v.Position - plr.Character.HumanoidRootPart.Position).Magnitude
        end
    end
    return Pos
end
function tp(pos)
    local Plr = game.Players.LocalPlayer
    local val = Instance.new("CFrameValue")
    val.Value = Plr.Character.HumanoidRootPart.CFrame
    local tween = game:GetService("TweenService"):Create(
        val, 
        TweenInfo.new((Plr.Character.HumanoidRootPart.Position - pos.p).magnitude / 250, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), 
        {Value = pos}
    )
    tween:Play()
    local completed
    tween.Completed:Connect(function()
        completed = true
    end)
    while not completed do
        if Plr.Character.Humanoid.Health <= 0 then tween:Cancel() break end
        Plr.Character.HumanoidRootPart.CFrame = val.Value
        task.wait()
		if (Plr.Character.HumanoidRootPart.Position - pos.p).magnitude <= 150 then tween:Cancel(); Plr.Character.HumanoidRootPart.CFrame = pos break end
    end
    val:Destroy()
end
local plr = game.Players.LocalPlayer
local oldTool = getWeapon("Sword")
for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryWeapons")) do
    if v.Rarity > 2 and v.Type == "Sword" and not Data["Sword"][v.Name] then
        repeat wait() tp(closetInventory()); until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - closetInventory().Position).magnitude <= 1
        if oldTool and (plr.Character:FindFirstChild(oldTool.Name) or plr.Backpack:FindFirstChild(oldTool.Name)) then
            Data["Sword"][oldTool.Name] = CheckMastery(oldTool.Name)
            repeat wait()
                tp(closetInventory())
                if (closetInventory().Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 2 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreItem", oldTool.Name)
                end
            until not plr.Character:FindFirstChild(oldTool.Name) and not plr.Backpack:FindFirstChild(oldTool.Name)
        end
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", v.Name)
        local sword = plr.Backpack:WaitForChild(v.Name, 1) or plr.Character:WaitForChild(v.Name, 1)
        Data["Sword"][v.Name] = CheckMastery(v.Name)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreItem", v.Name)
    end
end
if oldTool and not plr.Character:FindFirstChild(oldTool.Name) and not plr.Backpack:FindFirstChild(oldTool.Name) then
    repeat wait()
        tp(closetInventory())
        if (closetInventory().Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 2 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", oldTool.Name)
        end
    until plr.Character:FindFirstChild(oldTool.Name) or plr.Backpack:FindFirstChild(oldTool.Name)
end
SaveData()

local cd = 0
local RigC = getupvalue(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework),2)
local RigLib = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
local kkii = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
kkii:Stop()
function maxincrement()
	return #RigC.activeController.anims.basic
end
function GetCurrentBlade() 
	local p13 = RigC.activeController
	local ret = p13.blades[1]
	if not ret then return end
	while ret.Parent~=game.Players.LocalPlayer.Character do ret=ret.Parent end
	return ret
end
function GetDistance(Endpoint, bool)
    local plr = game.Players.LocalPlayer
    local Endpoint = Endpoint
    if not bool then
        if typeof(Endpoint) == "Instance" then
            Endpoint = Vector3.new(Endpoint.Position.X, plr.Character.HumanoidRootPart.Position.Y, Endpoint.Position.Z)
        elseif typeof(Endpoint) == "CFrame" then
            Endpoint = Vector3.new(Endpoint.Position.X, plr.Character.HumanoidRootPart.Position.Y, Endpoint.Position.Z)
        else
            Endpoint = Vector3.new(Endpoint.X, plr.Character.HumanoidRootPart.Position.Y, Endpoint.Z)
        end
    else
        if typeof(Endpoint) == "Instance" then
            Endpoint = Vector3.new(Endpoint.Position.X, Endpoint.Position.Y, Endpoint.Position.Z)
        elseif typeof(Endpoint) == "CFrame" then
            Endpoint = Vector3.new(Endpoint.Position.X, Endpoint.Position.Y, Endpoint.Position.Z)
        else
            Endpoint = Vector3.new(Endpoint.X, Endpoint.Y, Endpoint.Z)
        end
    end
    local Magnitude = (Endpoint - plr.Character.HumanoidRootPart.Position).Magnitude
    return Magnitude
end
function Tween(Endpoint)
    local Endpoint = Endpoint
    if typeof(Endpoint) == "Instance" then
        Endpoint = Endpoint.CFrame
    end
    local TweenFunc = {}
    local Distance = GetDistance(Endpoint)
    if Distance >= 1500 then speed = 350; elseif Distance < 500 then speed = 250; elseif Distance < 1499 then speed = 300; end
    local TweenInfo = game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance/speed, Enum.EasingStyle.Linear), {CFrame = Endpoint})
    TweenInfo:Play()
    function TweenFunc:Cancel()
        game:GetService("RunService").RenderStepped:wait()
        TweenInfo:Cancel()
        return false
    end
	if Distance <= 300 then
        TweenInfo:Cancel()
        game:GetService("RunService").RenderStepped:wait()
		plr.Character.HumanoidRootPart.CFrame = Endpoint
		return false
	end
    return TweenFunc
end
function AttackNoCD()
	local plr = game:GetService("Players").LocalPlayer
	local AC = RigC.activeController
	if tick() - cd > 0.15 then
		cd = tick()
		local bladehit = RigLib.getBladeHits(plr.Character, {plr.Character.HumanoidRootPart}, 60)
		local cac = {}
		local hash = {}
		for k, v in pairs(bladehit) do
			if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
				table.insert(cac, v.Parent.HumanoidRootPart)
				hash[v.Parent] = true
			end
		end
		bladehit = cac
		if plr.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] and GetCurrentBlade().Parent == plr.Character then
			if #bladehit > 0 then
				local val = debug.getupvalues(AC.attack)
				local u8 = val[5]
				local u9 = val[6]
				local u7 = val[4]
				local u10 = val[7]
				local u12 = (u8 * 798405 + u7 * 727595) % u9
				local u13 = u7 * 798405
				u12 = (u12 * u9 + u13) % 1099511627776
				u8 = math.floor(u12 / u9)
				u7 = u12 - u8 * u9
				u10 = u10 + 1
				debug.setupvalue(AC.attack, 5, u8)
				debug.setupvalue(AC.attack, 6, u9)
				debug.setupvalue(AC.attack, 4, u7)
				debug.setupvalue(AC.attack, 7, u10)
				pcall(function()
					for k, v in pairs(AC.animator.anims.basic) do
						v:Play()
					end                  
				end)
				if plr.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] then
					AC.hitSound = false
					game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(GetCurrentBlade()))
					game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
					game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, maxincrement(), "")
					AC.attacking = false
				end
			end
		end
	end
end

local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/xQuartyx/DonateMe/main/DiscordLib")()
local win = DiscordLib:Window("discord library")
local serv = win:Server("Preview", "")
local Main = serv:Channel("Free Fire")

Main:Toggle("Mastery Sword", _G.AutoSwordMastery, function(vu)
    AutoFarm = vu
    if not vu and TweenFa then
        game:GetService("RunService").RenderStepped:Wait()
        TweenFa:Cancal()
    end
end)

local HauntedMon = {"Reborn Skeleton [Lv. 1975]", "Living Zombie [Lv. 2000]", "Demonic Soul [Lv. 2025]", "Posessed Mummy [Lv. 2050]"}
SwordName = getWeapon("Sword")
spawn(function()
    while wait() do
        pcall(function()
            SwordName = getWeapon("Sword").Name
        end)
    end
end)
function EquipWeapon(tool)
    local plr = game.Players.LocalPlayer
    local Humanoid = plr.Character:WaitForChild("Humanoid")
    if Humanoid.Health > 0 then
        if plr.Character:FindFirstChild(tool) and plr.Character[tool]:IsA("Tool") then
        else
			wait()
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(tool))
        end
    end
end
function getNewSword()
    for i,v in pairs(Data["Sword"]) do
        if v < _G.Mastery then
            return i
        end
    end
end

spawn(function()
    while wait() do
        pcall(function()
            if AutoFarm then
                if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

spawn(function()
    while wait() do
        pcall(function()
            if AutoFarm then
                if not SwordName then
                    repeat wait() tp(closetInventory()); game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", getNewSword()) until plr.Character:FindFirstChild(getNewSword()) or plr.Backpack:FindFirstChild(getNewSword())
                elseif SwordName and CheckMastery(SwordName) >= _G.Mastery then
                    Data["Sword"][SwordName] = CheckMastery(SwordName)
                    SaveData()
                    repeat wait() tp(closetInventory()); game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreItem", SwordName) until not plr.Character:FindFirstChild(SwordName) and not plr.Backpack:FindFirstChild(SwordName)
                    repeat wait() tp(closetInventory()); game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", getNewSword()) until plr.Character:FindFirstChild(getNewSword()) or plr.Backpack:FindFirstChild(getNewSword())
                else
                    if game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value ~= "HauntedCastle" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Domenic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if AutoFarm and table.find(HauntedMon, v.Name) and v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (game:GetService("Workspace")["_WorldOrigin"].Locations["Haunted Castle"].Position - v.HumanoidRootPart.Position).Magnitude <= 1000 then
                                repeat task.wait()
                                    TweenFa = Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
    							    EquipWeapon(SwordName)
    					    		v.HumanoidRootPart.CanCollide = false
    			    				v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
    								AttackNoCD()
    								PosMon = v.HumanoidRootPart.CFrame
    								Magnet = true
                                until not AutoFarm or not v:FindFirstChild("Humanoid") or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Head") or v.Humanoid.Health <= 0 or (game:GetService("Workspace")["_WorldOrigin"].Locations["Haunted Castle"].Position - v.HumanoidRootPart.Position).Magnitude > 1000
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Reborn Skeleton [Lv. 1975]") and game:GetService("ReplicatedStorage"):FindFirstChild("Reborn Skeleton [Lv. 1975]").Humanoid.Health > 0 and (game:GetService("Workspace")["_WorldOrigin"].Locations["Haunted Castle"].Position - game:GetService("ReplicatedStorage"):FindFirstChild("Reborn Skeleton [Lv. 1975]").HumanoidRootPart.Position).Magnitude <= 1200 then
                        TweenFa = Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Reborn Skeleton [Lv. 1975]").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Living Zombie [Lv. 2000]") and game:GetService("ReplicatedStorage"):FindFirstChild("Living Zombie [Lv. 2000]").Humanoid.Health > 0 and (game:GetService("Workspace")["_WorldOrigin"].Locations["Haunted Castle"].Position - game:GetService("ReplicatedStorage"):FindFirstChild("Living Zombie [Lv. 2000]").HumanoidRootPart.Position).Magnitude <= 1200 then
                        TweenFa = Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Living Zombie [Lv. 2000]").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Demonic Soul [Lv. 2025]") and game:GetService("ReplicatedStorage"):FindFirstChild("Demonic Soul [Lv. 2025]").Humanoid.Health > 0 and (game:GetService("Workspace")["_WorldOrigin"].Locations["Haunted Castle"].Position - game:GetService("ReplicatedStorage"):FindFirstChild("Demonic Soul [Lv. 2025]").HumanoidRootPart.Position).Magnitude <= 1200 then
                        TweenFa = Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Demonic Soul [Lv. 2025]").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Posessed Mummy [Lv. 2050]") and game:GetService("ReplicatedStorage"):FindFirstChild("Posessed Mummy [Lv. 2050]").Humanoid.Health > 0 and (game:GetService("Workspace")["_WorldOrigin"].Locations["Haunted Castle"].Position - game:GetService("ReplicatedStorage"):FindFirstChild("Posessed Mummy [Lv. 2050]").HumanoidRootPart.Position).Magnitude <= 1200 then
                        TweenFa = Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Posessed Mummy [Lv. 2050]").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                    end
                end
            end
        end)
    end
end)

spawn(function()
	while task.wait() do
		pcall(function()
			if AutoFarm and Magnet then
				for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
						if table.find(HauntedMon, v.Name) then
							if (v.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 250 then
								v.HumanoidRootPart.CanCollide = false
								v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
								v.HumanoidRootPart.CFrame = PosMon
								sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
							end
						end
					end
				end
			end
		end)
	end
end)

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if AutoFarm then
			if plr.Character.Humanoid.Sit then
				game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(3)
			elseif not plr.Character.Humanoid.Sit then
				if syn then
					setfflag("HumanoidParallelRemoveNoPhysics", "False")
					setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
					game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
				else
					if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MyBodyVelocity") then
						local BodyVelocity = Instance.new("BodyVelocity")
						BodyVelocity.Name = "MyBodyVelocity"
						BodyVelocity.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
						BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
						BodyVelocity.Velocity = Vector3.new(0, 0, 0)
					end
				end
				for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
        elseif not syn then
            if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MyBodyVelocity") then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("MyBodyVelocity"):Destroy()
            end
        end
    end)
end)
