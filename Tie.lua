print("[D] init")

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
if not LP then
    repeat task.wait() until Players.LocalPlayer
    LP = Players.LocalPlayer
end

local ENV = _G
if type(getgenv) == "function" then
    local okE, g = pcall(getgenv)
    if okE and type(g) == "table" then ENV = g end
end

local container
do
    local okH, hui = pcall(function()
        if type(gethui) == "function" then return gethui() end
    end)
    if okH and hui then container = hui end
    if not container then
        local okC, cg = pcall(function() return game:GetService("CoreGui") end)
        if okC then container = cg end
    end
    if not container then container = LP:WaitForChild("PlayerGui", 10) end
end
if not container then warn("[D] no container"); return end
print("[D] container OK")

-- очистка
pcall(function()
    for _, n in ipairs({"DanyageyMainGui","DanyageyWatermark","DanyageyNotify","DanyageyKeyGui","DanyageyESP"}) do
        local g = container:FindFirstChild(n)
        if g then g:Destroy() end
    end
    local wp = workspace:FindFirstChild("Danyagey3DParticles")
    if wp then wp:Destroy() end
    if Lighting:FindFirstChild("DanyageyCC") then Lighting.DanyageyCC:Destroy() end
    if Lighting:FindFirstChild("DanyageyBloom") then Lighting.DanyageyBloom:Destroy() end
end)
for _, k in ipairs({"AeroColorLoop","AeroSnowLoop","AeroWorldParticlesLoop","AeroFogLoop"}) do
    if ENV[k] then pcall(function() ENV[k]:Disconnect() end) end
end
print("[D] cleanup OK")

-- ============ HELPERS ============
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
    return c
end
local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Thickness = th or 1
    s.Parent = p
    return s
end
local function vlist(p, gap)
    local x = Instance.new("UIListLayout")
    x.Padding = UDim.new(0, gap or 0)
    x.FillDirection = Enum.FillDirection.Vertical
    x.HorizontalAlignment = Enum.HorizontalAlignment.Center
    x.SortOrder = Enum.SortOrder.LayoutOrder
    x.Parent = p
    return x
end
local function hlist(p, gap)
    local x = Instance.new("UIListLayout")
    x.Padding = UDim.new(0, gap or 0)
    x.FillDirection = Enum.FillDirection.Horizontal
    x.HorizontalAlignment = Enum.HorizontalAlignment.Center
    x.VerticalAlignment = Enum.VerticalAlignment.Center
    x.SortOrder = Enum.SortOrder.LayoutOrder
    x.Parent = p
    return x
end

-- ============ NOTIFICATIONS ============
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "DanyageyNotify"
NotifyGui.ResetOnSpawn = false
NotifyGui.Parent = container

local NotifyStack = Instance.new("Frame")
NotifyStack.AnchorPoint = Vector2.new(1, 1)
NotifyStack.Position = UDim2.new(1, -16, 1, -16)
NotifyStack.Size = UDim2.new(0, 260, 0, 400)
NotifyStack.BackgroundTransparency = 1
NotifyStack.Parent = NotifyGui

vlist(NotifyStack, 8)

local function notify(text, kind)
    kind = kind or "info"
    local bg, accent
    if kind == "success" then bg = Color3.fromRGB(28, 45, 32); accent = Color3.fromRGB(80, 220, 110)
    elseif kind == "error" then bg = Color3.fromRGB(50, 25, 25); accent = Color3.fromRGB(255, 80, 80)
    elseif kind == "warn" then bg = Color3.fromRGB(50, 45, 22); accent = Color3.fromRGB(255, 200, 60)
    else bg = Color3.fromRGB(25, 30, 45); accent = Color3.fromRGB(90, 150, 255) end

    local n = Instance.new("Frame")
    n.Size = UDim2.fromOffset(240, 44)
    n.BackgroundColor3 = bg
    n.BackgroundTransparency = 0.15
    n.BorderSizePixel = 0
    n.Parent = NotifyStack
    corner(n, 8)
    stroke(n, accent, 1.4)

    local bar = Instance.new("Frame", n)
    bar.Size = UDim2.new(0, 3, 1, -8)
    bar.Position = UDim2.new(0, 4, 0, 4)
    bar.BackgroundColor3 = accent
    bar.BorderSizePixel = 0
    corner(bar, 2)

    local lbl = Instance.new("TextLabel", n)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(235, 240, 250)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true

    task.delay(3.2, function()
        if n and n.Parent then n:Destroy() end
    end)
end

-- ============ KEY GUI ============
local VALID_KEYS = {"potassium", "DANYAGEY-VIP-KEY"}
local keyPassed = false

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "DanyageyKeyGui"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = container

local KShadow = Instance.new("Frame", KeyGui)
KShadow.Size = UDim2.new(1, 0, 1, 0)
KShadow.BackgroundColor3 = Color3.new(0,0,0)
KShadow.BackgroundTransparency = 0.5
KShadow.BorderSizePixel = 0

local KFrame = Instance.new("Frame", KeyGui)
KFrame.Size = UDim2.fromOffset(360, 250)
KFrame.Position = UDim2.new(0.5, -180, 0.5, -125)
KFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
KFrame.BorderSizePixel = 0
corner(KFrame, 12)
stroke(KFrame, Color3.fromRGB(80, 130, 220), 1.5)

