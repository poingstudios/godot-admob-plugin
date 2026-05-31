extends Node

# gdlint: disable=function-name
func getSmartBannerAdSize() -> Dictionary:
	return {"width": 320, "height": 50}
# gdlint: disable=function-name

func getCurrentOrientationAnchoredAdaptiveBannerAdSize(width: int) -> Dictionary:
# gdlint: disable=function-name
	return {"width": width, "height": 50}

# gdlint: disable=function-name
func getPortraitAnchoredAdaptiveBannerAdSize(width: int) -> Dictionary:
	return {"width": width, "height": 50}

func getLandscapeAnchoredAdaptiveBannerAdSize(width: int) -> Dictionary:
	return {"width": width, "height": 50}
