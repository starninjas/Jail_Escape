gunslinger.register_gun("gunslinger:pistol", {
	itemdef = {
		description = "Pistol",
		inventory_image = "gunslinger_pistol.png",
		wield_image = "gunslinger_pistol.png^[transformFXR300",
	},

	mode = "semi-automatic",
	dmg_mult = 3,
	recoil_mult = 3,
	fire_rate = 4,
	clip_size = 15,
	range = 40
})