-- Bubble Gum Simulator Infinity - All-in-One Script
-- v2.0 - Complete Edition with Circus & All Teleports

getgenv().Functions = {
    -- Main Functions
    AutoBlowBubbles = false;
    AutoSell = false;
    AutoCollectPickups = false;
    FasterEggs = false;
    
    -- Fishing
    AutoFish = false;
    
    -- Rewards & Claims
    AutoClaimPlaytimeRewards = false;
    AutoClaimSeasonRewards = false;
    AutoClaimWheelSpin = false;
    AutoClaimChests = false;
    AutoBuyFromMarkets = false;
    AutoOpenMysteryBox = false;
    AutoGenieQuest = false;
    
    -- Rifts
    UseGoldenKeys = false;
    UseRoyalKeys = false;
    
    -- Circus
    AutoPlayMinigame = false;
    AutoBuyCircusShop = false;
    AutoHatchCircusEggs = false;
    
    -- CPU
    Disable3DRendering = false;
    BlackOutScreen = false;
    FixFPSCap = false;
};

-- Anti-AFK
for i, v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
    v:Disable();
end;

-- Remote references
local RemoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteEvent")
local RemoteFunction = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteFunction")

-- Utility Functions
local function CollectPickups()
    for i, v in next, game:GetService("Workspace").Rendered:GetChildren() do
        if v.Name == "Chunker" then
            for i2, v2 in next, v:GetChildren() do
                local Part, HasMeshPart = v2:FindFirstChild("Part"), v2:FindFirstChildWhichIsA("MeshPart");
                local HasStars = Part and Part:FindFirstChild("Stars");
                local HasPartMesh = Part and Part:FindFirstChild("Mesh");
                if HasMeshPart or HasStars or HasPartMesh then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pickups"):WaitForChild("CollectPickup"):FireServer(v2.Name);
                    v2:Destroy();
                end;
            end;
        end;
    end;
end;

local function TweenTo(Position, Speed)
    local CFrameValue = Instance.new("CFrameValue");
    CFrameValue.Value = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameValue.Value;
    end);
    game:GetService("TweenService"):Create(CFrameValue, TweenInfo.new(Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Value = Position}):Play();
end;

local function FancyNumberTranslator(FancyNumber)
    local FancyNumbers = {
        ["I"] = 1, ["II"] = 2, ["III"] = 3, ["IV"] = 4, ["V"] = 5, ["VI"] = 6;
    };
    return FancyNumbers[FancyNumber];
end;

local function GetTimerText(Text)
    local Hour, Minute, Second = string.match(Text, "^(%d+):(%d%d):(%d%d)$");
    if Hour and Minute and Second then
        return string.format("%02d:%02d:%02d", tonumber(Hour), tonumber(Minute), tonumber(Second));
    end;
    local Minute, Second = string.match(Text, "^(%d+):(%d%d)$");
    if Minute and Second then
        return string.format("00:%02d:%02d", tonumber(Minute), tonumber(Second));
    end;
    local Second = string.match(Text, "^(%d+)$");
    if Second then
        return string.format("00:00:%02d", tonumber(Second));
    end;
    return nil;
end;

local function CapitalizeTimeUnit(String)
    local Number, Unit = String:match("^(%d+)%s*(%a+)$");
    if Number and Unit then
        Unit = Unit:sub(1, 1):upper() .. Unit:sub(2);
        return Number .. " " .. Unit;
    else
        return String;
    end;
end;

local function FetchRiftEggs(x25)
    local FoundRiftEggs, Foundx25Eggs = {}, {};
    for i, v in next, game:GetService("Workspace").Rendered.Rifts:GetChildren() do
        if not table.find({"golden-chest", "royal-chest", "gift-rift"}, v.Name) then
            if v.Display.SurfaceGui.Icon.Luck.Text == "x25" then
                table.insert(Foundx25Eggs, v);
            else
                table.insert(FoundRiftEggs, v);
            end;
        end;
    end;
    return x25 and Foundx25Eggs or FoundRiftEggs;
end;

-- Load UI Library
local Repository = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/";
local Library = loadstring(game:HttpGet(Repository .. "Library.lua"))();
local ThemeManager = loadstring(game:HttpGet(Repository .. "addons/ThemeManager.lua"))();
local SaveManager = loadstring(game:HttpGet(Repository .. "addons/SaveManager.lua"))();

local Options = Library.Options;
local Toggles = Library.Toggles;

local Window = Library:CreateWindow({
    Title = "Bubble Gum Simulator ∞ - Complete Edition 🎪";
    Footer = "All-in-One Script v2.0";
    NotifySide = "Right";
    ShowCustomCursor = true;
});

-- Create Tabs
local Tabs = {
    Main = Window:AddTab("Main", "home");
    Eggs = Window:AddTab("Eggs", "egg");
    Pickups = Window:AddTab("Pickup Collector", "diamond");
    Fishing = Window:AddTab("Fishing", "fish");
    Circus = Window:AddTab("Circus Event", "tent");
    Potions = Window:AddTab("Potions", "flask-conical");
    Rifts = Window:AddTab("Rifts", "atom");
    Teleports = Window:AddTab("Teleports", "map-pin");
    CPU = Window:AddTab("CPU Settings", "cpu");
    Settings = Window:AddTab("Settings", "settings");
};

-- ============================================
-- MAIN TAB
-- ============================================
local MainFunctions = Tabs.Main:AddLeftGroupbox("Main Functions");

MainFunctions:AddToggle("AutoBlowBubbles", {
    Text = "Auto Blow Bubbles";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoBlowBubbles = Value;
        task.spawn(function()
            while Functions.AutoBlowBubbles do
                task.wait();
                RemoteEvent:FireServer("BlowBubble");
            end;
        end);
    end;
});

MainFunctions:AddToggle("AutoSell", {
    Text = "Auto Sell";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoSell = Value;
        task.spawn(function()
            while Functions.AutoSell do
                task.wait();
                RemoteEvent:FireServer("SellBubble");
            end;
        end);
    end;
});

MainFunctions:AddToggle("AutoCollectPickups", {
    Text = "Auto Collect Pickups";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoCollectPickups = Value;
        task.spawn(function()
            while Functions.AutoCollectPickups do
                CollectPickups();
                task.wait(1);
            end;
        end);
    end;
});

MainFunctions:AddToggle("FasterEggs", {
    Text = "Faster Eggs";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.FasterEggs = Value;
        task.spawn(function()
            while Functions.FasterEggs do
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.R, false, game);
                task.wait();
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.R, false, game);
            end;
        end);
    end;
});

