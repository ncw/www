---
categories: pymath, maths, python
date: 2011/01/19 00:00:00
title: Pi - Chudnovsky
draft: True
---

In `Part 3`_ we managed to calculate 1,000,000 decimal places of π with Machin_'s ``arctan`` formula.  Our stated aim was 100,000,000 places which we are going to achieve now!

.. sidebar:: Fun with Maths and Python

    This is a having fun with maths and python article.  See `the introduction`_ for important information!

.. _the introduction: /nick/articles/fun-with-maths-and-python-introduction/

We have still got a long way to go though, and we'll have to improve both our algorithm (formula) for π and our implementation.

The current darling of the π world is the `Chudnovsky algorithm`_ which is similar to the ``arctan`` formula but it converges much quicker.  It is also rather complicated.  The formula itself is derived from one by Ramanjuan_ who's work was extraordinary in the extreme.  It isn't trivial to prove, so I won't!

FIXME show formula
explain formula
simplify
present pi_chudnovsky.py

Prove binary splitting

Show general purpose python binary splitting

present pi_chudnovsky_bs.py

Almost all the time spent in the square root 56 seconds in bs, 419-56 in the square root!

(Try arctan bs?)

Explain about gmpy, faster multiplications than python (asymptotically)

present pi_chudnovsky_gmpy_bs.py

Graph all the results together including gmp-chudnovsky.c

Talk about gmp-chudnovsky.c's method of factoring as it goes along



There is also the `Arithmetic Geometric Mean`_ algorithm which doubles the number of decimal places each iteration.  It involves square roots and full precision divisions.  I may make these into a future article - watch this space!


ncw@dogger:~/Projects/PyMath$ python3 pi_chudnovsky.py
31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421172983
chudnovsky: digits 10 time 4.6968460083e-05
chudnovsky: digits 100 time 0.000153064727783
chudnovsky: digits 1000 time 0.00202703475952
chudnovsky: digits 10000 time 0.0868542194366
chudnovsky: digits 100000 time 8.45394992828
chudnovsky: digits 1000000 time 956.338469028

$ python3 pi_chudnovsky_bs.py
31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
chudnovsky_gmpy_bs: digits 10 time 1.09672546387e-05
chudnovsky_gmpy_bs: digits 100 time 3.19480895996e-05
Last 5 digits 70679 OK
chudnovsky_gmpy_bs: digits 1000 time 0.000489950180054
Last 5 digits 01989 OK
chudnovsky_gmpy_bs: digits 10000 time 0.0340359210968
Last 5 digits 75678 OK
chudnovsky_gmpy_bs: digits 100000 time 3.6251540184
Last 5 digits 24646 OK
chudnovsky_gmpy_bs: digits 1000000 time 419.166461945
Last 5 digits 58151 OK


Do gmpy implementatins of agm and chudnovsky?

http://gmplib.org/pi-with-gmp.html
ftp://ftp.gmplib.org/pub/misc/gmp-chudnovsky.c
https://code.google.com/p/gmpy/

agm_gmpy: digits 10 bits 49 time 5.10215759277e-05
agm_gmpy: digits 100 bits 348 time 7.20024108887e-05
agm_gmpy: digits 1000 bits 3337 time 0.000326156616211
agm_gmpy: digits 10000 bits 33235 time 0.0101361274719
agm_gmpy: digits 100000 bits 332208 time 0.401526927948
agm_gmpy: digits 1000000 bits 3321944 time 9.64124894142
agm_gmpy: digits 10000000 bits 33219296 time 189.74973917

Note that this is slightly faster than the gmpy.pi() function!

100,000,000 digits of pi uses about 300 MB of memory

chudnovsky_gmpy_mpz_bs: digits 10 time 1.59740447998e-05
chudnovsky_gmpy_mpz_bs: digits 100 time 3.40938568115e-05
chudnovsky_gmpy_mpz_bs: digits 1000 time 0.00340390205383
chudnovsky_gmpy_mpz_bs: digits 10000 time 0.0035719871521
chudnovsky_gmpy_mpz_bs: digits 100000 time 0.0912029743195
chudnovsky_gmpy_mpz_bs: digits 1000000 time 1.76005506516
chudnovsky_gmpy_mpz_bs: digits 10000000 time 30.1172571182
chudnovsky_gmpy_mpz_bs: digits 100000000 time 542.288604021

