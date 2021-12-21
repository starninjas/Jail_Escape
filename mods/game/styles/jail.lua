
 --      _       _ _ 
 --     | |     (_) |
 --     | | __ _ _| |
 -- _   | |/ _` | | |
 --| |__| | (_| | | |
 -- \____/ \__,_|_|_|
 
 game = {}
 
--- Node Registrations

minetest.register_node("game:jail_ground", {
  description = "Jail Ground",
  tiles = {"jail_ground.png"},
  on_blast = function() end,
  on_destruct = function () end,
})

-- wall sounds, if anyone tries breaking a wall
function game.break_sound(table)
	table = table or {}
	table.dug = table.dug or
			{name = "break_dug", gain = 1}
	table.dig = table.dig or
			{name = "break", gain = 0.25}
	return table
end

minetest.register_node("game:jail_wall", {
  description = "Jail Wall",
  tiles = {"jail_wall.png"},
  groups = {breakable = 4},
  sounds = game.break_sound(),
  drop = ""
})

minetest.register_node("game:jail_ceiling", {
  description = "Jail Ceiling",
  tiles = {"jail_ceiling.png"},
  sunlight_propagates = true,
  drop = ""
})

--- Trash Cans (when broke, drop junk)

-- the trash sounds

function game.trash_sound(table)
	table = table or {}
	table.dug = table.dug or
			{name = "trash_can_dug", gain = 10}
	table.dig = table.dig or
			{name = "trash_can", gain = 3}
	return table
end

minetest.register_node("game:jail_trash_can", {
  description = "Trash Can",
  tiles = {"jail_trash_can_top.png", "jail_trash_can.png"},
  sounds = game.trash_sound(),
  groups = {breakable = 1},
  drop = {
		max_items = 3,
		items = {
			{items = {"game:jail_shank"}, rarity = 3},
			{items = {"game:jail_apple_core"}, rarity = 2}
		}
	}
})

-- Trash can drops

minetest.register_item("game:jail_shank", {
	type = "tool",
	description = "Jail Shank",
	wield_image = "jail_shank.png",
	inventory_image = "jail_shank.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			breakable = {times={[1]=0.70, [2]=3.00}, uses=5, maxlevel=1}
		},
		damage_groups = {fleshy=3},
		punch_attack_uses = 15,
	}
})

minetest.register_craftitem("game:jail_apple_core", {
	description = ("Apple Core"),
	inventory_image = "jail_apple_core.png",
	on_use = minetest.item_eat(1),
})


--- Vending Machine

-- vending machine sounds

function game.machine_sound(table)
	table = table or {}
	table.dug = table.dug or
			{name = "trash_can_dug", gain = 10}
	table.dig = table.dig or
			{name = "vending_machine", gain = 0.7}
	return table
end

minetest.register_node("game:jail_vending_machine", {
	description = "Vending Machine",
	tiles = {
		"jail_vending_machine_back.png",
		"jail_vending_machine_back.png",
		"jail_vending_machine_side.png",
		"jail_vending_machine_side.png",
		"jail_vending_machine.png",
		"jail_vending_machine.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
    sounds = game.machine_sound(),
    groups = {breakable = 2},
	drop = {
		max_items = 2,
		items = {
			{items = {"game:jail_node_cola"}, rarity = 1},
			{items = {"game:jail_mtn_frost"}, rarity = 3},
			{items = {"game:jail_crocaid"}, rarity = 2},
			{items = {"game:jail_dr_salt"}, rarity = 4}
		},
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5625, -0.5, -0.5625, 0.5625, 1.5625, 0.5625},
		},
	},
	collison_box = {
		type = "fixed",
		fixed = {
			{-0.5625, -0.5, -0.5625, 0.5625, 1.5625, 0.5625},
		}
	}
})

-- Sodas

minetest.register_craftitem("game:jail_node_cola", {
	description = ("Node Cola"),
	inventory_image = "jail_node_cola.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craftitem("game:jail_mtn_frost", {
	description = ("Moutain Frost"),
	inventory_image = "jail_mtn_frost.png",
	on_use = minetest.item_eat(5),
})

minetest.register_craftitem("game:jail_crocaid", {
	description = ("CrocAid"),
	inventory_image = "jail_crocaid.png",
	on_use = function(itemstack, user, pointed_thing)
		sprint.add_stamina(user, 12)
		local func = minetest.item_eat(1)
		return func(itemstack, user, pointed_thing)
	end,
})

minetest.register_craftitem("game:jail_dr_salt", {
	description = ("DrSalt"),
	inventory_image = "jail_dr_salt.png",
	on_use = minetest.item_eat(6),
})

--- Vault

-- vault sounds

function game.vault_sound(table)
	table = table or {}
	table.dug = table.dug or
			{name = "vault_dug", gain = 10}
	table.dig = table.dig or
			{name = "vault", gain = 0.5, pitch = 0.6}
	return table
end

minetest.register_node("game:jail_vault", {
	description = "Vault",
	tiles = {"jail_vault.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sounds = game.vault_sound(),
    groups = {breakable = 3},
	drop = {
		max_items = 2,
		items = {
			{items = {"game:dynamite"}, rarity = 2},
			{items = {"game:jail_crowbar"}, rarity = 1}
		},
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5625, -0.5625, -0.5625, 0.5625, 0.625, 0.5625},
		},
	},
	collison_box = {
		type = "fixed",
		fixed = {
			{-0.5625, -0.5625, -0.5625, 0.5625, 0.625, 0.5625},
		},
	},
})

-- Dynamite (from Ranged Weapons)

local dynamite_boom = {
	name = "game:dynamite_explosion",
	radius = 6,
	tiles = {
		side = "jail_dynamite.png",
		top = "jail_dynamite.png",
		bottom = "jail_dynamite.png",
		burning = "jail_dynamite.png"
	},
}

minetest.register_craftitem("game:dynamite", {
	stack_max= 1,
	wield_scale = {x=1.1,y=1.1,z=1.05},
	description = "Dynamite",
	range = 0,
	inventory_image = "jail_dynamite.png",
})
minetest.register_craftitem("game:dynamite_ready", {
	stack_max= 1,
	wield_scale = {x=1.1,y=1.1,z=1.05},
	description = "Dynamite (Burning)",
	range = 0,
	inventory_image = "jail_dynamite_ready.png",
	groups = {not_in_creative_inventory = 1},
	on_use = function(itemstack, user, pointed_thing)
		local pos = user:getpos()
		local dir = user:get_look_dir()
		local yaw = user:get_look_yaw()
		if pos and dir and yaw then
			pos.y = pos.y + 1.6
			local obj = minetest.add_entity(pos, "game:dynamite")
			if obj then
				obj:setvelocity({x=dir.x * 7, y=dir.y * 1, z=dir.z * 7})
				obj:setacceleration({x=dir.x * -1, y=-6, z=dir.z * -1})
				obj:setyaw(yaw + math.pi)
				local ent = obj:get_luaentity()
				if ent then
					ent.player = ent.player or user
			itemstack = ""
				end
			end
		end
		return itemstack
	end,
})

	local timer = 0
minetest.register_globalstep(function(dtime, player, pos)
	timer = timer + dtime;
	if timer >= 0.001 then
	for _, player in pairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		local controls = player:get_player_control()
		if player:get_wielded_item():get_name() == "game:dynamite" then
		if controls.RMB then
		player:set_wielded_item("game:dynamite_ready")
		timer = 0
				minetest.sound_play("tnt_ignite", {player})
		local dir = player:get_look_dir()
		local yaw = player:get_look_yaw()
		if pos and dir and yaw then
			pos.y = pos.y + 0.3
			end

end
	end

	if timer >= 1.5 and
		 player:get_wielded_item():get_name() == "game:dynamite_ready" then
		player:set_wielded_item("")
		timer = 0
		tnt.boom(pos, bottle_boom)

		end
			end
				end
				end)

local jail_dynamite = {
	physical = false,
	timer = 0,
	visual = "sprite",
	visual_size = {x=0.5, y=0.5},
	textures = {"jail_dynamite_ready.png"},
	lastpos= {},
	collisionbox = {0, 0, 0, 0, 0, 0},
}
jail_dynamite.on_step = function(self, dtime, pos)
	local pos = self.object:getpos()
	local node = minetest.get_node(pos)
	if self.lastpos.x ~= nil then
	if minetest.registered_nodes[node.name].walkable then
	local vel = self.object:getvelocity()
	local acc = self.object:getacceleration()
	self.object:setvelocity({x=vel.x*-0.3, y=vel.y*-1, z=vel.z*-0.3})
	self.object:setacceleration({x=acc.x, y=acc.y, z=acc.z})
			end
	end
	self.timer = timer
	if self.timer > 1.5 then
	tnt.boom(pos, dynamite_boom)
	self.object:remove()
	end
	self.lastpos= {x = pos.x, y = pos.y, z = pos.z}

end
minetest.register_entity("game:dynamite", jail_dynamite)

-- Crowbar

minetest.register_item("game:jail_crowbar", {
	type = "tool",
	description = "Crowbar",
	wield_image = "jail_crowbar.png",
	inventory_image = "jail_crowbar.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			breakable = {times={[1]=0.5, [2]=1, [3]=2, [4]=3}, uses=10, maxlevel=1}
		},
		damage_groups = {fleshy=3},
		punch_attack_uses = 20,
	}
})


--Global Variable
local wall_width = 4  -- changes the hallway size

local function map_function(maze, player)
    local loc_maze = maze
    width = loc_maze.width
    height = loc_maze.height

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height*wall_width,y=5,z=width*wall_width})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
	local ceiling  =  minetest.get_content_id("game:jail_ceiling")
    local ground   =   minetest.get_content_id("game:jail_ground")
    local wall  =   minetest.get_content_id("game:jail_wall")
    local trash  =   minetest.get_content_id("game:jail_trash_can")
    local vending_machine  =   minetest.get_content_id("game:jail_vending_machine")
    local vault  =   minetest.get_content_id("game:jail_vault")
    local invisble = minetest.get_content_id("game:inv")
    local air =      minetest.get_content_id("air")
    
    --Set up the level itself
	local machine_count = 0
    local vault_count = 0
    local trash_count = 0
    for z=1, width do --z
        for x=1, height do --x
            if loc_maze[x][z] == 1 then
                for off_z=0, wall_width-1 do 
                    for off_x=0, wall_width-1 do
                        data[a:index(x*wall_width+off_x, 0, z*wall_width+off_z)]     = ground
                    end
				end	
            machine_count = machine_count + 1
                if machine_count == 60 then
                    machine_count = 0
                    local xof = math.random(0,2)
                    local zof = math.random(0,2)
                    data[a:index(x*3+xof, 1, z*3+zof)] = vending_machine
                end
            vault_count = vault_count + 1
                if vault_count == 40 then
                   vault_count = 0
                    local xof = math.random(0,2)
                    local zof = math.random(0,2)
                    data[a:index(x*3+xof, 5, z*3+zof)] = vault
                end
            trash_count = trash_count + 1
                if trash_count == 40 then
                    trash_count = 0
                    local xof = math.random(0,2)
                    local zof = math.random(0,2)
                    data[a:index(x*3+xof, 1, z*3+zof)] = trash
                end
            else
                for off_z=0, wall_width-1 do 
                    for off_x=0, wall_width-1 do
                        data[a:index(x*wall_width+off_x, 0, z*wall_width+off_z)]     = ground
                    end
                end
                for y=1,4 do
                    for off_z=0, wall_width-1 do 
                        for off_x=0, wall_width-1 do
                            data[a:index(x*wall_width+off_x, y, z*wall_width+off_z)]     = wall
                        end
                    end
                end
            end
            -------------------------------------------------------Adds a roof
            for off_z=0, wall_width-1 do 
                for off_x=0, wall_width-1 do
                    data[a:index(x*wall_width+off_x, 5, z*wall_width+off_z)]     = ceiling
                end
            end
        end
    end
    vm:set_data(data)
    vm:write_to_map(true)
    
    --player target coords
    player_x = (math.floor(height/2)+(math.floor(height/2)+1)%2)*wall_width
    player_z = (math.floor(width/2)+(math.floor(width/2)+1)%2)*wall_width
    
    --Lets now overwrite the channel for the player to fall into:
    local emin, emax = vm:read_from_map({x=player_x-1,y=4,z=player_z-1}, {x=player_x+1,y=32,z=player_z+1})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    vm:set_data(data)
    vm:write_to_map(true)
    
    --Finally, move  the player
    player:set_velocity({x=0,y=0,z=0})
    player:set_pos({x=player_x,y=3,z=player_z})
end

local function cleanup(width, height)
    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height*wall_width+1,y=4,z=width*wall_width+1})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local air = minetest.get_content_id("air")
	
    --zero it out
    for z=0, width*wall_width+1 do --z
        for y=0,5 do --
            for x=0, height*wall_width+1 do --x
                data[a:index(x, y, z)] = air
            end
        end
    end
    vm:set_data(data)
    vm:write_to_map(true)
    
    --player target coords
    player_x = (math.floor(height/2)+(math.floor(height/2)+1)%2)*wall_width
    player_z = (math.floor(width/2)+(math.floor(width/2)+1)%2)*wall_width
    
    --Lets now overwrite the channel for the player to fall into:
    local emin, emax = vm:read_from_map({x=player_x-1,y=4,z=player_z-1}, {x=player_x+1,y=32,z=player_z+1})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    for y=5,32 do
        for x=player_x-1, player_x+1 do
            for z=player_z-1, player_z+1 do
                data[a:index(x, y, z)] = air
            end
        end
    end
	
    vm:set_data(data)
    vm:write_to_map(true)
end

laby_register_style("jail","jail", map_function, cleanup)
