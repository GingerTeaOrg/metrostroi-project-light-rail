--------------------------------------------------------------------------------
-- Announcer and announcer-related code
--------------------------------------------------------------------------------
-- Copyright (C) 2013-2018 Metrostroi Team & FoxWorks Aerospace s.r.o.
-- Contains proprietary code. See license.md for additional information.
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("uf_announcer")
TRAIN_SYSTEM.DontAccelerateSimulation = true
local ANNOUNCER_CACHE_LIMIT = 30

function TRAIN_SYSTEM:Outputs()
    return {}
end

function TRAIN_SYSTEM:Inputs()
    return {"Reset"}
end

if TURBOSTROI then return end

--------------------------------------------------------------------------------
if SERVER then
    function TRAIN_SYSTEM:Initialize(tbl)
        self.Schedule = {}
        self.AnnTable = tbl
    end

    util.AddNetworkString("uf_announcer")

    function TRAIN_SYSTEM:TriggerInput(name,value)
        if name == "Reset" then
            self:Reset()
            self.AnnTable = value
        end
        if name == "Table" then
            self.AnnTable = value
        end
    end

    function TRAIN_SYSTEM:Queue(tbl)
        for k, v in pairs(tbl) do
            if v~=-2 then
                table.insert(self.Schedule, tbl and tbl[v] or v)
            else
                self:Reset()
            end
        end
    end

    function TRAIN_SYSTEM:Reset()
        if #self.Schedule > 0 then
            self.Schedule = {}
            self.AnnounceTimer = nil
        end
        self:WriteMessage("_STOP")
    end
    function TRAIN_SYSTEM:WriteMessage(msg)
        for i = 1, #self.Train.WagonList do
            net.Start("uf_announcer", true)
            local train = self.Train.WagonList[i]
            net.WriteEntity(train)
            net.WriteString(msg)
            net.Broadcast()
        end
    end
function TRAIN_SYSTEM:dumpTable(table, indent)
  indent = indent or 0
  for key, value in pairs(table) do
    if type(value) == "table" then
      print(string.rep("  ", indent) .. key .. " = {")
      self:dumpTable(value, indent + 1)
      print(string.rep("  ", indent) .. "}")
    else
      print(string.rep("  ", indent) .. key .. " = " .. tostring(value))
    end
  end
end
    --end
    function TRAIN_SYSTEM:Think()
        if #self.Schedule > 0 and not self.Playing then -- if announcements are queued and are not marked as playing yet
            for i = 1, #self.Train.WagonList do --for every car in the consist
                self.Train.WagonList[i]:SetNW2Bool("AnnouncerPlaying", true) --mark the announcements as active
            end
            self.Playing = true --note down the accounements as playing for us locally
        elseif #self.Schedule == 0 and self.Playing and not self.AnnounceTimer then --announcements aren't queued
            for i = 1, #self.Train.WagonList do
                self.Train.WagonList[i]:SetNW2Bool("AnnouncerPlaying", false) --we're not playing anything anymore
            end
            self.Playing = false --we're not playing anything anymore
        end

        while #self.Schedule > 0 and (not self.AnnounceTimer or CurTime() - self.AnnounceTimer > 0) do
            self:dumpTable(self.Schedule, 5)
            local tbl = table.remove(self.Schedule, 1)
            self:dumpTable(tbl,5)
            if type(tbl) == "number" then
                if tbl == -1 then
                else
                    self.AnnounceTimer = CurTime() + tbl
                end
            elseif type(tbl) == "table" then
                for k,v in pairs(tbl) do
                    self:WriteMessage(k)
                    self.AnnounceTimer = CurTime() + v
                end
            else
                ErrorNoHalt("Announcer error in message "..tbl.."\n")
            end
        end
        if #self.Schedule == 0 and self.AnnounceTimer and CurTime() - self.AnnounceTimer > 0 then
            self.AnnounceTimer = nil --no need to run a timer when self.Schedule is null
            
        end
        if #self.Schedule > ANNOUNCER_CACHE_LIMIT then
            self:Reset()
        end
    end
else
    net.Receive("uf_announcer", function(len, pl)
        local train = net.ReadEntity()
        if not IsValid(train) or not train.RenderClientEnts then return end
        local snd = net.ReadString()
        --print(snd)
        if train.AnnouncerPositions then
            
            for k, v in ipairs(train.AnnouncerPositions) do
                print("with announcerpos")
                train:PlayOnceFromPos("announcer" .. k, snd, 0.4, 1,400, 1e9, v[1])
            end
        else
            print("without announcerpos")
            train:PlayOnceFromPos("announcer", snd, train.OnAnnouncer and train:OnAnnouncer(1) or 0.4, 1, 600, 1e9, Vector(0, 0, 0))
        end
    end)

    function TRAIN_SYSTEM:ClientInitialize()
    end

    function TRAIN_SYSTEM:ClientThink()
    end
end