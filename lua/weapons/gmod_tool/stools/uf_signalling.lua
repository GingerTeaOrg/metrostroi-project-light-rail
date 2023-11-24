-- Register the tool
if CLIENT then
    language.Add("tool.uf_signalling.name",
                 "Metrostroi: Project Light Rail Signal Spawner")
    language.Add("tool.uf_signalling.desc", "Set up your signals, in style!")
    language.Add("tool.uf_signalling.left", "Left-click to spawn a signal.")
    language.Add("tool.uf_signalling.right",
                 "Right-click to load a signal's settings.")
    TOOL.Category = "Metrostroi: Project Light Rail"
    TOOL.Name = "Metrostroi: Project Light Rail Signal Spawner"
    TOOL.Information = {{name = "left"}, {name = "right"}}

    TOOL.ClientConVar["signal_type"] = "Overground_Large"
    TOOL.ClientConVar["signal_name1"] = "Signal 1"
    TOOL.ClientConVar["signal_name2"] = "Signal 2"
end

if SERVER then
    util.AddNetworkString("uf_signal_settings")
    util.AddNetworkString("uf_signal_settings_client")
end

function TOOL:Initialize() self.Owner = self:GetOwner() end

-- Table of signal types with their respective models
local signalTypes = {
    ["Overground large"] = "models/lilly/uf/signals/signal-bostrab-overground.mdl",
    ["Underground with small Pole"] = "models/lilly/uf/signals/underground_small_pole.mdl"
}

-- Add more signal types as needed
-- Precaching signal models
if CLIENT then
    for _, modelPath in pairs(signalTypes) do util.PrecacheModel(modelPath) end
end

