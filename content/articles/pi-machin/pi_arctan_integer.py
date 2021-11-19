"""
Python3 program to calculate PI using long integers

See: http://www.craig-wood.com/nick/articles/pi-machin/

By Nick Craig-Wood <nick@craig-wood.com>
"""

from time import time

def arctan(x, one=1000000):
    """
    Calculate arctan(1/x)

    arctan(1/x) = 1/x - 1/3*x**3 + 1/5*x**5 - ... (x > 1)

    This calculates it in fixed point, using the value for one passed in
    """
    power = one // x            # the +/- 1/x**n part of the term
    total = power               # the total so far
    x_squared = x * x           # precalculate x**2
    divisor = 1                 # the 1,3,5,7 part of the divisor
    while 1:
        power = - power // x_squared
        divisor += 2
        power += divisor // 2   # round the division
        delta = power // divisor
        if delta == 0:
            break
        total += delta
    return total

def arctan_euler(x, one=1000000):
    """
    Calculate arctan(1/x) using euler's accelerated formula

    arctan(1/x) =                   x / (1+x**2)
                + (2/3)           * x / (1+x**2)**2
                + (2*4/(3*5))     * x / (1+x**2)**3
                + (2*4*6/(3*5*7)) * x / (1+x**2)**4
                + ...

    This calculates it in fixed point, using the value for one passed in
    """
    x_squared = x * x
    x_squared_plus_1 = x_squared + 1
    term = (x * one) // x_squared_plus_1
    total = term
    two_n = 2
    while 1:
        divisor = (two_n+1) * x_squared_plus_1
        term *= two_n
        term += divisor // 2    # round the division
        term = term // divisor
        if term == 0:
            break
        total += term
        two_n += 2
    return total

def pi_machin(one):
    return 4*(4*arctan(5, one) - arctan(239, one))
def pi_machin_euler(one):
    return 4*(4*arctan_euler(5, one) - arctan_euler(239, one))

def pi_ferguson(one):
    return 4*(3*arctan(4, one) + arctan(20, one) + arctan(1985, one))

def pi_hutton(one):
    return 4*(2*arctan(3, one) + arctan(7, one))

def pi_gauss(one):
    return 4*(12*arctan(18, one) + 8*arctan(57, one) - 5*arctan(239, one))
def pi_gauss_euler(one):
    return 4*(12*arctan_euler(18, one) + 8*arctan_euler(57, one) - 5*arctan_euler(239, one))

if __name__ == "__main__":
    for log10_digits in range(1,7):
        digits = 10**log10_digits
        one = 10**digits

        start =time()
        pi = pi_machin(one)
        #print(pi)
        print("machin: digits",digits,"time",time()-start)

        start =time()
        pi = pi_machin_euler(one)
        #print(pi)
        print("machin euler: digits",digits,"time",time()-start)

        start =time()
        pi = pi_gauss(one)
        #print(pi)
        print("gauss: digits",digits,"time",time()-start)

        start =time()
        pi = pi_gauss_euler(one)
        #print(pi)
        print("gauss euler: digits",digits,"time",time()-start)
    #print(pi_ferguson(one))
    #print(pi_hutton(one))
    #print(pi_gauss(one))
