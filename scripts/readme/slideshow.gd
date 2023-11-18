extends Control

export var slides = []
var currentSlide:int = 0
var displayTextRate:float = 1
var bSlideUpdated:bool = false

func _process(delta):
	if (bSlideUpdated):
		get_node(slides[currentSlide]).get_node("RichTextLabel").percent_visible += displayTextRate * delta
		if (get_node(slides[currentSlide]).get_node("RichTextLabel").percent_visible >= 1):
			bSlideUpdated = false

func show_slide(slideIndex:int):
	for i in slides:
		get_node(i).visible = false
	currentSlide = slideIndex
	get_node(slides[slideIndex]).visible = true
	get_node(slides[slideIndex]).get_node("RichTextLabel").percent_visible = 0
	bSlideUpdated = true
