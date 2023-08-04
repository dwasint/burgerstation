

/event/economy_dump
	name = "Economy Dump"

	probability = 1 //relative

	occurances_max = 0 //Disabled.



/event/economy_dump/on_start()

	log_debug("Starting Economy Dump Event")

	var/price_increase = rand(5,25) //Percent.

	announce(
		"Central Command Economy Division",
		"Economy Crash",
		"Central Command Economy Division regrets to inform you that the market has suffered an economic crash. All items are [price_increase]% more expensive.",
		sound_to_play = 'sound/round_end/dump_it.ogg'
	)

	SSeconomy.crash_buy_multiplier += (price_increase/100)

	return ..()

/event/economy_dump/on_end()
	log_debug("Ending Economy Dump Event")
	return ..()
