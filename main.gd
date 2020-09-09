extends Node

var SNAKE = preload("res://snake.gd").new()
const SNAKE_SCENE = preload("res://snake.tscn")
const APPLE_SCENE = preload("res://apple.tscn")
const FLASH_SCENE = preload("res://flash.tscn")

var state = SNAKE.initial_state()
var time = 0
var time_step = 0.100

var apple_instance = null
var snake_instances = []
var flash_instance = null

func _ready():
    draw()

func _process(delta):
    handle_input()    
    time += delta
    if time > time_step:
        time -= time_step
        step()

func handle_input():
    if Input.is_action_just_pressed("ui_up"): state = SNAKE.enqueue(state, SNAKE.NORTH)
    if Input.is_action_just_pressed("ui_down"): state = SNAKE.enqueue(state, SNAKE.SOUTH)
    if Input.is_action_just_pressed("ui_left"): state = SNAKE.enqueue(state, SNAKE.WEST)
    if Input.is_action_just_pressed("ui_right"): state = SNAKE.enqueue(state, SNAKE.EAST)

func step():
    state = SNAKE.next(state)
    draw()

func draw():
    draw_snake(state.snake)
    draw_apple(state.apple)
    draw_flash(state.snake)

func draw_snake(snake):
    while snake_instances.size() < snake.size():  # Create snake instance if not exists
        var snake_instance = SNAKE_SCENE.instance()
        add_child(snake_instance)
        snake_instances.append(snake_instance)
    while snake_instances.size() > snake.size():  # Destroy snake instance if too many exists
        var snake_instance = snake_instances[0]
        snake_instance.queue_free()
        snake_instances.remove(0)
    for i in range(snake.size()): # "Draw" Snake
        snake_instances[i].global_position = snake[i] * 50

func draw_apple(apple):
    if not apple_instance: # Create apple instance if not exists
        apple_instance = APPLE_SCENE.instance()
        add_child(apple_instance)
    apple_instance.global_position = apple * 50 # "Draw" Apple

func draw_flash(snake):
    if snake.size() == 0 && not flash_instance: # "Draw" Flash
        flash_instance = FLASH_SCENE.instance()
        add_child(flash_instance)
    elif snake.size() != 0 && flash_instance: # Remove Flash
        flash_instance.queue_free()
        flash_instance = null
