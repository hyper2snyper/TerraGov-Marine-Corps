/obj/item/weapon/gun/sentry

	var/turret_flags = TURRET_HAS_CAMERA|TURRET_SAFETY|TURRET_ALERTS
	var/knockdown_threshold = 150
	var/range = 7

	current_mag = /obj/item/ammo_magazine/sentry

	burst_amount = 5
	burst_delay = 2

	fire_delay = 4

	flags_item = IS_SENTRY|TWOHANDED
	deploy_time = 8 SECONDS