local ClientOwner
-- Function to build the settings pane
function TOOL.BuildCPanel(panel)

    local tool = tool or {}
    tool.Settings = tool.Settings or {}
    tool.Settings.Routes = tool.Settings.Routes or {}

    panel:AddControl("Header", {Description = "Signal Settings"})

    local modelPreviewPanel = vgui.Create("DPanel")
    local panelSize = 300 -- Desired size
    modelPreviewPanel:SetSize(200, panelSize)
    local modelPreview = vgui.Create("DModelPanel", modelPreviewPanel)
    modelPreview:SetSize(220, 220) -- Adjust size as needed
    modelPreview:SetModel("") -- Set initial model to an empty string
    for signalType, modelPath in pairs(signalTypes) do
        local button = vgui.Create("DButton", modelPreviewPanel)
        button:SetText(signalType)
        button:Dock(TOP)
        button.DoClick = function()
            LocalPlayer():EmitSound("buttons/button3.wav")
            modelPreview:SetModel(modelPath)
            tool.Settings["SignalType"] = modelPath
        end
    end

    modelPreview.LayoutEntity = function(ent)
        -- Calculate the position based on panel size
        local idealPos = panelSize / 20 -- Adjust factor as needed
        ent:SetCamPos(Vector(130, -35, 120))
        ent:SetLookAng(Angle(0, 180, 0))
    end

    panel:AddPanel(modelPreviewPanel)
    ---------------------------------------------------------------------------
    local signalName1Entry = vgui.Create("DTextEntry")
    signalName1Entry:SetSize(200, 25)
    signalName1Entry:SetValue(tool.Settings.Name1 or "Top Signal Name Text")
    signalName1Entry.OnEnter = function(self)
        tool.Settings["Name1"] = signalName1Entry:GetValue()
    end
    panel:AddPanel(signalName1Entry)
    ------------------------------------------------------------------------------
    local function InputSwitchingData()
        local SwitchInput = vgui.Create("DFrame")
        SwitchInput:SetSize(200, 150)
        SwitchInput:SetTitle("Switching Data")
        SwitchInput:Center()
        SwitchInput:MakePopup()
        -- SwitchInput:Help("Specify which Switches to target by name, and specify their orientation. Leave empty if not applicable.")
        local labels = {"Switch", "Main/Alternate"}
        local yOffset = 66
        local textEntries = {}
        local labelElements = {}
        local submitButton = vgui.Create("DButton", SwitchInput)
        submitButton:Dock(LEFT)
        submitButton:Dock(BOTTOM)
        submitButton:SetText("Apply")
        submitButton.DoClick = function()
            local Owner = LocalPlayer()
            -- tool.Settings["Rotation"] = value
            tool.Settings["Owner"] = Owner
            net.Start("uf_signal_settings")
            net.WriteTable(tool.Settings)
            net.SendToServer()
            LocalPlayer():EmitSound("buttons/button3.wav")
            SwitchInput:Close()
        end

        local switch
        local orientation
        for i = 1, 2 do
            textEntries[i] = {} -- Initialize a new row for text entries

            local label = vgui.Create("DLabel", SwitchInput)
            label:SetPos(15 + (j - 1) * 88, yOffset + 5)
            label:SetText(labels[j] .. " " .. i)
            label:SizeToContents()
            label:SetTextColor(Color(51, 51, 51))
            label:SetZPos(2)
            labelElements[#labelElements + 1] = label -- Store labels
            local textEntry = vgui.Create("DTextEntry", SwitchInput)
            textEntry:SetPos(10 + (j - 1) * 85, yOffset)
            textEntry:SetSize(90, 25)
            textEntry:SetZPos(1)
            textEntry:SetValue()
            -- textEntry:SetValue("Field " .. i)
            textEntry.OnValueChange = function(self)
                local value = textEntry:GetValue()
                if not tool.Settings.Routes[i]["Switches"] then
                    tool.Settings.Routes[i]["Switches"] = {}
                end

                tool.Settings.Routes[i]["Switches"] = {
                    [j == 1 and #value > 0 and value or value] = (j == 2 and
                        #value > 0 and value or value)
                }

                if string.len(value) > 0 then
                    label:SetZPos(0)
                else
                    label:SetZPos(2)
                end
            end

            textEntry.OnLoseFocus = function(self)
                local value = textEntry:GetValue()
                if string.len(value) > 0 then
                    label:SetZPos(0) -- Keep label at a higher Z-order if text is present and focus is lost
                else
                    label:SetZPos(2) -- Set label back to its default Z-order if text is empty and focus is lost
                end
            end

            -- Store text entries in the table
            textEntries[i][j] = textEntry

            yOffset = yOffset + 30
        end
    end

    local signalName2Entry = vgui.Create("DTextEntry")
    signalName2Entry:SetSize(200, 25)
    signalName2Entry:SetValue(tool.Settings.Name2 or "Bottom Signal Name Text")
    signalName2Entry.OnEnter = function(self)
        tool.Settings["Name2"] = signalName2Entry:GetValue()
    end
    panel:AddPanel(signalName2Entry)
    ----------------------------------------------------------------------
    local submitButton = vgui.Create("DButton", panel)
    submitButton:SetText("Set up Routes")
    submitButton.DoClick = function()
        local inputFrame = vgui.Create("DFrame")
        inputFrame:SetSize(440, 300)
        inputFrame:SetTitle("Input Route Data")
        inputFrame:Center()
        inputFrame:MakePopup()
        local slider = vgui.Create("DNumSlider", inputFrame)
        slider:SetText("Number of Routes")
        slider:SetPos(10, 30)
        slider:SetWide(380)
        slider:SetMin(1)
        slider:SetMax(4)
        slider:SetDecimals(0)
        slider:SetValue(1)
        local labels = {"Next Signal"}
        local yOffset = 70
        local textEntries = {}
        local labelElements = {}
        local switchButtons = {} -- Store created SwitchButtons

        local function createFields(numFields)
            -- Clear existing text entry boxes and labels
            for _, entry in ipairs(textEntries) do
                if IsValid(entry) then entry:Remove() end
            end

            for _, label in ipairs(labelElements) do
                if IsValid(label) then label:Remove() end
            end

            textEntries = {} -- Clear textEntries table
            labelElements = {} -- Clear labelElements table
            local TableCompile = {}
            for i = 1, numFields do
                textEntries[i] = {} -- Initialize a new row for text entries
                switchButtons[i] = vgui.Create("DButton", inputFrame)
                switchButtons[i]:SetPos(205, yOffset + 2.4)
                switchButtons[i]:SetText("Switching Data for Route")
                switchButtons[i]:SetWide(130)
                local label2 = vgui.Create("DLabel", inputFrame)
                label2:SetPos(10 + 100, yOffset + 5)
                label2:SetText(labels[1] .. " " .. i)
                label2:SizeToContents()
                label2:SetTextColor(Color(51, 51, 51))
                label2:SetZPos(2)
                labelElements[#labelElements + 1] = label2 -- Store labels
                local textEntry2 = vgui.Create("DTextEntry", inputFrame)
                textEntry2:SetPos(5 + 100, yOffset)
                textEntry2:SetSize(100, 25)
                textEntry2:SetZPos(1)
                if tool.Settings.Routes[i] then
                    local val = tool.Settings.Routes[i]["NextSignal"] or ""
                    textEntry2:SetValue(val)
                else
                    -- Handle the case where tool.Settings.Routes[i] is nil or doesn't exist
                    -- For instance, set a default value for textEntry:SetValue()
                    textEntry2:SetValue("")
                end

                textEntry2.OnValueChange = function(self)
                    local value = textEntry:GetValue()
                    local route = tool.Settings.Routes[i] or {} -- Get existing route or initialize a new one
                    route["RouteID"] = i
                    route["NextSignal"] = value
                    route["DistantSignal"] = value
                    route["Switches"] = route["Switches"] or {} -- Ensure Switches table exists within the route
                    tool.Settings.Routes[i] = route -- Update the specific route entry

                    print("Next Signal Input",i)
                    PrintTable(tool.Settings.Routes[i], 1)
                    if string.len(value) > 0 then
                        label:SetZPos(0)
                    else
                        label:SetZPos(2)
                    end
                end

                switchButtons[i].DoClick = function()
                    InputSwitchingData()
                end
                textEntry.OnGetFocus = function(self)
                    label:SetZPos(0) -- Set label to a higher Z-order when the text box gains focus
                end

                textEntry.OnLoseFocus = function(self)
                    local value = textEntry:GetValue()
                    if string.len(value) > 0 then
                        label:SetZPos(0) -- Keep label at a higher Z-order if text is present and focus is lost
                    else
                        label:SetZPos(2) -- Set label back to its default Z-order if text is empty and focus is lost
                    end
                end

                -- Store text entries in the table
                textEntries[i] = textEntry

                yOffset = yOffset + 30
            end

            local submitButton = vgui.Create("DButton", inputFrame)
            submitButton:SetPos(10, 250)
            submitButton:SetText("Confirm")
            submitButton.DoClick = function()
                PrintTable(tool.Settings, 1)
                local Owner = LocalPlayer()
                tool.Settings["Owner"] = Owner

                inputFrame:Close()
            end

            -- Removing excess SwitchButtons if slider value decreases
            for i = numFields + 1, #switchButtons do
                if IsValid(switchButtons[i]) then
                    switchButtons[i]:Remove()
                    switchButtons[i] = nil
                end
            end
        end

        slider.OnValueChanged = function(self, value)
            yOffset = 70
            createFields(value)
        end

        createFields(slider:GetValue())
    end

    panel:AddPanel(submitButton)
    ----------------------------------------------------
    local rotationSlider = vgui.Create("DNumSlider", panel)
    rotationSlider:SetText("Signal Prop Rotation")
    rotationSlider:SetMin(-180)
    rotationSlider:SetMax(180)
    rotationSlider:SetDecimals(0)
    rotationSlider:SetValue(0) -- Initial rotation value
    rotationSlider.OnValueChanged = function(self, value)
        local Owner = LocalPlayer()
        tool.Settings["Rotation"] = value
        tool.Settings["Owner"] = Owner
        PrintTable(tool.Settings, 1)
    end

    panel:AddPanel(rotationSlider)
    ---------------------------------------------------------------
    local ApplySettings = vgui.Create("DButton", panel)
    ApplySettings:SetText("Apply")
    -- ApplySettings:Dock(TOP)
    ApplySettings.DoClick = function()
        local Owner = LocalPlayer()
        tool.Settings["Rotation"] = value
        tool.Settings["Owner"] = Owner
        net.Start("uf_signal_settings")
        net.WriteTable(tool.Settings)
        net.SendToServer()
        LocalPlayer():EmitSound("buttons/button3.wav")
    end

    panel:AddPanel(ApplySettings)
    -- self.Settings["Player"] = TOOL:GetOwner()
    panel:AddControl("Label", {Text = "Primary Fire to Spawn Signal"})

    panel:AddControl("Label", {Text = "Secondary Fire to Update Signal"})
end

-- Function to create the signal entity
function TOOL:LeftClick(trace)
    if SERVER then
        self.Settings = ServerSettings

        PrintTable(self.Settings, 1)
        local ply = self:GetOwner()
        local trace = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * 1000, -- Adjust the length based on how far you want to trace
            filter = {ply}
        })

        local signalType = self.Settings["SignalType"]
        local signalName1 = self.Settings["Name1"]
        local signalName2 = self.Settings["Name2"]
        local Rotation = self.Settings["Rotation"]
        local DistantSignal = self.Settings["DistantSignal"]
        local Rotation = Angle(0, self.Settings["Rotation"], 0)
        local Routes = self.Settings.Routes
        local ent = ents.Create("gmod_track_uf_signal")
        if not IsValid(ent) then return false end
        ent:SetPos(trace.HitPos)
        ent:SetModel(signalType)
        -- Set the signal names before spawning the entity
        ent.Name1 = signalName1
        ent.Name2 = signalName2
        ent.DistantSignal = DistantSignal
        ent.Routes = Routes
        ent:SetAngles(trace.HitNormal:Angle() + Angle(90, 00, 0) + Rotation)
        ent:Spawn()
        undo.Create("Signal")
        undo.AddEntity(ent)
        undo.SetPlayer(self:GetOwner())
        undo.Finish()
        return true
    end
end

function TOOL:GetClientInfo(property)
    if self.ClientConVars[property] and CLIENT then
        return self.ClientConVars[property]:GetString()
    end
    return self:GetOwner():GetInfo(self:GetMode() .. "_" .. property)
end

-- Function to update signal names on right-click
function TOOL:RightClick(trace)
    if CLIENT then return false end
    local ply = self:GetOwner()
    if not ply:IsAdmin() then return end
    if not IsValid(trace.Entity) or not trace.Entity:IsValid() then
        return false
    end
    if trace.Entity:GetClass() == "gmod_track_uf_signal" then
        local signalType = self.Settings["SignalType"]
        local modelName = signalTypes[signalType]
        local signalName1 = self.Settings["Name1"]
        local signalName2 = self.Settings["Name2"]
        local Rotation = self.Settings["Rotation"]
        trace.Entity.Name1 = signalName1
        trace.Entity.Name2 = signalName2
        return true
    end
    return false
end

-- Function to create the model preview
function TOOL:Think()
    if CLIENT then
        local ply = self:GetOwner()
        if not ply:IsAdmin() then
            ply:PrintMessage(HUD_PRINTTALK,
                             "You're not a server admin. Bailing.")
            return
        end

        -- print(ClientOwner)
        self.Settings = ClientSettings
        if not self.Settings then return end
        if not IsValid(ply) then
            print("No player")
            return
        end

        local trace = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * 1000, -- Adjust the length based on how far you want to trace
            filter = {ply}
        })

        if not trace.Hit then return end -- If the trace doesn't hit anything, return
        if not self.Settings then return end
        local signalType = self.Settings["SignalType"]
        local modelName = signalTypes[signalType] or
                              "models/lilly/uf/signals/underground_small_pole.mdl"
        if not modelName then
            print("No model sent, bailing out of preview function")
            return
        end

        local Rotation = Angle(0, self.Settings["Rotation"], 0)
        if not IsValid(self.PreviewModel) then
            self.PreviewModel = ClientsideModel(modelName, RENDERGROUP_OPAQUE)
            self.PreviewModel:Spawn()
            self.PreviewModel:SetModel(modelName)
        else
            self.PreviewModel:SetPos(trace.HitPos)
            self.PreviewModel:SetAngles(trace.HitNormal:Angle() +
                                            Angle(90, 00, 0) + Rotation)
            self.PreviewModel:SetModel(modelName)
        end

        self.PreviewModel:SetNoDraw(false)
    end
end

-- Function to remove the model preview
function TOOL:Holster()
    if CLIENT then
        if IsValid(self.PreviewModel) then self.PreviewModel:Remove() end
    end
end

if SERVER then local ServerSettings = {} end
if CLIENT then local ClientSettings = {} end
if SERVER then
    net.Receive("uf_signal_settings", function()
        ServerSettings = net.ReadTable()
        if ServerSettings then
            print("Relaying settings")
            net.Start("uf_signal_settings_client")
            net.WriteTable(ServerSettings, true)
            net.Broadcast()
        end
    end)
end

if CLIENT then
    net.Receive("uf_signal_settings_client",
                function() ClientSettings = net.ReadTable() end)
end
