
local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:DockMargin(5, 2, 0, 0)

    self:SetTall(30)
    self:SetUpdateOnType( true )

    self.complete = false
end

function PANEL:SetParent(pnl, type, value)
    local dock = pnl:GetWide()*0.45

    self:DockMargin(5, 5, dock, 0)

    self.data = type
    self.parent = pnl

    if (value) then
        self.parent.flagData[self.data] = value
        self:SetValue(value)
    end
end

function PANEL:SetRequirement(intRequire)
    self.require = intRequire
end

function PANEL:OnEnter()
    self.complete = true

    self.parent.flagData[self.data] = self:GetValue()
end

function PANEL:Think()
    if (self.complete) and (self.require) then
        local text = self:GetValue()

        if (string.len(text)) < self.require then
            self.complete = false
        end
    end
end

function PANEL:OnValueChange(text)
    if (self.require) then
         if (string.len(text)) >= self.require then
            self.complete = true
           self.parent.flagData[self.data] = self:GetValue()
        end
    end
end

function PANEL:Paint()
    surface.SetDrawColor(64, 64, 64)
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

    self:DrawTextEntryText(color_white, Color(30, 30, 30), color_white)

    if (self.complete) then
        surface.SetDrawColor(0, 255, 0, 200)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
    end
end


derma.DefineControl( "Conquest_TextEntry", " ", PANEL, "DTextEntry" )