local QuickToggles = Tabs.Main:AddLeftGroupbox("Quick Toggles");

QuickToggles:AddButton({
    Text = "Toggle Best";
    Func = function()
        Toggles.AutoBlowBubbles:SetValue(true);
        Toggles.AutoCollectPickups:SetValue(true);
        Toggles.FasterEggs:SetValue(true);
        Toggles.AutoClaimPlaytimeRewards:SetValue(true);
        Toggles.AutoClaimWheelSpin:SetValue(true);
        Toggles.AutoClaimChests:SetValue(true);
        Toggles.AutoBuyFromMarkets:SetValue(true);
        Toggles.AutoGenieQuest:SetValue(true);
    end;
    Tooltip = "Enables main farming features";
    Risky = true;
});

QuickToggles:AddButton({
    Text = "Untoggle All";
    Func = function()
        for name, toggle in pairs(Toggles) do
            toggle:SetValue(false);
        end;
    end;
    Tooltip = "Disables ALL toggles";
    Risky = true;
});

local OtherFunctions = Tabs.Main:AddRightGroupbox("Other Functions");

OtherFunctions:AddToggle("AutoClaimPlaytimeRewards", {
    Text = "Auto Claim Playtime Rewards";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoClaimPlaytimeRewards = Value;
        task.spawn(function()
            while Functions.AutoClaimPlaytimeRewards do
                for i = 1, 9 do
                    task.wait();
                    RemoteFunction:InvokeServer("ClaimPlaytime", i);
                end;
                task.wait(60);
            end;
        end);
    end;
});

OtherFunctions:AddToggle("AutoClaimWheelSpin", {
    Text = "Auto Claim Wheel Spin";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoClaimWheelSpin = Value;
        task.spawn(function()
            while Functions.AutoClaimWheelSpin do
                task.wait();
                RemoteEvent:FireServer("ClaimFreeWheelSpin");
            end;
        end);
    end;
});

OtherFunctions:AddToggle("AutoClaimSeasonRewards", {
    Text = "Auto Claim Season Rewards";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoClaimSeasonRewards = Value;
        task.spawn(function()
            while Functions.AutoClaimSeasonRewards do
                task.wait();
                RemoteEvent:FireServer("ClaimSeason");
            end;
        end);
    end;
});

OtherFunctions:AddToggle("AutoClaimChests", {
    Text = "Auto Claim Chests";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoClaimChests = Value;
        task.spawn(function()
            local Chests = {"Void Chest", "Giant Chest", "Infinity Chest", "Ticket Chest"};
            while Functions.AutoClaimChests do
                for i, v in next, Chests do
                    RemoteEvent:FireServer("ClaimChest", v, true);
                    task.wait(1);
                end;
                task.wait(60);
            end;
        end);
    end;
});

OtherFunctions:AddToggle("AutoBuyFromMarkets", {
    Text = "Auto Buy From Markets";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoBuyFromMarkets = Value;
        task.spawn(function()
            while Functions.AutoBuyFromMarkets do
                local Markets = {"alien-shop", "shard-shop"};
                for _, v in next, Markets do
                    for i = 1, 3 do
                        RemoteEvent:FireServer("BuyShopItem", v, i);
                    end;
                end;
                task.wait(60);
            end;
        end);
    end;
});

OtherFunctions:AddToggle("AutoOpenMysteryBox", {
    Text = "Auto Open Mystery Box";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoOpenMysteryBox = Value;
        task.spawn(function()
            while Functions.AutoOpenMysteryBox do
                task.wait();
                RemoteEvent:FireServer("UseGift", "Mystery Box", 1);
                RemoteEvent:FireServer("UseGift", "Golden Box", 1);
                for i, v in next, game:GetService("Workspace").Rendered.Gifts:GetChildren() do
                    RemoteEvent:FireServer("ClaimGift", v.Name);
                    task.wait();
                    v:Destroy();
                end;
            end;
        end);
    end;
});

OtherFunctions:AddToggle("AutoGenieQuest", {
    Text = "Auto Genie Quest";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoGenieQuest = Value;
        task.spawn(function()
            while Functions.AutoGenieQuest do
                RemoteEvent:FireServer("StartGenieQuest", math.random(1, 3));
                task.wait(3600);
            end;
        end);
    end;
});

OtherFunctions:AddButton({
    Text = "Redeem All Codes";
    Func = function()
        local Codes = {"easter", "RELEASE", "Lucky", "Thanks"};
        for i, v in next, Codes do
            RemoteFunction:InvokeServer("RedeemCode", v);          
        end;
    end;
});

-- ============================================
-- EGGS TAB
-- ============================================
local EggsMain = Tabs.Eggs:AddLeftGroupbox("Regular Eggs");

-- All egg names from Remote Spy
local RegularEggs = {
    "Common Egg",
    "Spotted Egg",
    "Iceshard Egg",
    "Spikey Egg",
    "Magma Egg",
    "Crystal Egg",
    "Lunar Egg",
    "Void Egg",
    "Hell Egg",
    "Nightmare Egg",
    "Rainbow Egg",
    "Showman Egg",
    "Mining Egg",
    "Cyber Egg",
    "Neon Egg",
};

-- Track which eggs are auto-hatching
local AutoHatchingEggs = {};

for _, eggName in ipairs(RegularEggs) do
    EggsMain:AddToggle("AutoHatch_" .. eggName:gsub(" ", ""), {
        Text = "Auto: " .. eggName;
        Default = false;
        Callback = function(Value)
            AutoHatchingEggs[eggName] = Value;
            if Value then
                task.spawn(function()
                    while AutoHatchingEggs[eggName] do
                        RemoteEvent:FireServer("HatchEgg", eggName, 6);
                        task.wait(); -- Instant/continuous fire
                    end;
                end);
            end;
        end;
        Tooltip = "Instantly hatches " .. eggName;
    });
end;

local CircusEggsBox = Tabs.Eggs:AddRightGroupbox("Circus Eggs");

local CircusEggs = {"Clown Egg", "Cannon Egg", "Magic Egg"};

for _, eggName in ipairs(CircusEggs) do
    CircusEggsBox:AddToggle("AutoHatch_" .. eggName:gsub(" ", ""), {
        Text = "Auto: " .. eggName;
        Default = false;
        Callback = function(Value)
            AutoHatchingEggs[eggName] = Value;
            if Value then
                task.spawn(function()
                    while AutoHatchingEggs[eggName] do
                        RemoteEvent:FireServer("HatchEgg", eggName, 6);
                        task.wait();
                    end;
                end);
            end;
        end;
        Tooltip = "Instantly hatches " .. eggName;
    });
