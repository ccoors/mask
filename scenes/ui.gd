extends Control

func set_mask(mask: Dictionary):
    %mask_label.text = "Current Mask: %s" % mask["name"]
