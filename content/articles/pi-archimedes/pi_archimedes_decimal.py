"""
Python3 program to Calculate 100 decimal places of PI using Archimedes
method and decimal numbers

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

from decimal import Decimal, getcontext

def pi_archimedes(n):
    """
    Calculate n iterations of Archimedes PI recurrence relation
    """
    polygon_edge_length_squared = Decimal(2)
    polygon_sides = 2
    for i in range(n):
        polygon_edge_length_squared = 2 - 2 * (1 - polygon_edge_length_squared / 4).sqrt()
        polygon_sides *= 2
    return polygon_sides * polygon_edge_length_squared.sqrt()

def main():
    """
    Try the series
    """
    places = 100
    old_result = None
    for n in range(10*places):
        # Do calculations with double precision
        getcontext().prec = 2*places
        result = pi_archimedes(n)
        # Print the result with single precision
        getcontext().prec = places
        result = +result           # do the rounding on result
        print("%3d: %s" % (n, result))
        if result == old_result:
            break
        old_result = result

if __name__ == "__main__":
    main()
