local PANEL = {}
PANEL.View = {}

local scale = 1.8
local x, y = nil

local circle = Material("nykez/circle.png", "noclamp smooth")
local square = Material("nykez/square.png", "noclamp smooth")

local getMaterials = {}
getMaterials["circle"] = circle
getMaterials["square"] = square


function PANEL:Init()
    self:SetTitle("")
    self:SetSize(1157, 698)
    self:Center()
    self:MakePopup()

    local spawnsEnabled = Conquest.Config.get("spawning", false)

    self.showTeams = Conquest.Config.get("showTeammates", false)
    self.contestedSpawns = Conquest.Config.get("nocontestedSpawns", false)

    if (spawnsEnabled ) then
        self.spawning = true
    end

    self.teamPlayers = {}

    self.beingHovered = false
    
    self.mousePosX, self.mousePosY = gui.MousePos()

    self.CloseButton = vgui.Create("DButton", self)
    self.CloseButton:SetSize(32, 32)
    self.CloseButton:SetText("")
    self.CloseButton:SetPos(1157 / 2 - 16, 636)

    self.CloseButton.DoClick = function()
      self:Remove()
    end

    self.CloseButton.Paint = function(s, w, h) end

    self:ShowCloseButton(false)


    if (not x) then
      x = LocalPlayer():GetPos().x
    end

    if (not y) then
      y = LocalPlayer():GetPos().y
    end

    local dx, dy = self:GetPos()
    self.View.angles = Angle(90, 0, 0)
    self.View.ortho = true
    self.View.x = dx + 64
    self.View.y = dy + 64
    self.View.w = self:GetWide() - 128
    self.View.h = self:GetTall() - 142
    self.View.ortholeft = -self.View.w
    self.View.orthoright = self.View.w
    self.View.orthotop = -self.View.h
    self.View.orthobottom = self.View.h
    self.View.dopostprocess = false
    self.View.drawhud = false
    self.View.drawviewmodel = false
    self.View.drawmonitors = false

    self.buttonPanels = {}

    local w = self:GetWide()
    local h = self:GetTall()

    if (spawnsEnabled) then
        for k,v in pairs(Conquest.cache) do

            self.buttonPanels[k] = vgui.Create('DButton', self)
            self.buttonPanels[k]:SetSize(64, 64)
            self.buttonPanels[k]:SetVisible(false)
            self.buttonPanels[k]:SetText("")
            self.buttonPanels[k]:SetPos(w / 2 + (y - v.position.y) / scale * 0.5, h / 2 + (x - v.position.x) / scale * 0.5 - 32 + 12)

            self.buttonPanels[k].id = v
        end
    end

end

