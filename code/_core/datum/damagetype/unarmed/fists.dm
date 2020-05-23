//Fists
/damagetype/unarmed/fists/
	name = "fist"
	attack_verbs = list("punch","hit","slap","strike","pummel","pound")

	hit_effect = /obj/effect/temp/impact/combat/punch

	//The base attack damage of the weapon. It's a flat value, unaffected by any skills or attributes.
	attack_damage_base = list(
		BLUNT = 5,
		FATIGUE = 5
	)

	//How much armor to penetrate. It basically removes the percentage of the armor using these values.
	attack_damage_penetration = list(
		BLUNT = 5,
		FATIGUE = 5,
	)

	attribute_stats = list(
		ATTRIBUTE_STRENGTH = 40,
		ATTRIBUTE_DEXTERITY = 20
	)

	attribute_damage = list(
		ATTRIBUTE_STRENGTH = BLUNT,
		ATTRIBUTE_DEXTERITY = BLUNT
	)

	skill_stats = list(
		SKILL_UNARMED = 40
	)

	skill_damage = list(
		SKILL_UNARMED = BLUNT
	)

	allow_friendly_fire = FALSE

	cqc_tag = "4"

/damagetype/unarmed/fists/help
	name = "help fists"
	attack_verbs = list("tap")

	hit_effect = null

	hit_effect = null

	//The base attack damage of the weapon. It's a flat value, unaffected by any skills or attributes.
	attack_damage_base = list(
		FATIGUE = 0
	)

	//How much armor to penetrate. It basically removes the percentage of the armor using these values.
	attack_damage_penetration = list(

	)

	attribute_stats = list(
		ATTRIBUTE_STRENGTH = 10
	)

	attribute_damage = list(
		ATTRIBUTE_STRENGTH = FATIGUE
	)

	skill_stats = list(

	)

	skill_damage = list(

	)

	cqc_tag = "1"

/damagetype/unarmed/fists/disarm
	name = "disarm fists"
	attack_verbs = list("shove")

	impact_sounds = list(
		'sounds/weapons/fists/grab.ogg'
	)

	hit_effect = /obj/effect/temp/impact/combat/disarm

	//The base attack damage of the weapon. It's a flat value, unaffected by any skills or attributes.
	attack_damage_base = list(
		FATIGUE = 10
	)

	//How much armor to penetrate. It basically removes the percentage of the armor using these values.
	attack_damage_penetration = list(

	)

	attribute_stats = list(
		ATTRIBUTE_STRENGTH = 20,
		ATTRIBUTE_DEXTERITY = 20
	)

	attribute_damage = list(
		ATTRIBUTE_STRENGTH = FATIGUE,
		ATTRIBUTE_DEXTERITY = FATIGUE
	)

	skill_stats = list(
		SKILL_UNARMED = 20
	)

	skill_damage = list(
		SKILL_UNARMED = FATIGUE
	)

	cqc_tag = "2"

/damagetype/unarmed/fists/disarm/post_on_hit(var/atom/attacker,var/atom/victim,var/atom/weapon,var/atom/hit_object,var/atom/blamed,var/total_damage_dealt=0)

	if(is_living(victim))
		var/mob/living/L = victim

		if(is_living(attacker))
			var/mob/living/A = attacker
			if(A.loyalty_tag != L.loyalty_tag && prob(total_damage_dealt))
				L.add_status_effect(DISARM,5,5, source = attacker)
				return ..()

		if(prob(total_damage_dealt*0.5))
			L.add_status_effect(STAGGER,1,1, source = attacker)

	return ..()

/damagetype/unarmed/fists/grab
	name = "grab fists"
	attack_verbs = list("grab")

	hit_effect = /obj/effect/temp/impact/combat/disarm

	impact_sounds = list(
		'sounds/weapons/fists/grab.ogg'
	)

	//The base attack damage of the weapon. It's a flat value, unaffected by any skills or attributes.
	attack_damage_base = list(
		FATIGUE = 0
	)

	//How much armor to penetrate. It basically removes the percentage of the armor using these values.
	attack_damage_penetration = list(

	)

	attribute_stats = list(
		ATTRIBUTE_STRENGTH = 10,
		ATTRIBUTE_DEXTERITY = 10
	)

	attribute_damage = list(
		ATTRIBUTE_STRENGTH = FATIGUE,
		ATTRIBUTE_DEXTERITY = FATIGUE
	)

	skill_stats = list(
		SKILL_UNARMED = 20
	)

	skill_damage = list(
		SKILL_UNARMED = FATIGUE
	)

	cqc_tag = "3"

/damagetype/unarmed/fists/grab/post_on_hit(var/atom/attacker,var/atom/victim,var/atom/weapon,var/atom/hit_object,var/atom/blamed,var/total_damage_dealt=0)

	if(is_advanced(attacker) && ismovable(victim) && isturf(victim.loc))
		var/mob/living/advanced/A = attacker
		if(istype(weapon,/obj/item/organ/hand))
			var/obj/item/organ/hand/H = weapon
			if(H.id == BODY_HAND_RIGHT)
				A.right_hand.grab_object(attacker,victim)
			else if(H.id == BODY_HAND_LEFT)
				A.left_hand.grab_object(attacker,victim)

	return ..()