-- ██╗      █████╗ ██████╗ ██╗   ██╗██████╗ ██╗███╗   ██╗████████╗██╗  ██╗
-- ██║     ██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██║████╗  ██║╚══██╔══╝██║  ██║
-- ██║     ███████║██████╔╝ ╚████╔╝ ██████╔╝██║██╔██╗ ██║   ██║   ███████║
-- ██║     ██╔══██║██╔══██╗  ╚██╔╝  ██╔══██╗██║██║╚██╗██║   ██║   ██╔══██║
-- ███████╗██║  ██║██████╔╝   ██║   ██║  ██║██║██║ ╚████║   ██║   ██║  ██║
-- ╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
-- Ascii art font: ANSI Shadow, All acii art from patorjk.com/software/taag/
--
-- The code for labyrinth is licensed as follows:
-- MIT License, ExeVirus (c) 2021
--
-- Please see the LICENSE file for texture licenses

game = {}

--Settings Changes --
--BE VERY CAREFUL WHEN PLAYING WITH OTHER PEOPLES SETTINGS--
minetest.settings:set("enable_damage","true")
minetest.settings:set("creative","false")
local max_block_send_distance = minetest.settings:get("max_block_send_distance")
local block_send_optimize_distance = minetest.settings:get("block_send_optimize_distance")
if max_block_send_distance == 31 then -- no one would set these to 31, so it must have been a crash,
    max_block_send_distance = 8       -- and we should revert to defaults on proper shutdown
end
if block_send_optimize_distance == 31 then
    block_send_optimize_distance = 4
end
minetest.settings:set("max_block_send_distance","30")
minetest.settings:set("block_send_optimize_distance","30")
minetest.register_on_shutdown(function()
    minetest.settings:set("max_block_send_distance",tostring(max_block_send_distance))
    minetest.settings:set("block_send_optimize_distance",tostring(block_send_optimize_distance))
end)
--End Settings Changes--

--Load our Settings--
local function handleColor(settingtypes_name, default)
    return minetest.settings:get(settingtypes_name) or default
end
local primary_c              = handleColor("laby_primary_c",              "#1d1d20")
local hover_primary_c        = handleColor("laby_hover_primary_c",        "#a6a6bf")
local on_primary_c           = handleColor("laby_on_primary_c",           "#ff4d00")
local secondary_c            = handleColor("laby_secondary_c",            "#bd2900")
local hover_secondary_c      = handleColor("laby_hover_secondary_c",      "#a6a6bf")
local on_secondary_c         = handleColor("laby_on_secondary_c",         "#1d1d20")
local background_primary_c   = handleColor("laby_background_primary_c",   "#616173")
local background_secondary_c = handleColor("laby_background_secondary_c", "#434350")

-- #616173 - light gray

--End Settings Load

local DefaultGenerateMaze = dofile(minetest.get_modpath("game") .. "/maze.lua")
local GenMaze = DefaultGenerateMaze

--Style registrations

local numStyles = 0
local styles = {}
local music = nil

-------------------
-- Global function laby_register_style(name, music_name, map_from_maze, cleanup, genMaze)
--
-- name: text in lowercase, typically, of the map style
-- music_name: music file name
-- map_from_maze = function(maze, player)
--   maze is from GenMaze() above, an input
--   player is the player_ref to place them at the start of the maze
-- cleanup = function (maze_w, maze_h) -- should replace maze with air
-- genMaze is an optional arguement to provide your own algorithm for this style to generate maps with
--
function laby_register_style(name, music_name, map_from_maze, cleanup, genMaze)
    numStyles = numStyles + 1
    styles[numStyles] = {}
    styles[numStyles].name = name
    styles[numStyles].music = music_name
    styles[numStyles].gen_map = map_from_maze
    styles[numStyles].cleanup = cleanup
    styles[numStyles].genMaze = genMaze
end

--Common node between styles, used for hidden floor to fall onto
minetest.register_node("game:inv",
{
  description = "Ground Block",
  drawtype = "airlike",
  groups = {not_in_creative_inventory=1, fall_damage_add_percent = -100},
  tiles = {"inv.png"},
  light_source = 11,
})

-- Mob remover node

minetest.register_node("game:kill",
{
  description = "Mobs Remover",
  drawtype = "airlike",
  walkable     = false,
  pointable    = false,
  diggable     = false,
  buildable_to = true, 
  tiles = {"inv.png"},
})

