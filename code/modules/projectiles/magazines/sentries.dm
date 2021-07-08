/obj/item/ammo_magazine/sentry
	name = "\improper M30 box magazine (10x28mm Caseless)"
	desc = "A box of 500 10x28mm caseless rounds for the UA 571-C sentry gun. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	w_class = WEIGHT_CLASS_BULKY
	icon = 'icons/Marine/sentry.dmi'
	icon_state = "ammo_can"
	flags_magazine = NONE //can't be refilled or emptied by hand
	caliber = CALIBER_10X28
	max_rounds = 500
	default_ammo = /datum/ammo/bullet/turret
	gun_type = /obj/item/weapon/gun/sentry