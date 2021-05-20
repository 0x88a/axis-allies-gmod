/* Este archivo contiene la versión en español de WCD.
Traducido por Chisma944 el (4/3/2019) ( https://steamcommunity.com/profiles/76561198017874358/ ) */

WCD.Lang 												= WCD.Lang or {};

/* SHARED VARIABLES */
WCD.Lang.fileNames										= WCD.Lang.fileNames or {};

WCD.Lang.fileNames.utility 								= "Utilidad";
WCD.Lang.fileNames.color								= "Color";
WCD.Lang.fileNames.settings								= "Ajustes";
WCD.Lang.fileNames.adminui								= "UI del Admin";
WCD.Lang.fileNames.dealerui								= "UI del Vendedor";
WCD.Lang.fileNames.various								= "Varios";
WCD.Lang.fileNames.vgui									= "VGUI";
WCD.Lang.fileNames.net									= "Redes";
WCD.Lang.fileNames.clientsettings						= "Ajustes de Usuario";
WCD.Lang.fileNames.storage								= "Almacenamiento";
WCD.Lang.fileNames.main									= "Principal";
WCD.Lang.fileNames.vehicledata							= "Data del vehiculo";
WCD.Lang.fileNames.minimal								= "Ayudantes mínimos";
WCD.Lang.fileNames.dealer								= "Funcionalidad del vendedor";
WCD.Lang.fileNames.customization						= "Funcionalidad de personalización";
WCD.Lang.fileNames.fuel									= "Control de la gasolina";
WCD.Lang.fileNames.visual								= "Visual";
WCD.Lang.fileNames.designer								= "Vista de diseñador";
WCD.Lang.fileNames.phystool								= "Restricciones de Physics & Toolgun";

WCD.Lang.loadedLang										= "Idioma Cargado!";
WCD.Lang.loadedWrapper									= "Wrapper: '[1]' ha sido cargado!";
WCD.Lang.loadedFile										= "File: '[1]' ha sido cargado!";

WCD.Lang.invalidSetting									= "Ajuste con llave '[1]' no existe!";
WCD.Lang.invalidTypeSetting								= "Ajuste con llave '[1]' enviado como tipo '[2]', tipo esperado '[3]'!";
WCD.Lang.updatedSetting									= "Ajuste '[1]' se ha cambiado a '[2]'";

WCD.Lang.files											= WCD.Lang.files or {};
WCD.Lang.files.startCreate								= "Se va a crear la carpeta de datos 'wcd'..";
WCD.Lang.files.failCreate								= "NO SE HA PODIDO CREAR: 'wcd'! Los datos no se guardarán!";
WCD.Lang.files.informOne								= "Error al crear la carpeta de datos 'wcd'! No se guardarán datos!";
WCD.Lang.files.informTwo								= "Intenta crearlo manualmente en el directorio 'garrysmod/data/' de tu server!";
WCD.Lang.files.successCreate							= "Successfully created the 'wcd' data folder.";
WCD.Lang.files.fileLoaded								= "Archivo de datos cargados '[1]', que contiene [2] valores.";
WCD.Lang.files.fileNotFound								= "Archivo '[1]' no ha sido encontrado, debe ser creado cuando sea necesario.";
WCD.Lang.files.beginLoading								= "Se van a cargar todos los ajustes...";
WCD.Lang.files.savingTable								= "Guardando tabla: '[1]'";

// this refers to the HUD positioning setting
WCD.Lang.Positions										= WCD.Lang.Positions or {};
WCD.Lang.Positions[ 1 ]									= "Arriba";
WCD.Lang.Positions[ 2 ]									= "Abajo";
WCD.Lang.Positions[ 3 ]									= "Izq.";
WCD.Lang.Positions[ 4 ]									= "Dech.";

// hud speedometer setting
WCD.Lang.Units											= WCD.Lang.Units or {};
WCD.Lang.Units[ 1 ] 									= "km/h";
WCD.Lang.Units[ 2 ] 									= "mp/h";