--Override the default hand
minetest.register_item(":", {
	type = "none",
	wield_image = "hand.png",
	groups = {not_in_creative_inventory=1},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			breakable = {times={[1]=1.00, [2]=2.00, [3]=3.5, [4]= 9.00}, uses=0, maxlevel=1}
		},
		damage_groups = {fleshy=2},
	}
})

--Style Registrations
dofile(minetest.get_modpath("game") .. "/styles/jail.lua")

local restart = styles[1].gen_map
local cleanup = styles[1].cleanup
local gwidth = 70
local gheight = 70
local gscroll = 0
local selectedStyle = 1
local first_load = false

local function setup(player, playerName)
    if styles[selectedStyle].genMaze ~= nil and type(styles[selectedStyle].genMaze) == "function" then
        GenMaze = styles[selectedStyle].genMaze
    else
        GenMaze = DefaultGenerateMaze
    end
    --Load up the level
    local maze = GenMaze(math.floor(gwidth/2)*2+((gwidth+1)%2),math.floor(gheight/2)*2+(gheight+1)%2)
    restart = styles[selectedStyle].gen_map
    cleanup = styles[selectedStyle].cleanup
    restart(maze, player)
    if music then
        minetest.sound_fade(music, 0.5, 0)
    end
    music = minetest.sound_play(styles[selectedStyle].music, {
        gain = 1.0,   -- default
        fade = 0.5,   -- default, change to a value > 0 to fade the sound in
        loop = true,
    })
	player:get_inventory():set_list("main", {})
	player:set_hp(20)
	sprint.add_stamina(player, 20)
	
	minetest.after(2, function() first_load = true end)
end

--------- GUI ------------

--used to make this formspec easier to read
local function table_concat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

--Main_Menu formspec function for Labyrinth
local function main_menu(width_in, height_in, scroll_in)
    local width  = width_in or gwidth
    local height  = height_in or gheight
    local scroll = scroll_in or 0

    --Main Menu Formspec "r"
    local r = {
        "formspec_version[3]",
        "size[11,11]",
        "position[0.5,0.5]",
        "anchor[0.5,0.5]",
        "no_prepend[]",
        "bgcolor[",background_primary_c,";both;#AAAAAA40]",
        "box[0,0;11,1;",primary_c,"]",
        "style_type[button;border=false;bgimg=back.png^[multiply:",secondary_c,";bgimg_middle=10,3;textcolor=",on_secondary_c,"]",
        "style_type[button:hovered;bgcolor=",hover_secondary_c,"]",
        "image[2,0.08;7,0.8;header.png]",
        "hypertext[0.5,1.2;9,5;;<global halign=left color=",on_secondary_c," size=24 font=Regular>Level style:]\n",
        "button[9.2,0.15;1.5,0.7;labyexit;QUIT]",
		"button[0.3,0.15;1.5,0.7;help;HELP]",
        "box[0.5,1.9;10,2.1;",background_secondary_c,"]",
        "scroll_container[0.5,2;10,2;scroll;horizontal;0.2]",

    }
    --for each set, output the icon and set_name as a button
    for i=1, numStyles, 1 do
        if selectedStyle == i then
            table.insert(r,"box["..((i-1)*2+0.1)..",0.0;1.8,1.8;#0B35]") --hardcoded color, sorry
        end
        local name = styles[i].name
        table.insert(r,"image_button["..((i-1)*2+0.25)..",0.15;1.5,1.5;"..name..".png;style"..i..";"..name.."]")
    end
    table.insert(r,"scroll_container_end[]")
    table.insert(r,"scrollbaroptions[max="..tostring((numStyles - 5) * 10)..";thumbsize="..tostring((numStyles - 5) * 2.5).."]")
    local r2 = {
        "scrollbar[0.5,4;10,0.5;horizontal;scroll;",tostring(scroll),"]",
        "style_type[button;border=false;bgimg=back.png^[multiply:",primary_c,";bgimg_middle=10,10;textcolor=",on_primary_c,"]",
        "style_type[button:hovered;bgimg=back.png^[multiply:",hover_primary_c,";bgcolor=#FFF]",
        "box[0.5,8.75;10,0.1;",background_secondary_c,"]",
        "style_type[field;border=false;font_size=16;textcolor=",on_secondary_c,"]",
        "style_type[label;textcolor=",on_secondary_c,"]",
        "button_exit[5.5,9.3;4,0.8;play;Play]",
    }
    table_concat(r,r2)
    return table.concat(r);
end

--- Help Menu

