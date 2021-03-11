/obj/item/clothing/suit/storage/marine/harness/boomvest
	name = "tactical explosive vest"
	desc = "Obviously someone just strapped a bomb to a marine harness and called it tactical. The light has been removed, and its switch used as the detonator.<br><span class='notice'>Control-Click to set a warcry.</span> <span class='warning'>This harness has no light, toggling it will detonate the vest!</span>"
	icon_state = "boom_vest"
	flags_item_map_variant = NONE
	flags_armor_features = NONE
	var/bomb_message = null

//Overwrites the parent function for activating a light. Instead it now detonates the bomb.
/obj/item/clothing/suit/storage/marine/harness/boomvest/attack_self(mob/user)
	var/mob/living/carbon/human/activator = user
	if(activator.wear_suit != src)
		to_chat(activator, "Due to the rigging of this device, it can only be detonated while worn.") //If you are going to use this, you have to accept death. No armor allowed.
		return FALSE
	if(bomb_message)
		activator.say("[bomb_message]!!")
		message_admins("[activator] has detonated an explosive vest with the warcry \"[bomb_message]\".")
		log_game("[activator] has detonated an explosive vest with the warcry \"[bomb_message].\"")
	else
		message_admins("[activator] has detonated an explosive vest with no warcry.")
		log_game("[activator] has detonated an explosive vest with no warcry.")
	explosion(loc, 0, 2, 6, 5, 5) 
	qdel(src)

//Gets a warcry to scream on Control Click
/obj/item/clothing/suit/storage/marine/harness/boomvest/CtrlClick(mob/user)
	if(loc == user)
		var/new_bomb_message = input(user, "Select Warcry", "Warcry", null) as text|null
		bomb_message = new_bomb_message
	. = ..()

/obj/item/clothing/suit/storage/marine/harness/boomvest/ob_vest
	name = "admeme oribital bombard vest"
	desc = "ORBITAL BOMBARDMENTS MADE CONVENIENT AND SUICIDAL"

/obj/item/clothing/suit/storage/marine/harness/boomvest/ob_vest/attack_self(mob/user)
	user.say("ORBITAL BOMBARDMENT INBOUND!!")
	message_admins("[user] has detonated an Orbital Bombardment vest! Unga!")
	log_game("[user] has detonated an Orbital Bombatdment vest! Unga!")
	explosion(loc, 15, 15, 15, 15, 15)
	qdel(src)