WCD.Lang.adminGun										= WCD.Lang.adminGun or {};
WCD.Lang.adminGun.instructions 							= "Haz clic izquierdo en el vendedor: Editar vendedor\nHaz clic izquierdo en el suelo: spawnear nuevo vendedor\nClic derecho en el suelo: Spawnear nuevo depósito de gasolina\nClic izquierdo en el depósito: Guardar\nHaga clic derecho en el depósito: Deshacer";
WCD.Lang.adminGun.invalidRank 							= "No tienes permiso para utilizar esta herramienta.";
WCD.Lang.adminGun.aimHelp 								= "Apunta a un terreno vacío, vendedor o depósito.";
WCD.Lang.adminGun.saved 								= "Se han guardado nuevos datos y spawns del vendedor!";
WCD.Lang.adminGun.savedPump								= "El depósito se ha guardado.";
WCD.Lang.adminGun.deletedPump 							= "El depósito se ha borrado.";
WCD.Lang.adminGun.deleted 								= "El distribuidor y los datos relacionados han sido eliminados.";

WCD.Lang.adminGun.settings 								=	WCD.Lang.adminGun.settings or {};
WCD.Lang.adminGun.settings[ 1 ]							=	{ key = "name", name = "Nombre", tooltip = "El nombre del vendedor", type = "string" };
WCD.Lang.adminGun.settings[ 2 ] 						=	{ key = "model", name = "Modelo", tooltip = "El modelo del vendedor", type = "string" };
WCD.Lang.adminGun.settings[ 3 ] 						=	{ key = "group", name = "Grupo", tooltip = "A qué grupo de distribuidores está asignado este distribuidor", type = "combobox", values = "DealerGroups" };
WCD.Lang.adminGun.settings[ 4 ] 						=	{ key = "disableGarage", nwbool = true, name = "Deshabilitar Garage", tooltip = "Activa esto para que el vendedor solo venda vehiculos", type = "checkbox" };
WCD.Lang.adminGun.settings[ 5 ] 						=	{ key = "disableShop", nwbool = true, name = "Deshabilitar Tienda", tooltip = "Activa esto para que el vendedor solo sirva como garage", type = "checkbox" };

WCD.Lang.adminGun.settings[ 6 ] 						=	{ key = "newPlatform", name = "Nueva plataforma de spawn", tooltip = "Crea un nuevo spawn de vehiculos", type = "button" };
WCD.Lang.adminGun.settings[ 7 ] 						=	{ key = "deleteAllPlatform", name = "Borrar todas las plataformas (total: [1])", tooltip = "Eliminar todas las plataformas vinculadas a este vendedor", type = "button" };


if( SERVER ) then
	WCD.Lang.initPlayer									= WCD.Lang.initPlayer or {};
	WCD.Lang.initPlayer.begin							= "Cargando jugador [1]";

	WCD.Lang.various									= WCD.Lang.various or {};
	WCD.Lang.various.noGroup 							= "Aún no me han asignado un grupo.!";
	WCD.Lang.various.cantAffordSpawn 					= "No puedes permitirte spawnear un vehículo.. ([1])";
	WCD.Lang.various.noFreeSpot 						= "No hay un lugar libre para su vehículo, por favor espere a que el área se despeje.";
	WCD.Lang.various.customizationBought 				= "Has pagado [1] para la personalización.";
	WCD.Lang.various.maxCarsSpawned 					= "Necesitas devolver un vehículo primero.";
	WCD.Lang.various.youReturned 						= "Devolviste tu vehiculo.";
	WCD.Lang.various.youPaidToSpawn 					= "Has pagado [1] para spawnear tu vehiculo.";
	WCD.Lang.various.noneInRange 						= "Ninguno de sus vehículos está dentro del alcance.";
	WCD.Lang.various.initializing 						= "Solicitando al concesionario vehículos específicos del servidor.. (esto solo será una vez)";
	WCD.Lang.various.loadingDone 						= "Inicialización completa!";
	WCD.Lang.various.youSold 							= "Has vendido [1] por [2].";
	WCD.Lang.various.youBought 							= "Has comprado [1] por [2].";
	WCD.Lang.various.inUse 								= "Este depósito está actualmente en uso, por favor espere.";
	WCD.Lang.various.cantAffordFuel 					= "No puedes permitirte ningún combustible!";
	WCD.Lang.various.noPlayerFound 						= "No se encontró el jugador o sus datos!";
	WCD.Lang.various.vehiclesEdited 					= "Los vehículos de los objetivos han sido actualizados.";
	WCD.Lang.various.yourVehiclesUpdated 				= "Tus vehículos fueron actualizados por [1].";
	WCD.Lang.various.speedingWantedReason 				= "Superando el límite de velocidad";
	WCD.Lang.various.refundedVehicleRemoved 			= "Te devolvieron [1] debido a un vehículo de tu propiedad ha sido retirado.";
