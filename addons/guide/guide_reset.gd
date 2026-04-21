extends Node


var _inputs_to_reset:Array[GUIDEInput] = []
var _perf_process_total_usec: float = 0.0
var _perf_process_frame_count: int = 0

func _enter_tree() -> void:
	# this should run at the end of the frame, so we put in a low priority (= high number)
	process_priority = 10000000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t0_usec := Time.get_ticks_usec()
	for input:GUIDEInput in _inputs_to_reset:
		input._reset()
		
	GUIDE._input_state._reset()
	_perf_process_total_usec += float(Time.get_ticks_usec() - t0_usec)
	_perf_process_frame_count += 1


func consume_perf_counters() -> Dictionary:
	var counters := {
		"process_usec": _perf_process_total_usec,
		"process_frames": _perf_process_frame_count,
	}
	_perf_process_total_usec = 0.0
	_perf_process_frame_count = 0
	return counters
