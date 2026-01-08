extends RefCounted
class_name MinHeap
var data: Array = []

func is_empty() -> bool:
	return data.is_empty()

func push(item):
	data.append(item)
	_sift_up(data.size() - 1)

func pop():
	var result = data[0]
	data[0] = data.back()
	data.pop_back()
	_sift_down(0)
	return result

func _sift_up(i):
	while i > 0:
		var p = (i - 1) >> 1
		if data[p].f <= data[i].f:
			break
		_swap(p, i)
		i = p

func _sift_down(i):
	while true:
		var l = i * 2 + 1
		var r = l + 1
		var smallest = i

		if l < data.size() and data[l].f < data[smallest].f:
			smallest = l
		if r < data.size() and data[r].f < data[smallest].f:
			smallest = r

		if smallest == i:
			break
		_swap(i, smallest)
		i = smallest

# Manually swap two elements
func _swap(a: int, b: int) -> void:
	var tmp = data[a]
	data[a] = data[b]
	data[b] = tmp