else

	WCD.Lang.dealerButtonsLeft							= WCD.Lang.dealerButtonsLeft or {};
	WCD.Lang.dealerButtonsLeft							= {
		"Tienda", "Tus Vehiculos", "Restringidos", "Favoritos"
	};


	WCD.Lang.dealerActionButtons						= WCD.Lang.dealerActionButtons or {};
	WCD.Lang.dealerActionButtons.buy 					= "Comprar";
	WCD.Lang.dealerActionButtons.sell 					= "Vender por [1]";
	WCD.Lang.dealerActionButtons.test 					= "Testear";
	WCD.Lang.dealerActionButtons.spawn 					= "Spawn";
	WCD.Lang.dealerActionButtons.spawnCustomize 		= "Spawn & Personalizar";
	WCD.Lang.dealerActionButtons.sure 					= "¿Estás seguro?";
	WCD.Lang.dealerActionButtons.noAfford 				= "No puedes permitirte este vehículo!";
	WCD.Lang.dealerActionButtons.sold 					= "Vendiste el vehiculo por [1].";

	WCD.Lang.dealerVarious								= WCD.Lang.dealerVarious or {};
	WCD.Lang.dealerVarious.canBeCustomized 				= "Este vehículo puede ser personalizado!";
	WCD.Lang.dealerVarious.canNotBeCustomized 			= "Este vehículo no puede ser personalizado.";
	WCD.Lang.dealerVarious.customize 					= "Spawn & personalizar";
	WCD.Lang.dealerVarious.wallet 						= "Cartera: [1]";

	WCD.Lang.adminMenuButtons			= {
		"Configuración",
		"Vehiculos",
		"Usuarios"
	};
	
	WCD.Lang.pump										= WCD.Lang.pump or {};
	WCD.Lang.pump.title 								= "GASOLINERA";
	WCD.Lang.pump.info 									= {
		"Aceptar para desbloquear la manguera,",
		"coloque la manguera en su vehículo",
		"para empezar a llenarlo de combustible.",
	};

	WCD.Lang.pump.price 								= "Cada litro costará [1].";
	WCD.Lang.pump.start 								= "Aceptar";
	WCD.Lang.pump.cancel 								= "Cancelar";

	WCD.Lang.clientSettingsPanel						= WCD.Lang.clientSettingsPanel or {};
	WCD.Lang.clientSettingsPanel.desc 					= 
