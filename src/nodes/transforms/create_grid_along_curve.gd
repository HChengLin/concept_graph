"""
TODO: It would be nice to have a WrapAroundCurve instead, so we could use a regular MakeGrid
(or anything else) and plug the output to a WrapAroundCurve, but I have no idea how to do that
"""

tool
class_name ConceptNodeCreateGridAlongCurve
extends ConceptNode


func _init() -> void:
	node_title = "Create grid along curve"
	category = "Nodes"
	description = "Create transforms along a curve"

	set_input(0, "Curve", ConceptGraphDataType.CURVE)
	set_input(1, "Density", ConceptGraphDataType.SCALAR, {"step": 0.001})
	set_input(2, "Height", ConceptGraphDataType.SCALAR)
	set_input(3, "Thickness", ConceptGraphDataType.SCALAR)
	set_output(0, "Transforms", ConceptGraphDataType.NODE)


func _generate_output(idx: int) -> Array:
	var result = []
	var curves = get_input(0)

	if not curves:
		return result
	if not curves is Array:
		curves = [curves]

	var density: float = get_input(1, 1.0)
	var height: float = get_input(2, 1.0)
	var thickness: float = get_input(3, 1.0)

	for curve in curves:
		var length: float = curve.get_baked_length()
		var steps := max(1, int(round(length / density)))
		var instances_in_column := max(1, int(round(height / density)))

		for i in range(steps):
			var offset := i * (length / steps)
			var pos: Vector3 = curve.interpolate_baked(offset)

			for j in range(instances_in_column):
				var node = Position3D.new()
				node.transform.origin = pos
				node.transform.origin.y = j * (height / instances_in_column)
				result.append(node)

	return result

"""
	if offset + 1.0 < path_length:
		pos1 = _path.curve.interpolate_baked(offset + 1.0)
		normal = (pos1 - pos)
	else:
		pos1 = _path.curve.interpolate_baked(offset - 1.0)
		normal = (pos - pos1)

	normal.y = 0.0
	normal = normal.normalized().rotated(Vector3.UP, PI / 2.0)
	var ratio = relative_pos / height
	var mod = height_curve.interpolate_baked(ratio)
	pos += normal * mod
	return [pos, normal]
"""