#!/usr/bin/env python3
"""
Snake cube solver
"""

# definition - number of straight bits, before 90 degree bend
snake = [3,2,2,2,1,1,1,2,2,1,1,2,1,2,1,1,2]
assert sum(snake) == 27

N = 5
xstride=1
ystride=N
zstride=N*N
empty = 0

# Define cube as 5 x 5 x 5 with filled in edges but empty middle for
# easy edge detection
top = [-1]*N*N
middle = [-1]*5 + [-1,0,0,0,-1]*3 + [-1]*5
cube = top + middle*3 + top

# directions next piece could go in
directions = [xstride, -xstride, ystride, -ystride, zstride, -zstride]

def pos(x, y, z):
    """Convert x,y,z into position in cube list"""
    return x+y*ystride+z*zstride

def print_cube(cube, margin=1):
    """Print the cube"""
    for z in range(margin,N-margin):
        for y in range(margin,N-margin):
            for x in range(margin,N-margin):
                v = cube[pos(x,y,z)]
                if v == 0:
                    s = " . "
                else:
                    s = "%02d " % v
                print(s, sep="", end="")
            print()
        print()

def place(cube, position, direction, length, piece_number):
    """Place a segment in the cube"""
    for _ in range(length):
        position += direction
        assert cube[position] == empty
        cube[position] = piece_number
        piece_number += 1
    return position

def unplace(cube, position, direction, length):
    """Remove a segment from the cube"""
    for _ in range(length):
        position += direction
        cube[position] = empty

def is_valid(cube, position, direction, length):
    """Returns True if a move is valid"""
    for _ in range(length):
        position += direction
        if cube[position] != empty:
            return False
    return True

def moves(cube, position, direction, length):
    """Returns the valid moves for the current position"""
    valid_moves = []
    for new_direction in directions:
        # Can't carry on in same direction, or the reverse of the same direction
        if new_direction == direction or new_direction == -direction:
            continue
        if is_valid(cube, position, new_direction, length):
            valid_moves.append(new_direction)
    return valid_moves

def solve(cube, position, direction, snake, piece_number):
    """Recursive cube solver"""
    if len(snake) == 0:
        print("Solution")
        print_cube(cube)
        return
    length, snake = snake[0], snake[1:]
    valid_moves = moves(cube, position, direction, length)
    for new_direction in valid_moves:
        new_position = place(cube, position, new_direction, length, piece_number)
        solve(cube, new_position, new_direction, snake, piece_number+length)
        unplace(cube, position, new_direction, length)

def main():
    # The first piece has to go along one edge
    position = pos(0,1,1)
    direction = xstride
    length = snake[0]
    position = place(cube, position, direction, length, 1)
    solve(cube, position, direction, snake[1:], length+1)

if __name__ == "__main__":
    main()
