--[[ 
    VMenu Addon
	v1.0.2
]]--

g_vMenuVer = "1.0.2"
g_vMenuAddons = g_vMenuAddons or {}

if (SERVER) then
    AddCSLuaFile( "sh_vmenu.lua" )
end

if (CLIENT) then
	function ScaleToWideScreen( size )
        return math.min(math.max( ScreenScale(size / 2.62467192), math.min(size, 14) ), size)
    end

    surface.CreateFont( "coolvetica20",  {font='coolvetica', size=ScaleToWideScreen(20), weight=500, antialias=true, additive=false})
    surface.CreateFont( "coolvetica28",  {font='coolvetica', size=ScaleToWideScreen(28), weight=500, antialias=true, additive=false})
    surface.CreateFont( "coolvetica30",  {font='coolvetica', size=ScaleToWideScreen(30), weight=500, antialias=true, additive=false})
    surface.CreateFont( "coolvetica40",  {font='coolvetica', size=ScaleToWideScreen(40), weight=500, antialias=true, additive=false})
	
	-- list.Set( "DesktopWindows", "GmodLegsEditor", 
    -- {
        -- title       = "Valkyrie's Menu",
        -- icon        = "icon64/playermodel.png",
        -- width       = 960,
        -- height      = 700,
        -- onewindow   = true,
        -- init        = function( icon, window )

            -- window:SetTitle("")
            -- window.Paint = function()
                -- draw.RoundedBox(0, 0, 0, window:GetWide(), window:GetTall(), Color( 0, 0, 0, 150 ) )
                -- draw.RoundedBox(0, 0, 0, window:GetWide(), 30, Color(0,0,0,180))
                -- draw.SimpleText("Valkyrie's Menu", "coolvetica28", 4, 15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)    
            -- end

            -- local tabs = vgui.Create( "DPropertySheet", window )
            -- tabs:Dock( FILL )
			
			-- hook.Run( "GetVMenuTabs", window, tabs )
-- /*
		
			-- local addons = vgui.Create( "DScrollPanel", window )
			-- addons:Dock( FILL )
			-- addons:SetPadding(20)
			
			-- http.Fetch( "http://www.corruptedpixel.com/products/vmenu/addons.php",
				-- function( body, len, headers, code )
					-- local resp = string.Explode( "\n", body );
					
					-- for k, v in ipairs(resp) do
						-- local AddonData = string.Explode( "|", v );
						
						-- if (!istable(AddonData)) then 
							-- return
						-- end

						-- steamworks.FileInfo( AddonData[1], function( result )	
							-- if (!istable(result)) then 
								-- return
							-- end

							-- local Panel = vgui.Create("DPanel", addons)
							-- Panel:Dock( TOP )
							-- Panel:SetTall( 30 )
							-- Panel.Paint = function()
								-- draw.RoundedBox(0, 0, 0, Panel:GetWide(), 30, Color(0,0,0,180))
								-- if ( !AddonData[3] ) then
									-- draw.SimpleText(result["title"], "coolvetica28", 4, 15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)    
								-- else
									-- draw.SimpleText(AddonData[2] .. " - Coming Soon", "coolvetica28", 4, 15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)    
								-- end
							-- end
							
							-- local bAction = vgui.Create("DButton", Panel)
							-- bAction:Dock( RIGHT )
								
							-- if ( !AddonData[3] ) then	
								-- if ( steamworks.IsSubscribed(AddonData[1]) ) then
									-- bAction:SetText("Subscribed")
									-- bAction:SetDisabled(true)
								-- else
									-- bAction:SetText("Subscribe")
									-- bAction.DoClick = function()
										-- gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=" .. AddonData[1])
									-- end
								-- end
							-- else
								-- bAction:SetText("Coming Soon")
								-- bAction:SetDisabled(true)
							-- end

							-- if (IsValid(Panel)) then
								-- addons:AddItem(Panel)
							-- end
						-- end )
					-- end
				-- end,
				-- function( error ) end
			 -- )
 
			-- tabs:AddSheet("Other Addons", addons, "icon16/add.png"   )
-- */				
        -- end
    -- } )
end	