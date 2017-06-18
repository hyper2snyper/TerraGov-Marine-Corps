//-----USS Almayer Turfs ---//

// alls

/turf/simulated/wall/almayer
	name = "hull"
	desc = "A huge chunk of metal used to seperate rooms and make up the ship."
	icon = 'icons/turf/almayer.dmi'
	icon_state = "testwall0"
	walltype = "testwall"

	damage = 0
	damage_cap = 10000 //Wall will break down to girders if damage reaches this point

	max_temperature = 18000 //K, walls will take damage if they're next to a fire hotter than this

	opacity = 1
	density = 1
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	tiles_with = list(
		/turf/simulated/wall,
		/obj/structure/window/reinforced/almayer,
		/obj/machinery/door/airlock)

/turf/simulated/wall/almayer/handle_icon_junction(junction)
	//lets make some detailed randomized shit happen.
	var/r1 = rand(0,10) //Make a random chance for this to happen
	var/r2 = rand(0,3) // Which wall if we do choose it
	if(junction == 12)
		switch(r1)
			if(0 to 8)
				icon_state = "[walltype]12"
			if(9 to 10)
				icon_state = "almayer_deco_wall[r2]"
	else
		icon_state = "[walltype][junction]"

/turf/simulated/wall/almayer/outer
	name = "outer hull"
	desc = "A huge chunk of metal used to seperate space from the ship"
	//icon_state = "testwall0_debug" //Use "testwall0". Testing sprite to check for missing/misplaced is testwall0_debug
	walltype = "testwall"
	hull = 1 //Impossible to destroy or even damage. Used for outer walls that would breach into space, potentially some special walls

/turf/simulated/wall/almayer/white
	walltype = "wwall"
	icon_state = "wwall0"

/turf/simulated/wall/almayer/white/handle_icon_junction(junction)
	icon_state = "[walltype][junction]"

/obj/effect/decal/wall_transition
	icon = 'icons/turf/almayer.dmi'
	icon_state = "transition_s"
	layer = 2

/obj/effect/decal/wall_transition/New()
	. = ..()

	loc.overlays += src
	cdel(src)

/turf/simulated/shuttle/wall/dropship1
	name = "\improper Alamo"
	icon = 'icons/turf/dropship.dmi'
	icon_state = "1"

/turf/simulated/shuttle/wall/dropship1/transparent
	opacity = 0

/turf/simulated/shuttle/wall/dropship2
	name = "\improper Normandy"
	icon = 'icons/turf/dropship2.dmi'
	icon_state = "1"

/turf/simulated/shuttle/wall/dropship2/transparent
	opacity = 0

/turf/simulated/shuttle/wall/escapepod
	name = "wall"
	icon = 'icons/turf/escapepods.dmi'
	icon_state = "wall0"

/turf/simulated/shuttle/floor/escapepod
	icon = 'icons/turf/escapepods.dmi'
	icon_state = "floor3"

//Floors

/turf/simulated/floor/almayer
	icon = 'icons/turf/almayer.dmi'
	icon_state = "default"

/turf/simulated/floor/almayer/plating
	name = "plating"
	icon_state = "plating"
	floor_tile = null
	intact = 0

/turf/simulated/floor/almayer/plating/catwalk
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating"
	name = "catwalk"
	desc = "Cats really don't like these things."
	var/covered = 1 //1 for theres the cover, 0 if there isn't.

	New()
		..()
		update_turf_overlay()

/turf/simulated/floor/almayer/plating/catwalk/proc/update_turf_overlay()
	var/image/reusable/I = rnew(/image/reusable, list('icons/turf/almayer.dmi',src,"catwalk",2.5))
	switch(covered)
		if(0)
			overlays -= I
			cdel(I)
		if(1) overlays += I

/turf/simulated/floor/almayer/plating/catwalk/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/crowbar))
		if(covered)
			var/obj/item/stack/catwalk/R = new(usr.loc)
			R.add_to_stacks(usr)
			covered = 0
			update_turf_overlay()
			return
	if(istype(W, /obj/item/stack/catwalk))
		if(!covered)
			var/obj/item/stack/catwalk/E = W
			E.use(1)
			covered = 1
			update_turf_overlay()
			return
	..()