function PANEL:Paint(w, h)
    surface.SetDrawColor(235, 235, 235, 50)
    surface.DrawRect(64, 64, w - 128, h - 142)


    self.View.origin = Vector(x or 0, y or 0, 1000 * scale)
    self.View.ortholeft = -self.View.w * scale
    self.View.orthoright = self.View.w * scale
    self.View.orthotop = -self.View.h * scale
    self.View.orthobottom = self.View.h * scale
    self.View.zfar = 10000 * scale
    render.RenderView(self.View)

    local dx, dy = self:LocalToScreen(0, 0)
    render.SetScissorRect(self.View.x, self.View.y, self.View.x + self.View.w, self.View.y + self.View.h, true)


    local builtPlayers = {}
    for k,v in pairs(Conquest.cache) do

        if (self.showTeams) then

            if (v.teamBased and v.teamBased) then
                
                local customTeam = Conquest.TeamManager.QuickCache[LocalPlayer():Team()]
                for k,v in pairs(player.GetAll()) do
                    if v == LocalPlayer() then continue end

                    if (Conquest.TeamManager.QuickCache[v:Team()] == customTeam) then
                        
                        table.insert(builtPlayers, v)

                    end

                end


            else

                if (v.category) and (v.category == true) then
                    for k,v in pairs(player.GetAll()) do
                        if v == LocalPlayer() then continue end
                        if v:getJobTable().category == LocalPlayer():getJobTable().category then
                            
                        table.insert(builtPlayers, v)

                        end
                    end
                else

                    for k,v in pairs(player.GetAll()) do
                        if v == LocalPlayer() then continue end

                        if v:Team() == LocalPlayer():Team() then

                            table.insert(builtPlayers, v)

                        end

                    end
                end
            
            end

        end

        if v.isCapturing then
            local clr = GetIconColor(v)
            surface.SetMaterial(getMaterials[tostring(v.shape)])
            surface.SetDrawColor(clr.r, clr.g, clr.b,  math.abs(math.sin(CurTime()*4)*255))
            surface.DrawTexturedRectRotated(w / 2 + (y - v.position.y) / scale * 0.5, h / 2 + (x - v.position.x) / scale * 0.5 - 32 + 12, 64, 64, 0)

        else

            surface.SetMaterial(getMaterials[tostring(v.shape)])
            surface.SetDrawColor(GetIconColor(v))
            surface.DrawTexturedRectRotated(w / 2 + (y - v.position.y) / scale * 0.5, h / 2 + (x - v.position.x) / scale * 0.5 - 32 + 12, 64, 64, 0)

        end
        
        draw.SimpleTextOutlined(v.tag, "Conquest_Button1", w / 2 + (y - v.position.y) / scale * 0.5, h / 2 + (x - v.position.x) / scale * 0.5 - 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, nil, 2, Color(0, 0, 0, 255))
		
        if (self.buttonPanels[k]) then
            self.buttonPanels[k]:SetVisible(true)
            self.buttonPanels[k]:SetPos(w / 2 + (y - v.position.y) / scale * 0.5 - 25, h / 2 + (x - v.position.x) / scale * 0.5 - 58 + 12)

            self.buttonPanels[k].Paint = function(s, w, h)
            end

            self.buttonPanels[k].DoClick = function(s)
                if self.contestedSpawns == true and v.isCapturing then return end
                net.Start("conquest_spawnon")
                    net.WriteTable(self.buttonPanels[k].id)
                net.SendToServer()

                CONQUEST_MAP:Close()
                CONQUEST_MAP = nil

            end

            self.buttonPanels[k].OnCursorEntered = function()
                self.beingHovered = true
            end

            self.buttonPanels[k].OnCursorExited = function()
                self.beingHovered = false
            end

        end
    end

    for k,v in pairs(builtPlayers) do
        surface.SetDrawColor(255, 255, 255, 255)
        draw.NoTexture()
        ConquestCircle(w / 2 + (y - v:GetPos().y) / scale * 0.5, h / 2 + (x - v:GetPos().x) / scale * 0.5 - 20, 16, 32)
    end

    draw.SimpleTextOutlined("YOU", "Conquest_Button1", w / 2 + (y - LocalPlayer():GetPos().y) / scale * 0.5, h / 2 + (x - LocalPlayer():GetPos().x) / scale * 0.5 - 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, nil, 2, Color(0, 0, 0, 255))

    render.SetScissorRect(0, 0, 0, 0, false)
    draw.SimpleText("PRESS [F1] TO CLOSE MENU", "Conquest_Button1", 82, h - 120, Color(255, 255, 255), TEXT_ALIGN_LEFT)

    if (self.spawning) then
        draw.SimpleText("CLICK A FLAG TO SPAWN ON IT", "Conquest_Button1", 82, h - 145, Color(225, 255, 255), TEXT_ALIGN_LEFT)
    end
    

    if input.IsKeyDown(KEY_ESCAPE) then

      self:Close()

    end

end


function PANEL:OnMouseWheeled(delta)
    if (self.beingHovered) then return end 

    scale = math.Clamp(scale - delta * 0.1, 1.8, 50)
end

function PANEL:OnMousePressed(lmb)
    if (self.beingHovered) then return end 


    self.mousePosX, self.mousePosY = gui.MousePos()
    self.cachedPosX, self.cachedPosY = gui.MousePos()
end


function PANEL:OnMouseReleased()
    if (self.beingHovered) then return end 


    self.mousePosX, self.mousePosY = gui.MousePos()
end

function PANEL:ComputeDragDelta( diff )
    if (self.beingHovered) then return end 


    if diff > -1 and diff < 1 then return 0 end

    return -( diff * scale )
end

function PANEL:AddOriginX( deltaOriginX )
    y = y + deltaOriginX
end

function PANEL:AddOriginY( deltaOriginY )
    x = x + deltaOriginY
end

function PANEL:Think()
    if input.IsButtonDown(KEY_F1) then
        self:Remove()
    end

    if input.IsButtonDown( MOUSE_LEFT ) and (!self.beingHovered) then
        local mousePosX, mousePosY = gui.MousePos()

        local deltaX = self:ComputeDragDelta( self.mousePosX - mousePosX )
        local deltaY = self:ComputeDragDelta( self.mousePosY - mousePosY )

        self:AddOriginX( deltaX )
        self:AddOriginY( deltaY )

        self.mousePosX, self.mousePosY = gui.MousePos()
    end
end

vgui.Register("Conquest_Map", PANEL, "DFrame")

net.Receive("Conquest_MapOpen", function()
    if CONQUEST_MAP then CONQUEST_MAP:Remove() CONQUEST_MAP = nil end

    timer.Simple(0.1, function()
        CONQUEST_MAP = vgui.Create("Conquest_Map")
        
    end)

end)