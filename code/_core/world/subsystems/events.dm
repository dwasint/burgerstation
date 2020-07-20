SUBSYSTEM_DEF(events)
	name = "Event Subsystem"
	desc = "Stores all the known dialogue in a list."
	priority = SS_ORDER_NORMAL
	tick_rate = SECONDS_TO_TICKS(1)

	var/list/all_events = list()
	var/list/all_events_prob = list()
	var/list/all_events_active = list()

	var/next_event_time = 0

/subsystem/events/Initialize()

	for(var/k in subtypesof(/event/))
		var/event/E = new k
		all_events[E.type] = E
		all_events_prob[E.type] = E.probability

	next_event_time = world.time + SECONDS_TO_DECISECONDS(1200)

/subsystem/events/on_life()

	for(var/event/E in all_events_active)
		if(E.end_time <= world.time)
			E.on_end()
			E.active = FALSE
			all_events_active -= E
		else
			E.on_life()

	if(world.time >= next_event_time)
		trigger_random_event()
		next_event_time = world.time + SECONDS_TO_DECISECONDS(rand(300,600))

	return TRUE

/subsystem/events/proc/trigger_random_event()

	var/event_id = pickweight(all_events_prob)

	if(!event_id)
		LOG_DEBUG("There are [length(all_events_prob)] events!")
		return FALSE

	var/event/E = all_events[event_id]
	if(E.active)
		return FALSE

	E.on_start()
	if(E.duration)
		all_events_active += E
		E.active = TRUE
		E.start_time = world.time
		E.end_time = world.time + E.duration
	else
		E.on_end()

	return E






