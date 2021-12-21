--
-- The Bad Guys
--

--- Basic Jail Gaurds

mobs:register_mob("jail_escape_mobs:jail_gaurd", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 2,
	hp_min = 10,
	hp_max = 15,
	armor = 100,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	pushable = true,
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_jail_gaurd1.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_jail_gaurd",
	},
	walk_velocity = 1,
	run_velocity = 4,
	jump_height = 0,
	stepheight = 1.1,
	floats = 0,
	view_range = 10,
	fall_damage = true,
	drops = {
		{name = "jail_escape_mobs:jail_rebel", chance = 4, min = 0, max = 1},
		{name = "jail_escape_mobs:jail_baton", chance = 3, min = 0, max = 1},
		{name = "jail_escape_mobs:mobs_jelly_donut", chance = 2, min = 0, max = 2},
		{name = "jail_escape_mobs:hand_cuffs", chance = 3, min = 0, max = 1}
	},
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219
	},
})

mobs:spawn({
	name = "jail_escape_mobs:jail_gaurd",
	nodes = {"game:jail_ground"},
	chance = 10,
	active_object_count = 3,
})

--- Patroller (advanced Gaurd, increased damage, speed, view, and armor)

mobs:register_mob("jail_escape_mobs:jail_patroller", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 3,
	hp_min = 10,
	hp_max = 15,
	armor = 90,
	collisionbox = {-0.4, -1.1, -0.4, 0.4, 1.0, 0.4},
	pushable = true,
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_jail_patroller1.png"},
	},
	visual_size = {x = 1.1, y = 1.1},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_jail_gaurd",
	},
	walk_velocity = 1,
	run_velocity = 5,
	jump_height = 0,
	stepheight = 1.1,
	floats = 0,
	view_range = 12,
	fall_damage = true,
	drops = {
		{name = "jail_escape_mobs:jail_rebel", chance = 3, min = 0, max = 3},
		{name = "jail_escape_mobs:jail_baton", chance = 2, min = 0, max = 1},
		{name = "jail_escape_mobs:jail_rebel_brute", chance = 3, min = 0, max = 1},
		{name = "jail_escape_mobs:mobs_jelly_donut", chance = 2, min = 0, max = 1},
		{name = "jail_escape_mobs:hand_cuffs", chance = 3, min = 0, max = 1}
	},
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219
	},
})

mobs:spawn({
	name = "jail_escape_mobs:jail_patroller",
	nodes = {"game:jail_ground"},
	chance = 15,
	active_object_count = 2,
})

--- Officer (super beefed up dude, but slow and a lower view range)

mobs:register_mob("jail_escape_mobs:jail_officer", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 2,
	hp_min = 10,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.4, -1.1, -0.4, 0.4, 1.0, 0.4},
	pushable = true,
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_jail_officer1.png"},
	},
	visual_size = {x = 1.1, y = 1.1},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_jail_gaurd",
	},
	walk_velocity = 1,
	run_velocity = 3,
	jump_height = 0,
	stepheight = 1.1,
	floats = 0,
	view_range = 8,
	fall_damage = true,
	drops = {
		{name = "jail_escape_mobs:jail_rebel", chance = 3, min = 0, max = 1},
		{name = "jail_escape_mobs:jail_rebel_brute", chance = 3, min = 0, max = 1},
		{name = "jail_escape_mobs:mobs_jelly_donut", chance = 2, min = 0, max = 2}, -- He eats a lot, he is a big dude
		{name = "jail_escape_mobs:hand_cuffs", chance = 3, min = 0, max = 1}
	},
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219
	},
})

mobs:spawn({
	name = "jail_escape_mobs:jail_officer",
	nodes = {"game:jail_ground"},
	chance = 10,
	active_object_count = 2,
})

--- S.W.A.T. (a better version of officer)

mobs:register_mob("jail_escape_mobs:jail_swat", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 3,
	hp_min = 15,
	hp_max = 20,
	armor = 80,
	collisionbox = {-0.45, -1.1, -0.45, 0.45, 1.0, 0.45},
	pushable = true,
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_jail_swat1.png"},
	},
	visual_size = {x = 1.2, y = 1.2},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_jail_gaurd",
	},
	walk_velocity = 1,
	run_velocity = 4,
	jump_height = 0,
	stepheight = 1.1,
	floats = 0,
	view_range = 10,
	fall_damage = true,
	drops = {
		{name = "jail_escape_mobs:jail_rebel", chance = 1, min = 0, max = 1},
		{name = "jail_escape_mobs:jail_rebel_brute", chance = 2, min = 0, max = 1},
		{name = "jail_escape_mobs:mobs_jelly_donut", chance = 1, min = 0, max = 2}, -- He eats even more
		{name = "jail_escape_mobs:hand_cuffs", chance = 3, min = 0, max = 1}
	},
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219
	},
})

mobs:spawn({
	name = "jail_escape_mobs:jail_swat",
	nodes = {"game:jail_ground"},
	chance = 15,
	active_object_count = 1,
})

--- Bailieff (low hp, but very fast and a high view range)

