
-- Tool settings
TOOL.Name = "Signalling Editor" -- The tool's name
TOOL.Category = "Metrostroi: Project Light Rail" -- The category it belongs to
TOOL.ConfigName = ""
-- Add the tool to the tool menu
local Types = {"Signal","Sign",[0] = "Choose Type"}
local TypesOfSignal = {"Overground_Large","Underground_Small_Pole","Placeholder"}
TOOL.Type = 0
if SERVER then util.AddNetworkString "mplr-stool-signalling" end
if CLIENT then
    language.Add("tool.uf_signalling.name", "MPLR Signalling Editor")
    language.Add("tool.uf_signalling.desc", "Edit Signalling for Light Rail")
    language.Add("tool.uf_signalling.0", "Left-click to use")

    function TOOL.BuildCPanel(panel)
        local Menu = vgui.Create("DMenu",panel)
        Menu:SetPos(0,50)
        Menu:AddOption( "Test" )
        Menu:AddOption( "Test2" )
        local button = vgui.Create("DButton",panel)
        button:SetSize(100,50)
		button:SetText("Save Path Configs")
        button:SetPos(100,100)
        button.DoClick = function()
			
			LocalPlayer():EmitSound("buttons/button3.wav")
        end
    end
    
end

-- Server-side initialization
function TOOL:LeftClick(trace)
    if CLIENT then
        return true
    end
    
    --self.Signal = util.JSONToTable(self:GetClientInfo("signaldata"):replace("''","\""))
    --if not self.Signal then return end
    local ply = self:GetOwner()
    if (ply:IsValid()) and (not ply:IsAdmin()) then return false end
    if not trace then return false end
    if trace.Entity and trace.Entity:IsPlayer() then return false end
    
    local ent
    if self.Type == 1 then
        ent = self:SpawnSignal(ply,trace)
    elseif self.Type == 2 then
        ent = self:SpawnSign(ply,trace)
    end
    
    return true
end
-- Server-side initialization
function TOOL:RightClick(trace)
    -- Your tool's left-click functionality here
    return true
end
-- Register the tool

function TOOL:SendSettings()
    if self.Type == 1 then
        if not self.Signal then return end
        RunConsoleCommand("signalling_signaldata",util.TableToJSON(self.Signal))
        net.Start "mplr-stool-signalling"
        net.WriteUInt(0,8)
        --net.WriteEntity(self)
        net.WriteTable(self.Signal)
        net.SendToServer()
        
    elseif self.Type == 2 then
        if not self.Sign then return end
        RunConsoleCommand("signalling_signdata",util.TableToJSON(self.Sign))
        net.Start "mplr-stool-signalling"
        net.WriteUInt(1,8)
        --net.WriteEntity(self)
        net.WriteTable(self.Sign)
        net.SendToServer()
    end
end

net.Receive("mplr-stool-signalling", function(_, ply)
    local TOOL = LocalPlayer and LocalPlayer():GetTool("signalling") or ply:GetTool("signalling")
    local typ = net.ReadUInt(8)
    if typ == 1 then
        TOOL.Sign = net.ReadTable()
        if CLIENT then
            RunConsoleCommand("signalling_signdata",util.TableToJSON(TOOL.Sign))
            NeedUpdate = true
        end
    elseif typ == 0 then
        TOOL.Signal = net.ReadTable()
        if CLIENT then
            RunConsoleCommand("signalling_signaldata",util.TableToJSON(TOOL.Signal))
            NeedUpdate = true
        end
    end
    TOOL.Type = typ+1
end)

-- Create the settings menu

function TOOL:SpawnSignal(ply,trace,param)
    local pos = trace.HitPos
    
    -- Use some code from rerailer --
    local tr = Metrostroi.RerailGetTrackData(pos,ply:GetAimVector())
    if not tr then return end
    -- Create self.Signal entity
    local ent
    local found = false
    local entlist = ents.FindInSphere(pos,64)
    for k,v in pairs(entlist) do
        if v:GetClass() == "gmod_track_uf_signal" then
            if v.Name==self.Signal.Name then
                ent = v
                found=0
                break
            end
            if not found or found > pos:Distance(v:GetPos()) then
                ent = v
                found = pos:Distance(v:GetPos())
            end
        end
    end
end

function TOOL:Think()
    if CLIENT and (self.NotBuilt or NeedUpdate) then
        self.Signal = self.Signal or util.JSONToTable(string.Replace(GetConVar("signalling_signaldata"):GetString(),"'","\"")) or {}
        self.Sign = self.Sign or util.JSONToTable(string.Replace(GetConVar("signalling_signdata"):GetString(),"'","\"")) or {}
        self.Auto = self.Auto or util.JSONToTable(string.Replace(GetConVar("signalling_autodata"):GetString(),"'","\"")) or {}
        self:SendSettings()
        self.NotBuilt = nil
        NeedUpdate = nil
    end
end