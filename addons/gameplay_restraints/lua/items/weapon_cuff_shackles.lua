/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/

-------------------------------------
------- Cuffs Gmod DayZ Items -------
-------------------------------------
-------------------------------------
-- Created by Phoenix129, added    --
-- with permission                 --
-------------------------------------
ITEM = {}
ITEM.Name 		 =  "Handcuffs (Shackled)"
ITEM.Angle		 =  Angle(0,0,0)
ITEM.Desc		 =  "A shackled variant of handcuffs."
ITEM.Model		 =  "models/props_lab/box01a.mdl"
ITEM.Weight		 =  10
ITEM.LootType	 =  { "Weapon" }
ITEM.Price		 =  1000
ITEM.Credits		 =  100	
ITEM.SpawnChance  = 1
ITEM.DontStock = true
ITEM.Tertiary	 =  true
ITEM.SpawnOffset	 =  Vector(0,0,0)
ITEM.Weapon		 =  "weapon_cuff_shackles"
ITEM.ReqCraft = {"item_part_c", "item_part_b", "item_part_d", "item_part_c", "item_part_a", "weapon_cuff_standard"}
ITEM.EatFunction = function(ply, item) ply:DoProcess(item, "Eating", 5, "eat.wav", 0, "npc/barnacle/barnacle_gulp2.wav") end
ITEM.ProcessFunction	 =  function(ply, item) ply:EatHurt(item, 5, 50) end

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/