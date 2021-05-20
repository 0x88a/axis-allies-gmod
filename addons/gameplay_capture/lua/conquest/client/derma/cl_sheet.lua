
local PANEL = {}

AccessorFunc( PANEL, "ActiveButton", "ActiveButton" )

function PANEL:Init()

	self.Navigation = vgui.Create( "DScrollPanel", self )
	self.Navigation:Dock( LEFT )
	self.Navigation:SetWidth( 200 )
	self.Navigation:DockMargin(0, self:GetTall() * 0.08, 1, 0 )
    self.Navigation:TDLib():Background(Color(39, 39, 39))
	self.Content = vgui.Create( "Panel", self )
	self.Content:Dock( FILL )

	self.Items = {}

end

function PANEL:UseButtonOnlyStyle()
	self.ButtonOnly = true
end

function PANEL:AddSheet( label, panel, material )

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}


	Sheet.Button = vgui.Create( "DButton", self.Navigation )

	Sheet.Button.Target = panel
	Sheet.Button:Dock( TOP )
    Sheet.Button:SetTall(46)
	Sheet.Button:SetText(label)
    Sheet.Button:SetTextColor(color_white)
	Sheet.Button:DockMargin( 0, 1, 0, 0 )
	Sheet.Button:SetFont("Conquest_Button1")
	Sheet.Button:SetContentAlignment(5)

	local clr = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255 )

    if (material) then
        Sheet.Button.Paint = function(s)

			if s:IsHovered() then
				surface.SetDrawColor(255, 255, 255, 170)
            	surface.SetMaterial(material)
            	surface.DrawTexturedRect(10, 7, 32, 32)

				s:SetAlpha(170)
			else
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(material)
				surface.DrawTexturedRect(10, 7, 32, 32)	

				s:SetAlpha(255)			
			end

			if self.ActiveButton == s then
				surface.SetDrawColor(255, 255, 255, 170)
            	surface.SetMaterial(material)
            	surface.DrawTexturedRect(10, 7, 32, 32)

				surface.SetDrawColor(60, 60, 60, 200)
				surface.DrawRect(0, 0, s:GetWide(), s:GetTall())

				s:SetAlpha(170)


				surface.SetDrawColor(clr)
				surface.DrawRect(0, 0, s:GetWide()*0.02, s:GetTall())
			end

        end
    end

	Sheet.Button.OnCursorEntered = function(s)
		surface.PlaySound("UI/buttonrollover.wav")
	end

	
	

	Sheet.Button.DoClick = function()
		self:SetActiveButton( Sheet.Button )
	end

	Sheet.Panel = panel
	Sheet.Panel:SetParent( self.Content )
	Sheet.Panel:SetVisible( false )

	if ( self.ButtonOnly ) then
		Sheet.Button:SizeToContents()
		--Sheet.Button:SetColor( Color( 150, 150, 150, 100 ) )
	end

	table.insert( self.Items, Sheet )

	if ( !IsValid( self.ActiveButton ) ) then
		self:SetActiveButton( Sheet.Button )
	end

end

function PANEL:SetActiveButton( active )

	if ( self.ActiveButton == active ) then return end

	if ( self.ActiveButton && self.ActiveButton.Target ) then
		self.ActiveButton.Target:SetVisible( false )
		self.ActiveButton:SetSelected( false )
		self.ActiveButton:SetToggle( false )
		--self.ActiveButton:SetColor( Color( 150, 150, 150, 100 ) )
	end

	self.ActiveButton = active
	active.Target:SetVisible( true )
	active:SetSelected( true )
	active:SetToggle( true )
	--active:SetColor( Color( 255, 255, 255, 255 ) )

	self.Content:InvalidateLayout()

end

derma.DefineControl( "ConquestSheet", "", PANEL, "Panel" )