end;

CircusEggsBox:AddDivider();
CircusEggsBox:AddLabel("⚠️ Circus eggs require");
CircusEggsBox:AddLabel("Circus Tickets to hatch!");

local EggsControls = Tabs.Eggs:AddLeftGroupbox("Quick Controls");

EggsControls:AddButton({
    Text = "✓ Enable All Regular Eggs";
    Func = function()
        for _, eggName in ipairs(RegularEggs) do
            local toggleName = "AutoHatch_" .. eggName:gsub(" ", "");
            if Toggles[toggleName] then
                Toggles[toggleName]:SetValue(true);
            end;
        end;
        Library:Notify({
            Title = "All Regular Eggs Enabled";
            Description = "Auto-hatch active for all";
            Time = 2;
        });
    end;
    Risky = true;
    Tooltip = "Enables all 15 regular eggs at once";
});

EggsControls:AddButton({
    Text = "✗ Disable All Eggs";
    Func = function()
        local allEggs = {};
        for _, egg in ipairs(RegularEggs) do table.insert(allEggs, egg); end;
        for _, egg in ipairs(CircusEggs) do table.insert(allEggs, egg); end;
        
        for _, eggName in ipairs(allEggs) do
            local toggleName = "AutoHatch_" .. eggName:gsub(" ", "");
            if Toggles[toggleName] then
                Toggles[toggleName]:SetValue(false);
            end;
        end;
        Library:Notify({
            Title = "All Eggs Disabled";
            Description = "Auto-hatch stopped";
            Time = 2;
        });
    end;
    Tooltip = "Disables ALL egg auto-hatching";
});

EggsControls:AddDivider();
EggsControls:AddLabel("⚡ How it works:");
EggsControls:AddLabel("• Instant/continuous hatching");
EggsControls:AddLabel("• No delay between hatches");
EggsControls:AddLabel("• Uses triple hatch (6)");
EggsControls:AddLabel("• Enable while farming");

local EggsManual = Tabs.Eggs:AddRightGroupbox("Manual Hatching");

local ManualEggSelect = EggsManual:AddDropdown("ManualEggSelect", {
    Values = RegularEggs;
    Default = 1;
    Text = "Select Egg";
    Callback = function(Value) return; end;
});

local ManualHatchAmount = EggsManual:AddSlider("ManualHatchAmount", {
    Text = "Hatch Amount";
    Default = 1;
    Min = 1;
    Max = 100;
    Rounding = 1;
    Callback = function(Value) return; end;
});

EggsManual:AddButton({
    Text = "Hatch Selected Egg";
    Func = function()
        local eggName = ManualEggSelect.Value;
        local amount = ManualHatchAmount.Value;
        
        task.spawn(function()
            for i = 1, amount do
                RemoteEvent:FireServer("HatchEgg", eggName, 6);
                task.wait(0.1);
            end;
        end);
        
        Library:Notify({
            Title = "Hatching";
            Description = amount .. "x " .. eggName;
            Time = 2;
        });
    end;
});

EggsManual:AddButton({
    Text = "Hatch All Types (1x each)";
    Func = function()
        task.spawn(function()
            for _, eggName in ipairs(RegularEggs) do
                RemoteEvent:FireServer("HatchEgg", eggName, 6);
                task.wait(0.1);
            end;
        end);
        
        Library:Notify({
            Title = "Hatching All";
            Description = "One of each egg type";
            Time = 2;
        });
    end;
});

-- ============================================
-- PICKUP COLLECTOR TAB
-- ============================================
local PickupMainBox = Tabs.Pickups:AddLeftGroupbox("Auto Collection");

local CollectionSpeed = PickupMainBox:AddSlider("CollectionSpeed", {
    Text = "Collection Speed";
    Default = 0.1;
    Min = 0.05;
    Max = 1.0;
    Rounding = 2;
    Tooltip = "Lower = faster collection (but more lag)";
    Callback = function(Value)
        PickupCollector.CollectionSpeed = Value;
    end;
});

PickupMainBox:AddToggle("AutoCollectPickups", {
    Text = "💎 Auto Collect Pickups";
    Default = false;
    Callback = function(Value)
        PickupCollector.AutoCollect = Value;
        if Value then
            StartAutoCollect();
        end;
    end;
    Tooltip = "Automatically collects all pickups";
});

PickupMainBox:AddDivider();
PickupMainBox:AddLabel("What this does:");
PickupMainBox:AddLabel("✓ Finds all pickups");
PickupMainBox:AddLabel("✓ Collects them instantly");
PickupMainBox:AddLabel("✓ Destroys client-side");
PickupMainBox:AddLabel("✓ Works everywhere");

-- Manual Controls
local PickupManualBox = Tabs.Pickups:AddRightGroupbox("Manual Controls");

PickupManualBox:AddButton({
    Text = "Collect Once";
    Func = function()
        local collected = CollectAllPickups();
        Library:Notify({
            Title = "Collected!";
            Description = "Collected " .. collected .. " pickups";
            Time = 2;
        });
    end;
    Tooltip = "Collects all pickups once";
});

PickupManualBox:AddButton({
    Text = "Rapid Collect (10x)";
    Func = function()
        task.spawn(function()
            local total = 0;
            for i = 1, 10 do
                total = total + CollectAllPickups();
                task.wait(0.05);
            end;
            Library:Notify({
                Title = "Rapid Collect Complete";
                Description = "Collected " .. total .. " pickups";
                Time = 2;
            });
        end);
    end;
});

PickupManualBox:AddDivider();

local PickupInfoLabel = PickupManualBox:AddLabel("Pickups Nearby: 0");

task.spawn(function()
    while task.wait(1) do
        local count = 0;
        pcall(function()
            if game:GetService("Workspace"):FindFirstChild("Rendered") then
                for _, chunker in pairs(game:GetService("Workspace").Rendered:GetChildren()) do
                    if chunker.Name == "Chunker" then
                        count = count + #chunker:GetChildren();
                    end;
                end;
            end;
        end);
        PickupInfoLabel:SetText("Pickups Nearby: " .. count);
    end;
end);

-- Statistics Box
local PickupStatsBox = Tabs.Pickups:AddLeftGroupbox("Session Statistics");

local PickupTotalLabel = PickupStatsBox:AddLabel("Total Collected: 0");
local PickupTimeLabel = PickupStatsBox:AddLabel("Session Time: 0:00");
local PickupRateLabel = PickupStatsBox:AddLabel("Collection Rate: 0/s");
local PickupAvgLabel = PickupStatsBox:AddLabel("Average: 0/min");

