"""
Python3 program to Calculate PI using the circumference of a polygon

See: http://www.craig-wood.com/nick/articles/nick/articles/pi-archimedes/

By Nick Craig-Wood <nick@craig-wood.com>

We inscribe a square in a circle of unit radius initially and
calculate half the circumference of the square to approximate pi.

We then divide each segment of the polygon in two and find the new
length of the polygon using the recurrence relation

new_edge_length = sqrt(2 - 2 * sqrt(1 - (edge_length ** 2) / 4))

It is simpler to calculate the square of the polygon_edge length, and
square root it at the end

new_edge_length_squared = 2 - 2 * sqrt(1 - edge_length_squared / 4))
"""

import math

def pi_archimedes(n):
    """
    Calculate n iterations of Archimedes PI recurrence relation
    """
    polygon_edge_length_squared = 2.0
    polygon_sides = 4
    for i in range(n):
        polygon_edge_length_squared = 2 - 2 * math.sqrt(1 - polygon_edge_length_squared / 4)
        polygon_sides *= 2
    return polygon_sides * math.sqrt(polygon_edge_length_squared) / 2

def main():
    """
    Try the series
    """
    for n in range(16):
        result = pi_archimedes(n)
        error = result - math.pi
        print("%8d iterations, sides %6d, %.10f error %.10f" % (n, 2**(n+2), result, error))

if __name__ == "__main__":
    main()
