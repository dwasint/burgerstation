/mob/living/simple/legionare
	name = "legion"

	icon = 'icons/mob/living/simple/lavaland/legioner.dmi'
	icon_state = "legion"


	damage_type = /damagetype/unarmed/fists

	ai = /ai/legion

	health_base = 100
	stamina_base = 200
	mana_base = 200

	value = 500

	movement_delay = DECISECONDS_TO_TICKS(10)

	var/mob/living/advanced/stored_corpse = /mob/living/advanced/npc/nanotrasen/shaft_miner

	var/mob/living/simple/legionare_head/head_type = /mob/living/simple/legionare_head

	var/list/mob/living/simple/legionare_head/tracked_heads = list()

	var/head_limit = 2
	var/next_head = 0

	var/clone=FALSE

	iff_tag = "Legion"
	loyalty_tag = "Legion"

	size = SIZE_HUMAN

	blood_type = null

	armor = /armor/legion

	soul_size = null

	level = 8

/mob/living/simple/legionare/PreDestroy()

	if(stored_corpse)
		if(istype(stored_corpse) && stored_corpse.ckey_last)
			stored_corpse.force_move(get_turf(src))
		stored_corpse = null

	for(var/k in tracked_heads)
		var/mob/living/simple/legionare_head/L = k
		L.death()
	tracked_heads?.Cut()

	return ..()

/mob/living/simple/legionare/proc/create_head()

	if(next_head > world.time)
		return FALSE

	if(length(tracked_heads) >= head_limit)
		return FALSE

	if(clone) //Clones cannot create heads.
		return FALSE

	if(dead)
		return FALSE

	var/mob/living/simple/legionare_head/L = new head_type(get_turf(src))
	L.parent_legion = src
	INITIALIZE(L)
	GENERATE(L)
	FINALIZE(L)

	if(L.ai)
		if(ai && ai.objective_attack)
			L.ai.set_objective(ai.objective_attack)
		else
			L.ai.set_active(TRUE)

	tracked_heads += L

	next_head = world.time + 20

	return TRUE

/mob/living/simple/legionare/Finalize()

	if(ispath(stored_corpse))
		stored_corpse = new stored_corpse(src)
		INITIALIZE(stored_corpse)
		GENERATE(stored_corpse)
		FINALIZE(stored_corpse)
		stored_corpse.death(silent=TRUE)
		if(stored_corpse.health) stored_corpse.health.adjust_loss_smart(brute=rand(100,200),burn=rand(100,200))

	return ..()

/mob/living/simple/legionare/post_death()

	if(stored_corpse)
		var/turf/T = get_turf(src)
		stored_corpse.force_move(T)
		stored_corpse = null
		if(!clone)
			CREATE(/obj/item/legion_core,T)

	qdel(src)

	return ..()

/mob/living/simple/legionare/snow
	name = "snow legion"
	icon = 'icons/mob/living/simple/snowlegion.dmi'
	icon_state = "living"

	stun_angle = 0

	armor = /armor/legion/snow

	size = SIZE_GIANT

	head_type = /mob/living/simple/legionare_head/snow

	stored_corpse = null

/mob/living/simple/legionare/snow/post_death()
	. = ..()
	icon_state = "dead"
