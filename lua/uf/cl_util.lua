function UF.PositionFromPanel( panel, button_id_or_vec, z, x, y, train )
	local self = train or ENT
	local panel = self.ButtonMapMPLR[ panel ]
	if not panel then return Vector( 0, 0, 0 ) end
	if not panel.buttons then return Vector( 0, 0, 0 ) end
	-- Find button or read position
	local vec
	if type( button_id_or_vec ) == "string" then
		local button
		for k, v in pairs( panel.buttons ) do
			if v.ID == button_id_or_vec then
				button = v
				break
			end
		end

		vec = Vector( button.x + ( button.radius and 0 or ( button.w or 0 ) / 2 ) + ( x or 0 ), button.y + ( button.radius and 0 or ( button.h or 0 ) / 2 ) + ( y or 0 ), z or 0 )
	else
		vec = button_id_or_vec
	end

	-- Convert to global coords
	vec.y = -vec.y
	vec:Rotate( panel.ang )
	return panel.pos + vec * panel.scale
end

function UF.AngleFromPanel( panel, ang, train )
	local self = train or ENT
	local panel = self.ButtonMapMPLR[ panel ]
	if not panel then return Vector( 0, 0, 0 ) end
	local true_ang = panel.ang + Angle( 0, 0, 0 )
	if type( ang ) == "Angle" then
		true_ang:RotateAroundAxis( panel.ang:Forward(), ang.pitch )
		true_ang:RotateAroundAxis( panel.ang:Right(), ang.yaw )
		true_ang:RotateAroundAxis( panel.ang:Up(), ang.roll )
	else
		true_ang:RotateAroundAxis( panel.ang:Up(), ang or -90 )
	end
	return true_ang
end