PickupStatsBox:AddDivider();

PickupStatsBox:AddButton({
    Text = "Reset Statistics";
    Func = function()
        PickupCollector.TotalCollected = 0;
        PickupCollector.SessionStart = tick();
        Library:Notify({
            Title = "Stats Reset";
            Description = "All statistics cleared";
            Time = 2;
        });
    end;
});

-- Update stats
task.spawn(function()
    while task.wait(1) do
        local sessionTime = tick() - PickupCollector.SessionStart;
        local minutes = math.floor(sessionTime / 60);
        local seconds = math.floor(sessionTime % 60);
        
        PickupTotalLabel:SetText("Total Collected: " .. PickupCollector.TotalCollected);
        PickupTimeLabel:SetText(string.format("Session Time: %d:%02d", minutes, seconds));
        PickupRateLabel:SetText(string.format("Collection Rate: %.1f/s", PickupCollector.CollectPerSecond));
        
        local avgPerMin = sessionTime > 0 and (PickupCollector.TotalCollected / sessionTime * 60) or 0;
        PickupAvgLabel:SetText(string.format("Average: %.0f/min", avgPerMin));
    end;
end);

-- Settings Box
local PickupSettingsBox = Tabs.Pickups:AddRightGroupbox("Collection Settings");

local DestroyPickups = PickupSettingsBox:AddToggle("DestroyPickups", {
    Text = "Destroy After Collection";
    Default = true;
    Callback = function(Value)
        PickupCollector.DestroyAfterCollection = Value;
    end;
    Tooltip = "Remove pickups client-side after collecting";
});

local CollectFromWorlds = PickupSettingsBox:AddToggle("CollectFromWorlds", {
    Text = "Also Scan World Pickups";
    Default = false;
    Callback = function(Value)
        PickupCollector.ScanWorldPickups = Value;
    end;
    Tooltip = "Scans Workspace.Worlds for additional pickups (slower)";
});

PickupSettingsBox:AddDivider();

PickupSettingsBox:AddLabel("Performance Guide:");
PickupSettingsBox:AddDivider();
PickupSettingsBox:AddLabel("0.05s = Ultra Fast (laggy)");
PickupSettingsBox:AddLabel("0.1s = Fast (recommended)");
PickupSettingsBox:AddLabel("0.25s = Normal");
PickupSettingsBox:AddLabel("0.5s = Slow (smooth)");
PickupSettingsBox:AddLabel("1.0s = Very Slow");
PickupSettingsBox:AddDivider();
PickupSettingsBox:AddLabel("Lower speed collects more");
PickupSettingsBox:AddLabel("but may cause lag/stuttering");

-- ============================================
-- FISHING TAB
-- ============================================
local FishingBox = Tabs.Fishing:AddLeftGroupbox("Auto Fishing");

local RodID = FishingBox:AddInput("RodID", {
    Default = "";
    Numeric = false;
    Text = "Your Rod ID";
    Placeholder = "Use Remote Spy to find";
    Callback = function(Value) return; end;
});

local CastPower = FishingBox:AddSlider("CastPower", {
    Text = "Cast Power %";
    Default = 100;
    Min = 50;
    Max = 100;
    Rounding = 1;
    Callback = function(Value) return; end;
});

local WaitTime = FishingBox:AddSlider("WaitTime", {
    Text = "Wait Time (seconds)";
    Default = 3;
    Min = 1;
    Max = 10;
    Rounding = 1;
    Callback = function(Value) return; end;
});

FishingBox:AddToggle("AutoFish", {
    Text = "Auto Fish";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoFish = Value;
        task.spawn(function()
            while Functions.AutoFish do
                pcall(function()
                    -- Equip rod
                    RemoteEvent:FireServer("EquipRod");
                    task.wait(0.5);
                    
                    -- Begin cast
                    RemoteEvent:FireServer("BeginCastCharge");
                    task.wait(0.1);
                    
                    -- Finish cast with luck (FIXED: use numbers not vectors)
                    local rodId = RodID.Value ~= "" and RodID.Value or "d748a927-34e3-4f5f-a17d-e8ce22904317";
                    RemoteEvent:FireServer("FinishCastCharge", 
                        rodId,
                        CastPower.Value,
                        math.random(100, 200) / 100, -- Luck 1.0-2.0x
                        0, 0, 0, 0  -- Position/rotation (all zeros)
                    );
                    
                    -- Wait for bite
                    task.wait(WaitTime.Value);
                    
                    -- Reel in
                    RemoteEvent:FireServer("Reel", true);
                    
                    -- Wait for reel animation
                    task.wait(2);
                end);
                task.wait(1);
            end;
        end);
    end;
});

local FishingManual = Tabs.Fishing:AddRightGroupbox("Manual Controls");

FishingManual:AddButton({
    Text = "Equip Rod";
    Func = function()
        RemoteEvent:FireServer("EquipRod");
    end;
});

FishingManual:AddButton({
    Text = "Cast at 2.0x Luck";
    Func = function()
        RemoteEvent:FireServer("BeginCastCharge");
        task.wait(0.1);
        local rodId = RodID.Value ~= "" and RodID.Value or "d748a927-34e3-4f5f-a17d-e8ce22904317";
        RemoteEvent:FireServer("FinishCastCharge", rodId, 100, 2.0, 0, 0, 0, 0);
    end;
});

FishingManual:AddButton({
    Text = "Reel In";
    Func = function()
        RemoteEvent:FireServer("Reel", true);
    end;
});

FishingManual:AddDivider();
FishingManual:AddLabel("How to find Rod ID:");
FishingManual:AddLabel("1. Use Remote Spy");
FishingManual:AddLabel("2. Cast manually");
FishingManual:AddLabel("3. Look for FinishCastCharge");
FishingManual:AddLabel("4. Copy the long ID string");

local FishingTeleports = Tabs.Fishing:AddLeftGroupbox("Fishing Spots");

FishingTeleports:AddButton({
    Text = "Fisher's Island";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.Seven Seas.Areas.Fisher's Island.IslandTeleport.Spawn");
    end;
});

FishingTeleports:AddButton({
    Text = "Classic Island";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.Seven Seas.Areas.Classic Island.IslandTeleport.Spawn");
    end;
});

FishingTeleports:AddButton({
    Text = "Dream Island";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.Seven Seas.Areas.Dream Island.IslandTeleport.Spawn");
    end;
});

-- ============================================
-- CIRCUS TAB
-- ============================================
local CircusMinigame = Tabs.Circus:AddLeftGroupbox("Pet Match Minigame");

