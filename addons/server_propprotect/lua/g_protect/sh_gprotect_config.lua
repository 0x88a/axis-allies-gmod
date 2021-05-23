gProtect = gProtect or {}
gProtect.config = gProtect.config or {}

gProtect.config.Prefix = "[gProtect] "

gProtect.config.FrameSize = {x = 720, y = 530}

gProtect.config.SelectedLanguage = "en"

gProtect.config.StorageType = "sql_local" --- (sql_local, mysql)

gProtect.config.EnableOwnershipHUD = true

gProtect.config.permissions = {
	["gProtect_Settings"] = { -- This is for modifying the values in gProtect
		["owner"] = true,
		["superadmin"] = true
	},
	["gProtect_StaffNotifications"] = { -- These groups will receive notifications from detections
		["owner"] = true,
		["superadmin"] = true
	},
	["gProtect_DashboardAccess"] = { -- These groups will receive notifications from detections
		["owner"] = true,
		["superadmin"] = true
	}
}