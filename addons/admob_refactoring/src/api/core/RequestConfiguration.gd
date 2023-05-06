class_name RequestConfiguration

enum TagForChildDirectedTreatment{
	UNSPECIFIED = -1,
	FALSE = 0,
	TRUE = 1
}

enum TagForUnderAgeOfConsent{
	UNSPECIFIED = -1,
	FALSE = 0,
	TRUE = 1
}

const MAX_AD_CONTENT_RATING_UNSPECIFIED := ""
const MAX_AD_CONTENT_RATING_G := "G"
const MAX_AD_CONTENT_RATING_PG := "PG"
const MAX_AD_CONTENT_RATING_T := "T"
const MAX_AD_CONTENT_RATING_MA := "MA"

var max_ad_content_rating := ""
var tag_for_child_directed_treatment := TagForChildDirectedTreatment.UNSPECIFIED
var tag_for_under_age_of_consent := TagForUnderAgeOfConsent.UNSPECIFIED
var test_device_ids : Array[String]
