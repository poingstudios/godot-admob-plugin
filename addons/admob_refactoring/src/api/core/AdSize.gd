class_name AdSize

static var BANNER := new(320, 50)
static var FULL_BANNER := new(468, 60)
static var LARGE_BANNER := new(320, 100)
static var LEADERBOARD := new(728, 90)
static var MEDIUM_RECTANGLE:= new(300, 250)
static var WIDE_SKYSCRAPER:= new(160, 600)

var width : int
var height : int

func _init(width : int, height : int):
	self.width = width
	self.height = height
