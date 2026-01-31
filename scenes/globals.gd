extends Node

var mask_idx: int = 0
signal mask_changed(idx: int)

const TILE_WIDTH:int = 120

const MASKS = [
    {
        "name": "Lava mask",
        "input_action": "mask_1",
        "color": Color(0.661, 0.143, 0.077, 1.0),
        "collision_mask": 2,
    },
    {
        "name": "Wood mask",
        "input_action": "mask_2",
        "color": Color(0.373, 0.613, 0.0, 1.0),
        "collision_mask": 3,
    },
    {
        "name": "Water mask",
        "input_action": "mask_3",
        "color": Color(0.0, 0.578, 0.805, 1.0),
        "collision_mask": 4,
    },
]

func reset() -> void:
    change_mask(0)

func _ready() -> void:
    change_mask(mask_idx)

func change_mask(idx: int):
    assert(idx >= 0)
    assert(idx < MASKS.size())
    mask_changed.emit(idx)
