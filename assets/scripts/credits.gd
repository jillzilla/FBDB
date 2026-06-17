extends Control

#functions
func _on_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta));

func _on_button_pressed() -> void:
	hide();