This is about half the speed of ./gmp-chudnovsky.c but all in python!


http://numbers.computation.free.fr/Constants/Algorithms/splitting.html
http://en.wikipedia.org/wiki/Binary_splitting

.. _Part 3: /nick/articles/pi-machin/
.. _Machin: http://en.wikipedia.org/wiki/John_Machin
.. _Chudnovsky algorithm: http://en.wikipedia.org/wiki/Chudnovsky_algorithm
.. _Arithmetic Geometric Mean: http://en.wikipedia.org/wiki/Gauss-Legendre_algorithm

.. _Ramanjuan: http://www-history.mcs.st-and.ac.uk/Biographies/Ramanujan.html


Write general python binary split which can be customised
with p(a), q(a) etc

m = (a + b) // 2
P(a,b) = P(a,m)Q(m,b) + P(m,b)
Q(a,b) = Q(a,m)Q(m,b)




g(a,a+1) = (6*b-5)*(2*b-1)*(6*b-1)
p(a,a+1) = b*b*b*C3_OVER_24
q = g(a,a+1) * (A+B*b)

recurse

        m = (a+b)//2
        p = p(a,m)*p(m,b)
        g = g(a,m)*g(m,b)
        q = q(a,m)*p(m,b) + q(m,b)*g(a,m)

Start with explation and test of computing factorieasl with binnary splitting and explanation of why it is quicker

Write the fractoion out

a1/b2 + a2/b2 + a3/b3+....an/bn

Then make a common denominator and add up


http://mathworld.wolfram.com/BinarySplitting.html

# Directly compute P(b-1,b), Q(b-1,b) and R(b-1,b)
Rab = (6*b-5)*(2*b-1)*(6*b-1))
Qab = b*b*b*C3_OVER_24
Pab = ((-1) ** b) * Rab * (A + B*b)


        # Recursively compute P(a,b), Q(a,b) and R(a,b)
        # m is the midpoint of a and b
        m = (a + b) // 2
        # Recursively calculate P(a,m), Q(a,m) and R(a,m)
        Pam, Qam, Ram = _pi_chudnovsky_bs(a, m)
        # Recursively calculate P(m,b), Q(m,b) and R(m,b)
        Pmb, Qmb, Rmb = _pi_chudnovsky_bs(m, b)
        # Now combine
        Pab = Pam * Qmb + Ram * Pmb
        Qab = Qam * Qmb
        Rab = Ram * Rmb
    return Pab, Qab, Rab

used this paper
.. _proof of binary splitting: http://www.ginac.de/CLN/binsplit.pdf


pi_gauss arctan digits 10 time 1.31130218506e-05
pi_gauss arctan_euler digits 10 time 8.82148742676e-06
pi_gauss arctan_bs digits 10 time 3.09944152832e-05
pi_gauss arctan_euler_bs digits 10 time 2.28881835938e-05
...
pi_gauss arctan digits 100 time 8.20159912109e-05
pi_gauss arctan_euler digits 100 time 6.41345977783e-05
pi_gauss arctan_bs digits 100 time 0.000153064727783
pi_gauss arctan_euler_bs digits 100 time 0.000136852264404
...
pi_gauss arctan digits 1000 time 0.00285506248474
pi_gauss arctan_euler digits 1000 time 0.00185012817383
pi_gauss arctan_bs digits 1000 time 0.00165295600891
pi_gauss arctan_euler_bs digits 1000 time 0.00161004066467
...
pi_gauss arctan digits 10000 time 0.190967082977
pi_gauss arctan_euler digits 10000 time 0.106532812119
pi_gauss arctan_bs digits 10000 time 0.0348498821259
pi_gauss arctan_euler_bs digits 10000 time 0.0329759120941
...
pi_gauss arctan digits 100000 time 18.3626730442
pi_gauss arctan_euler digits 100000 time 10.288025856
pi_gauss arctan_bs digits 100000 time 1.20849299431
pi_gauss arctan_euler_bs digits 100000 time 1.2115380764
...
pi_gauss arctan digits 1000000 time 1886.89702201
pi_gauss arctan_euler digits 1000000 time 1164.72837996
pi_gauss arctan_bs digits 1000000 time 49.5484290123
pi_gauss arctan_euler_bs digits 1000000 time 50.841176033

