
// Shop::Button1
// Default button used in most places

// Shop::DTextEntry1
// Only allows a-z, spaces and letters

// Shop::DPanelLowAlpha
// Low alpha DPanel

// Shop::DComboBox
// Default style combobox
local PANEL = {};
function PANEL:Init()
    self:SetColor( Color( 0, 0, 0 ) );
end

function PANEL:Paint( w, h )

        surface.SetDrawColor( 0, 0, 0 );
        surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
        self:DrawTextEntryText( Color( 0, 255, 0 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) );

end

vgui.Register( "Shop::DComboBox", PANEL, "DComboBox" );

local PANEL = nil;
PANEL = {};
function PANEL:Init()

end

function PANEL:Paint( w, h )
        draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 0, 0, 80 ) );
end

vgui.Register( "Shop::DPanelLowAlpha", PANEL, "DPanel" );

local PANEL = nil;
PANEL = {};

function PANEL:Init()
    self:SetColor( Shop.Colors.BtnText );
end

function PANEL:Paint( w, h )
    draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnBg );
    draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.Btn );
end;

function PANEL:OnCursorEntered()
    function self:Paint( w, h )
        draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnHover );
    end;
end;

function PANEL:OnCursorExited()
    function self:Paint( w, h )
        draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnBg );
        draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.Btn );
    end;
end;

vgui.Register( "Shop::Button1", PANEL, "DButton" );

local PANEL = nil;
PANEL = {};
function PANEL:Init()
	
end

function PANEL:Paint( w, h )
        draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 0, 0, 80 ) );
end

vgui.Register( "Shop::DPanelLowAlpha", PANEL, "DPanel" );

local PANEL = nil;
PANEL = {};
AccessorFunc( PANEL, "active", "State", FORCE_BOOL );

function PANEL:Init()
    self:SetColor( Shop.Colors.BtnTextShop );
	self:SetState( false );
end


function PANEL:Paint( w, h )
	if( self:GetState() ) then
		draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnHoverShop );
	else
		draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnBgShop );
		draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnShop );
	end
end;

function PANEL:OnCursorEntered()
    function self:Paint( w, h )
        draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnHoverShop );
    end;
end;

function PANEL:OnCursorExited()
	function self:Paint( w, h )
		if( self:GetState() ) then
			draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnHoverShop );
		else
			draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnBgShop );
			draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BtnShop );
		end
    end;
end;

vgui.Register( "Shop::Button2", PANEL, "DButton" );


// DTextEntry1
local PANEL = nil;
PANEL = {};

function PANEL:Init()
    self.Restrict = true;
    self.Clear = true;
    self:SetSize( 180, 22 );
end

function PANEL:OnGetFocus()
    if( self.Restrict && self.Clear ) then
        self:SetText( "" );
    end
end;

function PANEL:Paint( self )

end;

function PANEL:Think()
    if( self.Restrict && self:GetValue():match( "[^%w%s()_,.!?-]" ) != nil ) then
        self.Paint = function( self )
            surface.SetDrawColor( 0, 0, 0 );
            surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
            self:DrawTextEntryText( Color( 255, 0, 0 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) );
        end
    else
        self.Paint = function( self )
            surface.SetDrawColor( 0, 0, 0 );
            surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
            self:DrawTextEntryText( Color( 0, 255, 0 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) );
        end
    end
end

vgui.Register( "Shop::TextEntry1", PANEL, "DTextEntry" );

// DTextEntry1
local PANEL = nil;
PANEL = {};

function PANEL:Init()
    self.Restrict = true;
    self:SetSize( 180, 22 );
end

function PANEL:OnGetFocus()
        self:SetText( "" );
end;

function PANEL:Paint( self )

end;

function PANEL:Think()
    if( self:GetValue() != "yes" && self:GetValue() != "no" ) then
        self.Paint = function( self )
            surface.SetDrawColor( 0, 0, 0 );
            surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
            self:DrawTextEntryText( Color( 255, 0, 0 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) );
        end
    else
        self.Paint = function( self )
            surface.SetDrawColor( 0, 0, 0 );
            surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
            self:DrawTextEntryText( Color( 0, 255, 0 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) );
        end
    end
end

vgui.Register( "Shop::BoolTextEntry1", PANEL, "Shop::TextEntry1" );

// DTextEntry1
local PANEL = nil;
PANEL = {};

function PANEL:Init()
    self.Restrict = true;
    self:SetSize( 180, 22 );
end

function PANEL:Paint( w, h )
        draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 0, 0, 80 ) );
end;


vgui.Register( "DLine", PANEL, "DPanel" );

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/