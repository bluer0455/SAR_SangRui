---SAR SUTURE SCRIPT😍
---THIS IS THE SOURCE CODE😍
---BRO ENJOY TO ONE'S HEAR'S CONTENT😍
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bluer0455/SAR_SangRui/refs/heads/main/SATRHNNNNNNNNNN"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local originalBrightness = game.Lighting.Brightness
local currentWalkSpeed = humanoid.WalkSpeed
local currentJumpPower = humanoid.JumpPower
local currentGravity = game.Workspace.Gravity

local Window = OrionLib:MakeWindow({
    Name = "私人SAR中心",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "SAR",
    ConfigFolder = "SAR"
})

-- 获取 SoundService 服务
local SoundService = game:GetService("SoundService")
-- 创建一个 Sound 实例
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://12221967"
sound.Parent = SoundService
-- 立即播放音乐
sound:Play()

local noticeTab = Window:MakeTab({
    Name = "公告",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

noticeTab:AddParagraph("脚本是缝合 完全私人")
noticeTab:AddParagraph("如果你没有经过作者同意就使用并且外传就死全家")
noticeTab:AddParagraph("如果账号或者服务器封禁,请不要找作者")
noticeTab:AddParagraph("记住 不要外传")
noticeTab:AddParagraph("作者会不定时更新脚本")
noticeTab:AddParagraph("如果脚本有问题可以跟我讲")

local authorInfoTab = Window:MakeTab({
    Name = "作者信息",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
authorInfoTab:AddParagraph("作者: sangrui")
authorInfoTab:AddParagraph("作者qq: 2741747218")
authorInfoTab:AddParagraph("作者抖音：100588ZT")

local copyAuthorInfoTab = Window:MakeTab({
    Name = "复制作者信息",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
copyAuthorInfoTab:AddButton({
    Name = "复制作者QQ",
    Callback = function()
        setclipboard("2741747218")
    end
})
copyAuthorInfoTab:AddButton({
    Name = "复制抖音",
    Callback = function()
        setclipboard("100588ZT")
    end
})

local generalTab = Window:MakeTab({
    Name = "通用",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 先添加文本输入框（保持在最上方）
generalTab:AddTextbox({
    Name = "设置移动速度 (当前: "..currentWalkSpeed..")",
    Default = tostring(currentWalkSpeed),
    TextDisappear = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            humanoid.WalkSpeed = num
            if not lockWalkSpeed then  -- 未锁定时更新锁定值（避免锁定后使用旧值）
                lockedWalkSpeed = num
            end
        end
    end
})

generalTab:AddTextbox({
    Name = "设置跳跃高度 (当前: "..currentJumpPower..")",
    Default = tostring(currentJumpPower),
    TextDisappear = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            humanoid.JumpPower = num
            if not lockJumpPower then  -- 未锁定时更新锁定值（避免锁定后使用旧值）
                lockedJumpPower = num
            end
        end
    end
})

generalTab:AddTextbox({
    Name = "重力设置 (当前: "..currentGravity..")",
    Default = tostring(currentGravity),
    TextDisappear = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            game.Workspace.Gravity = num
        end
    end
})

-- 再添加锁定功能的Toggle（显示在文本框下方）
local lockWalkSpeed = false
local lockedWalkSpeed = nil
local walkSpeedLoop = nil
generalTab:AddToggle({
    Name = "锁定移动速度",
    Default = false,
    Callback = function(Value)
        lockWalkSpeed = Value
        if Value then
            lockedWalkSpeed = humanoid.WalkSpeed
            if not walkSpeedLoop then
                walkSpeedLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if humanoid and lockWalkSpeed then
                        humanoid.WalkSpeed = lockedWalkSpeed
                    end
                end)
            end
        else
            if walkSpeedLoop then
                walkSpeedLoop:Disconnect()
                walkSpeedLoop = nil
            end
            lockedWalkSpeed = nil
        end
    end
})

local lockJumpPower = false
local lockedJumpPower = nil
local jumpPowerLoop = nil
generalTab:AddToggle({
    Name = "锁定跳跃高度",
    Default = false,
    Callback = function(Value)
        lockJumpPower = Value
        if Value then
            lockedJumpPower = humanoid.JumpPower
            if not jumpPowerLoop then
                jumpPowerLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if humanoid and lockJumpPower then
                        humanoid.JumpPower = lockedJumpPower
                    end
                end)
            end
        else
            if jumpPowerLoop then
                jumpPowerLoop:Disconnect()
                jumpPowerLoop = nil
            end
            lockedJumpPower = nil
        end
    end
})

generalTab:AddToggle({
    Name = "无限跳跃",
    Default = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
        local Players = game:GetService("Players")
        local userInputService = game:GetService("UserInputService")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if Value then
            jumpConnection = userInputService.JumpRequest:Connect(function()
                if InfiniteJumpEnabled then
                    humanoid:ChangeState("Jumping")
                end
            end)
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end
})

local isWallhackEnabled = false
local originalCanCollide = {}  -- 存储原始碰撞状态
local wallhackConnection  -- 心跳事件连接

-- 添加穿墙开关
generalTab:AddToggle({
    Name = "穿墙",
    Default = false,
    Callback = function(Value)
        isWallhackEnabled = Value
        
        if Value then
            -- 初始化时获取角色部件并记录原始状态
            local character = player.Character
            if not character then return end  -- 确保角色已加载
            
            originalCanCollide = {}
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalCanCollide[part] = part.CanCollide  -- 记录原始状态
                    part.CanCollide = false  -- 关闭碰撞
                end
            end
            
            -- 心跳事件持续维持碰撞状态（防止外部修改）
            wallhackConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = player.Character
                if not character or not isWallhackEnabled then return end
                
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false  -- 强制维持无碰撞状态
                    end
                end
            end)
            
        else
            -- 关闭时恢复原始状态并清理资源
            if wallhackConnection then
                wallhackConnection:Disconnect()
                wallhackConnection = nil
            end
            
            local character = player.Character
            if not character then return end
            
            for part, originalValue in pairs(originalCanCollide) do
                if part:IsValid() then  -- 检查部件是否仍然存在
                    part.CanCollide = originalValue
                end
            end
            originalCanCollide = {}  -- 清空存储表
        end
    end
})


local antiFlingConnection = nil
local currentThreshold = nil
generalTab:AddDropdown({
    Name = "防甩飞阈值调节(阈值越低效果越好)",
    Default = "关闭",
    Options = {"关闭", "350阈值", "500阈值", "1000阈值"},
    Callback = function(Value)
        if antiFlingConnection then
            antiFlingConnection:Disconnect()
            antiFlingConnection = nil
        end
        if Value == "关闭" then
            currentThreshold = nil
        else
            currentThreshold = tonumber(Value:match("%d+"))
            antiFlingConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = character.HumanoidRootPart
                local linearSpeed = hrp.AssemblyLinearVelocity.Magnitude
                local angularSpeed = hrp.AssemblyAngularVelocity.Magnitude
                if linearSpeed > currentThreshold or angularSpeed > currentThreshold then
                    hrp.AssemblyLinearVelocity = Vector3.new()
                    hrp.AssemblyAngularVelocity = Vector3.new()
                end
            end)
        end
    end
})

generalTab:AddDropdown({
    Name = "夜视强度调节",
    Default = "恢复默认",
    Options = {"低亮度", "中亮度", "高亮度", "恢复默认"},
    Callback = function(Value)
        local lighting = game:GetService("Lighting")
        local lights = workspace:GetDescendants()
        for _, lightObj in ipairs(lights) do
            if lightObj:IsA("PointLight") or lightObj:IsA("SpotLight") or lightObj:IsA("SurfaceLight") then
                if Value == "低亮度" then
                    lightObj.Brightness = 5.0
                elseif Value == "中亮度" then
                    lightObj.Brightness = 15.0
                elseif Value == "高亮度" then
                    lightObj.Brightness = 25.0
                elseif Value == "恢复默认" then
                    lightObj.Brightness = originalBrightness
                end
            end
        end
        if Value == "低亮度" then
            lighting.Brightness = 5.0
        elseif Value == "中亮度" then
            lighting.Brightness = 15.0
        elseif Value == "高亮度" then
            lighting.Brightness = 25.0
        elseif Value == "恢复默认" then
            lighting.Brightness = originalBrightness
        end
    end
})

generalTab:AddButton({
    Name = "飞行v3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})

generalTab:AddButton({
    Name = "飞车(汉化)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bluer0455/SAR_SangRui/refs/heads/main/bHSJjsjdSjjsJsjdJSJS"))()
    end
})

generalTab:AddButton({
    Name = "玩家进入提示",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
    end
})

generalTab:AddButton({
    Name = "甩飞",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Touch-fling-script-22447"))()
    end
})

generalTab:AddButton({
    Name = "隔墙跳(可以装跑酷大神)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bluer0455/SAR_SangRui/refs/heads/main/WallHop-V4-SARHANGHUA"))()
    end
})

local generalTab = Window:MakeTab({
    Name = "黑洞脚本",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

generalTab:AddButton({
    Name = "环绕黑洞v3",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Projeto-LKB-I-Super-Ring-V3-I-Cracked-23346"))()
    end
})

generalTab:AddButton({
    Name = "环绕黑洞v4",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Natural-Disaster-Survival-Super-ring-V4-24296"))()
    end
})

generalTab:AddButton({
    Name = "(汉化)环绕黑洞v6",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bluer0455/SAR_SangRui/refs/heads/main/SARBCDEFGMIAOMiAO"))()
    end
})

generalTab:AddButton({
    Name = "贴身黑洞",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-blackhole-re-upload-18510"))()
    end
})

local generalTab = Window:MakeTab({
    Name = "动画(r6/r15都有)",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 用于存储r6拥抱动画1的轨道
local r6HugAnimTrack1
-- 用于存储r6拥抱动画2的轨道
local r6HugAnimTrack2

generalTab:AddToggle({
    Name = "r6拥抱",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if Value then
            -- 处理动画1
            if not r6HugAnimTrack1 then
                local anim1 = Instance.new("Animation")
                anim1.AnimationId = "rbxassetid://283545583"
                r6HugAnimTrack1 = humanoid:LoadAnimation(anim1)
                r6HugAnimTrack1:Play()
            elseif not r6HugAnimTrack1.IsPlaying then
                r6HugAnimTrack1:Play()
            end

            -- 处理动画2
            if not r6HugAnimTrack2 then
                local anim2 = Instance.new("Animation")
                anim2.AnimationId = "rbxassetid://225975820"
                r6HugAnimTrack2 = humanoid:LoadAnimation(anim2)
                r6HugAnimTrack2:Play()
            elseif not r6HugAnimTrack2.IsPlaying then
                r6HugAnimTrack2:Play()
            end
        else
            -- 停止动画1
            if r6HugAnimTrack1 and r6HugAnimTrack1.IsPlaying then
                r6HugAnimTrack1:Stop()
                r6HugAnimTrack1.Animation:Destroy()
                r6HugAnimTrack1 = nil
            end
            -- 停止动画2
            if r6HugAnimTrack2 and r6HugAnimTrack2.IsPlaying then
                r6HugAnimTrack2:Stop()
                r6HugAnimTrack2.Animation:Destroy()
                r6HugAnimTrack2 = nil
            end
        end
    end
})

generalTab:AddButton({
    Name = "r15免费所有动画(r6不加载)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BeemTZy/Motiona/refs/heads/main/source.lua"))()
    end
})

generalTab:AddButton({
    Name = "伪vr(要r6体型)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/Wow%202"))()
    end
})

generalTab:AddButton({
    Name = "r6撸管",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
    end
})

generalTab:AddButton({
    Name = "r15撸管",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
})

generalTab:AddButton({
    Name = "r6/r15动画",
    Callback = function()
       loadstring(game:HttpGet(('https://raw.githubusercontent.com/bluer0455/SAR_SangRui/refs/heads/main/r6r15dancescript'),true))() 
    end
})

OrionLib:Init()