local KTitle = Instance.new("TextLabel", KFrame)
KTitle.Size = UDim2.new(1, 0, 0, 40)
KTitle.Position = UDim2.new(0, 0, 0, 15)
KTitle.BackgroundTransparency = 1
KTitle.Text = "KEY REQUIRED"
KTitle.Font = Enum.Font.Code
KTitle.TextSize = 20
KTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local KSub = Instance.new("TextLabel", KFrame)
KSub.Size = UDim2.new(1, -40, 0, 20)
KSub.Position = UDim2.new(0, 20, 0, 58)
KSub.BackgroundTransparency = 1
KSub.Text = "Get key in Telegram: @boldbild"
KSub.Font = Enum.Font.Code
KSub.TextSize = 12
KSub.TextColor3 = Color3.fromRGB(160, 190, 235)

local KInput = Instance.new("TextBox", KFrame)
KInput.Size = UDim2.new(1, -40, 0, 40)
KInput.Position = UDim2.new(0, 20, 0, 92)
KInput.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
KInput.Text = ""
KInput.PlaceholderText = "Enter key here..."
KInput.Font = Enum.Font.Code
KInput.TextSize = 14
KInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KInput.BorderSizePixel = 0
corner(KInput, 8)
stroke(KInput, Color3.fromRGB(60, 70, 95), 1.2)

local KError = Instance.new("TextLabel", KFrame)
KError.Size = UDim2.new(1, -40, 0, 18)
KError.Position = UDim2.new(0, 20, 0, 138)
KError.BackgroundTransparency = 1
KError.Text = ""
KError.Font = Enum.Font.Code
KError.TextSize = 11
KError.TextColor3 = Color3.fromRGB(255, 90, 90)

local KSubmit = Instance.new("TextButton", KFrame)
KSubmit.Size = UDim2.new(1, -40, 0, 42)
KSubmit.Position = UDim2.new(0, 20, 0, 165)
KSubmit.BackgroundColor3 = Color3.fromRGB(50, 110, 210)
KSubmit.Text = "SUBMIT"
KSubmit.Font = Enum.Font.Code
KSubmit.TextSize = 15
KSubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
KSubmit.AutoButtonColor = false
KSubmit.BorderSizePixel = 0
corner(KSubmit, 8)

local KClose = Instance.new("TextButton", KFrame)
KClose.Size = UDim2.new(0, 26, 0, 26)
KClose.Position = UDim2.new(1, -34, 0, 8)
KClose.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
KClose.Text = "X"
KClose.Font = Enum.Font.Code
KClose.TextSize = 13
KClose.TextColor3 = Color3.fromRGB(255, 255, 255)
KClose.AutoButtonColor = false
KClose.BorderSizePixel = 0
corner(KClose, 6)

local KFooter = Instance.new("TextLabel", KFrame)
KFooter.Size = UDim2.new(1, -40, 0, 16)
KFooter.Position = UDim2.new(0, 20, 1, -28)
KFooter.BackgroundTransparency = 1
KFooter.Text = "t.me/boldbild"
KFooter.Font = Enum.Font.Code
KFooter.TextSize = 10
KFooter.TextColor3 = Color3.fromRGB(120, 130, 150)

local function trySubmitKey()
    local entered = KInput.Text
    if entered == "" then
        KError.Text = "Enter a key"
        return
    end
    for _, k in ipairs(VALID_KEYS) do
        if entered == k then
            keyPassed = true
            KFrame.Visible = false
            KShadow.Visible = false
            task.wait(0.05)
            KeyGui:Destroy()
            notify("Key accepted!", "success")
            return
        end
    end
    KError.Text = "Invalid key. Get new in @boldbild"
    KInput.Text = ""
end

KSubmit.MouseButton1Click:Connect(trySubmitKey)
KInput.FocusLost:Connect(function(enter) if enter then trySubmitKey() end end)

KClose.MouseButton1Click:Connect(function()
    if not keyPassed then
        notify("Key not entered. Kicked.", "error")
        task.wait(0.3)
        pcall(function() LP:Kick("Key required: t.me/boldbild") end)
    end
    KeyGui:Destroy()
end)

pcall(function() KInput:CaptureFocus() end)
print("[D] key gui ready")