[[¡Estas son los ajustes del cliente de WCD!
Coloca el cursor sobre una opción para leer la información sobre esta.
Puedes cambiar estos ajustes más tarde desde un vendedor de vehiculos.]];

	WCD.Lang.clientSettingsPanel.save 					= "La configuración se ha actualizado!";
	WCD.Lang.clientSettingsPanel.data 					= WCD.Lang.clientSettingsPanel.data or {};
	WCD.Lang.clientSettingsPanel.data[ 1 ] 				= { key = "CacheOnReceive", name = "Guardar en caché todos los modelos cuando se reciben", tooltip = "¿Se deben almacenar en caché todos los coches cuando se reciben del server?\nSi está marcado, abrir un vendedor\nPodría congelar tu juego por unos instantes.\nDeja esto desmarcado si tienes una ordenador débil.", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 2 ] 				= { key = "MoveableModel", name = "Modelo de vista previa ajustable", tooltip = "¿Quieres poder mover el modelo del coche\ncon el ratón, en el menú del vendedor? (no afecta al rendimiento)", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 3 ] 				= { key = "SpinModel", name = "Modelo de vista previa giratorio", tooltip = "¿Quieres que el coche gire?\n(sin efecto si se usa el modelo ajustable)", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 4 ] 				= { key = "SortAsc", name = "Ordenar los coches en ascenso (los más baratos primero)", tooltip = "¿Quieres ver los\ncoches más baratos en la parte superior?", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 5 ] 				= { key = "Language", name = "Idioma", tooltip = "Elige el idioma.", type = "combobox", values ="Languages" };
	WCD.Lang.clientSettingsPanel.data[ 6 ]				= { key = "Fullscreen", name = "Pantalla completa", tooltip = "¿Quieres que la interfaz del vendedor esté en pantalla completa?", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 7 ] 				= { key = "DefaultDealerTab", name = "Pestaña por defecto", tooltip = "¿Qué pestaña te gustaría que se muestre por defecto?", type = "combobox", values = "dealerButtonsLeft", global = true };

	WCD.Lang.invalidSettingValue						= "El campo '[1]' tiene un valor inválido! Por favor, edite esto antes de continuar.";
	WCD.Lang.clientSettings								= "Ajustes";
	WCD.Lang.dealerTop									= "Concesionario de vehículos";
	WCD.Lang.addFavorite								= "Añadir a Favoritos";
	WCD.Lang.removeFavorite								= "Borrar de favoritos ";
	WCD.Lang.save										= "Guardar";
	WCD.Lang.select 									= "Seleccionar";
	WCD.Lang.delete										= "Borrar";
	WCD.Lang.sureShort									= "¿Seguro?";
	WCD.Lang.edit										= "Editar";
	WCD.Lang.choiceSaved								= "Tu elección ha sido guardada.";
	WCD.Lang.active										= "Activar valor: [1]";
	WCD.Lang.unselect									= "Deseleccionar";
	WCD.Lang.none										= "Ninguno";
	WCD.Lang.free										= "Gratis";
	WCD.Lang.sure										= "¿Estás seguro?";
	WCD.Lang.returnVehicles								= "Devolver vehiculos";
	WCD.Lang.fuel										= " litros";
	WCD.Lang.nitroActivated 							= "Nitro Activado";
	WCD.Lang.nitroReady									= "Nitro Listo";

	WCD.Lang.requestingAllVehicles						= "Solicitando vehículos del servidor..";
	WCD.Lang.visibleFor									= "Visible por: ";

	WCD.Lang.settingsSent								= "Configuraciones enviadas al servidor.";
	WCD.Lang.settingsReceived							= "Nuevos ajustes recibidos.";

	WCD.Lang.noSettingsChanged							= "No se cambiaron los ajustes!";

	WCD.Lang.designer									= WCD.Lang.designer or {};
	WCD.Lang.designer.cantBeCustomized 					= "Este vehículo no puede ser personalizado..";
	WCD.Lang.designer.purchase 							= "Comprar";
	WCD.Lang.designer.reset 							= "Reinicio completo";
	WCD.Lang.designer.confirmReset 						= "Pagar: [x]?";
	WCD.Lang.designer.spaceToToggleMouse 				= "Presiona espacio para alternar el cursor";
	WCD.Lang.designer.price 							= "[1]";
	WCD.Lang.designer.pricePerChange 					= "[1] por cambio";
	WCD.Lang.designer.skinCounter 						= "[1] de [2]";
	WCD.Lang.designer.underglow 						= "Las luces de neón se alternan con 'G'";
	WCD.Lang.designer.nitroLevel 						= "Nivel de nitro [1]";
	WCD.Lang.designer.uninstall 						= "Desinstalar";
	WCD.Lang.designer.totalPrice 						= "Precio total: [1]";
	WCD.Lang.designer.cantAfford 						= "No tienes [1] para pagar las modificaciones.";

	WCD.Lang.designer.buttons 							= WCD.Lang.designer.buttons or {};
	WCD.Lang.designer.buttons[ 1 ] 						= { key = "skin", name = "Skin" };
	WCD.Lang.designer.buttons[ 2 ] 						= { key = "color", name = "Color" };
	WCD.Lang.designer.buttons[ 3 ] 						= { key = "bodygroups", name = "Bodygroups" };
	WCD.Lang.designer.buttons[ 4 ] 						= { key = "underglow", name = "Luces de Neón" };
	WCD.Lang.designer.buttons[ 5 ] 						= { key = "nitro", name = "Nitro" };

	WCD.Lang.allowedInputs								= WCD.Lang.allowedInputs or {};
	WCD.Lang.allowedInputs.string						= "solo texto";
	WCD.Lang.allowedInputs.numberMinMax		 			= "número entre [1] - [2]";
	WCD.Lang.allowedInputs.seconds		 				= "número, segundos";
	WCD.Lang.allowedInputs.number						= "0 o mayor";

	WCD.Lang.AccessHelper								= WCD.Lang.AccessHelper or {};
	WCD.Lang.AccessHelper.create 						= "Nuevo grupo de acceso";
	WCD.Lang.AccessHelper.editing 						= "Editando [1]";
	WCD.Lang.AccessHelper.jobs 							= "Seleccionar trabajos";
	WCD.Lang.AccessHelper.ranks 						= "Seleccionar rangos";
	WCD.Lang.AccessHelper.needBoth 						= "Require ambos rango + trabajo";
	WCD.Lang.AccessHelper.newGroupName 					= "Nuevo nombre del grupo";
	WCD.Lang.AccessHelper.needName 						= "Necesitas insertar un nombre para el grupo!";
	WCD.Lang.AccessHelper.existingGroups 				= "Grupos de acceso existentes";

	WCD.Lang.DealerHelper								= WCD.Lang.DealerHelper or {};
	WCD.Lang.DealerHelper.create 						= "Nuevo grupo de vendedor";
	WCD.Lang.DealerHelper.editing 						= "Editando [1]";
	WCD.Lang.DealerHelper.needName 						= "Necesitas insertar un nombre para el grupo!";
	WCD.Lang.DealerHelper.newGroupName 					= "Nuevo nombre del grupo";
	WCD.Lang.DealerHelper.existingGroups 				= "Grupos de acceso existentes";

	WCD.Lang.adminTabs									= WCD.Lang.adminTabs or {};
	WCD.Lang.adminTabs.settings							= WCD.Lang.adminTabs.settings or {};
	WCD.Lang.adminTabs.settings.title 					= "Ajustes";
	WCD.Lang.adminTabs.settings.desc 					=
