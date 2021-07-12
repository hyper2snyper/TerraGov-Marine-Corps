/obj/item/weapon/gun/sentry
	name = "\improper UA 571-C sentry gun"
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with a M30 autocannon and a 500-round drum magazine."
	icon = 'icons/Marine/miniturret.dmi'
	icon_state = "sentry"

	max_integrity = 200

	var/turret_flags = TURRET_HAS_CAMERA|TURRET_SAFETY|TURRET_ALERTS
	var/knockdown_threshold = 150
	var/range = 7

	var/obj/item/cell/lasgun/lasrifle/marine/battery

	current_mag = /obj/item/ammo_magazine/sentry

	burst_amount = 5
	burst_delay = 2

	fire_delay = 2
	scatter = 0
	scatter_unwielded = 0
	burst_scatter_mult = 0

	gun_iff_signal = list(ACCESS_IFF_MARINE)

	gun_firemode_list = list(GUN_FIREMODE_SEMIAUTO)
	flags_item = IS_SENTRY|TWOHANDED
	deploy_time = 8 SECONDS
