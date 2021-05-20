if SAM_LOADED then return end

--[[
	Three's Derma Lib
	Made by Threebow

	You are free to use this anywhere you like, or sell any addons
	made using this, as long as I am properly accredited.
]]

local Lerp, RealFrameTime, ScrW, ScrH = Lerp, RealFrameTime, ScrW, ScrH
local RoundedBox, RoundedBoxEx, NoTexture = draw.RoundedBox, draw.RoundedBoxEx, draw.NoTexture
local SetDrawColor, DrawRect = surface.SetDrawColor, surface.DrawRect
local Round = math.Round

--[[
	Constants
]]
local BLUR = Material("pp/blurscreen")

local COL_WHITE_1 = Color(255, 255, 255)
local COL_WHITE_2 = Color(255, 255, 255, 30)

--[[
	Circle function - credit to Beast
]]
local draw_circle do
	local DrawPoly = surface.DrawPoly
	local rad, cos, sin = math.rad, math.cos, math.sin
	function draw_circle(circle, x, y, r)
		for i = 1, 360 do
			local w_e = rad(i * 360) / 360
			if not circle[i] then -- avoid creating 361 tables each frame lol
				circle[i] = {
					x = x + cos(w_e) * r,
					y = y + sin(w_e) * r
				}
			else
				circle[i].x, circle[i].y = x + cos(w_e) * r, y + sin(w_e) * r
			end
		end
		DrawPoly(circle)
	end
end

local copy_color = function(color)
	return Color(color.r, color.g, color.b, color.a)
end

local color_alpha = function(color, a)
	color.a = a
	return color
end

--[[
	Collection of various utilities
]]

local TDLibUtil = {}

function TDLibUtil.DrawCircle(circle, x, y, r, color)
	SetDrawColor(color)
	NoTexture()
	draw_circle(circle, x, y, r)
end

do
	local UpdateScreenEffectTexture, DrawTexturedRect, SetScissorRect = render.UpdateScreenEffectTexture, surface.DrawTexturedRect, render.SetScissorRect

	function TDLibUtil.BlurPanel(s)
		local x, y = s:LocalToScreen(0, 0)
		local scr_w, scr_h = ScrW(), ScrH()

		SetDrawColor(255, 255, 255)
		surface.SetMaterial(BLUR)

		for i = 1, 3 do
			BLUR:SetFloat("$blur", (i / 3) * 6)
			BLUR:Recompute()

			UpdateScreenEffectTexture()
			DrawTexturedRect(x * -1, y * -1, scr_w, scr_h)
		end
	end

	function TDLibUtil.DrawBlur(x, y, w, h)
		local scr_w, scr_h = ScrW(), ScrH()

		SetDrawColor(255, 255, 255)
		surface.SetMaterial(BLUR)

		for i = 1, 3 do
			BLUR:SetFloat("$blur", (i / 3) * 6)
			BLUR:Recompute()

			UpdateScreenEffectTexture()

			SetScissorRect(x, y, x + w, y + h, true)
				DrawTexturedRect(-1, -1, scr_w, scr_h)
			SetScissorRect(0, 0, 0, 0, false)
		end
	end
end

local LibClasses = {}

do
	local on_funcs = {}

	function LibClasses:On(name, func)
		local old_func = self[name]

		if not old_func then
			self[name] = func
			return self
		end

		local name_2 = name .. "_funcs"

		-- we gotta avoid creating 13535035 closures
		if not on_funcs[name] then
			on_funcs[name] = function(s, a1, a2, a3, a4)
				local funcs = s[name_2]
				local i, n = 0, #funcs
				::loop::
				i = i + 1
				if i <= n then
					funcs[i](s, a1, a2, a3, a4)
					goto loop
				end
			end
		end

		if not self[name_2] then
			self[name] = on_funcs[name]
			self[name_2] = {
				old_func,
				func
			}
		else
			table.insert(self[name_2], func)
		end

		return self
	end
end

do
	local RealTime = RealTime

	local transition_func = function(s)
		local transitions = s.transitions
		local i, n = 0, #transitions
		::loop::
		i = i + 1

		if i <= n then
			local v = transitions[i]
			local name = v.name
			local v2 = s[name]
			if v.func(s) then
				if v.start_0 then
					v.start_1, v.start_0 = RealTime(), nil
				end

				if v2 ~= 1 then
					s[name] = Lerp((RealTime() - v.start_1) / v.time, v2, 1)
				end
			else
				if v.start_1 then
					v.start_0, v.start_1 = RealTime(), nil
				end

				if v2 ~= 0 then
					s[name] = Lerp((RealTime() - v.start_0) / v.time, v2, 0)
				end
			end

			goto loop
		end
	end

	function LibClasses:SetupTransition(name, time, func)
		self[name] = 0

		local transition = {
			name = name,
			time = time,
			func = func,
			start_0 = 0,
			start_1 = 0,
		}

		if self.transitions then
			for k, v in ipairs(self.transitions) do
				if v.name == name then
					self.transitions[k] = transition
					return self
				end
			end
			table.insert(self.transitions, transition)
		else
			self.transitions = {transition}
			self:On("Think", transition_func)
		end

		return self
	end
end

function LibClasses:ClearPaint()
	self.Paint = nil
	self.Paint_funcs = nil
	self:SetPaintBackgroundEnabled(false)
	return self
end

