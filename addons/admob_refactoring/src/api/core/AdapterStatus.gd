class_name AdapterStatus

var latency : int
var initialization_status : State 
var description : String

enum State{
	NOT_READY,
	READY
}

func _init(latency : int, initialization_status : State, description : String ) -> void:
	self.latency = latency
	self.initialization_status = initialization_status
	self.description = description
