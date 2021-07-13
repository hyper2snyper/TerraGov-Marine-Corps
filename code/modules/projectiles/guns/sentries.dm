/obj/item/weapon/gun/sentry
	name = "\improper UA 571-C sentry gun"
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with a M30 autocannon and a 500-round drum magazine."
	icon = 'icons/Marine/miniturret.dmi'
	icon_state = "sentry"

	max_integrity = 200

	var/turret_flags = TURRET_HAS_CAMERA|TURRET_SAFETY|TURRET_ALERTS
	var/knockdown_threshold = 150
	var/range = 7

	var/obj/item/cell/lasgun/lasrifle/marine/battery = new()

	current_mag = /obj/item/ammo_magazine/sentry

	burst_amount = 3
	burst_delay = 1

	fire_delay = 2
	scatter = 0
	scatter_unwielded = 0
	burst_scatter_mult = 0

	gun_iff_signal = list(ACCESS_IFF_MARINE)

	gun_firemode_list = list(GUN_FIREMODE_SEMIAUTO, GUN_FIREMODE_BURSTFIRE)
	flags_item = IS_SENTRY|TWOHANDED
	deploy_time = 8 SECONDS

/obj/item/weapon/gun/sentry/Destroy()
	. = ..()
	QDEL_NULL(battery)

/obj/item/weapon/gun/sentry/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/cell/lasgun/lasrifle/marine))
		var/obj/item/cell/lasgun/lasrifle/marine/new_battery = I
		if(!new_battery.charge)
			to_chat(user, "<span class='warning'>[new_battery] is out of charge!</span>")
			return
		playsound(src, 'sound/weapons/guns/interact/standard_laser_rifle_reload.ogg', 20)
		battery = new_battery
		user.temporarilyRemoveItemFromInventory(new_battery)
		new_battery.forceMove(src)
		to_chat(user, "<span class='notice'>You install the [new_battery] into the [src].</span>")
		return
	return ..()

/obj/item/weapon/gun/sentry/AltClick(mob/user)
	. = ..()
	if(!user.Adjacent(src) || !ishuman(user))
		return
	var/mob/living/carbon/human/human = user
	if(!battery)
		to_chat(human, "<span class='warning'> There is no battery to remove from [src].</span>")
		return
	if(human.get_active_held_item() != src && human.get_inactive_held_item() != src && !CHECK_BITFIELD(flags_item, IS_DEPLOYED))
		to_chat(human, "<span class='notice'>You have to hold [src] to take out its battery.</span>")
		return
	playsound(src, 'sound/weapons/flipblade.ogg', 20)
	human.put_in_hands(battery)
	battery = null