UF.PrecacheModels = UF.PrecacheModels or {}
function UF.GenerateClientProps()
	local self = ENT
	if not self.AutoAnimNames then self.AutoAnimNames = {} end
	local ret = "self.table = {\n"
	--local reti = 0
	for id, panel in pairs( self.ButtonMapMPLR ) do
		if not panel.buttons then continue end
		if not panel.props then panel.props = {} end
		for name, buttons in pairs( panel.buttons ) do
			--if reti > 8 then reti=0; ret=ret.."\n" end
			if buttons.tooltipFunc then
				local func = buttons.tooltipFunc
				buttons.tooltipState = function( ent )
					local str = func( ent )
					if not str then return "" end
					return "\n[" .. str:gsub( "\n", "]\n[" ) .. "]"
				end
			elseif buttons.varTooltip then
				local states = buttons.states or { "Train.Buttons.Off", "Train.Buttons.On" }
				local count = #states - 1
				buttons.tooltipState = function( ent ) return Format( "\n[%s]", Metrostroi.GetPhrase( states[ math.floor( buttons.varTooltip( ent ) * count + 0.5 ) + 1 ] ):gsub( "\n", "]\n[" ) ) end
			elseif buttons.var then
				local var = buttons.var
				local st1, st2 = "Train.Buttons.Off", "Train.Buttons.On"
				if buttons.states then
					st1 = buttons.states[ 1 ]
					st2 = buttons.states[ 2 ]
				end

				buttons.tooltipState = function( ent ) return Format( "\n[%s]", Metrostroi.GetPhrase( ent:GetPackedBool( var ) and st2 or st1 ):gsub( "\n", "]\n[" ) ) end
			end

			if buttons.model then
				local config = buttons.model
				local name = config.name or buttons.ID
				if config.tooltipFunc then
					local func = config.tooltipFunc
					buttons.tooltipState = function( ent )
						local str = func( ent )
						if not str then return "" end
						return "\n[" .. str:gsub( "\n", "]\n[" ) .. "]"
					end
				elseif config.varTooltip then
					local states = config.states or { "Train.Buttons.Off", "Train.Buttons.On" }
					local count = #states - 1
					local func = config.getfunc
					if config.varTooltip == true and func then
						buttons.tooltipState = function( ent ) return Format( "\n[%s]", Metrostroi.GetPhrase( states[ math.floor( config.func( ent ) * count + 0.5 ) + 1 ] ):gsub( "\n", "]\n[" ) ) end
					elseif config.varTooltip ~= true then
						buttons.tooltipState = function( ent ) return Format( "\n[%s]", Metrostroi.GetPhrase( states[ math.floor( config.varTooltip( ent ) * count + 0.5 ) + 1 ] ):gsub( "\n", "]\n[" ) ) end
					end
				elseif config.var and ( not config.noTooltip and not buttons.ID:find( "Set" ) or config.noTooltip == false ) then
					local var = config.var
					local st1, st2 = "Train.Buttons.Off", "Train.Buttons.On"
					if config.states then
						st1 = config.states[ 1 ]
						st2 = config.states[ 2 ]
					end

					buttons.tooltipState = function( ent ) return Format( "\n[%s]", Metrostroi.GetPhrase( ent:GetPackedBool( var ) and st2 or st1 ) ) end
				end

				if config.model then
					table.insert( panel.props, name )
					self.ClientProps[ name ] = {
						model = config.model or "models/metrostroi/81-717/button07.mdl",
						pos = UF.PositionFromPanel( id, config.pos or buttons.ID, config.z or 0.2, config.x or 0, config.y or 0 ),
						ang = UF.AngleFromPanel( id, config.ang ),
						color = config.color,
						colora = config.colora,
						skin = config.skin or 0,
						config = config,
						cabin = config.cabin,
						hide = panel.hide or config.hide,
						hideseat = panel.hideseat or config.hideseat,
						bscale = config.bscale,
						scale = config.scale,
					}

					--[[if config.varTooltip then
					local states = config.states or {"Train.Buttons.On","Train.Buttons.Off"}
					local count = (#states-1)
					buttons.tooltipState = function(ent)
						local text = "\n["
						for i,t in ipairs(states) do
							if i == #states then
								text = text..Metrostroi.GetPhrase(t)
							else
								text = text..Metrostroi.GetPhrase(t).."|"
							end
						end
						text = text.."]"
						return text,states[math.floor(config.varTooltip(ent)+0.5)*count+1]
					end
				elseif (config.var and not config.noTooltip) then
					local var = config.var
					local st1,st2 = "Train.Buttons.On","Train.Buttons.Off"
					if config.states then
						st1 = config.states[1]
						st2 = config.states[2]
					end
					buttons.tooltipState = function(ent)
						return Format("\n[%s|%s]",Metrostroi.GetPhrase(st1),Metrostroi.GetPhrase(st2)),ent:GetPackedBool(var) and st1 or st2
					end
				end]]
					if config.var then
						local var = config.var
						local vmin, vmax = config.vmin or 0, config.vmax or 1
						local min, max = config.min or 0, config.max or 1
						local speed, damping, stickyness = config.speed or 16, config.damping or false, config.stickyness or nil
						local func = config.getfunc
						local i
						if func then
							if config.disable then
								i = table.insert( self.AutoAnims, function( ent )
									ent:Animate( name, func( ent, vmin, vmax, var ), min, max, speed, damping, stickyness )
									ent:HideButton( config.disable, ent:GetPackedBool( var ) )
								end )
							elseif config.disableinv then
								i = table.insert( self.AutoAnims, function( ent )
									ent:Animate( name, func( ent, vmin, vmax, var ), min, max, speed, damping, stickyness )
									ent:HideButton( config.disableinv, not ent:GetPackedBool( var ) )
								end )
							elseif config.disableoff and config.disableon then
								i = table.insert( self.AutoAnims, function( ent )
									ent:Animate( name, func( ent, vmin, vmax, var ), min, max, speed, damping, stickyness )
									ent:HideButton( config.disableoff, ent:GetPackedBool( var ) )
									ent:HideButton( config.disableon, not ent:GetPackedBool( var ) )
								end )
							elseif config.disablevar then
								i = table.insert( self.AutoAnims, function( ent )
									ent:HideButton( name, ent:GetPackedBool( config.disablevar ) )
									ent:Animate( name, func( ent, vmin, vmax, var ), min, max, speed, damping, stickyness )
								end )
							else
								i = table.insert( self.AutoAnims, function( ent ) ent:Animate( name, func( ent, vmin, vmax ), min, max, speed, damping, stickyness ) end )
							end
						else
							if config.disable then
								i = table.insert( self.AutoAnims, function( ent )
									ent:Animate( name, ent:GetPackedBool( var ) and vmax or vmin, min, max, speed, damping, stickyness )
									ent:HideButton( config.disable, ent:GetPackedBool( var ) )
								end )
							elseif config.disableinv then
								i = table.insert( self.AutoAnims, function( ent )
									ent:Animate( name, ent:GetPackedBool( var ) and vmax or vmin, min, max, speed, damping, stickyness )
									ent:HideButton( config.disableinv, not ent:GetPackedBool( var ) )
								end )
							elseif config.disableoff and config.disableon then
								i = table.insert( self.AutoAnims, function( ent )
									ent:Animate( name, ent:GetPackedBool( var ) and vmax or vmin, min, max, speed, damping, stickyness )
									ent:HideButton( config.disableoff, ent:GetPackedBool( var ) )
									ent:HideButton( config.disableon, not ent:GetPackedBool( var ) )
								end )
							elseif config.disablevar then
								i = table.insert( self.AutoAnims, function( ent )
									ent:HideButton( name, ent:GetPackedBool( config.disablevar ) )
									ent:Animate( name, ent:GetPackedBool( var ) and vmax or vmin, min, max, speed, damping, stickyness )
								end )
							else
								i = table.insert( self.AutoAnims, function( ent ) ent:Animate( name, ent:GetPackedBool( var ) and vmax or vmin, min, max, speed, damping, stickyness ) end )
							end
						end

						self.AutoAnimNames[ i ] = name
					end
				end

				if config.sound or config.sndvol and config.var then
					local id = config.sound or config.var
					local sndid = config.sndid or buttons.ID
					local vol, pitch, min, max = config.sndvol, config.sndpitch, config.sndmin, config.sndmax
					local func, snd = config.getfunc, config.snd
					local vmin, vmax = config.vmin or 0, config.vmax or 1
					local var = config.var
					local ang = config.sndang
					--if func then
					--self.ClientSounds[id] = {sndid,function(ent,var) return snd(func(ent,vmin,vmax),var) end,vol or 1,pitch or 1,min or 100,max or 1000,ang or Angle(0,0,0)}
					--else
					if not self.ClientSounds[ id ] then self.ClientSounds[ id ] = {} end
					table.insert( self.ClientSounds[ id ], { sndid, function( ent, var ) return snd( var > 0, var ) end, vol or 1, pitch or 1, min or 100, max or 1000, ang or Angle( 0, 0, 0 ) } )
					--end
				end

				if config.plomb then
					local pconfig = config.plomb
					local pname = name .. "_pl"
					if pconfig.model then
						table.insert( panel.props, pname )
						self.ClientProps[ pname ] = {
							model = pconfig.model,
							pos = UF.PositionFromPanel( id, config.pos or buttons.ID, ( config.z or 0.2 ) + ( pconfig.z or 0.2 ), ( config.x or 0 ) + ( pconfig.x or 0 ), ( config.y or 0 ) + ( pconfig.y or 0 ) ),
							ang = UF.AngleFromPanel( id, pconfig.ang or config.ang ),
							color = pconfig.color or pconfig.color,
							skin = pconfig.skin or config.skin or 0,
							config = pconfig,
							cabin = pconfig.cabin,
							hide = panel.hide or config.hide,
							hideseat = panel.hideseat or config.hideseat,
							bscale = pconfig.bscale or config.bscale,
							scale = pconfig.scale or config.scale,
						}
					end

					if pconfig.var then
						local var = pconfig.var
						if pconfig.model then
							local i = table.insert( self.AutoAnims, function( ent ) ent:SetCSBodygroup( pname, 1, ent:GetPackedBool( var ) and 0 or 1 ) end )
							self.AutoAnimNames[ i ] = pname
						end

						local id, tooltip = buttons.ID, buttons.tooltip
						local pid, ptooltip = pconfig.ID, pconfig.tooltip
						buttons.plombed = function( ent )
							if ent:GetPackedBool( var ) then
								return Format( "%s\n%s", buttons.tooltip, Metrostroi.GetPhrase( "Train.Buttons.Sealed" ) or "Plombed" ), pid, Color( 255, 150, 150 ), true
							else
								return buttons.tooltip, id, false
							end
						end
					end
				end

				if config.lamp then
					local lconfig = config.lamp
					local lname = name .. "_lamp"
					table.insert( panel.props, lname )
					self.ClientProps[ lname ] = {
						model = lconfig.model or "models/metrostroi/81-717/button07.mdl",
						pos = UF.PositionFromPanel( id, config.pos or buttons.ID, ( config.z or 0.2 ) + ( lconfig.z or 0.2 ), ( config.x or 0 ) + ( lconfig.x or 0 ), ( config.y or 0 ) + ( lconfig.y or 0 ) ),
						ang = UF.AngleFromPanel( id, lconfig.ang or config.ang ),
						color = lconfig.color or config.color,
						skin = lconfig.skin or config.skin or 0,
						config = lconfig,
						cabin = lconfig.cabin,
						igrorepanel = true,
						hide = panel.hide or config.hide,
						hideseat = panel.hideseat or config.hideseat,
						bscale = lconfig.bscale or config.bscale,
						scale = lconfig.scale or config.scale,
					}

					if lconfig.anim then
						local i = table.insert( self.AutoAnims, function( ent ) ent:AnimateFrom( lname, name ) end )
						self.AutoAnimNames[ i ] = lname
					end

					if lconfig.lcolor then
						self.Lights[ lname ] = {
							"headlight",
							UF.PositionFromPanel( id, config.pos or buttons.ID, ( config.z or 0.2 ) + ( lconfig.z or 0.2 ) + ( lconfig.lz or 0.2 ), ( config.x or 0 ) + ( lconfig.x or 0 ) + ( lconfig.lx or 0 ), ( config.y or 0 ) + ( lconfig.y or 0 ) + ( lconfig.ly or 0 ) ),
							UF.AngleFromPanel( id, lconfig.lang or lconfig.ang or config.ang ) + Angle( 90, 0, 0 ),
							lconfig.lcolor,
							farz = lconfig.lfar or 8,
							nearz = lconfig.lnear or 1,
							shadows = lconfig.lshadows or 1,
							brightness = lconfig.lbright or 1,
							fov = lconfig.lfov,
							texture = lconfig.ltex or "effects/flashlight/soft",
							panellight = true,
							hidden = lname,
						}
						--[[self.ClientProps[lname.."TEST"] = {
				model = "models/metrostroi_train/81-703/cabin_cran_334.mdl",
				pos = UF.PositionFromPanel(id,config.pos or buttons.ID,(config.z or 0.2)+(lconfig.z or 0.2)+(lconfig.lz or 0.2),(config.x or 0)+(lconfig.x or 0)+(lconfig.lx or 0),(config.y or 0)+(lconfig.y or 0)+(lconfig.ly or 0)),
				ang = UF.AngleFromPanel(id,lconfig.lang or lconfig.ang or config.ang)+Angle(-180,180,0),
				scale=0.1,
			}]]
						--[[table.insert(self.AutoAnims, function(ent)
			ent:AnimateFrom(lname,name)
		end)]]
					end

					if lconfig.var then
						--ret=ret.."\""..lconfig.var.."\","
						--reti = reti + 1
						local var, animvar = lconfig.var, lname .. "_anim"
						local min, max = lconfig.min or 0, lconfig.max or 1
						local speed = lconfig.speed or 10
						local func = lconfig.getfunc
						local light = lconfig.lcolor
						if func then
							table.insert( self.AutoAnims, function( ent )
								local val = ent:Animate( animvar, func( ent, min, max, var ), 0, 1, speed, false )
								ent:ShowHideSmooth( lname, val )
								if light then ent:SetLightPower( lname, val > 0, val ) end
							end )
						else
							local i = table.insert( self.AutoAnims, function( ent )
								--print(lname,ent.SmoothHide[lname])
								local val = ent:Animate( animvar, ent:GetPackedBool( var ) and max or min, 0, 1, speed, false )
								ent:ShowHideSmooth( lname, val )
								if light then ent:SetLightPower( lname, val > 0, val ) end
							end )
						end
					end
				end

				if config.lamps then
					for k, lconfig in ipairs( config.lamps ) do
						local lname = name .. "_lamp" .. k
						table.insert( panel.props, lname )
						self.ClientProps[ lname ] = {
							model = lconfig.model or "models/metrostroi/81-717/button07.mdl",
							pos = UF.PositionFromPanel( id, config.pos or buttons.ID, ( config.z or 0.2 ) + ( lconfig.z or 0.2 ), ( config.x or 0 ) + ( lconfig.x or 0 ), ( config.y or 0 ) + ( lconfig.y or 0 ) ),
							ang = UF.AngleFromPanel( id, lconfig.ang or config.ang ),
							color = lconfig.color or config.color,
							skin = lconfig.skin or config.skin or 0,
							config = lconfig,
							cabin = lconfig.cabin,
							igrorepanel = true,
							hide = panel.hide or config.hide,
							hideseat = panel.hideseat or config.hideseat,
							bscale = lconfig.bscale or config.bscale,
							scale = lconfig.scale or config.scale,
						}

						if lconfig.var then
							--ret=ret.."\""..lconfig.var.."\","
							--reti = reti + 1
							local var, animvar = lconfig.var, lname .. "_anim"
							local min, max = lconfig.min or 0, lconfig.max or 1
							local speed = lconfig.speed or 10
							local func = lconfig.getfunc
							if func then
								table.insert( self.AutoAnims, function( ent )
									local val = ent:Animate( animvar, func( ent, min, max, var ), 0, 1, speed, false )
									ent:ShowHideSmooth( lname, val )
								end )
							else
								table.insert( self.AutoAnims, function( ent )
									--print(lname,ent.SmoothHide[lname])
									local val = ent:Animate( animvar, ent:GetPackedBool( var ) and max or min, 0, 1, speed, false )
									ent:ShowHideSmooth( lname, val )
								end )
							end
						end
					end
				end

				if config.sprite then
					local sconfig = config.sprite
					local hideName = sconfig.hidden or config.lamp and name .. "_lamp" or name
					self.Lights[ sconfig.lamp or name ] = {
						sconfig.glow and "glow" or "light",
						UF.PositionFromPanel( id, config.pos or buttons.ID, ( config.z or 0.5 ) + ( sconfig.z or 0.2 ), ( config.x or 0 ) + ( sconfig.x or 0 ), ( config.y or 0 ) + ( sconfig.y or 0 ) ),
						UF.AngleFromPanel( id, sconfig.ang or config.ang ) + Angle( 90, 0, 0 ),
						sconfig.color or sconfig.color,
						brightness = sconfig.bright,
						texture = sconfig.texture or "sprites/light_glow02",
						scale = sconfig.scale or 0.02,
						vscale = sconfig.vscale,
						size = sconfig.size,
						hidden = hideName,
						aa = sconfig.aa,
						panel = sconfig.panel ~= false,
					}

					local i
					if sconfig.getfunc then
						local func = sconfig.getfunc
						i = table.insert( self.AutoAnims, function( ent )
							local val = func( ent )
							ent:SetLightPower( name, not ent.Hidden[ hideName ] and val > 0, val )
						end )
					elseif sconfig.var then
						--ret=ret.."\""..lconfig.var.."\","
						--reti = reti + 1
						local var, animvar = sconfig.var, name .. "_sanim"
						local speed = sconfig.speed or 10
						i = table.insert( self.AutoAnims, function( ent )
							local val = ent:Animate( animvar, ent:GetPackedBool( var ) and 1 or 0, 0, 1, speed, false )
							ent:SetLightPower( name, val > 0, val )
						end )
					elseif sconfig.lamp then
						local lightName = sconfig.lamp
						i = table.insert( self.AutoAnims, function( ent )
							local val = ent.Anims[ lightName ] and ent.Anims[ lightName ].value or 0
							ent:SetLightPower( lightName, val > 0, val )
						end )
					elseif config.lamp and config.lamp.var then
						local lname = name .. "_lamp"
						local lightName = lname .. "_anim"
						i = table.insert( self.AutoAnims, function( ent )
							local val = ent.Anims[ lightName ] and ent.Anims[ lightName ].value or 0
							ent:SetLightPower( name, val > 0, val )
						end )
					end

					if not i then
						ErrorNoHalt( "Bad sprite " .. name .. "/" .. hideName .. ", no controlable function...\n" )
					else
						self.AutoAnimNames[ i ] = hideName
					end
				end

				if config.labels then
					for k, aconfig in ipairs( config.labels ) do
						local aname = name .. "_label" .. k
						table.insert( panel.props, aname )
						self.ClientProps[ aname ] = {
							model = aconfig.model or "models/metrostroi/81-717/button07.mdl",
							pos = UF.PositionFromPanel( id, config.pos or buttons.ID, ( config.z or 0.2 ) + ( aconfig.z or 0.2 ), ( config.x or 0 ) + ( aconfig.x or 0 ), ( config.y or 0 ) + ( aconfig.y or 0 ) ),
							ang = UF.AngleFromPanel( id, aconfig.ang or config.ang ),
							color = aconfig.color or config.color,
							colora = aconfig.colora or config.colora,
							skin = aconfig.skin or config.skin or 0,
							config = aconfig,
							cabin = aconfig.cabin,
							igrorepanel = true,
							hide = panel.hide or config.hide,
							hideseat = panel.hideseat or config.hideseat,
							bscale = aconfig.bscale or config.bscale,
							scale = aconfig.scale or config.scale,
						}
					end
				end

				buttons.model = nil
			end
		end
	end

	for k, v in pairs( self.ClientProps ) do
		if not v.model then continue end
		UF.PrecacheModels[ v.model ] = true
	end

	for k, v in pairs( self.Lights or {} ) do
		if not v.hidden then continue end
		local cP = self.ClientProps[ v.hidden ]
		if not cP then
			ErrorNoHalt( "No clientProp " .. v.hidden .. " in entity " .. self.Folder .. "\n" )
			continue
		end

		if not cP.lamps then cP.lamps = {} end
		table.insert( cP.lamps, k )
	end
	--ret = ret.."\n}"
	--SetClipboardText(ret)
end

UF.SpriteCache1 = UF.SpriteCache1 or {}
UF.SpriteCache2 = UF.SpriteCache2 or {}
function UF.MakeSpriteTexture( path, isSprite )
	if isSprite then
		if UF.SpriteCache1[ path ] then return UF.SpriteCache1[ path ] end
		matSprite[ "$basetexture" ] = path
		UF.SpriteCache1[ path ] = CreateMaterial( path .. ":sprite", "Sprite", matSprite )
		return UF.SpriteCache1[ path ]
	else
		if UF.SpriteCache1[ path ] then return UF.SpriteCache1[ path ] end
		matUnlit[ "$basetexture" ] = path
		UF.SpriteCache2[ path ] = CreateMaterial( path .. ":spriteug", "UnlitGeneric", matUnlit )
		return UF.SpriteCache2[ path ]
	end
end

-- format: multiline
UF.charMatrixSmallThin = {
	-- format: multiline
	[ "EMPTY" ] = {
		"0",
		"0",
		"0",
		"0",
		"0",
		"0",
		"0",
	},
	[ " " ] = {
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
	},
	[ "	" ] = {
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
	},
	[ "A" ] = {
		"01110",
		"10001",
		"10001",
		"11111",
		"10001",
		"10001",
		"10001"
	},
	[ "B" ] = {
		"11110",
		"10001",
		"10001",
		"11110",
		"10001",
		"10001",
		"11110"
	},
	[ "C" ] = {
		"01110",
		"10001",
		"10000",
		"10000",
		"10000",
		"10001",
		"01110"
	},
	[ "D" ] = {
		"11110",
		"10001",
		"10001",
		"10001",
		"10001",
		"10001",
		"11110"
	},
	[ "E" ] = {
		"11111",
		"10000",
		"10000",
		"11110",
		"10000",
		"10000",
		"11111"
	},
	[ "F" ] = {
		"11111",
		"10000",
		"10000",
		"11110",
		"10000",
		"10000",
		"10000"
	},
	[ "G" ] = {
		"01110",
		"10000",
		"10000",
		"10011",
		"10001",
		"10001",
		"01111"
	},
	[ "H" ] = {
		"10001",
		"10001",
		"10001",
		"11111",
		"10001",
		"10001",
		"10001"
	},
	[ "I" ] = {
		"11111",
		"00100",
		"00100",
		"00100",
		"00100",
		"00100",
		"11111"
	},
	[ "J" ] = {
		"00011",
		"00011",
		"00011",
		"00011",
		"00011",
		"10011",
		"01110"
	},
	[ "K" ] = {
		"10001",
		"10010",
		"10010",
		"11100",
		"11100",
		"10110",
		"10011"
	},
	[ "L" ] = {
		"1000",
		"1000",
		"1000",
		"1000",
		"1000",
		"1000",
		"1111"
	},
	[ "M" ] = {
		"10001",
		"11011",
		"10101",
		"10001",
		"10001",
		"10001",
		"10001"
	},
	[ "N" ] = {
		"10001",
		"11001",
		"10111",
		"10011",
		"10001",
		"10001",
		"10001"
	},
	[ "O" ] = {
		"01110",
		"10001",
		"10001",
		"10001",
		"10001",
		"10001",
		"01110"
	},
	[ "P" ] = {
		"11110",
		"10001",
		"10001",
		"11110",
		"10000",
		"10000",
		"10000"
	},
	[ "Q" ] = {
		"01110",
		"10001",
		"10001",
		"10001",
		"10101",
		"10011",
		"01110",
	},
	[ "R" ] = {
		"11110",
		"10001",
		"10001",
		"11110",
		"10010",
		"10001",
		"10001"
	},
	[ "S" ] = {
		"01111",
		"10000",
		"10000",
		"01110",
		"00001",
		"00001",
		"11110"
	},
	[ "T" ] = {
		"11111",
		"00100",
		"00100",
		"00100",
		"00100",
		"00100",
		"00100"
	},
	[ "U" ] = {
		"10001",
		"10001",
		"10001",
		"10001",
		"10001",
		"10001",
		"01110"
	},
	[ "V" ] = {
		"10001",
		"10001",
		"10001",
		"10001",
		"10001",
		"01010",
		"00100"
	},
	[ "W" ] = {
		"10001",
		"10001",
		"10001",
		"10001",
		"10101",
		"11011",
		"10001"
	},
	[ "X" ] = {
		"10001",
		"10001",
		"01010",
		"00100",
		"01010",
		"10001",
		"10001"
	},
	[ "Y" ] = {
		"10001",
		"10001",
		"01010",
		"00100",
		"00100",
		"00100",
		"00100"
	},
	[ "Z" ] = {
		"1111",
		"0001",
		"0001",
		"0010",
		"0100",
		"1000",
		"1111"
	},
	[ "0" ] = {
		"01110",
		"10001",
		"10011",
		"10101",
		"01110"
	},
	[ "1" ] = {
		"00100",
		"01100",
		"00100",
		"00100",
		"00100",
		"00100",
		"11111"
	},
	[ "2" ] = {
		"11110",
		"00001",
		"01110",
		"10000",
		"11111"
	},
	[ "3" ] = {
		"11111",
		"00001",
		"00110",
		"00001",
		"11111"
	},
	[ "4" ] = {
		"00110",
		"01010",
		"11111",
		"00010",
		"00010"
	},
	[ "5" ] = {
		"11111",
		"10000",
		"10000",
		"11110",
		"00001",
		"00001",
		"11110"
	},
	[ "6" ] = {
		"01110",
		"10000",
		"10000",
		"11110",
		"10001",
		"10001",
		"01110"
	},
	[ "7" ] = {
		"11111",
		"00001",
		"00010",
		"00100",
		"01000"
	},
	[ "8" ] = {
		"01110",
		"10001",
		"01110",
		"10001",
		"01110"
	},
	[ "9" ] = {
		"01110",
		"10001",
		"01111",
		"00001",
		"01110"
	},
	[ "Ä" ] = {
		"10101",
		"10001",
		"11111",
		"10001",
		"10001"
	},
	[ "Ö" ] = {
		"01110",
		"10001",
		"10001",
		"10001",
		"01110"
	},
	[ "Ü" ] = {
		"10001",
		"10001",
		"10001",
		"10001",
		"01110"
	},
	[ "a" ] = {
		"00000",
		"00000",
		"01110",
		"00001",
		"01111",
		"10001",
		"01111"
	},
	[ "b" ] = {
		"10000",
		"10000",
		"10110",
		"11001",
		"10001",
		"10001",
		"11110"
	},
	[ "c" ] = {
		"00000",
		"00000",
		"01110",
		"10001",
		"10000",
		"10001",
		"01110"
	},
	[ "d" ] = {
		"0001",
		"0001",
		"0111",
		"1001",
		"1001",
		"1001",
		"0111"
	},
	[ "e" ] = {
		"00000",
		"00000",
		"01110",
		"10001",
		"11111",
		"10000",
		"01110"
	},
	[ "f" ] = {
		"0011",
		"0100",
		"1111",
		"0100",
		"0100",
		"0100",
		"0100",
		"0100",
		"0100"
	},
	[ "g" ] = {
		"00000",
		"00000",
		"01111",
		"10001",
		"10001",
		"10001",
		"01111",
		"00001",
		"01110"
	},
	[ "h" ] = {
		"10000",
		"10000",
		"11110",
		"11001",
		"10001",
		"10001",
		"10001"
	},
	[ "i" ] = {
		"00100",
		"00000",
		"01100",
		"00100",
		"00100",
		"00100",
		"01110"
	},
	[ "j" ] = {
		"00001",
		"00000",
		"00001",
		"00001",
		"00001",
		"10001",
		"01110"
	},
	[ "k" ] = {
		"10000",
		"10010",
		"11100",
		"11000",
		"11100",
		"10010",
		"10001"
	},
	[ "l" ] = {
		"01100",
		"00100",
		"00100",
		"00100",
		"00100",
		"00100",
		"01110"
	},
	[ "m" ] = {
		"0000000",
		"0000000",
		"1011011",
		"1101101",
		"1001001",
		"1001001",
		"1001001",
	},
	[ "n" ] = {
		"00000",
		"00000",
		"10110",
		"11001",
		"10001",
		"10001",
		"10001"
	},
	[ "o" ] = {
		"00000",
		"00000",
		"01110",
		"10001",
		"10001",
		"10001",
		"01110"
	},
	[ "p" ] = {
		"00000",
		"00000",
		"11110",
		"10001",
		"10001",
		"11110",
		"10000",
		"10000",
		"10000",
	},
	[ "q" ] = {
		"00000",
		"00000",
		"01111",
		"10001",
		"10001",
		"01111",
		"00001",
		"00001",
		"00001",
	},
	[ "r" ] = {
		"00000",
		"00000",
		"10110",
		"11000",
		"10000",
		"10000",
		"10000"
	},
	[ "s" ] = {
		"0000",
		"0000",
		"0111",
		"1000",
		"0110",
		"0001",
		"1110",
	},
	[ "t" ] = {
		"01000",
		"01000",
		"11100",
		"01000",
		"01000",
		"01000",
		"00110"
	},
	[ "u" ] = {
		"00000",
		"00000",
		"10001",
		"10001",
		"10001",
		"10001",
		"01110"
	},
	[ "v" ] = {
		"00000",
		"00000",
		"10001",
		"10001",
		"10001",
		"01010",
		"00100"
	},
	[ "w" ] = {
		"00000",
		"00000",
		"10001",
		"10001",
		"10001",
		"10101",
		"01010"
	},
	[ "x" ] = {
		"00000",
		"00000",
		"10001",
		"01010",
		"00100",
		"01010",
		"10001",
	},
	[ "y" ] = {
		"00000",
		"00000",
		"10001",
		"10001",
		"10001",
		"10001",
		"01111",
		"00001",
		"01110"
	},
	[ "z" ] = {
		"00000",
		"00000",
		"11111",
		"00110",
		"01100",
		"11000",
		"11111"
	},
	[ "ä" ] = {
		"01010",
		"00000",
		"01110",
		"10001",
		"01110"
	},
	[ "ö" ] = {
		"01110",
		"10001",
		"10001",
		"10001",
		"01110"
	},
	[ "ü" ] = {
		"10001",
		"10001",
		"10001",
		"10001",
		"01110"
	},
	[ ":" ] = {
		"00000",
		"00100",
		"00000",
		"00100",
		"00000"
	},
	[ "/" ] = {
		"00001",
		"00010",
		"00100",
		"01000",
		"10000"
	},
	[ "\\" ] = {
		"10000",
		"01000",
		"00100",
		"00010",
		"00001"
	},
	[ "?" ] = {
		"01110",
		"10001",
		"00110",
		"00000",
		"00100"
	},
	[ "!" ] = {
		"00100",
		"00100",
		"00100",
		"00100",
		"00100",
		"00000",
		"00100"
	},
	[ " " ] = {
		"0000",
		"0000",
		"0000",
		"0000",
		"0000",
		"0000"
	},
}

-- format: multiline
UF.charMatrixSmallBold = {
	-- format: multiline
	[ "EMPTY" ] = {
		"0",
		"0",
		"0",
		"0",
		"0",
		"0",
		"0",
	},
	[ " " ] = {
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
	},
	[ "	" ] = {
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
	},
	[ "0" ] = {
		"001100",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"001100",
	},
	[ "1" ] = {
		"001100",
		"011100",
		"111100",
		"001100",
		"001100",
		"001100",
		"111111",
	},
	[ "2" ] = {
		"011110",
		"110011",
		"000111",
		"000110",
		"001100",
		"011000",
		"111111",
	},
	[ "3" ] = {
		"011110",
		"100011",
		"000011",
		"000110",
		"000011",
		"100011",
		"011110",
	},
	[ "4" ] = {
		"000110",
		"001110",
		"010110",
		"101110",
		"111111",
		"000110",
		"000110",
	},
	[ "A" ] = {
		"011110",
		"110011",
		"110011",
		"111111",
		"111111",
		"110011",
		"110011"
	},
	[ "B" ] = {
		"000000",
		"111110",
		"110011",
		"110011",
		"111110",
		"110011",
		"110011",
		"111110"
	},
	[ "C" ] = {
		"011110",
		"110001",
		"110000",
		"110000",
		"110000",
		"110001",
		"011110"
	},
	[ "D" ] = {
		"011110",
		"110001",
		"110001",
		"110001",
		"110001",
		"110001",
		"011110"
	},
	[ "E" ] = {
		"111110",
		"110000",
		"110000",
		"111100",
		"110000",
		"110000",
		"111110"
	},
	[ "F" ] = {
		"111110",
		"110000",
		"110000",
		"111100",
		"110000",
		"110000",
		"110000"
	},
	[ "G" ] = {
		"011110",
		"110000",
		"110000",
		"110110",
		"110111",
		"110011",
		"111111",
		"011110"
	},
	[ "H" ] = {
		"110011",
		"110011",
		"111111",
		"111111",
		"110011",
		"110011",
		"110011",
	},
	[ "I" ] = {
		"111111",
		"001100",
		"001100",
		"001100",
		"001100",
		"001100",
		"111111",
	},
	[ "J" ] = {
		"111111",
		"000110",
		"000110",
		"000110",
		"000110",
		"101110",
		"111100",
	},
	[ "K" ] = {
		"1100011",
		"1100110",
		"1111100",
		"1110000",
		"1111100",
		"1100110",
		"1100011",
	},
	[ "L" ] = {
		"1100000",
		"1100000",
		"1100000",
		"1100000",
		"1100000",
		"1111110",
		"1111111",
	},
	[ "M" ] = {
		"1100011",
		"1110111",
		"1111111",
		"1101011",
		"1100011",
		"1100011",
		"1100011"
	},
	[ "N" ] = {
		"1100011",
		"1110011",
		"1111011",
		"1101111",
		"1101111",
		"1100111",
		"1100011"
	},
	[ "O" ] = {
		"0111110",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"0111110"
	},
	[ "P" ] = {
		"1111110",
		"1100011",
		"1100011",
		"1111110",
		"1100000",
		"1100000",
		"1100000"
	},
	[ "Q" ] = {
		"0111110",
		"1100011",
		"1100011",
		"1100011",
		"1101011",
		"1100111",
		"0111010"
	},
	[ "R" ] = {
		"1111110",
		"1100011",
		"1100011",
		"1111110",
		"1101110",
		"1100111",
		"1100011"
	},
	[ "S" ] = {
		"0111110",
		"1111111",
		"1100000",
		"1111110",
		"0111111",
		"0000111",
		"0111110",
	},
	[ "T" ] = {
		"1111111",
		"1111111",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
	},
	[ "U" ] = {
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"111111",
		"011110",
	},
	[ "V" ] = {
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"011110",
		"001100",
	},
	[ "W" ] = {
		"1100011",
		"1100011",
		"1100011",
		"1101011",
		"1101011",
		"1111111",
		"0111110",
		"0010100",
	},
	[ "X" ] = {
		"1100011",
		"1110111",
		"0011100",
		"0001000",
		"0011100",
		"1110111",
		"1100011",
	},
	[ "Y" ] = {
		"1100011",
		"1110111",
		"0011100",
		"0011100",
		"0001000",
		"0001000",
		"0001000",
	},
	[ "Z" ] = {
		"1111111",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "a" ] = {
		"000000",
		"011110",
		"110011",
		"000011",
		"001111",
		"110011",
		"110011",
		"111111",
		"011111",
	},
	[ "b" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "c" ] = {
		"000000",
		"000000",
		"011110",
		"110011",
		"110000",
		"110000",
		"110011",
		"011110",
	},
	[ "d" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "e" ] = {
		"000000",
		"000000",
		"011110",
		"110011",
		"110011",
		"111110",
		"110000",
		"011110",
	},
	[ "f" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "g" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "h" ] = {
		"110000",
		"110000",
		"110000",
		"111110",
		"110011",
		"110011",
		"110011",
		"110011",
	},
	[ "i" ] = {
		"11",
		"11",
		"00",
		"11",
		"11",
		"11",
		"11",
		"11",
	},
	[ "j" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "k" ] = {
		"1100000",
		"1100000",
		"1100110",
		"1101100",
		"1111000",
		"1100110",
		"1100110",
		"1100011",
	},
	[ "l" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "m" ] = {
		"00000000000",
		"11000000000",
		"11011001110",
		"11111011111",
		"11001100011",
		"11001100011",
		"11001100011",
		"11001100011",
	},
	[ "n" ] = {
		"000000",
		"000000",
		"110000",
		"111110",
		"110011",
		"110011",
		"110011",
		"110011",
	},
	[ "o" ] = {
		"0000000",
		"0000000",
		"0111110",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"0111110",
	},
	[ "p" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "q" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "r" ] = {
		"000000",
		"110000",
		"110011",
		"110111",
		"111100",
		"110000",
		"110000",
		"110000",
	},
	[ "s" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "t" ] = {
		"001100",
		"001100",
		"111111",
		"001100",
		"001100",
		"001100",
		"001110",
		"000111",
	},
	[ "/" ] = {
		"0000011",
		"0000110",
		"0001100",
		"0011000",
		"0110000",
		"1100000",
		"1100000",
	},
	[ "\\" ] = {
		"1100000",
		"0110000",
		"0011000",
		"0001100",
		"0000110",
		"0000011",
		"0000011",
	},
	[ "!" ] = {
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0000000",
		"0011100",
		"0011100",
	},
	[ "?" ] = {
		"1111110",
		"0000011",
		"0000111",
		"0011100",
		"0000000",
		"0011100",
		"0011100",
	},
	[ "(" ] = {
		"0011110",
		"1000011",
		"1000000",
		"1000000",
		"1000000",
		"1000001",
		"0011111",
	},
}

-- format: multiline
UF.charMatrixSmallBold = {
	[ "EMPTY" ] = {
		"0",
		"0",
		"0",
		"0",
		"0",
		"0",
		"0",
	},
	[ " " ] = {
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
		"00",
	},
	[ "	" ] = {
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
	},
	[ "0" ] = {
		"001100",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"001100",
	},
	[ "1" ] = {
		"001100",
		"011100",
		"111100",
		"001100",
		"001100",
		"001100",
		"111111",
	},
	[ "2" ] = {
		"011110",
		"110011",
		"000111",
		"000110",
		"001100",
		"011000",
		"111111",
	},
	[ "3" ] = {
		"011110",
		"100011",
		"000011",
		"000110",
		"000011",
		"100011",
		"011110",
	},
	[ "4" ] = {
		"000110",
		"001110",
		"010110",
		"101110",
		"111111",
		"000110",
		"000110",
	},
	[ "A" ] = {
		"011110",
		"110011",
		"110011",
		"111111",
		"111111",
		"110011",
		"110011"
	},
	[ "B" ] = {
		"000000",
		"111110",
		"110011",
		"110011",
		"111110",
		"110011",
		"110011",
		"111110"
	},
	[ "C" ] = {
		"011110",
		"110001",
		"110000",
		"110000",
		"110000",
		"110001",
		"011110"
	},
	[ "D" ] = {
		"011110",
		"110001",
		"110001",
		"110001",
		"110001",
		"110001",
		"011110"
	},
	[ "E" ] = {
		"111110",
		"110000",
		"110000",
		"111100",
		"110000",
		"110000",
		"111110"
	},
	[ "F" ] = {
		"111110",
		"110000",
		"110000",
		"111100",
		"110000",
		"110000",
		"110000"
	},
	[ "G" ] = {
		"011110",
		"110000",
		"110000",
		"110110",
		"110111",
		"110011",
		"111111",
		"011110"
	},
	[ "H" ] = {
		"110011",
		"110011",
		"111111",
		"111111",
		"110011",
		"110011",
		"110011",
	},
	[ "I" ] = {
		"111111",
		"001100",
		"001100",
		"001100",
		"001100",
		"001100",
		"111111",
	},
	[ "J" ] = {
		"111111",
		"000110",
		"000110",
		"000110",
		"000110",
		"101110",
		"111100",
	},
	[ "K" ] = {
		"1100011",
		"1100110",
		"1111100",
		"1110000",
		"1111100",
		"1100110",
		"1100011",
	},
	[ "L" ] = {
		"1100000",
		"1100000",
		"1100000",
		"1100000",
		"1100000",
		"1111110",
		"1111111",
	},
	[ "M" ] = {
		"1100011",
		"1110111",
		"1111111",
		"1101011",
		"1100011",
		"1100011",
		"1100011"
	},
	[ "N" ] = {
		"1100011",
		"1110011",
		"1111011",
		"1101111",
		"1101111",
		"1100111",
		"1100011"
	},
	[ "O" ] = {
		"0111110",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"0111110"
	},
	[ "P" ] = {
		"1111110",
		"1100011",
		"1100011",
		"1111110",
		"1100000",
		"1100000",
		"1100000"
	},
	[ "Q" ] = {
		"0111110",
		"1100011",
		"1100011",
		"1100011",
		"1101011",
		"1100111",
		"0111010"
	},
	[ "R" ] = {
		"1111110",
		"1100011",
		"1100011",
		"1111110",
		"1101110",
		"1100111",
		"1100011"
	},
	[ "S" ] = {
		"0111110",
		"1111111",
		"1100000",
		"1111110",
		"0111111",
		"0000111",
		"0111110",
	},
	[ "T" ] = {
		"1111111",
		"1111111",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
	},
	[ "U" ] = {
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"111111",
		"011110",
	},
	[ "V" ] = {
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"011110",
		"001100",
	},
	[ "W" ] = {
		"1100011",
		"1100011",
		"1100011",
		"1101011",
		"1101011",
		"1111111",
		"0111110",
		"0010100",
	},
	[ "X" ] = {
		"1100011",
		"1110111",
		"0011100",
		"0001000",
		"0011100",
		"1110111",
		"1100011",
	},
	[ "Y" ] = {
		"1100011",
		"1110111",
		"0011100",
		"0011100",
		"0001000",
		"0001000",
		"0001000",
	},
	[ "Z" ] = {
		"1111111",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "a" ] = {
		"000000",
		"011110",
		"110011",
		"000011",
		"001111",
		"110011",
		"110011",
		"111111",
		"011111",
	},
	[ "b" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "c" ] = {
		"000000",
		"000000",
		"011110",
		"110011",
		"110000",
		"110000",
		"110011",
		"011110",
	},
	[ "d" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "e" ] = {
		"000000",
		"000000",
		"011110",
		"110011",
		"110011",
		"111110",
		"110000",
		"011110",
	},
	[ "f" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "g" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "h" ] = {
		"110000",
		"110000",
		"110000",
		"111110",
		"110011",
		"110011",
		"110011",
		"110011",
	},
	[ "i" ] = {
		"11",
		"11",
		"00",
		"11",
		"11",
		"11",
		"11",
		"11",
	},
	[ "j" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "k" ] = {
		"1100000",
		"1100000",
		"1100110",
		"1101100",
		"1111000",
		"1100110",
		"1100110",
		"1100011",
	},
	[ "l" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "m" ] = {
		"00000000000",
		"11000000000",
		"11011001110",
		"11111011111",
		"11001100011",
		"11001100011",
		"11001100011",
		"11001100011",
	},
	[ "n" ] = {
		"000000",
		"000000",
		"110000",
		"111110",
		"110011",
		"110011",
		"110011",
		"110011",
	},
	[ "o" ] = {
		"0000000",
		"0000000",
		"0111110",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"0111110",
	},
	[ "p" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "q" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "r" ] = {
		"000000",
		"110000",
		"110011",
		"110111",
		"111100",
		"110000",
		"110000",
		"110000",
	},
	[ "s" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "t" ] = {
		"001100",
		"001100",
		"111111",
		"001100",
		"001100",
		"001100",
		"001110",
		"000111",
	},
	[ "/" ] = {
		"0000011",
		"0000110",
		"0001100",
		"0011000",
		"0110000",
		"1100000",
		"1100000",
	},
	[ "\\" ] = {
		"1100000",
		"0110000",
		"0011000",
		"0001100",
		"0000110",
		"0000011",
		"0000011",
	},
	[ "!" ] = {
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0000000",
		"0011100",
		"0011100",
	},
	[ "?" ] = {
		"1111110",
		"0000011",
		"0000111",
		"0011100",
		"0000000",
		"0011100",
		"0011100",
	},
	[ "(" ] = {
		"0011110",
		"1000011",
		"1000000",
		"1000000",
		"1000000",
		"1000001",
		"0011111",
	},
}

-- format: multiline
UF.charMatrixHeadline = {
	[ "EMPTY" ] = {
		"0",
		"0",
		"0",
		"0",
		"0",
		"0",
		"0",
	},
	[ "SPACE" ] = {
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
	},
	[ "0" ] = {
		"001100",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"001100",
	},
	[ "1" ] = {
		"001100",
		"011100",
		"111100",
		"001100",
		"001100",
		"001100",
		"001100",
		"111111",
		"111111",
	},
	[ "2" ] = {
		"0111110",
		"1100011",
		"0000011",
		"0000110",
		"0001100",
		"0011000",
		"0111111",
		"11111111",
		"11111111",
	},
	[ "3" ] = {
		"011110",
		"111111",
		"100011",
		"000011",
		"000110",
		"000011",
		"100011",
		"111111",
		"011110",
	},
	[ "4" ] = {
		"000110",
		"001110",
		"011110",
		"110110",
		"100110",
		"111111",
		"111111",
		"000110",
		"000110",
	},
	[ "A" ] = {
		"011110",
		"110011",
		"110011",
		"111111",
		"111111",
		"110011",
		"110011",
		"110011",
		"110011"
	},
	[ "B" ] = {
		"111110",
		"110011",
		"110011",
		"110011",
		"111110",
		"110011",
		"110011",
		"110011",
		"111110"
	},
	[ "C" ] = {
		"011110",
		"110001",
		"110000",
		"110000",
		"110000",
		"110000",
		"110000",
		"110001",
		"011110"
	},
	[ "D" ] = {
		"111100",
		"110010",
		"110001",
		"110001",
		"110001",
		"110001",
		"110001",
		"110010",
		"111100"
	},
	[ "E" ] = {
		"111110",
		"110000",
		"110000",
		"110000",
		"111100",
		"110000",
		"110000",
		"110000",
		"111110"
	},
	[ "F" ] = {
		"111110",
		"110000",
		"110000",
		"111100",
		"110000",
		"110000",
		"110000",
		"110000",
		"110000"
	},
	[ "G" ] = {
		"011110",
		"110000",
		"110000",
		"110000",
		"110110",
		"110111",
		"110011",
		"111111",
		"011110"
	},
	[ "H" ] = {
		"110011",
		"110011",
		"110011",
		"110011",
		"111111",
		"111111",
		"110011",
		"110011",
		"110011",
	},
	[ "I" ] = {
		"111111",
		"001100",
		"001100",
		"001100",
		"001100",
		"001100",
		"001100",
		"001100",
		"111111",
	},
	[ "J" ] = {
		"111111",
		"000110",
		"000110",
		"000110",
		"000110",
		"000110",
		"000110",
		"101110",
		"111100",
	},
	[ "K" ] = {
		"1100011",
		"1100110",
		"1111100",
		"1110000",
		"1110000",
		"1110000",
		"1111100",
		"1100110",
		"1100011",
	},
	[ "L" ] = {
		"1100000",
		"1100000",
		"1100000",
		"1100000",
		"1100000",
		"1100000",
		"1100000",
		"1111111",
		"1111111",
	},
	[ "M" ] = {
		"1100011",
		"1110111",
		"1111111",
		"1101011",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1100011"
	},
	[ "N" ] = {
		"1100011",
		"1100011",
		"1110011",
		"1111011",
		"1101111",
		"1101111",
		"1100111",
		"1100011",
		"1100011"
	},
	[ "O" ] = {
		"0111110",
		"1111111",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1111111",
		"0111110"
	},
	[ "P" ] = {
		"1111110",
		"1100011",
		"1100011",
		"1100011",
		"1111110",
		"1100000",
		"1100000",
		"1100000",
		"1100000"
	},
	[ "Q" ] = {
		"0111110",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1101011",
		"1100111",
		"0111010"
	},
	[ "R" ] = {
		"1111110",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1111110",
		"1101110",
		"1100111",
		"1100011"
	},
	[ "S" ] = {
		"0111110",
		"1111111",
		"1100000",
		"1100000",
		"1111110",
		"0111111",
		"0000111",
		"1111111",
		"0111110",
	},
	[ "T" ] = {
		"1111111",
		"1111111",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
	},
	[ "U" ] = {
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"111111",
		"011110",
	},
	[ "V" ] = {
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"011110",
		"001100",
	},
	[ "W" ] = {
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"1101011",
		"1101011",
		"1111111",
		"0111110",
		"0010100",
	},
	[ "X" ] = {
		"1100011",
		"1110111",
		"0011100",
		"0011100",
		"0001000",
		"0011100",
		"0011100",
		"1110111",
		"1100011",
	},
	[ "Y" ] = {
		"1100011",
		"1110111",
		"0111110",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0011100",
	},
	[ "Z" ] = {
		"1111111",
		"1111111",
		"0001110",
		"0011100",
		"0011100",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "a" ] = {
		"000000",
		"000000",
		"011110",
		"110011",
		"000011",
		"011111",
		"110011",
		"111111",
		"011111",
	},
	[ "b" ] = {
		"110000",
		"110000",
		"110000",
		"110110",
		"111011",
		"110011",
		"110011",
		"110011",
		"111110",
	},
	[ "c" ] = {
		"000000",
		"000000",
		"000000",
		"011110",
		"110011",
		"110000",
		"110000",
		"110011",
		"011110",
	},
	[ "d" ] = {
		"000011",
		"000011",
		"000011",
		"011111",
		"110111",
		"110011",
		"110011",
		"110011",
		"011111",
	},
	[ "e" ] = {
		"000000",
		"000000",
		"011110",
		"110011",
		"110011",
		"111110",
		"110000",
		"110011",
		"011110",
	},
	[ "f" ] = {
		"000110",
		"001100",
		"001100",
		"111111",
		"111111",
		"001100",
		"001100",
		"001100",
		"001100",
	},
	[ "g" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "h" ] = {
		"110000",
		"110000",
		"110000",
		"111110",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
	},
	[ "i" ] = {
		"11",
		"11",
		"00",
		"11",
		"11",
		"11",
		"11",
		"11",
		"11",
	},
	[ "j" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "k" ] = {
		"1100000",
		"1100000",
		"1100000",
		"1100110",
		"1101100",
		"1111000",
		"1100110",
		"1100110",
		"1100011",
	},
	[ "l" ] = {
		"110",
		"110",
		"110",
		"110",
		"110",
		"110",
		"110",
		"110",
		"011",
	},
	[ "m" ] = {
		"00000000000",
		"00000000000",
		"11000000000",
		"11011001110",
		"11111011111",
		"11001100011",
		"11001100011",
		"11001100011",
		"11001100011",
	},
	[ "n" ] = {
		"000000",
		"000000",
		"000000",
		"110000",
		"111110",
		"110011",
		"110011",
		"110011",
		"110011",
	},
	[ "o" ] = {
		"0000000",
		"0000000",
		"0000000",
		"0111110",
		"1100011",
		"1100011",
		"1100011",
		"1100011",
		"0111110",
	},
	[ "p" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "q" ] = {
		"0011110",
		"1111111",
		"0001110",
		"0011100",
		"0111000",
		"1111111",
		"1111111",
	},
	[ "r" ] = {
		"00000",
		"00000",
		"11000",
		"110110",
		"11111",
		"11100",
		"11000",
		"11000",
		"11000",
	},
	[ "s" ] = {
		"000000",
		"000000",
		"011110",
		"110001",
		"110000",
		"011110",
		"000011",
		"100011",
		"011110",
	},
	[ "t" ] = {
		"000000",
		"001100",
		"001100",
		"111111",
		"001100",
		"001100",
		"001100",
		"001110",
		"000111",
	},
	[ "u" ] = {
		"000000",
		"000000",
		"110011",
		"110011",
		"110011",
		"110011",
		"110011",
		"110111",
		"011101",
	},
	[ "ü" ] = {
		"110011",
		"110011",
		"000000",
		"110011",
		"110011",
		"110011",
		"110011",
		"011011",
		"001111",
	},
	[ "/" ] = {
		"0000011",
		"0000110",
		"0001100",
		"0011000",
		"0110000",
		"1100000",
		"1100000",
	},
	[ "\\" ] = {
		"1100000",
		"0110000",
		"0011000",
		"0001100",
		"0000110",
		"0000011",
		"0000011",
	},
	[ "!" ] = {
		"0011100",
		"0011100",
		"0011100",
		"0011100",
		"0000000",
		"0011100",
		"0011100",
	},
	[ "?" ] = {
		"1111110",
		"0000011",
		"0000111",
		"0011100",
		"0000000",
		"0011100",
		"0011100",
	},
	[ "." ] = {
		"0000000",
		"0000000",
		"0000000",
		"0000000",
		"0000000",
		"0000000",
		"0000000",
		"1100000",
		"1100000",
	},
	[ "(" ] = {
		"0011110",
		"1000011",
		"1000000",
		"1000000",
		"1000000",
		"1000001",
		"0011111",
	},
}

-- format: multiline
UF.charMatrixSymbols = {
	-- format: multiline
	[ "i" ] = {
		"00111111100",
		"01110001110",
		"11111111111",
		"11110001111",
		"11110001111",
		"11110001111",
		"11110001111",
		"01100000110",
		"00111111100",
	},
	[ "T" ] = {
		"000011111",
		"000111111",
		"001000011",
		"010000011",
		"111111111",
		"001111111",
		"000111111",
	},
	[ "!" ] = {
		"000000011000000",
		"0000001111000000",
		"0000001001000000",
		"000001011010000",
		"0000010110100000",
		"0000100110010000",
		"0000100110010000",
		"0001000110001000",
		"0001000110001000",
		"0010000000000100",
		"0010000110000100",
		"0100000000000010",
		"0111111111111110",
	},
	[ "R" ] = {
		"1000000001000000001000000001000000001",
		"1111111111111111111111111111111111111"
	},
}