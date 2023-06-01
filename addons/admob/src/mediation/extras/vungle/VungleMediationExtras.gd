class_name VungleMediationExtras
extends MediationExtras

const ALL_PLACEMENTS_KEY := "ALL_PLACEMENTS_KEY"
const USER_ID_KEY := "USER_ID_KEY"
const SOUND_ENABLED_KEY := "SOUND_ENABLED_KEY"

var all_placements : Array[String] : 
	set(value):
		extras[ALL_PLACEMENTS_KEY] = str(value)

var user_id : String : 
	set(value):
		extras[USER_ID_KEY] = value

var sound_enabled : bool : 
	set(value):
		extras[SOUND_ENABLED_KEY] = value
