--------------------------------------------------------------------------------
-- Battery
--------------------------------------------------------------------------------
-- Copyright (C) 2013-2018 Metrostroi Team & FoxWorks Aerospace s.r.o.
-- Contains proprietary code. See Metrostroi license.txt for additional information.
--------------------------------------------------------------------------------
Metrostroi.DefineSystem( "Duewag_Battery" )
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
	-- Battery parameters
	self.ElementCapacity = 50 -- A*hour
	self.ElementCount = 36
	self.Capacity = self.ElementCapacity * self.ElementCount * 3600
	self.Charge = 0
	self.Voltage = 0
	-- Current through battery in amperes
	self.Current = 0
	self.Charging = 0
end

function TRAIN_SYSTEM:Inputs()
	return { "Charge" }
end

function TRAIN_SYSTEM:Outputs()
	return { "Capacity", "Charge", "Voltage" }
end

function TRAIN_SYSTEM:TriggerInput( name, value )
	if name == "Charge" then self.Charging = value end
end

function TRAIN_SYSTEM:Think( dT )
	local cS = self.Train.CoreSys
	-- Calculate discharge
	self.Current = 0 -- theoretically possible to calculate, but would necessitate electrical schematics to calculate the bottom line electrical consumption of all LV devices
	-- print(self.Train.Panel["V1"])
	self.Charge = math.min( self.Capacity, self.Charge + self.Charging * dT )
	-- Calculate battery voltage
	if cS.BatteryOn or cS.BatteryActivated then
		self.Voltage = 24 * ( self.Charge / self.Capacity )
	else
		self.Voltage = 24 * ( self.Charge / self.Capacity ) + ( self.Charging > 0 and 24 or 0 )
	end
end