local MinigameDifficulty = CircusMinigame:AddDropdown("MinigameDifficulty", {
    Values = {"Easy", "Medium", "Hard", "Insane"};
    Default = 1;
    Text = "Select Difficulty";
    Callback = function(Value) return; end;
});

local MinigameDelay = CircusMinigame:AddSlider("MinigameDelay", {
    Text = "Delay Between Games";
    Default = 35;
    Min = 20;
    Max = 120;
    Rounding = 1;
    Callback = function(Value) return; end;
});

CircusMinigame:AddToggle("AutoPlayMinigame", {
    Text = "Auto Play Pet Match";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoPlayMinigame = Value;
        task.spawn(function()
            while Functions.AutoPlayMinigame do
                -- Get current difficulty
                local difficulty = Options.MinigameDifficulty.Value or "Easy";
                
                -- Start the minigame
                RemoteEvent:FireServer("StartMinigame", "Circus Pet Match", difficulty);
                print("✓ Started minigame:", difficulty);
                
                -- Wait 8 seconds before finishing
                task.wait(8);
                
                -- Finish the minigame
                pcall(function()
                    RemoteEvent:FireServer("FinishMinigame");
                    print("✓ Finished minigame");
                end);
                
                -- Wait the delay before next game
                local delay = Options.MinigameDelay.Value or 35;
                task.wait(delay);
            end;
        end);
    end;
});

CircusMinigame:AddDivider();

CircusMinigame:AddButton({
    Text = "Play Once";
    Func = function()
        RemoteEvent:FireServer("StartMinigame", "Circus Pet Match", MinigameDifficulty.Value);
    end;
});

CircusMinigame:AddButton({
    Text = "Finish Minigame";
    Func = function()
        RemoteEvent:FireServer("FinishMinigame");
    end;
});

local CircusShop = Tabs.Circus:AddRightGroupbox("Ticket Shop");

CircusShop:AddButton({
    Text = "Buy Item 1";
    Func = function()
        RemoteEvent:FireServer("BuyShopItem", "circus-ticket-shop", 1, false);
    end;
});

CircusShop:AddButton({
    Text = "Buy Item 2";
    Func = function()
        RemoteEvent:FireServer("BuyShopItem", "circus-ticket-shop", 2, false);
    end;
});

CircusShop:AddButton({
    Text = "Buy Item 3";
    Func = function()
        RemoteEvent:FireServer("BuyShopItem", "circus-ticket-shop", 3, false);
    end;
});

CircusShop:AddDivider();

CircusShop:AddButton({
    Text = "Buy All Items";
    Func = function()
        for i = 1, 3 do
            RemoteEvent:FireServer("BuyShopItem", "circus-ticket-shop", i, false);
            task.wait(0.5);
        end;
    end;
});

local AutoBuyInterval = CircusShop:AddSlider("AutoBuyInterval", {
    Text = "Auto Buy Interval";
    Default = 60;
    Min = 30;
    Max = 300;
    Rounding = 1;
    Callback = function(Value) return; end;
});

CircusShop:AddToggle("AutoBuyCircusShop", {
    Text = "Auto Buy All Items";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.AutoBuyCircusShop = Value;
        task.spawn(function()
            while Functions.AutoBuyCircusShop do
                for i = 1, 3 do
                    RemoteEvent:FireServer("BuyShopItem", "circus-ticket-shop", i, false);
                    task.wait(0.5);
                end;
                task.wait(AutoBuyInterval.Value);
            end;
        end);
    end;
});

local CircusEggs = Tabs.Circus:AddLeftGroupbox("Circus Eggs");

local EggTypes = {"Clown Egg", "Cannon Egg", "Magic Egg"};
local SelectedEgg = CircusEggs:AddDropdown("SelectedEgg", {
    Values = EggTypes;
    Default = 1;
    Text = "Select Egg Type";
    Callback = function(Value) return; end;
});

local EggAmount = CircusEggs:AddSlider("EggAmount", {
    Text = "Number of Eggs";
    Default = 1;
    Min = 1;
    Max = 100;
    Rounding = 1;
    Callback = function(Value) return; end;
});

CircusEggs:AddButton({
    Text = "Hatch Selected Eggs";
    Func = function()
        for i = 1, EggAmount.Value do
            RemoteEvent:FireServer("HatchEgg", SelectedEgg.Value, 6);
            task.wait(0.5);
        end;
    end;
});

CircusEggs:AddButton({
    Text = "Hatch All Egg Types";
    Func = function()
        for _, eggType in ipairs(EggTypes) do
            for i = 1, EggAmount.Value do
                RemoteEvent:FireServer("HatchEgg", eggType, 6);
                task.wait(0.5);
            end;
        end;
    end;
});

local CircusTeleport = Tabs.Circus:AddRightGroupbox("Circus Teleport");

CircusTeleport:AddButton({
    Text = "Teleport to Circus";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Circus Event.Spawn");
    end;
});

-- ============================================
-- POTIONS TAB
-- ============================================
local PotionsCraft = Tabs.Potions:AddLeftGroupbox("Craft Potions");

PotionsCraft:AddButton({
    Text = "Craft Lucky Potions";
    Func = function()
        for i = 2, 5 do
            RemoteEvent:FireServer("CraftPotion", "Lucky", i, true);
            task.wait(1);
        end;
    end;
});

PotionsCraft:AddButton({
    Text = "Craft Speed Potions";
    Func = function()
        for i = 2, 5 do
            RemoteEvent:FireServer("CraftPotion", "Speed", i, true);
            task.wait(1);
        end;
    end;
});

PotionsCraft:AddButton({
    Text = "Craft Coins Potions";
    Func = function()
        for i = 2, 5 do
            RemoteEvent:FireServer("CraftPotion", "Coins", i, true);
            task.wait(1);
        end;
    end;
});

PotionsCraft:AddButton({
    Text = "Craft Mythic Potions";
    Func = function()
        for i = 2, 5 do
            RemoteEvent:FireServer("CraftPotion", "Mythic", i, true);
            task.wait(1);
        end;
    end;
});

PotionsCraft:AddButton({
    Text = "Craft All Potions";
    Func = function()
        local PotionTypes = {"Lucky", "Speed", "Coins", "Mythic"};
        for _, v in next, PotionTypes do
            for i = 2, 5 do
                RemoteEvent:FireServer("CraftPotion", v, i, true);
                task.wait(1);
            end;
        end;
    end;
});

local PotionsTime = Tabs.Potions:AddLeftGroupbox("Time Left");

