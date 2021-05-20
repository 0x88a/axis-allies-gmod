-- if SERVER then
    -- AddCSLuaFile( "shared.lua" )
-- end

if CLIENT then
    SWEP.PrintName = "Administration Stick"
    SWEP.Slot = 0
    SWEP.SlotPos = 5
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true 
end

SWEP.Author         = "Crap-Head"
SWEP.Instructions   = "Right click to bring up tools. Left click to perform selected action."
SWEP.Contact        = ""
SWEP.Purpose        = ""

SWEP.ViewModelFOV   = 62
SWEP.ViewModelFlip  = false
SWEP.UseHands		= true
SWEP.AnimPrefix  	= "stunstick"

SWEP.Spawnable      	= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.Primary.ClipSize     	= -1
SWEP.Primary.DefaultClip   	= 0
SWEP.Primary.Automatic    	= false
SWEP.Primary.Ammo 			= ""

SWEP.Secondary.ClipSize  	= -1
SWEP.Secondary.DefaultClip  = 0
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = ""

local AdminTools = {}

function SWEP:Initialize()
 	self:SetWeaponHoldType( "melee" )    
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	
	ply:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:EmitSound( Sound( "weapons/stunstick/stunstick_swing1.wav" ) )
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
 	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	
	AccessAllowed = false
	
	if CH_AdminStick.Config.UseULX then
		if table.HasValue( CH_AdminStick.Config.ULXRanks, ply:GetUserGroup() ) then
			AccessAllowed = true
		end
	end
	if CH_AdminStick.Config.UseSteamIDs then
		if table.HasValue( CH_AdminStick.Config.SteamIDs, ply:SteamID() ) then
			AccessAllowed = true
		end
	end
	if CH_AdminStick.Config.UseSpecificTeams then
		if table.HasValue( CH_AdminStick.Config.SpecificTeams, ply:Team() ) then
			AccessAllowed = true
		end
	end
	if ply:IsAdmin() then
		AccessAllowed = true
	end
	
	if not AccessAllowed then
		if SERVER then
			DarkRP.notify(ply, 1, 4, "You must be an Administrator to use this tool.")
			return
		end
	end

	AdminTools[ply:GetTable().CurGear or 1][4](ply, ply:GetEyeTrace())
	
	-- -- Billy Log Support
	-- if SERVER then
		-- hook.Run( "CH_AdminStick_Action", ply, AdminTools[ply:GetTable().CurGear or 1][1], ply:GetEyeTrace().Entity )
	-- end
end

if SERVER then
	util.AddNetworkString( "ADMINSTICK_SelectTool" )
	net.Receive( "ADMINSTICK_SelectTool", function (length, ply )
		local CurrentGear = net.ReadDouble()
		local Message = net.ReadString()
		
		DarkRP.notify( ply, 2, 5, Message )
		ply:GetTable().CurGear = tonumber( CurrentGear )
	end)
end

function SWEP:SecondaryAttack()
	if CLIENT then
		local MENU = DermaMenu()
		MENU:AddOption( LocalPlayer():Nick() ):SetIcon( "icon16/user.png" )
		MENU:AddSpacer()

		local CategoryAll = MENU:AddSubMenu( "General Tools" )

		for k, v in pairs( AdminTools ) do
			if string.find( v[1], "DARKRP" ) then
				CategoryDarkRP:AddOption( v[1], function()
					net.Start( "ADMINSTICK_SelectTool" )
						net.WriteDouble( k )
						net.WriteString( v[2] )
					net.SendToServer()
				end):SetIcon( v[3] )
			elseif string.find( v[1], "TTT" ) then
				CategoryTTT:AddOption( v[1], function()
					net.Start( "ADMINSTICK_SelectTool" )
						net.WriteDouble( k )
						net.WriteString( v[2] )
					net.SendToServer()
				end):SetIcon( v[3] )
			else
				CategoryAll:AddOption( v[1], function()
					net.Start( "ADMINSTICK_SelectTool" )
						net.WriteDouble( k )
						net.WriteString( v[2] )
					net.SendToServer()
				end):SetIcon( v[3] )
			end
		end
		
		MENU:Open( 100, 100 )
		input.SetCursorPos( 100, 100 )
	end
end

local function AddTool( name, description, icon, func )
	table.insert( AdminTools, {name, description, icon, func} )
end

AddTool( "[ALL] Copy SteamID", "Copy the SteamID of the player you are looking at.", "icon16/information.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		SetClipboardText ( Trace.Entity:SteamID())
	end
end)