local function help_menu()
    local r = {
        "formspec_version[3]",
        "size[11,11]",
        "position[0.5,0.5]",
        "anchor[0.5,0.5]",
        "no_prepend[]",
        "bgcolor[",background_primary_c,";both;#AAAAAA40]",
        "box[0,0;11,1;",primary_c,"]",
        "style_type[button;border=false;bgimg=back.png^[multiply:",secondary_c,";bgimg_middle=10,3;textcolor=",on_secondary_c,"]",
        "style_type[button:hovered;bgcolor=",hover_secondary_c,"]",
		"image[2,0.08;7,0.8;help.png]",
		"button[9.2,0.15;1.5,0.7;labyexit;QUIT]",
		"button_exit[0.3,0.15;1.5,0.7;game_menu;BACK]",
		
		"image[0.4,1.3;1.5,1.5;icon.png]",
		"item_image[0.4,3.7;1.5,1.5;game:jail_vault]",
		"model[-0.6,5.8;3,3;test;character.b3d;mobs_jail_gaurd1.png;0,0;true; false]",
		
		"hypertext[2,1.5;8,8;;<global halign=center color=#ff4d00 size=16 font=Regular>\n",
        "Welcome to Jail Escape! Try to escape the randomly generated maze, while avoiding being attacked by gaurds.\n",
        "See a big hole that leads out to nowhere? This isn't a glitch! Jump out of this hole to win the game!\n",
		"Below are some helpful tips:\n",
		"<global halign=center color=#ffffff size=18 font=Regular>LOOT BLOCKS\n",
        "<global halign=center color=#a6a6bf size=16 font=Regular>Keep your eye peeled for loot blocks! This can be anything from a lowly trash can to a highly reinforced vault! \n",
		"These blocks, once destroyed, will drop helpful items.\n",
		"<global halign=center color=#ffffff size=18 font=Regular>GUARDS\n",
        "<global halign=center color=#a6a6bf size=16 font=Regular>Watch out for guards wandering around! If you get killed by one of them, then it's game over...\n",
		"Sometimes picking a fight with a guard may be helpful, if you're in need of some really good items.\n",
		"<global halign=center color=#ff4d00 size=16 font=Regular>The rest you will learn by playing more, good luck!\n",


    }
    return table.concat(r)
end

--- Pause Menu

local function pause_menu()
    local r = {
        "formspec_version[3]",
        "size[10,10]",
        "position[0.5,0.5]",
        "anchor[0.5,0.5]",
        "no_prepend[]",
        "bgcolor[",background_primary_c,";both;#AAAAAA40]",
		"list[current_player;main;1.4,6.7;6,2;]",
		"listcolors[#1d1d20;#ff4d00;#000000]",
        "style_type[button;border=false;bgimg=back.png^[multiply:",primary_c,";bgimg_middle=10,10;textcolor=",on_primary_c,"]",
        "style_type[button:hovered;bgimg=back.png^[multiply:",hover_primary_c,";bgcolor=#FFF]",
        "button_exit[1.5,0.5;6.8,1;game_menu;Quit to Game Menu]",
        "button_exit[1.5,2;6.8,1;restart;Restart with new Map]",
        "hypertext[3.5,3.5;2.5,4.25;;<global halign=center color=#ffffff size=34 font=Regular>Credits<global halign=center color=#a6a6bf size=18 font=Regular>\n",
        "Jail Escape by StarNinjas\n", 
		"Original Game by ExeVirus\n",
    }
    return table.concat(r)
end


local function to_game_menu(player)
    first_load = false
    minetest.show_formspec(player:get_player_name(), "game:main", main_menu())
    cleanup(gwidth, gheight)
    if music then
        minetest.sound_fade(music, 0.5, 0)
    end
    music = minetest.sound_play("main", {
        gain = 1.0,   -- default
        fade = 0.8,   -- default, change to a value > 0 to fade the sound in
        loop = true,
    })
end

