if not CLIENT then return end

local mat = Material("fpicker/back.png")
local nazis = Material("fpicker/ba.png")
local allies = Material("fpicker/ba2.png")

hook.Add('PlayerFinishedLoading', 'FinishedLoad.Picker', function()
    local panel = vgui.Create("EditablePanel")
    panel:SetSize(ScrW(), ScrH())
    panel:MakePopup()
    panel:Center()
    panel.Paint = function(this, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(0, 0, w, h)
    
        surface.SetDrawColor(Color(0, 0, 0))
        surface.DrawOutlinedRect(0, 0, w, h, 5)
    end
    
    local p = panel:Add("DPanel")
    p:Dock(BOTTOM)
    p:SetTall(ScrH() * 0.3)
    p:SetPaintBackground(false)
    
    local f1 = p:Add("DButton")
    f1:Dock(LEFT)
    f1:DockMargin(100, 50, 50, 50)
    f1:SetWide(ScrW() * 0.26)
    f1:SetText("")
    f1:SetColor(color_white)
    f1.Paint = function(this, w, h)
        local col = (this.Hovered or this.Depressed) and color_white or Color(107, 107, 107)
        surface.SetDrawColor(col)
        surface.SetMaterial(nazis)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    f1.DoClick = function(this, w, h)
        net.Start("fpicker.SetJob")
            net.WriteEntity(LocalPlayer())
            net.WriteBool(true)
        net.SendToServer()
    
        panel:Remove()
    end
    
    local f2 = p:Add("DButton")
    f2:Dock(RIGHT)
    f2:DockMargin(50, 50, 100, 50)
    f2:SetWide(ScrW() * 0.28)
    f2:SetText("")
    f2:SetColor(color_white)
    f2.Paint = function(this, w, h)
        local col = (this.Hovered or this.Depressed) and color_white or Color(107, 107, 107)
        surface.SetDrawColor(col)
        surface.SetMaterial(allies)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    f2.DoClick = function(this, w, h)
        net.Start("fpicker.SetJob")
            net.WriteEntity(LocalPlayer())
            net.WriteBool(false)
        net.SendToServer()
    
        panel:Remove()
    end
end)

concommand.Add('pick', function()
    local panel = vgui.Create("EditablePanel")
    panel:SetSize(ScrW(), ScrH())
    panel:MakePopup()
    panel:Center()
    panel.Paint = function(this, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(0, 0, w, h)
    
        surface.SetDrawColor(Color(0, 0, 0))
        surface.DrawOutlinedRect(0, 0, w, h, 5)
    end
    
    local p = panel:Add("DPanel")
    p:Dock(BOTTOM)
    p:SetTall(ScrH() * 0.3)
    p:SetPaintBackground(false)
    
    local f1 = p:Add("DButton")
    f1:Dock(LEFT)
    f1:DockMargin(100, 50, 50, 50)
    f1:SetWide(ScrW() * 0.26)
    f1:SetText("")
    f1:SetColor(color_white)
    f1.Paint = function(this, w, h)
        local col = (this.Hovered or this.Depressed) and color_white or Color(107, 107, 107)
        surface.SetDrawColor(col)
        surface.SetMaterial(nazis)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    f1.DoClick = function(this, w, h)
        net.Start("fpicker.SetJob")
            net.WriteEntity(LocalPlayer())
            net.WriteBool(true)
        net.SendToServer()
    
        panel:Remove()
    end
    
    local f2 = p:Add("DButton")
    f2:Dock(RIGHT)
    f2:DockMargin(50, 50, 40, 50)
    f2:SetWide(ScrW() * 0.28)
    f2:SetText("")
    f2:SetColor(color_white)
    f2.Paint = function(this, w, h)
        local col = (this.Hovered or this.Depressed) and color_white or Color(107, 107, 107)
        surface.SetDrawColor(col)
        surface.SetMaterial(allies)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    f2.DoClick = function(this, w, h)
        net.Start("fpicker.SetJob")
            net.WriteEntity(LocalPlayer())
            net.WriteBool(false)
        net.SendToServer()
    
        panel:Remove()
    end
end)