[[-Estos son todos los ajustes que se pueden editar! Edítelos aquí, no a través
del archivo wcd_settings.lua (pueden ser anulados). -Solo la configuración deMySQL y los rangos que tienen acceso a !wcd deben editarse a través de
los archivos: wcd_settings.lua (rangos) y server/wcd_storage.lua (MySQL).
-Desplaza el ratón sobre una opción para obtener más información sobre esta.
-CONSEJO: Puede desplazarse hacia arriba/abajo!]];

	WCD.Lang.adminTabs.settings.content 				= WCD.Lang.adminTabs.settings.content or {};
	WCD.Lang.adminTabs.settings.content[ 1 ] 			= { key = "header", text = "Ajustes Generales" };
	WCD.Lang.adminTabs.settings.content[ 2 ] 			= { key = "fuel", name = "Habilitar gasolina", tooltip = "¿Debería usarse la gasolina de WCD?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 3 ] 			= { key = "fuelMultiplier", name = "Multiplicador de consumo de combustible global", tooltip = "1 = por defecto. 0.5 = 50% menos de combustible consumido. 1.5 = 50% más, etc", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 4 ] 			= { key = "nitro", name = "Habilitar Nitro", tooltip = "¿Se puede comprar/usar nitro?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 5 ] 			= { key = "nitroPower", name = "Modificador de energía nitro", tooltip = "1 = normal, 1.5 = 50% más alto, 0.5 = 50% menos, etc", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 6 ] 			= { key = "nitroCooldown", name = "Espera de nitro", tooltip = "Segundos que hay que esperar para usar el nitro", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 7 ] 			= { key = "fuelCost", name = "Costo de combustible por litro", tooltip = "¿Cuánto cuesta 1L de combustible?", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 8 ] 			= { key = "logData", name = "Registrar compras/ventas", tooltip = "¿Las compras/ventas deben registrarse en la carpeta de datos?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 9 ] 			= { key = "showFuel", name = "Mostrar medidor de combustible", tooltip = "¿Debería mostrarse el medidor de combustible en el HUD?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 10 ] 			= { key = "showSpeed", name = "Mostrar medidor de velocidad", tooltip = "¿Debería mostrarse el medidor de velocidad en el HUD?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 11 ] 			= { key = "speedUnits", name = "Unidades de medidor de velocidad", tooltip = "¿Qué unidades de medidor de velocidad deben usarse?", type = "combobox", values = "Units" };
	WCD.Lang.adminTabs.settings.content[ 12 ] 			= { key = "fuelPos", name = "Posición de HUD", tooltip = "El medidor de combustible puede ser:\narriba/abajo = horizontal,\nIZQ./DECH. = vertical", type = "combobox", values = "Positions" };
	WCD.Lang.adminTabs.settings.content[ 13 ] 			= { key = "autoEnter", name = "Entrar automaticamente al vehiculo", tooltip = "¿Deberían los jugadores entrar automáticamente en su vehículo cuando se spawnee?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 14 ] 			= { key = "disallowCustomization", name = "Deshabilitar la personalización", tooltip = "Esto significa que todos los vehículos por defecto no pueden ser personalizados,\nPero puedes permitir manualmente vehículos específicos.", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 15 ] 			= { key = "autoLock", name = "Vehiculos Auto-Cerrados", tooltip = "¿Deben los coches aparecer cerrados?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 16 ] 			= { key = "autoWantSpeed", name = "[Radar Manual] Poner Wanted al pasar límite de velocidad", tooltip = "Si se utiliza el Radar manual, ¿a que velocidad habria que poner wanted?", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 17 ]			= { key = "maxCarsSpawned", name = "Máximo de vehiculos", tooltip = "Cuántos vehículos puede tener un jugador.", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 18 ] 			= { key = "fuelTankAmount", name = "Combusible del depísto de gasolina", tooltip = "¿Cuánto combustible le da a un vehículo el depósito de gasolina?", type = "number", input = "number" };

	WCD.Lang.adminTabs.settings.content[ 19 ] 			= { key = "saveFuel", name = "Guardar combustible", tooltip = "¿Deberían los coches generar con la cantidad de combustible que tenían cuando fueron removidos?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 20 ] 			= { key = "language", name = "Idioma", tooltip = "¡Esto es solo el idioma del SERVIDOR!\nLos jugadores pueden seleccionar su propio idioma en el menú del Vendedor o la primera vez que se unen", type = "combobox", values = "Languages" };
	WCD.Lang.adminTabs.settings.content[ 21 ] 			= { key = "returnRange", name = "Distancia de devolución", tooltip = "¿Desde que distacia se pueden devolver vehiculos?", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 22 ] 			= { key = "saveVcmodHealth", name = "Guardar/Aplicar El estado de VCMod", tooltip = "(solo funciona si tienes vcmod), los autos guardarán las partes dañadas", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 23 ] 			= { key = "saveVcmodFuel", name = "Guardar/Aplicar El combustible de VCMod", tooltip = "(solo funciona si tienes vcmod), los autos guardarán sus depósitos de gasolina", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 24 ] 			= { key = "autoSellCarsWhenRemoved", name = "Auto-vender vehiculos", tooltip = "Auto-vender automáticamente autos (como si los jugadores vendieran el auto), cuando retiras un auto.", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 25 ]			= { key = "allowEntityCustomization", name = "Permitir la personalización de la entidad", tooltip = "(CONSIDERAR esto experimental)", type = "bool" };

	WCD.Lang.adminTabs.settings.content[ 26 ] 			= { key = "header", text = "Ajustes de Vendedor" };
	WCD.Lang.adminTabs.settings.content[ 27 ] 			= { key = "testDriving", name = "Permitir prueba de conducción", tooltip = "¿Pueden los jugadores probar los vehículos?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 28 ] 			= { key = "testDrivingTime", name = "Tiempo de prueba", tooltip = "¿Por cuánto tiempo se puede probar un vehículo?", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 29 ] 			= { key = "spawnDelay", name = "Tiempo de Spawn", tooltip = "Tiempo de espera (en segundos) entre spawn y spawn de vehículos", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 30 ] 			= { key = "spawnCost", name = "Costo de Spawn", tooltip = "Precio al spawnear un vehiculo", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 31 ] 			= { key = "percentage", name = "Porcentaje de venta", tooltip = "¿Que porcentaje recibe un jugador cuando vende su vehiculo?", type = "number", input = "numberMinMax", min = 0, max = 100 };

	WCD.Lang.adminTabs.settings.content[ 32 ] 			= { key = "header", text = "Valores predeterminados del vehículo (al agregar un vehículo nuevo)" };
	WCD.Lang.adminTabs.settings.content[ 33 ] 			= { key = "fuelTank", name = "Tamaño predeterminado del tanque de combustible", tooltip = "Tamaño predeterminado del tanque de combustible", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 34 ] 			= { key = "skinCost", name = "Precio de personalización de skin", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 35 ] 			= { key = "bodygroupCost", name = "Precio de personalización de bodygroups", tooltip = "(Price is per bodygroup)", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 36 ] 			= { key = "colorCost", name = "Precio de personalización de color", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 37 ] 			= { key = "nitroOneCost", name = "Precio de nivel de nitro uno", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 38 ] 			= { key = "nitroTwoCost", name = "Precio de nivel de nitro dos", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 39 ]			= { key = "nitroThreeCost", name = "Precio de nivel de nitro tres", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 40 ] 			= { key = "underGlowCost", name = "Precio para las lucen de neón", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 41 ] 			= { key = "fullResetCost", name = "Costo de reinicio completo", tooltip = "", type = "number" };

	WCD.Lang.adminTabs.vehicles							= WCD.Lang.adminTabs.vehicles or {};
	WCD.Lang.adminTabs.vehicles.selectVehicle 			= "Seleccione una base de vehículo";
	WCD.Lang.adminTabs.vehicles.editVehicle 			= "Seleccione un vehículo para editar";
	WCD.Lang.adminTabs.vehicles[ "or" ] 				= "o";
	WCD.Lang.adminTabs.vehicles.select 					= "Crear nuevo vehículo";
	WCD.Lang.adminTabs.vehicles.edit 					= "Editar";
	WCD.Lang.adminTabs.vehicles.editing 				= "Editando vehiculo";
	WCD.Lang.adminTabs.vehicles.selecting 				= "Creación de vehículo (base: [1])";
	WCD.Lang.adminTabs.vehicles.active					= "Activar: [1]";
	WCD.Lang.adminTabs.vehicles.invalidSelection 		= "Selección inválidad!";
	WCD.Lang.adminTabs.vehicles.invalidValues 			= "El campo '[1]' contiene valores inválidos!";

	WCD.Lang.adminTabs.vehicles.content 				= WCD.Lang.adminTabs.vehicles.content or {};
	WCD.Lang.adminTabs.vehicles.content[ 1 ] 			= { key = "header", text = "[1]" };
	WCD.Lang.adminTabs.vehicles.content[ 2 ] 			= { key = "name", name = "Nombre", tooltip = "Bajo qué nombre se mostrará el vehículo", type = "string" };
	WCD.Lang.adminTabs.vehicles.content[ 3 ] 			= { key = "free", name = "Gratis", tooltip = "¿Debería ser gratis el vehículo? (recomendado para coches de policía, etc)", type = "bool", default = false };
	WCD.Lang.adminTabs.vehicles.content[ 4 ] 			= { key = "fuel", name = "Tamaño del tanque de combustible", tooltip = "Maximo combustible en el vehiculo", type = "number", min = 0, default = 70, notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 5 ] 			= { key = "fuelMulti", name = "Multiplicador de consumo de combustible", tooltip = "Si desea que el vehículo consuma más/menos combustible que otros (1 es el valor predeterminado, 0,75 = 25% menos, etc)", type = "number", input = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 6 ] 			= { key = "price", name = "Precio", tooltip = "Costo del vehiculo", type = "number", min = 0 };
	WCD.Lang.adminTabs.vehicles.content[ 7 ] 			= { key = "noFuel", name = "Combustible ilimitado", tooltip = "¿Deberia tener el vehiculo combustible ilimitado?", type = "bool", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 8 ] 			= { key = "nitro", name = "Nitro preinstalado", tooltip = "Nivel de nitro que viene preinstalado", type="combobox", values = { 0, 1, 2, 3 }, notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 9 ] 			= { key = "ownedPriority", name = "Prioridad del propietario", tooltip = "Marcado = la gente puede generar este vehículo siempre que lo posea,\nincluso si ya no tienen acceso.", type="bool" };

	WCD.Lang.adminTabs.vehicles.content[ 10 ] 			= { key = "header", text = "Precios de personalización" };
	WCD.Lang.adminTabs.vehicles.content[ 11 ] 			= { key = "bodygroupCost", name = "Precio por cambio de bodygroup", tooltip = "¿Cuánto cuesta cambiar un bodygroup?", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 12 ] 			= { key = "skinCost", name = "Precio por personalizar la skin", tooltip = "¿Cuánto cuesta editar la skin?", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 13 ] 			= { key = "nitroOneCost", name = "Precio por Nitro nivel uno", tooltip = "¿Cuánto cuesta actualizar a Nitro nivel uno?", type = "number", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 14 ] 			= { key = "nitroTwoCost", name = "Precio por Nitro nivel dos", tooltip = "¿How much it costs to upgrade to Nitro level dos?", type = "number", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 15 ] 			= { key = "nitroThreeCost", name = "Precio por Nitro nivel tres", tooltip = "¿How much it costs to upgrade to Nitro level tres?", type = "number", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 16 ] 			= { key = "colorCost", name = "Precio para editar el color", tooltip = "Cuánto cuesta editar el color del vehículo?", type = "number" };
	WCD.Lang.adminTabs.vehicles.content[ 17 ] 			= { key = "underglowCost", name = "Prrecio para editar las luces de neón", tooltip = "¿Cuánto cuesta editar las luces de neón?", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 18 ] 			= { key = "spawnCost", name = "Precio para Spawnear", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.vehicles.content[ 19 ] 			= { key = "spawnDelay", name = "Tiempo de espera de spawn", tooltip = "Tiempo de espera de spawn en segundos para poder volver a spawnear otro auto", type = "number" };

	WCD.Lang.adminTabs.vehicles.content[ 20 ] 			= { key = "header", text = "Varios" };
	WCD.Lang.adminTabs.vehicles.content[ 21 ] 			= { key = "color", name = "Color por defecto", tooltip = "Si quieres que el vehículo spawnee con un color determinado.", type = "display_color" };
	WCD.Lang.adminTabs.vehicles.content[ 22 ] 			= { key = "bodygroups", name = "Bodygroups por defecto", tooltip = "Si quieres que el vehículo spawnee con bodygroups determinados", type = "display_bodygroups", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 23 ] 			= { key = "skin", name = "Skin por defecto", tooltip = "Si quieres que el vehiculo spawnee con una skin especifica", type = "display_skin", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 24 ] 			= { key = "access", name = "Accceso", tooltip = "¿Qué rangos/trabajos pueden acceder a este vehículo. DEJAR VACÍO PARA TODOS!", type = "display_access" };
	WCD.Lang.adminTabs.vehicles.content[ 25 ] 			= { key = "dealer", name = "Vendedores", tooltip = "¿Qué concesionarios venden este vehículo?", type = "display_dealers" };

	WCD.Lang.adminTabs.vehicles.content[ 26 ] 			= { key = "header", text = "Personalizaciones permitidas", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 27 ] 			= { key = "disallowCustomization", name = "Deshabilitar todas las personalizaciones", tooltip = "Con esto marcado, todos los otros permisos sern automáticamente deshabilitados.", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 28 ] 			= { key = "disallowNitro", name = "Deshabilitarnitro mejoras", tooltip = "¿Se puede comprar/usar la actualización nitro?", type = "bool", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 29 ] 			= { key = "disallowSkin", name = "Deshabilitar cambios de skin", tooltip = "¿Se puede personalizar la skin?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 30 ] 			= { key = "disallowColor", name = "Deshabilitar cambios de color", tooltip = "¿Se puede personalizar el color?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 31 ] 			= { key = "disallowBodygroup", name = "Deshabilitar cambios de bodygroup", tooltip = "¿Se puede personalizar los bodygroups?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 32 ] 			= { key = "disallowUnderglow", name = "Deshabilitar cambios de luces de neón", tooltip = "¿Se puede personalizar las luces de neón?", type = "bool", notForEnt = true };

	WCD.Lang.adminTabs.users							= WCD.Lang.adminTabs.users or {};
	WCD.Lang.adminTabs.users.selectUser 				= "Seleccione un jugador en línea";
	WCD.Lang.adminTabs.users.inputSteam 				= "Escribe la Steam ID (formato 32)";
	WCD.Lang.adminTabs.users[ "or" ] 					= "o";
	WCD.Lang.adminTabs.users.selectUserButton 			= "Seleccionar jugador";
	WCD.Lang.adminTabs.users.inputSteamButton 			= "Recuperar datos del jugador";
end

/* Este archivo contiene la versión en español de WCD.
Traducido por Chisma944 el (4/3/2019) ( https://steamcommunity.com/profiles/76561198017874358/ ) */