if SAM_LOADED then return end

local format, isstring, istable, tonumber = string.format, sam.isstring, sam.istable, tonumber

local config = {}

local SQL, _SQL = {}, nil

function SQL.Print(...)
	MsgC(
		Color(255, 255, 255), "(",
		Color(244, 67, 54), SQL.GetAddonName(),
		Color(255, 255, 255), " | ",
		Color(244, 67, 54), SQL.IsMySQL() and "MySQL" or "SQLite",
		Color(255, 255, 255), ") ",
		...
	)
	Msg("\n")
end

function SQL.Error(err, trace)
	SQL.Print(err, trace or debug.traceback("", 2))
end

function SQL.Connect()
	return _SQL.Connect(SQL.OnConnected, SQL.OnConnectionFailed, config)
end

do
	local in_transaction, old_query = false, nil

	function SQL.Begin()
		if in_transaction then
			return SQL.Error("transaction on going!")
		end
		in_transaction = true

		SQL.Query, old_query = _SQL.Begin(), SQL.Query
	end

	function SQL.Commit(callback)
		if not in_transaction then return end

		in_transaction = false
		SQL.Query, old_query = old_query, nil

		return _SQL.Commit(callback)
	end
end

local numbers = {} for i = 1, 9 do numbers[tostring(i)] = i end

local sub, find = string.sub, string.find
function SQL.FQuery(query, args, callback, first_row, callback_obj)
	local start, _end = nil, 0

	while true do
		start, _end = find(query, "{", _end + 1, true)
		if not start then break end

		local i = sub(query, start + 1, _end + 1)
		if not numbers[i] then continue end

		if sub(query, start + 2, _end + 2) ~= "}" then
			_end = _end + 1
			if sub(query, start + 3, _end + 2) ~= "}" then
				continue
			end
		end

		query = sub(query, 1, start - 1) .. SQL.Escape(args[numbers[i]], sub(query, start + 2, _end + 1) ~= "") .. sub(query, _end + 3)
	end

	return SQL.Query(query, callback, first_row, callback_obj)
end

do
	local table_exists = function(data, callback)
		callback(data and true or false)
	end

	function SQL.TableExists(name, callback)
		return SQL.Query(_SQL.TableExistsQuery(name), table_exists, true, callback)
	end
end

function SQL.IsMySQL()
	return config.MySQL == true
end

do
	local connected = false
	function SQL.IsConnected()
		return connected
	end
	function SQL.SetConnected(is_connected)
		connected = is_connected
	end
end

function SQL.Escape(value, no_quotes)
	local value_type = type(value)
	if value_type == "string" then
		return _SQL.EscapeString(value, no_quotes)
	elseif value_type == "number" then
		return value
	else
		error(
			format(
				"%s invalid type '%s' was passed to escape '%s'",
				"(" .. SQL.GetAddonName() .. " | " .. SQL.IsMySQL() and "MySQL" or "SQLite" .. ")",
				value_type,
				value
			)
		)
	end
end

function SQL.OnConnected()
	SQL.SetConnected(true)
	hook.Call(SQL.GetAddonName() .. ".DatabaseConnected")
end

function SQL.OnConnectionFailed(error_text)
	SQL.Error("Failed to connect to the server: " .. error_text)
	hook.Call(SQL.GetAddonName() .. ".DatabaseConnectionFailed", nil, error_text)
end

function SQL.SetConfig(new_config)
	if not istable(new_config) then return end
	if new_config.MySQL == true then
		for _, v in ipairs({"Host", "Username", "Password", "Database"}) do
			if not isstring(new_config[v]) then
				return SQL.Error(
					format("config value for '%s' is invalid '%s' needs to be a string!", v, config[v])
				)
			end
		end
		new_config.Port = tonumber(new_config.Port) or 3306
		_SQL = include("sam/libs/sql/databases/mysql.lua")
	else
		_SQL = include("sam/libs/sql/databases/sqlite.lua")
	end

	SQL.Query = _SQL.Query
	config = new_config
end

do
	local addon_name = "NO NAME"
	function SQL.SetAddonName(name)
		addon_name = name
	end
	function SQL.GetAddonName()
		return addon_name
	end
end

sam.SQL = SQL