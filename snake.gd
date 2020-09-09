extends Node

const NORTH = Vector2.UP
const SOUTH = Vector2.DOWN
const EAST = Vector2.RIGHT
const WEST = Vector2.LEFT

# Operations
func equals(o1, o2): return o1 == o2
func contains(list, value):
    for item in list:
        if item == value:
            return true
    return false
func copy(dict): return dict.duplicate(true)
func length(list): return list.size()
func head(list): return list[0]
func tail(list): return list[list.size() - 1]
func modulus_xy(v1, v2): return Vector2(int(v1.x) % int(v2.x), int(v1.y) % int(v2.y))
func concat(list1, list2): return list1 + list2
func drop_first(list): 
    list = copy(list); 
    if list.size() > 0: list.remove(0);
    return list
func drop_last(list): 
    list = copy(list);
    if list.size() > 0: list.remove(list.size() - 1);
    return list

# Booleans
func will_eat(state): return equals(next_head(state), state.apple)
func will_crash(state): return contains(state.snake, next_head(state))
func valid_move(state, move): return state.moves[0].x != -move.x || state.moves[0].y != -move.y

# Next Values
func next_moves(state): return drop_first(state.moves) if length(state.moves) > 1 else state.moves
func next_apple(state): return random_position(state) if will_eat(state) else state.apple
func next_head(state):
    if length(state.snake) == 0: return Vector2(2,2)
    else: return modulus_xy(head(state.snake) + head(state.moves) + state.world_size, state.world_size)

func next_snake(state):
    if will_crash(state): return []
    elif will_eat(state): return concat([next_head(state)], state.snake)
    else: return concat([next_head(state)], drop_last(state.snake))


func random_position(state):
    return Vector2(randi() % int(state.world_size.x), randi() % int(state.world_size.y))

func initial_state():
    return {
        "world_size": Vector2(20, 12),
        "moves": [EAST],
        "snake": [],
        "apple": Vector2(16, 2)}

func next(state):
    return {
        "world_size": state.world_size,
        "moves": next_moves(state),
        "snake": next_snake(state),
        "apple": next_apple(state)}

func enqueue(state, move):
    if valid_move(state, move): return update_moves(state, concat(state.moves, [move]))
    else: return state

func update_moves(state, moves):
    state = copy(state); state.moves = moves; return state
