
local path = minetest.get_modpath("mobs")

-- Peaceful player privilege
minetest.register_privilege("peaceful_player", {
	description = "Prevents Mobs Redo mobs from attacking player",
	give_to_singleplayer = false
})

-- Mob API
dofile(path .. "/api.lua")

-- Mob API
dofile(path .. "/spawner.lua")

minetest.log("action", "[MOD] Mobs Redo loaded")