/obj/item/stack/catwalk
	name = "catwalk mesh"
	singular_name = "catwalk mesh"
	desc = "Those could work as a pretty decent throwing weapon"
	icon = 'icons/turf/almayer.dmi'
	icon_state = "catwalk_tile"
	w_class = 3.0
	force = 6.0
	throwforce = 8.0
	throw_speed = 3
	throw_range = 6
	flags_atom = FPRINT|CONDUCT
	max_amount = 60

//Outerhull

/turf/unsimulated/floor/almayer_hull
	icon = 'icons/turf/almayer.dmi'
	icon_state = "outerhull"
	name = "hull"
	oxygen = 0.00
	nitrogen = 0.00
	temperature = TCMB

//Others

//------ Grilles -----///

/obj/structure/grille/almayer
	icon = 'icons/turf/almayer.dmi'
	icon_state = "grille0"
	tiles_with = list(
		/turf/simulated/wall,
		/obj/machinery/door/airlock,
		/obj/structure/grille/almayer)

/obj/structure/grille/almayer/New()
	spawn(10)
		relativewall()
		relativewall_neighbours()

/obj/structure/grille/almayer/update_icon()
	relativewall()

//------ Windows -----//

/obj/structure/window/reinforced/almayer
	name = "reinforced window"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/turf/almayer.dmi'
	icon_state = "rwindow0"
	basestate = "rwindow"
	health = 100 //Was 600
	reinf = 1
	dir = 5
	window_frame = /obj/structure/window_frame/almayer
	static_frame = 1

	tiles_with = list(
		/turf/simulated/wall)

	var/tiles_special[] = list( //Special case.
		/obj/machinery/door/airlock,
		/obj/structure/window/reinforced/almayer,
		/obj/structure/window_frame)

/obj/structure/window/reinforced/almayer/New()
	spawn(10)
		relativewall()
		relativewall_neighbours()

/obj/structure/window/reinforced/almayer/update_nearby_icons()
	relativewall_neighbours()

/obj/structure/window/reinforced/almayer/update_icon()
	relativewall()

/obj/structure/window/reinforced/almayer/Dispose()
	density = 0
	update_nearby_tiles()
	update_nearby_icons()
	. = ..()

/obj/structure/window/reinforced/almayer/hull
	name = "hull window"
	desc = "A glass window with a special rod matrice inside a wall frame. This one was made out of exotic materials to prevent hull breaches. No way to get through here."
	//icon_state = "rwindow0_debug" //Should be rwindow0. Use rwindow0_debug to check for missing/misplaced hull windows
	hull = 1
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window_frame
	name = "window frame"
	desc = "A big hole in the wall that used to sport a large window. Can be vaulted through"
	icon = 'icons/turf/almayer.dmi'
	icon_state = "rwindow0_frame"
	climbable = 1 //Small enough to vault over, but you do need to vault over it
	climb_delay = 15 //One second and a half, gotta vault fast
	var/obj/item/stack/sheet/sheet_type = /obj/item/stack/sheet/glass/reinforced
	var/obj/structure/window/reinforced/almayer/window_type = /obj/structure/window/reinforced/almayer
	var/basestate = "window"

/obj/structure/window_frame/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || (height == 0)) return 1 //Air can pass through a window-sized hole
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S.climbable) //Climbable objects allow you to universally climb over others
		if(climbable) //If the other can be climbed on, of course
			return 1
	return 0

/obj/structure/window_frame/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	return 1

/obj/structure/window_frame/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, sheet_type))
		var/obj/item/stack/sheet/sheet = W
		if(sheet.get_amount() < 2)
			user << "<span class='warning'>You need more [W.name] to install a new window.</span>"
			return
		user.visible_message("<span class='notice'>[user] starts installing a new glass window on the frame.</span>", \
		"<span class='notice'>You start installing a new window on the frame.</span>")
		playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 20, TRUE, 5, BUSY_ICON_CLOCK))
			user.visible_message("<span class='notice'>[user] installs a new glass window on the frame.</span>", \
			"<span class='notice'>You install a new window on the frame.</span>")
			sheet.use(2)
			new window_type(loc) //This only works on Almayer windows!
			cdel(src)


/obj/structure/window_frame/almayer
	icon_state = "rwindow0_frame"

/obj/structure/window/reinforced/almayer/white
	icon_state = "rwwindow0"
	basestate = "rwwindow"
	window_frame = /obj/structure/window_frame/almayer/white

/obj/structure/window_frame/almayer/white
	icon_state = "wwindow0_frame"
	basestate = "wwindow"
	window_type = /obj/structure/window/reinforced/almayer/white