mobs:register_mob("jail_escape_mobs:jail_bailieff", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 2,
	hp_min = 10,
	hp_max = 10,
	armor = 140,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	pushable = true,
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_jail_bailieff1.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_jail_gaurd",
	},
	walk_velocity = 1,
	run_velocity = 6,
	jump_height = 0,
	stepheight = 1.1,
	floats = 0,
	view_range = 12,
	fall_damage = true,
	drops = {
		{name = "jail_escape_mobs:jail_rebel", chance = 3, min = 0, max = 1},
		{name = "jail_escape_mobs:jail_baton", chance = 3, min = 0, max = 1},
		{name = "jail_escape_mobs:mobs_jelly_donut", chance = 2, min = 0, max = 1},
		{name = "jail_escape_mobs:hand_cuffs", chance = 3, min = 0, max = 1}
	},
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219
	},
})

mobs:spawn({
	name = "jail_escape_mobs:jail_bailieff",
	nodes = {"game:jail_ground"},
	chance = 10,
	active_object_count = 2,
})

--- Marshall (an advanced Bailieff)

mobs:register_mob("jail_escape_mobs:jail_marshal", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 2,
	hp_min = 10,
	hp_max = 15,
	armor = 120,
	collisionbox = {-0.4, -1.1, -0.4, 0.4, 1.0, 0.4},
	pushable = true,
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_jail_marshal1.png"},
	},
	visual_size = {x = 1.1, y = 1.1},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_jail_gaurd",
	},
	walk_velocity = 1,
	run_velocity = 7,
	jump_height = 0,
	stepheight = 1.1,
	floats = 0,
	view_range = 15,
	fall_damage = true,
	drops = {
		{name = "jail_escape_mobs:jail_rebel", chance = 1, min = 0, max = 1},
		{name = "jail_escape_mobs:jail_baton", chance = 2, min = 0, max = 1},
		{name = "jail_escape_mobs:jail_rebel_brute", chance = 3, min = 0, max = 1},
		{name = "jail_escape_mobs:jelly_donut", chance = 2, min = 0, max = 2},
		{name = "jail_escape_mobs:hand_cuffs", chance = 3, min = 0, max = 1}
	},
	animation = {
		speed_normal = 30,
		speed_run = 50,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219
	},
})

mobs:spawn({
	name = "jail_escape_mobs:jail_marshal",
	nodes = {"game:jail_ground"},
	chance = 15,
	active_object_count = 1,
})

--
-- The Good Guys
--

-- A fellow rebel

mobs:register_mob("jail_escape_mobs:jail_rebel", {
	type = "npc",
	passive = true,
	attack_type = "dogfight",
	pathfinding = true,
	pushable = true,
	reach = 2,
	damage = 1,
	hp_min = 10,
	hp_max = 20,
	armor = 120,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"character.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_jail_gaurd",
	},
	walk_velocity = 6,
	run_velocity = 6,
	jump_height = 0,
	stepheight = 1.1,
	owner = "",
	order = "follow",
	owner_loyal = true,
	attacks_monsters = true,
	fall_damage = true,
	floats = 0,
	view_range = 40,
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219
	},
})

mobs:register_egg("jail_escape_mobs:jail_rebel", ("Small Key"), "mobs_small_key.png", 0)


mobs:register_mob("jail_escape_mobs:jail_rebel_brute", {
	type = "npc",
	passive = true,
	attack_type = "dogfight",
	pathfinding = 2,
	pushable = true,
	reach = 2,
	damage = 3,
	hp_min = 20,
	hp_max = 20,
	armor = 80,
	collisionbox = {-0.45, -1.1, -0.45, 0.45, 1.0, 0.45},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_jail_rebel_brute.png"},
	},
	visual_size = {x = 1.2, y = 1.2},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_jail_gaurd",
	},
	walk_velocity = 6,
	run_velocity = 6,
	jump_height = 0,
	stepheight = 1.1,
	owner = "",
	order = "wander",
	attacks_monsters = true,
	owner_loyal = true,
	fall_damage = true,
	floats = 0,
	view_range = 10,
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219
	},
})

mobs:register_egg("jail_escape_mobs:jail_rebel_brute", ("Big Key"), "mobs_big_key.png", 0)

--
-- Items
--

-- whap whap whappers

minetest.register_item("jail_escape_mobs:jail_baton", {
	type = "tool",
	description = "Baton",
	wield_image = "mobs_baton.png",
	inventory_image = "mobs_baton.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			breakable = {times={[1]=0.70, [2]=3.00}, uses=0, maxlevel=1}
		},
		damage_groups = {fleshy=5},
		punch_attack_uses = 30,
	}
})

-- Hand Cuffs (1 hit!)

minetest.register_item("jail_escape_mobs:hand_cuffs", {
	type = "tool",
	description = "Hand Cuffs",
	wield_image = "mobs_hand_cuffs.png",
	inventory_image = "mobs_hand_cuffs.png",
	tool_capabilities = {
		full_punch_interval = 1,
		damage_groups = {fleshy=100},
		punch_attack_uses = 1,
	}
})

-- Donuts (for the police :D)

minetest.register_craftitem("jail_escape_mobs:jelly_donut", {
	description = ("Jelly Donut"),
	inventory_image = "mobs_jelly_donut.png",
	on_use = minetest.item_eat(3),
})