do
	local fade_hover_Paint = function(s, w, h)
		if s.FadeHovers ~= 0 then
			color_alpha(s.fadehover_color, s.fadehover_old_alpha * s.FadeHovers)
			if s.fadehover_radius > 0 then
				RoundedBox(s.fadehover_radius, 0, 0, w, h, s.fadehover_color)
			else
				SetDrawColor(s.fadehover_color)
				DrawRect(0, 0, w, h)
			end
		end
	end

	function LibClasses:FadeHover(color, time, radius, func)
		color = copy_color(color or COL_WHITE_2)
		self.fadehover_color = color
		self.fadehover_radius = radius or 0
		self.fadehover_old_alpha = color.a
		self:SetupTransition("FadeHovers", time or 0.8, func or TDLibUtil.HoverFunc)
		self:On("Paint", fade_hover_Paint)
		return self
	end
end

function LibClasses:BarHover(color, height, time)
	color = color or COL_WHITE_1
	height = height or 2
	time = time or 1.6
	self:SetupTransition("BarHovers", time, TDLibUtil.HoverFunc)
	self:On("Paint", function(s, w, h)
		if s.BarHovers ~= 0 then
			local bar = Round(w * s.BarHovers)
			SetDrawColor(color)
			DrawRect((w / 2) - (bar / 2), h - height, bar, height)
		end
	end)
	return self
end

do
	local background_Paint_1 = function(s)
		s:SetBGColor(s.background_color)
	end

	local background_Paint_2 = function(s, w, h)
		RoundedBoxEx(s.background_radius, 0, 0, w, h, s.background_color, true, true, true, true)
	end

	local background_Paint_3 = function(s, w, h)
		RoundedBoxEx(s.background_radius, 0, 0, w, h, s.background_color, s.background_r_tl, s.background_r_tr, s.background_r_bl, s.background_r_br)
	end

	function LibClasses:Background(color, radius, r_tl, r_tr, r_bl, r_br)
		self.background_color = color
		if sam.isnumber(radius) and radius ~= 0 then
			self.background_radius = radius
			if sam.isbool(r_tl) or sam.isbool(r_tr) or sam.isbool(r_bl) or sam.isbool(r_br) then
				self.background_r_tl = r_tl
				self.background_r_tr = r_tr
				self.background_r_bl = r_bl
				self.background_r_br = r_br
				self:On("Paint", background_Paint_3)
			else
				self:On("Paint", background_Paint_2)
			end
		else
			self:SetPaintBackgroundEnabled(true)
			self:On("ApplySchemeSettings", background_Paint_1)
		end
		return self
	end
end

function LibClasses:CircleClick(color, speed, target_radius)
	color = copy_color(color or COL_WHITE_2)
	speed = speed or 5
	target_radius = sam.isnumber(target_radius) and target_radius or false

	local radius, alpha, click_x, click_y = 0, -1, 0, 0
	local old_alpha = color.a
	local circle = {}
	self:On("Paint", function(s, w)
		if alpha >= 0 then
			TDLibUtil.DrawCircle(circle, click_x, click_y, radius, color_alpha(color, alpha))
			local frame_time = RealFrameTime()
			radius, alpha = Lerp(frame_time * speed, radius, target_radius or w), Lerp(frame_time * speed, alpha, -1)
		end
	end)
	self:On("DoClick", function()
		click_x, click_y = self:CursorPos()
		radius, alpha = 0, old_alpha
	end)
	return self
end

-- https://github.com/Facepunch/garrysmod/pull/1520#issuecomment-410458090
function LibClasses:Outline(color, width)
	color = color or COL_WHITE_1
	width = width or 1
	self:On("Paint", function(s, w, h)
		SetDrawColor(color)
		DrawRect(0, 0, w, width)
		DrawRect(0, h - width, w, width)
		DrawRect(0, width, width, h - (width * 2))
		DrawRect(w - width, width, width, h - (width * 2))
	end)
	return self
end

function LibClasses:LinedCorners(color, len)
	color = color or COL_WHITE_1
	len = len or 15
	self:On("Paint", function(s, w, h)
		SetDrawColor(color)
		DrawRect(0, 0, len, 1)
		DrawRect(0, 1, 1, len - 1)
		DrawRect(w - len, h - 1, len, 1)
		DrawRect(w - 1, h - len, 1, len - 1)
	end)
	return self
end

function LibClasses:SideBlock(color, size, side)
	color = color or COL_WHITE_1
	size = size or 3
	side = side or LEFT
	self:On("Paint", function(s, w, h)
		SetDrawColor(color)
		if side == LEFT then
			DrawRect(0, 0, size, h)
		elseif side == TOP then
			DrawRect(0, 0, w, size)
		elseif size == RIGHT then
			DrawRect(w - size, 0, size, h)
		elseif side == BOTTOM then
			DrawRect(0, h - size, w, size)
		end
	end)
	return self
end

function LibClasses:Blur()
	self:On("Paint", TDLibUtil.BlurPanel)
	return self
end

local Panel = FindMetaTable("Panel")

function Panel:SAM_TDLib()
	for k, v in pairs(LibClasses) do
		self[k] = v
	end
	return self
end

local count = 0
TDLibUtil.Start = function()
	count = count + 1
	for k, v in pairs(LibClasses) do
		if not Panel["SAM_OLD" .. k] then
			local old = Panel[k]
			if old == nil then
				old = v
			end
			Panel[k], Panel["SAM_OLD" .. k] = v, old
		end
	end
end

TDLibUtil.End = function()
	count = count - 1
	if count > 0 then return end
	for k, v in pairs(LibClasses) do
		local old = Panel["SAM_OLD" .. k]
		if old == v then
			Panel[k] = nil
		else
			Panel[k] = old
		end
		Panel["SAM_OLD" .. k] = nil
	end
end

TDLibUtil.HoverFunc = function(p)
	return p:IsHovered() and not p:GetDisabled()
end

sam.TDLib = TDLibUtil