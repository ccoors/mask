extends HBoxContainer

var health: int = 0

func set_health(new_health: int):
    health = new_health
    var icons = get_tree().get_nodes_in_group("health_icon")
    if icons.size() == new_health:
        return
    elif icons.size() > new_health:
        for i in icons.slice(new_health + 1):
            i.queue_free()
    else:
        for i in range(new_health - icons.size()):
            var t = %template.duplicate()
            add_child(t)
            t.visible = true