----------------------------------------------------------
--
-- onRecieveFields(player, formname, fields)
--
-- player: player object 
-- formname: use provided form name
-- fields: standard recieve fields
-- Callback for on_recieve fields
----------------------------------------------------------
local function onRecieveFields(player, formname, fields)
    if formname ~= "game:main" and formname ~= "" then return end
    if formname == "" then --process the inventory formspec
        if fields.game_menu then
            minetest.after(0.15, function() to_game_menu(player) end)
        elseif fields.restart then
            cleanup(gwidth, gheight)
            local maze = GenMaze(math.floor(gwidth/2)*2+((gwidth+1)%2),math.floor(gheight/2)*2+(gheight+1)%2)
            restart(maze, player)
			player:get_inventory():set_list("main", {})
			player:set_hp(20)
			sprint.add_stamina(player, 20)
        end
        return
    end
    
    local scroll_in = 0
    local width_in = 39
    local height_in = 74
    if fields.scroll then
        scroll_in = tonumber(minetest.explode_scrollbar_event(fields.scroll).value)
    end

    --Loop through all fields for level selected
    for name,_ in pairs(fields) do
        if string.sub(name,1,5) == "style" then
            local newStyle = tonumber(string.sub(name,6,-1))
            if newStyle ~= selectedStyle then --load level style
                selectedStyle = newStyle
                minetest.show_formspec(player:get_player_name(), "game:main", main_menu(width_in, height_in, scroll_in))
            end
        end
    end
	
    if fields.play then
        setup(player)
		
elseif fields.help then
        minetest.show_formspec(player:get_player_name(), "game:main", help_menu(width_in, height_in, scroll_in))	
	
elseif fields.quit then
        minetest.after(0.10, function() minetest.show_formspec(player:get_player_name(), "game:main", main_menu(width_in, height_in, scroll_in)) end)
        return
    elseif fields.labyexit then
        minetest.request_shutdown("Thanks for playing!")
        return
    else
        --minetest.show_formspec(player:get_player_name(), "game:main", main_menu(width_in, height_in, scroll_in))
    end
end

minetest.register_on_player_receive_fields(onRecieveFields)

local function safe_clear(w, l)
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=-10,y=-11,z=-10}, {x=w,y=10,z=l})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local invisible = minetest.get_content_id("game:inv")
	local remover = minetest.get_content_id("game:kill")
    local air = minetest.get_content_id("air")
    
    for z=0, l-10 do --z
        for y=0,10 do --y
            for x=0, w-10 do --x
                data[a:index(x, y, z)] = air
            end
        end
    end

    for z=-20, l do --z
        for x=-20, w do --x
            data[a:index(x, -11, z)] = invisible
        end
    end
	
	for z=-20, l do --z
        for x=-20, w do --x
            data[a:index(x, -10, z)] = remover
        end
    end
	
    vm:set_data(data)
    vm:write_to_map(true)
end

minetest.register_on_joinplayer(
function(player)
    safe_clear(300,300)
	player:hud_set_flags(
        {
            hotbar = true,
            healthbar = true,
            crosshair = true,
            wielditem = true,
            breathbar = false,
            minimap = true,
            minimap_radar = true,
        }
    )
		
	player:hud_set_hotbar_itemcount(6)
    player:set_inventory_formspec(pause_menu())
	player:hud_set_hotbar_selected_image("hotbar_select.png")
	player:set_formspec_prepend(
		"background[-0.2,-0.3;11.4,6.25;background.png"
	)
    minetest.show_formspec(player:get_player_name(), "game:main", main_menu())
    music = minetest.sound_play("main", {
        gain = 1.0,   -- default
        fade = 0.8,   -- default, change to a value > 0 to fade the sound in
        loop = true,
    })
end
)

minetest.register_globalstep(
function(dtime)
    local player = minetest.get_player_by_name("singleplayer")
    if player and first_load then
        local pos = player:get_pos()
        if pos.y < -5 then
            minetest.sound_play("win")
            minetest.chat_send_all(minetest.colorize(secondary_c,"You escaped the ".. styles[selectedStyle].name).. "!")
            to_game_menu(player)
        end
    end
end
)

minetest.register_on_dieplayer(function(player)
	local player = minetest.get_player_by_name("singleplayer")
	 --Move  the player
    player:set_velocity({x=0,y=0,z=0})
    player:set_pos({x=player_x,y=-15,z=player_z})
	
	minetest.sound_play("lose")
    minetest.chat_send_all(minetest.colorize(secondary_c,"You failed escaping ".. styles[selectedStyle].name).. ". Too bad. Try again next time.")
    to_game_menu(player)
end)

minetest.register_on_respawnplayer(function(player)	
	local player = minetest.get_player_by_name("singleplayer")
	to_game_menu(player)
end)

minetest.register_on_mods_loaded(function()
	minetest.register_on_respawnplayer(function(player)
		if player:get_hp() < 1 then
			return
		end
		minetest.after(0, function(player)
			local player = minetest.get_player_by_name("singleplayer")
			to_game_menu(player)
		end, player)
	end)
end)

--- Add a timer and, make the game menu show your high score