local LuckyPotionTime = PotionsTime:AddLabel("Lucky Potion: 00:00:00");
local SpeedPotionTime = PotionsTime:AddLabel("Speed Potion: 00:00:00");
local MythicPotionTime = PotionsTime:AddLabel("Mythic Potion: 00:00:00");
local CoinsPotionTime = PotionsTime:AddLabel("Coins Potion: 00:00:00");
PotionsTime:AddDivider();
PotionsTime:AddLabel("Only displays Rarity V");

task.spawn(function()
    while task.wait() do
        local PotionTypes = {
            Lucky = LuckyPotionTime;
            Speed = SpeedPotionTime;
            Mythic = MythicPotionTime;
            Coins = CoinsPotionTime;
        };
        for i, v in next, PotionTypes do
            local BuffsGUI = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Buffs:FindFirstChild(i)
            if BuffsGUI and BuffsGUI.Button and BuffsGUI.Button.Label and BuffsGUI.Button.Label.Text and BuffsGUI.Button.Icon:FindFirstChild("Potion" .. i .. "5") then
                local TimerText = GetTimerText(BuffsGUI.Button.Label.Text);
                if TimerText then
                    v:SetText(i .. " Potion: " .. TimerText);
                else
                    v:SetText(i .. " Potion: " .. CapitalizeTimeUnit(BuffsGUI.Button.Label.Text) .. "+");
                end;
            else
                v:SetText(i .. " Potion: 00:00:00");
            end;
        end;
    end;
end);

local PotionsUse = Tabs.Potions:AddRightGroupbox("Use Potions");

local SelectPotionType = PotionsUse:AddDropdown("SelectPotionType", {
    Values = {"Lucky", "Speed", "Coins", "Mythic"};
    Default = 1;
    Text = "Select Potion Type";
    Callback = function(Value) return; end;
});

local SelectPotionRarity = PotionsUse:AddDropdown("SelectPotionRarity", {
    Values = {"I", "II", "III", "IV", "V", "VI"};
    Default = 1;
    Text = "Select Potion Rarity";
    Callback = function(Value) return; end;
});

local SelectPotionAmount = PotionsUse:AddSlider("SelectPotionAmount", {
    Text = "Select Potion Amount";
    Default = 1;
    Min = 1;
    Max = 100;
    Rounding = 1;
    Callback = function(Value) return; end;
});

PotionsUse:AddButton({
    Text = "Use Potions";
    Func = function()
        for i = 1, math.floor(SelectPotionAmount.Value + 0.5) do
            task.wait(0.3);
            RemoteEvent:FireServer("UsePotion", SelectPotionType.Value, FancyNumberTranslator(SelectPotionRarity.Value));
        end;
    end;
});

PotionsUse:AddDivider();

PotionsUse:AddButton({
    Text = "Use Hatching Potions";
    Func = function()
        local PotionTypes = {"Lucky", "Speed", "Mythic"};
        for _, v in next, PotionTypes do
            for i = 1, 35 do
                task.wait(0.3);
                RemoteEvent:FireServer("UsePotion", v, 5);
            end;
        end;
    end;
    Tooltip = "Uses 10 hours of Lucky V, Speed V, Mythic V";
    Risky = true;
});

-- ============================================
-- RIFTS TAB
-- ============================================
local RiftsEggs = Tabs.Rifts:AddLeftGroupbox("Rift Eggs");

local RiftEggsDropdown = RiftsEggs:AddDropdown("RiftEggsDropdown", {
    Values = {};
    Default = 1;
    Text = "Rift Eggs";
    Callback = function(Value)
        if Value then
            RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn");
            task.wait(1);
            TweenTo(Value.Display.CFrame, 15);
        end;
    end;
});

local x25EggsDropdown = RiftsEggs:AddDropdown("x25EggsDropdown", {
    Values = {};
    Default = 1;
    Text = "x25 Eggs";
    Callback = function(Value)
        if Value then
            RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn");
            task.wait(1);
            TweenTo(Value.Display.CFrame, 15);
        end;
    end;
});

RiftsEggs:AddDivider();

RiftsEggs:AddButton({
    Text = "Refresh Dropdowns";
    Func = function()
        local Foundx25Eggs, FoundRiftEggs = FetchRiftEggs(true), FetchRiftEggs(false);
        if #Foundx25Eggs > 0 then
            x25EggsDropdown:SetValues(Foundx25Eggs);
        end;
        if #FoundRiftEggs > 0 then
            RiftEggsDropdown:SetValues(FoundRiftEggs);
        end;
    end;
});

local RiftsChests = Tabs.Rifts:AddRightGroupbox("Rift Chests");

RiftsChests:AddToggle("UseGoldenKeys", {
    Text = "Use Golden Keys";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.UseGoldenKeys = Value;
        task.spawn(function()
            while Functions.UseGoldenKeys do
                task.wait();
                RemoteEvent:FireServer("UnlockRiftChest", "golden-chest", false);
            end;
        end);
    end;
});

RiftsChests:AddToggle("UseRoyalKeys", {
    Text = "Use Royal Keys";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.UseRoyalKeys = Value;
        task.spawn(function()
            while Functions.UseRoyalKeys do
                task.wait();
                RemoteEvent:FireServer("UnlockRiftChest", "royal-chest", false);
            end;
        end);
    end;
});

RiftsChests:AddButton({
    Text = "Teleport To Golden Chest";
    Func = function()
        if game:GetService("Workspace").Rendered.Rifts:FindFirstChild("golden-chest") then
            RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn");
            task.wait(1);
            TweenTo(game:GetService("Workspace").Rendered.Rifts["golden-chest"].Chest["golden-chest"].CFrame + Vector3.new(0, 6, 0), 15);
        end;
    end;
});

RiftsChests:AddButton({
    Text = "Teleport To Royal Chest";
    Func = function()
        if game:GetService("Workspace").Rendered.Rifts:FindFirstChild("royal-chest") then
            RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn");
            task.wait(1);
            TweenTo(game:GetService("Workspace").Rendered.Rifts["royal-chest"].Chest["royal-chest"].CFrame + Vector3.new(0, 6, 0), 15);
        end;
    end;
});

-- ============================================
-- TELEPORTS TAB
-- ============================================
local WorldTeleports = Tabs.Teleports:AddLeftGroupbox("Main Worlds");

WorldTeleports:AddButton({
    Text = "The Overworld";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn");
    end;
});

WorldTeleports:AddButton({
    Text = "Minigame Paradise";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.Minigame Paradise.FastTravel.Spawn");
    end;
});

WorldTeleports:AddDivider();

WorldTeleports:AddLabel("Minigame Paradise Islands:");

