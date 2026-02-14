-- Original Copyright:
-- Copyright © Platunov I. M., 2020 All rights reserved
-- Modified for M:PLR based on Trolleybus GitHub Release under CC BY-NC-SA 4.0
if SERVER then
	AddCSLuaFile( "uf/trolleybus/trolleytrafficeditor/cl_init.lua" )
	AddCSLuaFile( "uf/trolleybus/trolleytrafficeditor/shared.lua" )
	include( "uf/trolleybus/trolleytrafficeditor/init.lua" )
else
	include( "uf/trolleybus/trolleytrafficeditor/cl_init.lua" )
end

include( "uf/trolleybus/trolleytrafficeditor/shared.lua" )