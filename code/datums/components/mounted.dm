/datum/component/deployable_item
	///Whether or not the parent is deployed
	var/deployed = FALSE
	///Time it takes for the parent to be deployed/undeployed
	var/deploy_time = 0

	var/wrench_dissasemble = FALSE

	var/deploy_flags

	///Machine that parent is deployed into and out of
	var/obj/machinery/deployable/deployed_machine

/datum/component/deployable_item/Initialize(deploy_type, _deploy_time, _wrench_dissasemble, _deploy_flags)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	deploy_time = _deploy_time
	deployed_machine = deploy_type
	wrench_dissasemble = _wrench_dissasemble
	deploy_flags = _deploy_flags
	
	deployed_machine = new deployed_machine(parent, parent, deploy_flags)
	RegisterSignal(parent, COMSIG_ITEM_DEPLOY, .proc/deploy)
	RegisterSignal(parent, COMSIG_IS_DEPLOYED, .proc/is_deployed)
	RegisterSignal(parent, COMSIG_DEPLOYABLE_SET_DEPLOYED, .proc/set_deploy)

///Wrapper for proc/finish_deploy
/datum/component/deployable_item/proc/deploy(datum/source, mob/user)
	SIGNAL_HANDLER
	to_chat(user, "<span class='notice'>you start deploying the [source]</span>")
	INVOKE_ASYNC(src, .proc/finish_deploy, source, user)

///Handles the conversion of item into machine
/datum/component/deployable_item/proc/finish_deploy(datum/source, mob/user)
	if(!ishuman(user)) 
		return
	var/turf/here = get_step(user, user.dir)
	var/obj/item/parent_item = parent
	if(parent_item.check_blocked_turf(here))
		to_chat(user, "<span class='warning'>There is insufficient room to deploy [parent_item]!</span>")
		return
	var/direction = user.dir
	if(!do_after(user, deploy_time, TRUE, parent_item, BUSY_ICON_BUILD))
		return

	deployed_machine.forceMove(here)
	deployed_machine.setDir(direction)

	user.temporarilyRemoveItemFromInventory(parent_item)
	parent_item.forceMove(deployed_machine)

	deployed = TRUE

	RegisterSignal(deployed_machine, COMSIG_ITEM_UNDEPLOY, .proc/undeploy)

///Wrapper for proc/finish_undeploy
/datum/component/deployable_item/proc/undeploy(datum/source, mob/user, using_wrench)
	SIGNAL_HANDLER
	to_chat(user, "<span class='notice'>You begin disassembling [parent].</span>")
	INVOKE_ASYNC(src, .proc/finish_undeploy, source, user, using_wrench)

///Transfers the machine into the item
/datum/component/deployable_item/proc/finish_undeploy(datum/source, mob/user, using_wrench)
	if(!using_wrench && wrench_dissasemble)
		return
	if(!do_after(user, deploy_time, TRUE, deployed_machine, BUSY_ICON_BUILD))
		return
	user.visible_message("<span class='notice'> [user] disassembles [parent]! </span>","<span class='notice'> You disassemble [parent]!</span>")

	user.unset_interaction()
	user.put_in_hands(parent)

	deployed = FALSE

	UnregisterSignal(deployed_machine, COMSIG_ITEM_UNDEPLOY)

	deployed_machine.forceMove(parent)

///This is used incase the machine needs to be set as deployed without a user
/datum/component/deployable_item/proc/set_deploy(datum/source, _deployed)
	SIGNAL_HANDLER
	deployed = _deployed

///Returns Deployed
/datum/component/deployable_item/proc/is_deployed()
	SIGNAL_HANDLER
	return deployed

///Checks if the item is deployed
/obj/item/proc/is_deployed()
	return SEND_SIGNAL(src, COMSIG_IS_DEPLOYED)

/datum/component/deployable_item/mounted_gun

///Unregisters for safety
/datum/component/deployable_item/mounted_gun/finish_deploy(datum/source, mob/user)
	. = ..()
	parent.UnregisterSignal(user, list(COMSIG_MOB_MOUSEDOWN, COMSIG_MOB_MOUSEUP, COMSIG_MOB_MOUSEDRAG, COMSIG_KB_RAILATTACHMENT, COMSIG_KB_UNDERRAILATTACHMENT, COMSIG_KB_UNLOADGUN, COMSIG_KB_FIREMODE))