WorldTeleports:AddButton({
    Text = "Dice Island";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.Minigame Paradise.Islands.Dice Island.Island.Portal.Spawn");
    end;
});

WorldTeleports:AddButton({
    Text = "Minecart Forest";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.Minigame Paradise.Islands.Minecart Forest.Island.Portal.Spawn");
    end;
});

WorldTeleports:AddButton({
    Text = "Robot Factory";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.Minigame Paradise.Islands.Robot Factory.Island.Portal.Spawn");
    end;
});

WorldTeleports:AddButton({
    Text = "Hyperwave Island";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.Minigame Paradise.Islands.Hyperwave Island.Island.Portal.Spawn");
    end;
});

WorldTeleports:AddDivider();

WorldTeleports:AddLabel("Overworld Islands:");

-- CORRECTED based on Remote Spy - uses Islands.[Name].Island.Portal.Spawn
WorldTeleports:AddButton({
    Text = "Floating Island";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands.Floating Island.Island.Portal.Spawn");
    end;
});

WorldTeleports:AddButton({
    Text = "Outer Space";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands.Outer Space.Island.Portal.Spawn");
    end;
});

WorldTeleports:AddButton({
    Text = "Twilight";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands.Twilight.Island.Portal.Spawn");
    end;
});

WorldTeleports:AddButton({
    Text = "The Void";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands.The Void.Island.Portal.Spawn");
    end;
});

WorldTeleports:AddButton({
    Text = "Zen";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn");
    end;
});

local SevenSeasTeleports = Tabs.Teleports:AddRightGroupbox("Seven Seas");

-- CORRECTED based on Remote Spy logs - uses IslandTeleport.Spawn
local SevenSeasAreas = {
    {"Fisher's Island", "Workspace.Worlds.Seven Seas.Areas.Fisher's Island.IslandTeleport.Spawn"};
    {"Blizzard Hills", "Workspace.Worlds.Seven Seas.Areas.Blizzard Hills.IslandTeleport.Spawn"};
    {"Poison Jungle", "Workspace.Worlds.Seven Seas.Areas.Poison Jungle.IslandTeleport.Spawn"};
    {"Infernite Volcano", "Workspace.Worlds.Seven Seas.Areas.Infernite Volcano.IslandTeleport.Spawn"};
    {"Lost Atlantis", "Workspace.Worlds.Seven Seas.Areas.Lost Atlantis.IslandTeleport.Spawn"};
    {"Dream Island", "Workspace.Worlds.Seven Seas.Areas.Dream Island.IslandTeleport.Spawn"};
    {"Classic Island", "Workspace.Worlds.Seven Seas.Areas.Classic Island.IslandTeleport.Spawn"};
};

for _, area in ipairs(SevenSeasAreas) do
    SevenSeasTeleports:AddButton({
        Text = area[1];
        Func = function()
            RemoteEvent:FireServer("Teleport", area[2]);
        end;
    });
end;

local OtherTeleports = Tabs.Teleports:AddLeftGroupbox("Other Locations");

OtherTeleports:AddButton({
    Text = "Circus Event";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Circus Event.Spawn");
    end;
});

OtherTeleports:AddButton({
    Text = "Hatching Zone";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn");
        task.wait(0.3);
        TweenTo(CFrame.new(-57, 9, -27), 1.4);
    end;
});

OtherTeleports:AddButton({
    Text = "Coin Farm Area (Zen)";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn");
        task.wait(0.3);
        TweenTo(CFrame.new(4, 15973, 44), 0.8);
    end;
});

OtherTeleports:AddButton({
    Text = "Best Egg";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn");
        task.wait(0.3);
        TweenTo(CFrame.new(15, 10, -5), 0.5);
    end;
});

OtherTeleports:AddDivider();

OtherTeleports:AddButton({
    Text = "Unlock All Islands";
    Func = function()
        for i, v in next, game:GetService("Workspace").Worlds["The Overworld"].Islands:GetChildren() do
            firetouchinterest(v.Island.UnlockHitbox, game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, 0);
            task.wait();
            firetouchinterest(v.Island.UnlockHitbox, game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, 1);
            task.wait(0.3);
        end;
    end;
});

local ObbyTeleports = Tabs.Teleports:AddRightGroupbox("Obbys");

ObbyTeleports:AddButton({
    Text = "Easy Obby";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Obbys.Easy.Spawn");
    end;
});

ObbyTeleports:AddButton({
    Text = "Medium Obby";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Obbys.Medium.Spawn");
    end;
});

ObbyTeleports:AddButton({
    Text = "Hard Obby";
    Func = function()
        RemoteEvent:FireServer("Teleport", "Workspace.Obbys.Hard.Spawn");
    end;
});

-- ============================================
-- CPU TAB
-- ============================================
local CPUSaving = Tabs.CPU:AddLeftGroupbox("CPU Saving");

CPUSaving:AddToggle("Disable3DRendering", {
    Text = "Disable 3D Rendering";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.Disable3DRendering = Value;
        game:GetService("RunService"):Set3dRenderingEnabled(not Value);
    end;
});

CPUSaving:AddToggle("BlackOutScreen", {
    Text = "Black Out Screen";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.BlackOutScreen = Value;
        if Value then
            local ScreenGui = Instance.new("ScreenGui");
            ScreenGui.Name = "BlackoutGui";
            ScreenGui.ResetOnSpawn = false;
            ScreenGui.IgnoreGuiInset = true;
            ScreenGui.Parent = game:GetService("CoreGui");
            local BlackFrame = Instance.new("Frame");
            BlackFrame.Size = UDim2.new(1, 0, 1, 0);
            BlackFrame.Position = UDim2.new(0, 0, 0, 0);
            BlackFrame.BackgroundColor3 = Color3.new(0, 0, 0);
            BlackFrame.BorderSizePixel = 0;
            BlackFrame.Parent = ScreenGui;
        else
            pcall(function()
                game:GetService("CoreGui").BlackoutGui:Destroy();
            end);
        end;
    end;
});

CPUSaving:AddButton({
    Text = "Toggle CPU Saver";
    Func = function()
        Toggles.Disable3DRendering:SetValue(true);
        Toggles.BlackOutScreen:SetValue(true);
        CustomFPSCap:SetValue(10);
        Toggles.FixFPSCap:SetValue(true);
    end;
    Tooltip = "Enables all CPU saving features";
    Risky = true;
});

local FPSSettings = Tabs.CPU:AddRightGroupbox("FPS Cap");