AddTool( "[ALL] Exit Vehicle", "Kick the driver out of their current vehicle.", "icon16/car.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:GetClass() == "prop_vehicle_jeep" then
		if Trace.Entity:IsVehicle() and IsValid( Trace.Entity.GetDriver and Trace.Entity:GetDriver() ) then
			Trace.Entity:GetDriver():ExitVehicle()
			DarkRP.notify( Trace.Entity:GetDriver(), 1, 2,  "An administrator has kicked you out of your vehicle!")
		end
	end
end)

AddTool( "[ALL] Bring", "Aim at a player to bring them in front of you.", "icon16/cart_go.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		Trace.Entity:SetPos( Player:GetPos() + ( (Player:GetForward() * 45) +  Vector( 0, 0, 50 )) )
		DarkRP.notify( Trace.Entity, 2, 2,  "An administrator has bought you to them.")
	end
end)

AddTool( "[ALL] Player Info", "Gives you a lot of information about the target.", "icon16/information.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		Player:ChatPrint( "Name: "..Trace.Entity:Nick() )
		Player:ChatPrint( "SteamID: "..Trace.Entity:SteamID() )
		Player:ChatPrint( "SteamID 64: "..Trace.Entity:SteamID64() )
		Player:ChatPrint( "Kills: "..Trace.Entity:Frags() )
		Player:ChatPrint( "Deaths: "..Trace.Entity:Deaths() )
		Player:ChatPrint( "HP: " ..Trace.Entity:Health() )
		Player:ChatPrint( "Armor: " ..Trace.Entity:Armor() )
	elseif IsValid( Trace.Entity ) and Trace.Entity:IsVehicle() then
		if IsValid( Trace.Entity.GetDriver and Trace.Entity:GetDriver() ) then
			Player:ChatPrint( "Name: "..Trace.Entity:GetDriver():Nick() )
			Player:ChatPrint( "SteamID: "..Trace.Entity:GetDriver():SteamID() )
			Player:ChatPrint( "SteamID 64: "..Trace.Entity:GetDriver():SteamID64() )
			Player:ChatPrint( "Kills: "..Trace.Entity:GetDriver():Frags() )
			Player:ChatPrint( "Deaths: "..Trace.Entity:GetDriver():Deaths() )
			Player:ChatPrint( "HP: " ..Trace.Entity:GetDriver():Health() )
			Player:ChatPrint( "Armor: " ..Trace.Entity:GetDriver():Armor() )
		end
	end
end)

AddTool("[ALL] Freeze/Unfreeze", "Target a player to change his freeze state.", "icon16/bug.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		if Trace.Entity.IsFrozens then
			Trace.Entity:Freeze( false )
			DarkRP.notify( Player, 2, 2,  Trace.Entity:Nick() .. "has been unfrozen.")
			DarkRP.notify( Trace.Entity, 1, 2,  "You have been unfrozen by an administrator.")
			Trace.Entity:EmitSound( "npc/metropolice/vo/allrightyoucango.wav" )
			Trace.Entity.IsFrozens = false
		else
			Trace.Entity.IsFrozens = true
			Trace.Entity:Freeze( true )
			DarkRP.notify( Player, 2, 2,  Trace.Entity:Nick() .. "has been frozen.")
			DarkRP.notify( Trace.Entity, 1, 2,  "You have been frozen by an administrator.")
			Trace.Entity:EmitSound( "npc/metropolice/vo/holdit.wav" )
		end
	end
end)

AddTool("[ALL] Heal Player", "Aim at a player to heal them. Aim at the world to heal yourself.", "icon16/heart.png", function( Player, Trace )
	if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
		Trace.Entity:SetHealth( 100 )
		Trace.Entity:EmitSound( "items/smallmedkit1.wav",110,100 )
		DarkRP.notify( Trace.Entity, 3, 2,  "You have been healed by an administrator.")
	elseif Trace.Entity:IsWorld() then
		Player:SetHealth( 100 )
		Player:EmitSound( "items/smallmedkit1.wav",110,100 ) 
		DarkRP.notify( Player, 3, 2,  "You've healed yourself.")
	end
end)

AddTool("[ALL] God Mode", "Aim at a player to god/ungod them. Aim at the world to god/ungod yourself.", "icon16/shield.png", function( Player, Trace )
	if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
		if Trace.Entity:HasGodMode() then
			Trace.Entity:GodDisable()
			DarkRP.notify( Trace.Entity, 2, 2,  "Your godmode has been disabled by an administrator.")
		else
			Trace.Entity:GodEnable()
			DarkRP.notify( Trace.Entity, 2, 2,  "Your godmode has been enabled by an administrator.")
		end
	elseif Trace.Entity:IsWorld() then
		if Player:HasGodMode() then
			Player:GodDisable()
			DarkRP.notify( Player, 2, 2,  "Your godmode has been disabled.")
		else
			Player:GodEnable()
			DarkRP.notify( Player, 2, 2,  "Your godmode has been enabled.")
		end
	end
end)

