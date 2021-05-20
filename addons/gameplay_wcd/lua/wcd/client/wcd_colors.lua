WCD.Colors 							= {};
WCD.Colors.frameBg 					= Color( 27, 27, 28, 180);
WCD.Colors.gradient					= Color( 27, 27, 28, 180 );
WCD.Colors.closeButton				= Color( 179, 20, 20 );
WCD.Colors.configureButton			= Color( 27, 27, 28, 180 );
WCD.Colors.saveButton				= Color( 27, 27, 28, 180 );
WCD.Colors.tooltipBg				= Color( 27, 27, 28, 180 );
WCD.Colors.selectButton				= Color( 27, 27, 28, 180 );
WCD.Colors.editButton				= Color( 27, 27, 28, 180 );

WCD.Colors.mainColor				= Color( 27, 27, 28, 180 );
WCD.Colors.line						= Color( 27, 27, 28, 180 );

WCD.Colors.menuButton				= { default = Vector( 27, 27, 28, 180 ), hover = Vector( 27, 27, 28, 180 ) };
WCD.Colors.actionButton				= { default = Vector( 27, 27, 28, 180 ), hover = Vector( 27, 27, 28, 180 ) };
WCD.Colors.starButton				= { default = Vector( 27, 27, 28, 180 ), hover = Vector( 27, 27, 28, 180 ) };

WCD.Colors.hud						= {
	bg = Color( 27, 27, 28, 180 ),
	border = Color( 27, 27, 28, 180 ),
	speedmeter = Color( 27, 27, 28, 180 ),
};

WCD.Colors.pump						= {
	bg = Color( 40, 40, 40, 120 ),
	bar = Color( 0, 168, 0, 120 ),
	barBg = Color( 60, 60, 60, 120 ),
	barBorder = Color( 0, 0, 0, 120 ),

	buttonAcceptBg = Color( 204, 102, 0 ),
	buttonBusyBg = Color( 168, 0, 0 ),
	buttonBorder = Color( 0, 0, 0 ),
};

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.color or "color" ) );