FPSSettings:AddButton({Text = "FPS: 3", Func = function() setfpscap(3); end;});
FPSSettings:AddButton({Text = "FPS: 10", Func = function() setfpscap(10); end;});
FPSSettings:AddButton({Text = "FPS: 30", Func = function() setfpscap(30); end;});
FPSSettings:AddButton({Text = "FPS: 60", Func = function() setfpscap(60); end;});

local CustomFPSCap = FPSSettings:AddSlider("CustomFPSCap", {
    Text = "Custom FPS Cap";
    Default = 60;
    Min = 3;
    Max = 60;
    Rounding = 1;
    Callback = function(Value)
        setfpscap(Value);
    end;
});

FPSSettings:AddToggle("FixFPSCap", {
    Text = "Fix FPS Cap";
    Default = false;
    Callback = function(Value)
        getgenv().Functions.FixFPSCap = Value;
        task.spawn(function()
            while Functions.FixFPSCap do
                setfpscap(CustomFPSCap.Value);
                task.wait(60);
            end;
        end);
    end;
    Tooltip = "Loops FPS cap every minute";
    Risky = true;
});

local CurrentFPS = FPSSettings:AddLabel("Current FPS: ???");

task.spawn(function()
    local Frames, Last = 0, tick();
    game:GetService("RunService").RenderStepped:Connect(function()
        Frames += 1;
        if tick() - Last >= 1 then
            CurrentFPS:SetText("Current FPS: " .. Frames);
            Frames = 0;
            Last = tick();
        end;
    end);
end);

-- ============================================
-- SETTINGS TAB
-- ============================================
local UISettings = Tabs.Settings:AddLeftGroupbox("UI Settings");

UISettings:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible;
    Text = "Open Keybind Menu";
    Callback = function(value)
        Library.KeybindFrame.Visible = value;
    end;
});

UISettings:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor";
    Default = true;
    Callback = function(Value)
        Library.ShowCustomCursor = Value;
    end;
});

UISettings:AddDropdown("NotificationSide", {
    Values = {"Left", "Right"};
    Default = "Right";
    Text = "Notification Side";
    Callback = function(Value)
        Library:SetNotifySide(Value);
    end;
});

UISettings:AddDropdown("DPIDropdown", {
    Values = {"50%", "75%", "100%", "125%", "150%", "175%", "200%"};
    Default = "100%";
    Text = "DPI Scale";
    Callback = function(Value)
        Value = Value:gsub("%%", "");
        local DPI = tonumber(Value);
        Library:SetDPIScale(DPI);
    end;
});

UISettings:AddDivider();
UISettings:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "LeftControl", NoUI = true, Text = "Menu keybind"});

-- Custom Lightning Cursor
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");

local LightningCursor = {
    Enabled = true;
    Particles = {};
};

-- Create lightning cursor GUI
local function CreateLightningCursor()
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "LightningCursor";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 999999;
    ScreenGui.Parent = game:GetService("CoreGui");
    
    -- Create lightning particles around cursor
    for i = 1, 8 do
        local Particle = Instance.new("ImageLabel");
        Particle.Name = "Lightning" .. i;
        Particle.Size = UDim2.new(0, 20, 0, 20);
        Particle.BackgroundTransparency = 1;
        Particle.Image = "rbxassetid://4965945816"; -- Lightning bolt
        Particle.ImageColor3 = Color3.fromRGB(100, 200, 255);
        Particle.ImageTransparency = 0.3;
        Particle.Parent = ScreenGui;
        
        table.insert(LightningCursor.Particles, Particle);
    end;
    
    return ScreenGui;
end;

local LightningGui = CreateLightningCursor();

-- Animate lightning around cursor
RunService.RenderStepped:Connect(function()
    if not LightningCursor.Enabled then return; end;
    
    local mousePos = UserInputService:GetMouseLocation();
    local time = tick() * 3;
    
    for i, particle in ipairs(LightningCursor.Particles) do
        local angle = (i / #LightningCursor.Particles) * math.pi * 2 + time;
        local radius = 30 + math.sin(time * 2 + i) * 10;
        
        local x = mousePos.X + math.cos(angle) * radius;
        local y = mousePos.Y + math.sin(angle) * radius;
        
        particle.Position = UDim2.new(0, x - 10, 0, y - 10);
        particle.Rotation = math.deg(angle) + 90;
        
        -- Pulsing effect
        local alpha = 0.3 + math.sin(time * 4 + i * 0.5) * 0.2;
        particle.ImageTransparency = alpha;
    end;
end);

-- Toggle lightning cursor
UISettings:AddToggle("LightningCursor", {
    Text = "⚡ Lightning Cursor";
    Default = true;
    Callback = function(Value)
        LightningCursor.Enabled = Value;
        if LightningGui then
            LightningGui.Enabled = Value;
        end;
    end;
    Tooltip = "Cool lightning effect around cursor";
});

UISettings:AddButton({
    Text = "🗑️ Unload Script";
    Func = function()
        -- Stop all automation
        if getgenv().Functions then
            for key, value in pairs(getgenv().Functions) do
                getgenv().Functions[key] = false;
            end;
        end;
        
        -- Stop pickup collector
        if getgenv().PickupCollector then
            getgenv().PickupCollector.AutoCollect = false;
        end;
        
        -- Stop all egg hatching
        if AutoHatchingEggs then
            for eggName, _ in pairs(AutoHatchingEggs) do
                AutoHatchingEggs[eggName] = false;
            end;
        end;
        
        -- Remove lightning cursor
        pcall(function()
            if LightningGui then
                LightningGui:Destroy();
            end;
        end);
        
        -- Unload library
        Library:Unload();
    end;
});

ThemeManager:SetLibrary(Library);
SaveManager:SetLibrary(Library);
SaveManager:IgnoreThemeSettings();
SaveManager:SetIgnoreIndexes({"MenuKeybind"});
ThemeManager:SetFolder("Bubble Gum Complete");
SaveManager:BuildConfigSection(Tabs.Settings);
ThemeManager:ApplyToTab(Tabs.Settings);
SaveManager:LoadAutoloadConfig();

-- Set the library's toggle keybind to LeftControl (after library is fully set up)
Library.ToggleKeybind = Options.MenuKeybind;

-- Keep cursor always visible
task.spawn(function()
    while task.wait(0.1) do
        if not Library.Unloaded then
            UserInputService.MouseIconEnabled = true;
        end;
    end;
end);

Library:Notify({
    Title = "Script Loaded!";
    Description = "All-in-One Complete Edition";
    Time = 4;
});

print("=== BUBBLE GUM SIMULATOR INFINITY ===");
print("All-in-One Script v2.0 Loaded!");
print("Features: Main Farming, Circus, Potions, Rifts, All Teleports");
print("=====================================");
