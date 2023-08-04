/obj/item/clothing/get_base_value()

	var/armor/A = ARMOR(armor)
	if(A) . = 5 + A.value

	var/total_value_mul = 0
	for(var/limb_zone in protected_limbs)
		if(SSbalance.limbs_to_value[limb_zone] <= 0)
			continue
		total_value_mul += SSbalance.limbs_to_value[limb_zone]
	if(total_value_mul > 0)
		. *= total_value_mul

	// https://www.desmos.com/calculator/mzuyizloap
	if(is_container && dynamic_inventory_count > 0)
		. += ((dynamic_inventory_count*container_max_size)**1.4)*0.35

	if(speed_bonus > 0) // 3000 per 0.1 (10%)
		. += speed_bonus*(3000/0.1)

	. = CEILING(.,1)