-- ============ MAIN ============
local function init()
    print("[D] init main")

    local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)

    local DEFAULT_W = isMobile and 380 or 560
    local DEFAULT_H = isMobile and 380 or 440
    if isMobile then
        DEFAULT_W = math.clamp(math.floor(viewport.X * 0.85), 300, 420)
        DEFAULT_H = math.clamp(math.floor(viewport.Y * 0.55), 280, 380)
    end

    local cfgSize = Vector2.new(DEFAULT_W, DEFAULT_H)
    local BASE_RATIO = DEFAULT_H / DEFAULT_W

    local state = {
        themeTarget = "both",
        colorName = "Standard",
        ptType = "Off",
        fogName = "Off",
    }

    local ORIG = {
        base = Color3.fromRGB(18, 19, 23),
        stroke = Color3.fromRGB(50, 52, 63),
        header = Color3.fromRGB(13, 14, 18),
        sidebar = Color3.fromRGB(15, 16, 20),
        modal = Color3.fromRGB(38, 42, 55),
        wm = Color3.fromRGB(22, 23, 30),
        wmS = Color3.fromRGB(80, 85, 105),
    }

    -- сохранение оригинального света
    ENV.DanyageyOrigLighting = {
        FogColor = Lighting.FogColor,
        FogEnd = Lighting.FogEnd,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ClockTime = Lighting.ClockTime,
    }
    local CC = Instance.new("ColorCorrectionEffect")
    CC.Name = "DanyageyCC"
    CC.Enabled = false
    CC.Parent = Lighting
    local Bloom = Instance.new("BloomEffect")
    Bloom.Name = "DanyageyBloom"
    Bloom.Enabled = false
    Bloom.Parent = Lighting

    -- MAIN GUI
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "DanyageyMainGui"
    MainGui.ResetOnSpawn = false
    MainGui.Parent = container

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(cfgSize.X, cfgSize.Y)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = ORIG.base
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainGui
    corner(MainFrame, 12)
    local MainStroke = stroke(MainFrame, ORIG.stroke, 1.5)

    -- snowflakes
    local flakes = {}
    for i = 1, (isMobile and 20 or 35) do
        local f = Instance.new("Frame", MainFrame)
        f.Name = "Snowflake"
        f.BackgroundColor3 = Color3.fromRGB(255,255,255)
        f.BackgroundTransparency = math.random(30, 60) / 100
        local sz = math.random(4, 8)
        f.Size = UDim2.fromOffset(sz, sz)
        f.BorderSizePixel = 0
        f.ZIndex = 50
        corner(f, sz/2)
        table.insert(flakes, {o = f, x = math.random(), y = math.random(), sp = math.random(4,9)/1000, dr = math.random(-5,5)/1000})
    end
    ENV.AeroSnowLoop = RunService.RenderStepped:Connect(function(dt)
        for _, f in ipairs(flakes) do
            if MainFrame.Visible then
                f.y = f.y + f.sp * dt * 60
                f.x = f.x + f.dr * dt * 60
                if f.y > 1 then f.y = -0.05; f.x = math.random() end
                if f.x < -0.05 then f.x = 1.05 elseif f.x > 1.05 then f.x = -0.05 end
                f.o.Position = UDim2.new(f.x, 0, f.y, 0)
                f.o.Visible = true
            else
                f.o.Visible = false
            end
        end
    end)

    -- header
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = ORIG.header
    Header.BorderSizePixel = 0
    Header.ZIndex = 10
    corner(Header, 12)

    local HeaderCover = Instance.new("Frame", Header)
    HeaderCover.Position = UDim2.new(0, 0, 1, -10)
    HeaderCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderCover.BackgroundColor3 = ORIG.header
    HeaderCover.BorderSizePixel = 0
    HeaderCover.ZIndex = 10

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.Position = UDim2.new(0, 15, 0.5, 0)
    TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
    TitleLabel.Size = UDim2.new(0, 250, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Danyagey1488.win"
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 15

    local CtrlBox = Instance.new("Frame", Header)
    CtrlBox.AnchorPoint = Vector2.new(1, 0.5)
    CtrlBox.Position = UDim2.new(1, -8, 0.5, 0)
    CtrlBox.Size = UDim2.new(0, 110, 0, 30)
    CtrlBox.BackgroundTransparency = 1
    CtrlBox.ZIndex = 15
    hlist(CtrlBox, 5)

    local function headBtn(txt, cb)
        local b = Instance.new("TextButton", CtrlBox)
        b.Size = UDim2.new(0, 32, 0, 32)
        b.BackgroundColor3 = Color3.fromRGB(24, 25, 31)
        b.Text = txt
        b.Font = Enum.Font.Code
        b.TextSize = 14
        b.TextColor3 = Color3.fromRGB(220, 225, 235)
        b.AutoButtonColor = false
        b.BorderSizePixel = 0
        b.ZIndex = 20
        corner(b, 6)
        stroke(b, Color3.fromRGB(50, 52, 63), 1)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    -- sidebar
    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.Size = UDim2.new(0, 160, 1, -45)
    Sidebar.BackgroundColor3 = ORIG.sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.ScrollBarThickness = 2
    Sidebar.ZIndex = 10
    vlist(Sidebar, 6)
    local sbPad = Instance.new("UIPadding", Sidebar)
    sbPad.PaddingTop = UDim.new(0, 10)

    local Content = Instance.new("Frame", MainFrame)
    Content.Position = UDim2.new(0, 165, 0, 45)
    Content.Size = UDim2.new(1, -165, 1, -45)
    Content.BackgroundTransparency = 1
    Content.ZIndex = 10

    local Tabs = {}
    local function createTab(name)
        local page = Instance.new("ScrollingFrame", Content)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollBarThickness = 4
        page.ZIndex = 10
        vlist(page, 6)
        local p = Instance.new("UIPadding", page)
        p.PaddingTop = UDim.new(0, 8); p.PaddingBottom = UDim.new(0, 8)

        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(0.9, 0, 0, 34)
        btn.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
        btn.Text = "  " .. name
        btn.Font = Enum.Font.Code
        btn.TextSize = 13
        btn.TextColor3 = Color3.fromRGB(190, 195, 210)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.ZIndex = 15
        corner(btn, 8)

        btn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
                t.Btn.TextColor3 = Color3.fromRGB(190, 195, 210)
            end
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        Tabs[name] = {Page = page, Btn = btn}
        return page, btn
    end

    local MainTab, MainBtn = createTab("Main")
    local FeaturesTab = createTab("Features")
    local SettingsTab = createTab("Settings")
    MainTab.Visible = true
    MainBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- MODAL helper
    local function createModal(title, w, h)
        local M = Instance.new("Frame", MainGui)
        M.Size = UDim2.fromOffset(w, h)
        M.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
        M.BackgroundColor3 = ORIG.modal
        M.BorderSizePixel = 0
        M.Visible = false
        M.ZIndex = 200
        M.Active = true
        corner(M, 10)
        stroke(M, Color3.fromRGB(110, 130, 180), 1.5)

        local H = Instance.new("TextButton", M)
        H.Size = UDim2.new(1, 0, 0, 30)
        H.BackgroundColor3 = Color3.fromRGB(52, 58, 76)
        H.Text = "  " .. title
        H.Font = Enum.Font.Code
        H.TextSize = 12
        H.TextColor3 = Color3.fromRGB(255, 255, 255)
        H.TextXAlignment = Enum.TextXAlignment.Left
        H.AutoButtonColor = false
        H.ZIndex = 201
        corner(H, 10)

        local HC = Instance.new("Frame", H)
        HC.Position = UDim2.new(0, 0, 1, -8)
        HC.Size = UDim2.new(1, 0, 0, 8)
        HC.BackgroundColor3 = H.BackgroundColor3
        HC.BorderSizePixel = 0
        HC.ZIndex = 201

        local C = Instance.new("TextButton", H)
        C.Size = UDim2.new(0, 22, 0, 22)
        C.Position = UDim2.new(1, -26, 0.5, 0)
        C.AnchorPoint = Vector2.new(0, 0.5)
        C.BackgroundColor3 = Color3.fromRGB(150, 55, 55)
        C.Text = "X"
        C.Font = Enum.Font.Code
        C.TextSize = 13
        C.TextColor3 = Color3.fromRGB(255, 255, 255)
        C.AutoButtonColor = false
        C.BorderSizePixel = 0
        C.ZIndex = 202
        corner(C, 5)
        C.MouseButton1Click:Connect(function() M.Visible = false end)

        local B = Instance.new("Frame", M)
        B.Position = UDim2.new(0, 0, 0, 30)
        B.Size = UDim2.new(1, 0, 1, -30)
        B.BackgroundTransparency = 1
        B.ZIndex = 200
        B.Active = true
        vlist(B, 8)
        local bp = Instance.new("UIPadding", B)
        bp.PaddingTop = UDim.new(0, 10); bp.PaddingBottom = UDim.new(0, 10)
        bp.PaddingLeft = UDim.new(0, 12); bp.PaddingRight = UDim.new(0, 12)

        local mD, mS, mP = false, nil, nil
        H.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                mD = true; mS = i.Position; mP = M.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if mD and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - mS
                M.Position = UDim2.new(mP.X.Scale, mP.X.Offset + d.X, mP.Y.Scale, mP.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                mD = false
            end
        end)
        return M, B
    end

    -- MAIN TAB
    local info = Instance.new("TextLabel", MainTab)
    info.Size = UDim2.new(0.92, 0, 0, 130)
    info.BackgroundColor3 = Color3.fromRGB(24, 25, 33)
    info.Text = " Danyagey Premium Hub\n- Watermark\n- Resizable menu\n- Color themes\n- 3D particles\n- Custom fog\n- Key from @boldbild"
    info.Font = Enum.Font.Code
    info.TextSize = 12
    info.TextColor3 = Color3.fromRGB(200, 205, 220)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.TextWrapped = true
    corner(info, 8)
    stroke(info, Color3.fromRGB(45, 48, 60), 1)
    local ip = Instance.new("UIPadding", info)
    ip.PaddingLeft = UDim.new(0, 10); ip.PaddingTop = UDim.new(0, 6)

    -- FEATURES TAB
    local features = {
        {n = "Player ESP", d = "Boxes and names through walls"},
        {n = "Speed Hack", d = "Faster movement"},
        {n = "Fly", d = "Fly over the map"},
        {n = "Noclip", d = "Walk through walls"},
        {n = "Hitbox Expander", d = "Bigger hitbox"},
        {n = "Infinite Jump", d = "Endless jumps"},
        {n = "Fullbright", d = "Full lighting"},
        {n = "Teleport", d = "Teleport to player"},
        {n = "Anti-AFK", d = "No kick for AFK"},
        {n = "Rejoin", d = "Fast rejoin"},
    }

    for _, fn in ipairs(features) do
        local row = Instance.new("Frame", FeaturesTab)
        row.Size = UDim2.new(0.92, 0, 0, 50)
        row.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        row.BorderSizePixel = 0
        corner(row, 8)
        stroke(row, Color3.fromRGB(45, 48, 60), 1)

        local nl = Instance.new("TextLabel", row)
        nl.Size = UDim2.new(1, -80, 0, 22)
        nl.Position = UDim2.new(0, 10, 0, 4)
        nl.BackgroundTransparency = 1
        nl.Text = fn.n
        nl.Font = Enum.Font.Code
        nl.TextSize = 13
        nl.TextColor3 = Color3.fromRGB(230, 235, 245)
        nl.TextXAlignment = Enum.TextXAlignment.Left

        local dl = Instance.new("TextLabel", row)
        dl.Size = UDim2.new(1, -80, 0, 18)
        dl.Position = UDim2.new(0, 10, 0, 26)
        dl.BackgroundTransparency = 1
        dl.Text = fn.d
        dl.Font = Enum.Font.Code
        dl.TextSize = 10
        dl.TextColor3 = Color3.fromRGB(150, 160, 180)
        dl.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 60, 0, 30)
        btn.Position = UDim2.new(1, -70, 0, 10)
        btn.BackgroundColor3 = Color3.fromRGB(40, 44, 58)
        btn.Text = "OFF"
        btn.Font = Enum.Font.Code
        btn.TextSize = 11
        btn.TextColor3 = Color3.fromRGB(200, 210, 230)
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        corner(btn, 6)

        local on = false
        btn.MouseButton1Click:Connect(function()
            on = not on
            btn.Text = on and "ON" or "OFF"
            btn.BackgroundColor3 = on and Color3.fromRGB(30, 90, 50) or Color3.fromRGB(40, 44, 58)
            notify((on and "[+] " or "[-] ") .. fn.n, on and "success" or "info")
        end)
    end

    -- SETTINGS: FOG
    local fogTitle = Instance.new("TextLabel", SettingsTab)
    fogTitle.Size = UDim2.new(0.92, 0, 0, 30)
    fogTitle.BackgroundTransparency = 1
    fogTitle.Text = "Custom Fog: sky and world lighting"
    fogTitle.Font = Enum.Font.Code
    fogTitle.TextSize = 11
    fogTitle.TextColor3 = Color3.fromRGB(215, 220, 235)
    fogTitle.TextXAlignment = Enum.TextXAlignment.Left
    fogTitle.TextWrapped = true

    local fogBtn = Instance.new("TextButton", SettingsTab)
    fogBtn.Size = UDim2.new(0.92, 0, 0, 34)
    fogBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    fogBtn.Text = "  Fog: " .. state.fogName .. " v"
    fogBtn.Font = Enum.Font.Code
    fogBtn.TextSize = 12
    fogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    fogBtn.TextXAlignment = Enum.TextXAlignment.Left
    fogBtn.AutoButtonColor = false
    fogBtn.BorderSizePixel = 0
    corner(fogBtn, 8)
    stroke(fogBtn, Color3.fromRGB(45, 48, 60), 1)

    local fogList = Instance.new("ScrollingFrame", SettingsTab)
    fogList.Size = UDim2.new(0.92, 0, 0, 0)
    fogList.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    fogList.Visible = false
    fogList.CanvasSize = UDim2.new(0, 0, 0, 0)
    fogList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    fogList.ScrollBarThickness = 2
    fogList.BorderSizePixel = 0
    corner(fogList, 8)
    stroke(fogList, Color3.fromRGB(50, 54, 70), 1)
    vlist(fogList, 0)

    local fogPresets = {"Off", "Aurora", "Rainbow", "Blood Moon", "Cyberpunk", "Toxic", "Abyss", "Sunrise"}
    local fogOpen = false

    fogBtn.MouseButton1Click:Connect(function()
        fogOpen = not fogOpen
        fogList.Visible = fogOpen
        fogList.Size = fogOpen and UDim2.new(0.92, 0, 0, 176) or UDim2.new(0.92, 0, 0, 0)
    end)

    local function applyFog(preset)
        if ENV.AeroFogLoop then ENV.AeroFogLoop:Disconnect(); ENV.AeroFogLoop = nil end
        CC.Enabled = false; Bloom.Enabled = false
        local o = ENV.DanyageyOrigLighting
        if not o then return end

        if preset == "Off" then
            Lighting.FogColor = o.FogColor
            Lighting.FogEnd = o.FogEnd
            Lighting.Ambient = o.Ambient
            Lighting.OutdoorAmbient = o.OutdoorAmbient
            Lighting.ClockTime = o.ClockTime
        elseif preset == "Aurora" then
            Lighting.ClockTime = 0; Lighting.FogEnd = 800
            CC.Enabled = true; CC.Contrast = 0.2; CC.Saturation = 0.5
            CC.TintColor = Color3.fromRGB(150, 255, 200)
            Bloom.Enabled = true; Bloom.Intensity = 0.6
            ENV.AeroFogLoop = RunService.RenderStepped:Connect(function()
                local t = tick() * 0.2
                Lighting.FogColor = Color3.fromHSV((t % 1) * 0.3 + 0.45, 0.85, 0.55)
                Lighting.Ambient = Color3.fromHSV(((t+0.3) % 1) * 0.3 + 0.45, 0.85, 0.3)
                Lighting.OutdoorAmbient = Color3.fromHSV(((t+0.6) % 1) * 0.3 + 0.45, 0.85, 0.3)
            end)
        elseif preset == "Rainbow" then
            Lighting.ClockTime = 12; Lighting.FogEnd = 800
            Bloom.Enabled = true; Bloom.Intensity = 0.3
            ENV.AeroFogLoop = RunService.RenderStepped:Connect(function()
                local h = (tick() % 5) / 5
                local c = Color3.fromHSV(h, 0.7, 1)
                Lighting.FogColor = c; Lighting.Ambient = c; Lighting.OutdoorAmbient = c
            end)
        elseif preset == "Blood Moon" then
            Lighting.ClockTime = 0; Lighting.FogEnd = 300
            Lighting.FogColor = Color3.fromRGB(120, 10, 10)
            Lighting.Ambient = Color3.fromRGB(50, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(80, 10, 10)
            CC.Enabled = true; CC.Contrast = 0.3; CC.Saturation = 0.8
            CC.TintColor = Color3.fromRGB(255, 150, 150)
        elseif preset == "Cyberpunk" then
            Lighting.ClockTime = 2; Lighting.FogEnd = 400
            Lighting.FogColor = Color3.fromRGB(255, 0, 150)
            Lighting.Ambient = Color3.fromRGB(0, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(150, 0, 255)
            Bloom.Enabled = true; Bloom.Intensity = 0.8
        elseif preset == "Toxic" then
            Lighting.ClockTime = 14; Lighting.FogEnd = 250
            Lighting.FogColor = Color3.fromRGB(80, 255, 50)
            Lighting.Ambient = Color3.fromRGB(50, 100, 20)
            Lighting.OutdoorAmbient = Color3.fromRGB(100, 200, 50)
            CC.Enabled = true; CC.TintColor = Color3.fromRGB(200, 255, 180)
        elseif preset == "Abyss" then
            Lighting.ClockTime = 0; Lighting.FogEnd = 50
            Lighting.FogColor = Color3.fromRGB(0, 0, 0)
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        elseif preset == "Sunrise" then
            Lighting.ClockTime = 6.5; Lighting.FogEnd = 800
            Lighting.FogColor = Color3.fromRGB(255, 150, 100)
            Lighting.Ambient = Color3.fromRGB(255, 100, 150)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 200, 150)
            Bloom.Enabled = true; Bloom.Intensity = 0.3
        end
    end

    for _, p in ipairs(fogPresets) do
        local b = Instance.new("TextButton", fogList)
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundTransparency = 1
        b.Text = "  " .. p
        b.Font = Enum.Font.Code
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(220, 225, 235)
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.MouseButton1Click:Connect(function()
            state.fogName = p
            fogBtn.Text = "  Fog: " .. p .. " v"
            fogList.Visible = false
            fogOpen = false
            applyFog(p)
            notify(p == "Off" and "Fog disabled" or ("Fog: " .. p), p == "Off" and "info" or "success")
        end)
    end
    applyFog("Off")

    -- SETTINGS: PARTICLES
    local ptTitle = Instance.new("TextLabel", SettingsTab)
    ptTitle.Size = UDim2.new(0.92, 0, 0, 30)
    ptTitle.BackgroundTransparency = 1
    ptTitle.Text = "Particles: 3D particles in world"
    ptTitle.Font = Enum.Font.Code
    ptTitle.TextSize = 11
    ptTitle.TextColor3 = Color3.fromRGB(215, 220, 235)
    ptTitle.TextXAlignment = Enum.TextXAlignment.Left

    local ptBtn = Instance.new("TextButton", SettingsTab)
    ptBtn.Size = UDim2.new(0.92, 0, 0, 34)
    ptBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    ptBtn.Text = "  Particles: Off v"
    ptBtn.Font = Enum.Font.Code
    ptBtn.TextSize = 12
    ptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ptBtn.TextXAlignment = Enum.TextXAlignment.Left
    ptBtn.AutoButtonColor = false
    ptBtn.BorderSizePixel = 0
    corner(ptBtn, 8)
    stroke(ptBtn, Color3.fromRGB(45, 48, 60), 1)

    local ptList = Instance.new("ScrollingFrame", SettingsTab)
    ptList.Size = UDim2.new(0.92, 0, 0, 0)
    ptList.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    ptList.Visible = false
    ptList.CanvasSize = UDim2.new(0, 0, 0, 0)
    ptList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ptList.ScrollBarThickness = 2
    ptList.BorderSizePixel = 0
    corner(ptList, 8)
    stroke(ptList, Color3.fromRGB(50, 54, 70), 1)
    vlist(ptList, 0)

    local ptTypes = {"Off", "Snow", "Money", "Bolts", "Pigs"}
    local ptOpen = false

    ptBtn.MouseButton1Click:Connect(function()
        ptOpen = not ptOpen
        ptList.Visible = ptOpen
        ptList.Size = ptOpen and UDim2.new(0.92, 0, 0, 140) or UDim2.new(0.92, 0, 0, 0)
    end)

    for _, t in ipairs(ptTypes) do
        local b = Instance.new("TextButton", ptList)
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundTransparency = 1
        b.Text = "  " .. t
        b.Font = Enum.Font.Code
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(220, 225, 235)
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.MouseButton1Click:Connect(function()
            state.ptType = t
            ptBtn.Text = "  Particles: " .. t .. " v"
            ptList.Visible = false
            ptOpen = false
            notify(t == "Off" and "Particles off" or ("Particles: " .. t), t == "Off" and "info" or "success")
        end)
    end

    -- PARTICLES ENGINE
    local partsFolder = Instance.new("Folder", workspace)
    partsFolder.Name = "Danyagey3DParticles"
    local pool = {}
    for i = 1, 60 do
        local part = Instance.new("Part", partsFolder)
        part.Size = Vector3.new(0.4, 0.4, 0.4)
        part.Transparency = 1
        part.CanCollide = false
        part.Anchored = true
        part.CastShadow = false
        table.insert(pool, {
            p = part,
            pos = Vector3.new(0, -9999, 0),
            sp = math.random(15, 35),
            dx = (math.random() - 0.5) * 8,
            dz = (math.random() - 0.5) * 8
        })
    end

    ENV.AeroWorldParticlesLoop = RunService.RenderStepped:Connect(function(dt)
        local type_ = state.ptType
        if type_ == "Off" then
            for _, x in ipairs(pool) do x.p.Transparency = 1 end
            return
        end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local center = root.Position
        for _, x in ipairs(pool) do
            x.pos = x.pos - Vector3.new(x.dx * dt, x.sp * dt, x.dz * dt)
            if x.pos.Y < center.Y - 15 or math.abs(x.pos.X - center.X) > 70 or math.abs(x.pos.Z - center.Z) > 70 then
                x.pos = Vector3.new(
                    center.X + (math.random() - 0.5) * 140,
                    center.Y + 50 + math.random(0, 15),
                    center.Z + (math.random() - 0.5) * 140
                )
            end
            x.p.CFrame = CFrame.new(x.pos)
            x.p.Transparency = 0.15
            if type_ == "Snow" then
                x.p.Shape = Enum.PartType.Ball
                x.p.Size = Vector3.new(0.4, 0.4, 0.4)
                x.p.Color = Color3.fromRGB(240, 248, 255)
                x.p.Material = Enum.Material.Neon
            elseif type_ == "Money" then
                x.p.Shape = Enum.PartType.Block
                x.p.Size = Vector3.new(0.8, 0.1, 0.5)
                x.p.Color = Color3.fromRGB(85, 170, 127)
                x.p.Material = Enum.Material.SmoothPlastic
            elseif type_ == "Bolts" then
                x.p.Shape = Enum.PartType.Block
                x.p.Size = Vector3.new(0.15, 1.2, 0.15)
                x.p.Color = Color3.fromRGB(255, 255, 0)
                x.p.Material = Enum.Material.Neon
            elseif type_ == "Pigs" then
                x.p.Shape = Enum.PartType.Block
                x.p.Size = Vector3.new(1, 0.8, 1)
                x.p.Color = Color3.fromRGB(255, 170, 255)
                x.p.Material = Enum.Material.SmoothPlastic
            end
        end
    end)

    -- WATERMARK
    local WMGui = Instance.new("ScreenGui")
    WMGui.Name = "DanyageyWatermark"
    WMGui.ResetOnSpawn = false
    WMGui.Parent = container

    local WM = Instance.new("TextButton", WMGui)
    WM.AnchorPoint = Vector2.new(0.5, 0.5)
    WM.Position = UDim2.new(0.6, 0, 0.05, 0)
    WM.Size = UDim2.new(0, 0, 0, 28)
    WM.AutomaticSize = Enum.AutomaticSize.X
    WM.BackgroundColor3 = ORIG.wm
    WM.BackgroundTransparency = 0.1
    WM.Text = ""
    WM.AutoButtonColor = false
    WM.Active = true
    corner(WM, 14)
    local WMStroke = stroke(WM, ORIG.wmS, 1)

    local wl = Instance.new("UIListLayout", WM)
    wl.FillDirection = Enum.FillDirection.Horizontal
    wl.VerticalAlignment = Enum.VerticalAlignment.Center
    wl.Padding = UDim.new(0, 6)

    local wp = Instance.new("UIPadding", WM)
    wp.PaddingLeft = UDim.new(0, 12); wp.PaddingRight = UDim.new(0, 12)

    local wmSegments = {}
    local function seg(txt, order)
        local l = Instance.new("TextLabel", WM)
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(0, 0, 1, 0)
        l.AutomaticSize = Enum.AutomaticSize.X
        l.Font = Enum.Font.Code
        l.Text = txt
        l.TextSize = 12
        l.TextColor3 = Color3.fromRGB(240, 245, 255)
        l.LayoutOrder = order
        table.insert(wmSegments, l)
        return l
    end
    seg("Danyagey1488.win", 1); seg("|", 2)
    local fpsLbl = seg("0 fps", 3); seg("|", 4)
    seg(LP.Name, 5); seg("|", 6)
    seg(isMobile and "Mobile" or "PC", 7)

    local wmDrag, wmStart, wmPos = false, nil, nil
    WM.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            wmDrag = true
            wmStart = i.Position
            wmPos = WM.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if wmDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - wmStart
            WM.Position = UDim2.new(wmPos.X.Scale, wmPos.X.Offset + d.X, wmPos.Y.Scale, wmPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            wmDrag = false
        end
    end)

    local fc, lt = 0, tick()
    RunService.RenderStepped:Connect(function()
        fc = fc + 1
        if tick() - lt >= 1 then
            fpsLbl.Text = fc .. " fps"
            fc = 0; lt = tick()
        end
    end)

    -- THEME (LAST: functions used by color dropdown)
    local cTitle = Instance.new("TextLabel", SettingsTab)
    cTitle.Size = UDim2.new(0.92, 0, 0, 20)
    cTitle.BackgroundTransparency = 1
    cTitle.Text = "Color: changes gui / watermark"
    cTitle.Font = Enum.Font.Code
    cTitle.TextSize = 11
    cTitle.TextColor3 = Color3.fromRGB(215, 220, 235)
    cTitle.TextXAlignment = Enum.TextXAlignment.Left

    local cBtn = Instance.new("TextButton", SettingsTab)
    cBtn.Size = UDim2.new(0.92, 0, 0, 34)
    cBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    cBtn.Text = "  Color: Standard v"
    cBtn.Font = Enum.Font.Code
    cBtn.TextSize = 12
    cBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cBtn.TextXAlignment = Enum.TextXAlignment.Left
    cBtn.AutoButtonColor = false
    cBtn.BorderSizePixel = 0
    corner(cBtn, 8)
    stroke(cBtn, Color3.fromRGB(45, 48, 60), 1)

    local cList = Instance.new("ScrollingFrame", SettingsTab)
    cList.Size = UDim2.new(0.92, 0, 0, 0)
    cList.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    cList.Visible = false
    cList.CanvasSize = UDim2.new(0, 0, 0, 0)
    cList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    cList.ScrollBarThickness = 2
    cList.BorderSizePixel = 0
    corner(cList, 8)
    stroke(cList, Color3.fromRGB(50, 54, 70), 1)
    vlist(cList, 0)

    local colorList = {
        {"Standard", Color3.fromRGB(18, 19, 23), Color3.fromRGB(50, 52, 63)},
        {"Red", Color3.fromRGB(45, 12, 12), Color3.fromRGB(255, 60, 60)},
        {"Blue", Color3.fromRGB(12, 25, 45), Color3.fromRGB(60, 130, 255)},
        {"Green", Color3.fromRGB(12, 45, 20), Color3.fromRGB(60, 255, 110)},
        {"Purple", Color3.fromRGB(35, 12, 45), Color3.fromRGB(180, 60, 255)},
        {"Pink", Color3.fromRGB(45, 12, 30), Color3.fromRGB(255, 110, 190)},
        {"Gold", Color3.fromRGB(45, 35, 12), Color3.fromRGB(255, 205, 60)},
        {"Rainbow", nil, nil}
    }
    local cOpen = false

    cBtn.MouseButton1Click:Connect(function()
        cOpen = not cOpen
        cList.Visible = cOpen
        cList.Size = cOpen and UDim2.new(0.92, 0, 0, 176) or UDim2.new(0.92, 0, 0, 0)
    end)

    local function applyTheme(base, st)
        MainFrame.BackgroundColor3 = base
        MainStroke.Color = st
        Header.BackgroundColor3 = Color3.new(
            math.max(0, base.R*255 - 10)/255,
            math.max(0, base.G*255 - 10)/255,
            math.max(0, base.B*255 - 10)/255
        )
        Sidebar.BackgroundColor3 = Color3.new(
            math.max(0, base.R*255 - 15)/255,
            math.max(0, base.G*255 - 15)/255,
            math.max(0, base.B*255 - 15)/255
        )
        WM.BackgroundColor3 = base
        WMStroke.Color = st
    end

    for _, c in ipairs(colorList) do
        local b = Instance.new("TextButton", cList)
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundTransparency = 1
        b.Text = "  " .. c[1]
        b.Font = Enum.Font.Code
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(220, 225, 235)
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.MouseButton1Click:Connect(function()
            state.colorName = c[1]
            cBtn.Text = "  Color: " .. c[1] .. " v"
            cList.Visible = false
            cOpen = false
            if ENV.AeroColorLoop then ENV.AeroColorLoop:Disconnect(); ENV.AeroColorLoop = nil end
            if c[1] == "Rainbow" then
                ENV.AeroColorLoop = RunService.RenderStepped:Connect(function()
                    local h = (tick() % 4) / 4
                    applyTheme(Color3.fromHSV(h, 0.7, 0.25), Color3.fromHSV(h, 1, 1))
                end)
                notify("Theme: Rainbow", "success")
            else
                applyTheme(c[2], c[3])
                notify("Theme: " .. c[1], "success")
            end
        end)
    end

    -- HEADER BUTTONS
    headBtn("-", function()
        MainFrame.Visible = false
        notify("Menu minimized", "info")
    end)
    headBtn("X", function()
        MainGui:Destroy()
        WMGui:Destroy()
        local wp = workspace:FindFirstChild("Danyagey3DParticles")
        if wp then wp:Destroy() end
        if Lighting:FindFirstChild("DanyageyCC") then Lighting.DanyageyCC:Destroy() end
        if Lighting:FindFirstChild("DanyageyBloom") then Lighting.DanyageyBloom:Destroy() end
        if ENV.DanyageyOrigLighting then
            Lighting.FogColor = ENV.DanyageyOrigLighting.FogColor
            Lighting.FogEnd = ENV.DanyageyOrigLighting.FogEnd
            Lighting.Ambient = ENV.DanyageyOrigLighting.Ambient
            Lighting.OutdoorAmbient = ENV.DanyageyOrigLighting.OutdoorAmbient
            Lighting.ClockTime = ENV.DanyageyOrigLighting.ClockTime
        end
        for _, k in ipairs({"AeroSnowLoop","AeroColorLoop","AeroWorldParticlesLoop","AeroFogLoop"}) do
            if ENV[k] then pcall(function() ENV[k]:Disconnect() end) end
        end
        notify("Script unloaded", "warn")
    end)

    -- WM toggle GUI
    WM.Activated:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    notify("Script loaded", "success")
    print("[D] loaded OK")
end

-- ждём ключ
task.spawn(function()
    while not keyPassed do task.wait(0.15) end
    task.wait(0.1)
    local ok, err = pcall(init)
    if not ok then
        warn("[D] init error: " .. tostring(err))
    end
end)

print("[D] waiting for key")