AddTool("[ALL] Invisiblity", "Left click to go invisible. Left click again to become visible again.", "icon16/eye.png", function( Player, Trace )
	local c = Player:GetColor()
	local r,g,b,a = c.r, c.g, c.b, c.a
		
	if a == 255 then
		DarkRP.notify( Player, 2, 2,  "You are now invisible.")
		Player:SetColor( Color( 255, 255, 255, 0 ) )
		Player:SetNoDraw( true )
	else
		DarkRP.notify( Player, 2, 2,  "You are now visible.")
		Player:SetColor( Color( 255, 255, 255, 255 ) )
		Player:SetNoDraw( false )
	end
end)

AddTool("[ALL] Kick Player", "Aim at a player to kick him.", "icon16/cancel.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		Trace.Entity:Kick( "You have been kicked!" )
		Trace.Entity:EmitSound( "npc/metropolice/vo/finalverdictadministered.wav" )
		DarkRP.notify( Player, 1, 2,  "You kicked " ..Trace.Entity:Nick() )
	end
end)

AddTool("[ALL] Remover", "Aim at any object to remove it.", "icon16/wrench.png", function( Player, Trace )
	if Trace.Entity:IsPlayer() then 
		DarkRP.notify( Player, 1, 2,  "You can't remove players!" )
		return
	end
			
	if IsValid( Trace.Entity ) then
		Trace.Entity:Remove()
	end
end)

AddTool("[ALL] Kill Player", "Aim at a player to kill him.", "icon16/gun.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		DarkRP.notify( Trace.Entity, 1, 2,  "An administrator has killed you.")
		Trace.Entity:Kill()
		
		DarkRP.notify( Player, 2, 2, "You killed " ..Trace.Entity:Nick())
	end
end)

AddTool("[ALL] Teleport", "Teleports you to a targeted location.", "icon16/connect.png", function( Player, Trace )
	local EndPos = Player:GetEyeTrace().HitPos
	local CloserToUs = (Player:GetPos() - EndPos):Angle():Forward()
		
	Player:SetPos( EndPos + ( CloserToUs * 20) )
end)

AddTool("[ALL] Unfreeze (Prop)", "Aim at an entity to unfreeze it.", "icon16/attach.png", function( Player, Trace )
	if IsValid( Trace.Entity ) then
		Trace.Entity:GetPhysicsObject():EnableMotion( true )
		Trace.Entity:GetPhysicsObject():Wake()
		DarkRP.notify( Player, 1, 2,  "You have unfrozen the prop." )
	end
end)

AddTool("[ALL] Slap Player", "Aim at a player to slap him.", "icon16/joystick.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		Trace.Entity:EmitSound( "physics/body/body_medium_impact_hard1.wav" )
		Trace.Entity:SetVelocity( Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) ) )
	end
end)

AddTool("[ALL] Get Weapons", "Aim at a player to print all their weapons.", "icon16/find.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		Player:ChatPrint( "The target has the following weapons:" )
		for k, v in ipairs( Trace.Entity:GetWeapons() ) do
			local wep = tostring( v:GetClass() )
			Player:ChatPrint( wep )
		end
	end
end)

AddTool("[ALL] Explode", "Aim at an entity to explode it.", "icon16/bomb.png", function( Player, Trace )
	if IsValid( Trace.Entity ) then
		Trace.Entity:Ignite( 10, 0 )

		local eyetrace = Player:GetEyeTrace()
		local explode = ents.Create( "env_explosion" )
		explode:SetPos( eyetrace.HitPos ) 
		explode:Spawn() 
		explode:SetKeyValue( "iMagnitude","75" ) 
		explode:Fire( "Explode", 0, 0 ) 

		if Trace.Entity:IsPlayer() then
			Trace.Entity:Kill()
		end
	end
end)

AddTool("[ALL] Respawn Player", "Use on a player to respawn them.", "icon16/user_gray.png", function( Player, Trace )
	if IsValid( Trace.Entity ) and Trace.Entity:IsPlayer() then
		Trace.Entity:Spawn()
		DarkRP.notify( Player, 1, 2,  "They have been respawned." )
		DarkRP.notify( Trace.Entity, 3, 2,  "You have been respawned by an administrator." )
	end
end)
