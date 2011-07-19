"""
Python3 program to Calculate PI using Gregory's Series

See: http://www.craig-wood.com/nick/articles/pi-gregorys-series/

By Nick Craig-Wood <nick@craig-wood.com>
"""

import math

def pi_gregory(n):
    """
    Calculate n iterations of Gregory's series
    """
    result = 0
    divisor = 1
    sign = 1
    for i in range(n):
        result += sign / divisor
        divisor += 2
        sign = -sign
    return 4 * result

def main():
    """
    Try Gregory's series
    """
    for log_n in range(1,8):
        n = 10**log_n
        result = pi_gregory(n)
        error = result - math.pi
        print("%8d iterations %.10f error %.10f" % (n, result, error))

if __name__ == "__main__":
    main()

        

        
        
