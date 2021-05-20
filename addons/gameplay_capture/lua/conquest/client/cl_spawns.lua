
net.Receive("conquest_spawncl", function()
    if conquest_death then
        conquest_death:Remove()
    end

    conquest_death = vgui.Create("ConquestSpawns_New")
end)

local function getTeamCommand(command)
	for k,v in pairs(RPExtraTeams) do

			if v.command == command then

				return v

			end

	end
end

local function GetIconColor(flag)
	local darkrp = Conquest.Config.get("darkrp", false)
	if (flag.category) then

		if (darkrp) then
			local categories = DarkRP.getCategories().jobs

			for _, cat in pairs(categories) do
				if cat.name == flag.owner then
					return cat.color
				end
			end
		
		else
			for k,v in pairs(team.GetAllTeams()) do

				if v.Name == flag.owner then

					return v.Color

				end

			end

			return Color(255, 0, 0, 255)
		end
	else
		if (darkrp == true) then

			local team = getTeamCommand(flag.owner)

			if (team) then
				return team.color
			end

			
		else

			for k,v in pairs(team.GetAllTeams()) do

				if v.Name == flag.owner then

					return v.Color

				end

			end

			return Color(255, 0, 0)

		end
	end

	return Color(255, 0, 0)
end

local PANEL = {}

function PANEL:Init()
    self:SetWide(ScrW() * 0.5)
	self:SetTall(ScrH() * 0.45)
	self:Center()
	self:MakePopup()

	self:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0)):FadeIn()

    self.navbar = self:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self:GetTall() * 0.08)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text("Available Spawns")


    self.exit = self:Add("DButton")
	self.exit:SetSize(32, 32)
	self.exit:SetPos(self:GetWide() - 38, 2)
	self.exit:SetText('X')
	self.exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	self.exit:SetTextColor(color_white)
	self.exit:On('DoClick', function()
		self:Remove()
	end)

    self.container = self:Add("DIconLayout")
    self.container:Dock(FILL)
    self.container:SetSpaceX(5)
    self.container:SetSpaceY(5)
    self.container:DockMargin(5, 5, 5, 5)


    for k,v in pairs(Conquest.cache) do
        local dbutton = self.container:Add("DButton")
        dbutton:SetSize(self:GetWide()/4, self:GetTall()*0.50)
        local clr = GetIconColor(v)

        if clr == Color(255, 0, 0, 255) then
            clr = Color(255, 0, 0, 150)
        end

        dbutton:TDLib():ClearPaint():Circle(clr):CircleFadeHover():CircleExpandHover()
        local owner = " "
        if v.owner then
            owner = "["..v.owner.."]"
        end
        dbutton:SetText(v.name .." " .. owner.."")
        dbutton:SetTextColor(color_white)
        dbutton:SetFont("DermaDefaultBold")
        dbutton.parent = v
        dbutton:On('DoClick', function(s)
            if s.parent then
                net.Start("conquest_spawnon")
                    net.WriteTable(s.parent)
                net.SendToServer()

                self:Remove()
            end
        end)
    end

end

vgui.Register("ConquestSpawns_New", PANEL, "EditablePanel")
