---
categories: pymath, maths, python
date: 2011/07/24 00:00:00
title: Pi - Chudnovsky
permalink: /nick/articles/pi-chudnovsky
---

In `Part 3`_ we managed to calculate 1,000,000 decimal places of π with Machin_'s ``arctan`` formula.  Our stated aim was 100,000,000 places which we are going to achieve now!

.. sidebar:: Fun with Maths and Python

    This is a having fun with maths and python article.  See `the introduction`_ for important information!

.. _the introduction: /nick/articles/fun-with-maths-and-python-introduction/
.. _Machin: http://en.wikipedia.org/wiki/John_Machin

We have still got a long way to go though, and we'll have to improve both our algorithm (formula) for π and our implementation.

The current darling of the π world is the `Chudnovsky algorithm`_ which is similar to the ``arctan`` formula but it converges much quicker.  It is also rather complicated.  The formula itself is derived from one by Ramanjuan_ who's work was extraordinary in the extreme.  It isn't trivial to prove, so I won't!  Here is Chudnovsky's formula for π as it is usually stated:

.. latex::
    \[
    \frac{1}{\pi} = 12 \sum^\infty_{k=0} \frac{(-1)^k (6k)! (13591409 + 545140134k)}{(3k)!(k!)^3 640320^{3k + 3/2}}
    \]

.. _Chudnovsky algorithm: http://en.wikipedia.org/wiki/Chudnovsky_algorithm
.. _Ramanjuan: http://www-history.mcs.st-and.ac.uk/Biographies/Ramanujan.html

That is quite a complicated formula, we will make more comprehensible in a moment.  If you haven't seen the Σ notation before it just like a ``sum`` over a ``for`` loop in python.  For example:

.. latex::
    \[
    \sum^{10}_{k=1} k^2
    \]

Is exactly the same as this python fragment::

    #!python
    sum(k**2 for k in range(1,11))

First let's get rid of that funny fractional power:

.. latex::
    \begin{eqnarray*}
    \frac{1}{\pi} &=& 12 \sum^\infty_{k=0} \frac{(-1)^k (6k)! (13591409 + 545140134k)}{(3k)!(k!)^3 640320^{3k + 3/2}} \\
                  &=& \frac{12}{640320 \sqrt{640320}} \sum^\infty_{k=0} \frac{(-1)^k (6k)! (13591409 + 545140134k)}{(3k)!(k!)^3 640320^{3k}} \\
                  &=& \frac{1}{426880 \sqrt{10005}} \sum^\infty_{k=0} \frac{(-1)^k (6k)! (13591409 + 545140134k)}{(3k)!(k!)^3 640320^{3k}} \\
    \end{eqnarray*}

Now let's split it into two independent parts.  See how there is a ``+`` sign inside the Σ?  We can split it into two series which we will call ``a`` and ``b`` and work out what π is in terms of ``a`` and ``b``:

.. latex::
    \begin{eqnarray*}
    a     &=& \sum^\infty_{k=0} \frac{(-1)^k (6k)!}{(3k)!(k!)^3 640320^{3k}} \\
          &=& 1
              - \frac{6\cdot5\cdot4}{(1)^3 640320^3}
              + \frac{12\cdot11\cdot10\cdot9\cdot8\cdot7}{(2\cdot1)^3 640320^6}
              - \frac{18\cdot17\cdots13}{(3\cdot2\cdot1)^3 640320^{9}}
              + \cdots \\
    b     &=& \sum^\infty_{k=0} \frac{(-1)^k (6k)!k}{(3k)!(k!)^3 640320^{3k}} \\
    \frac{1}{\pi} &=& \frac{13591409a + 545140134b}{426880 \sqrt{10005}} \\
    \pi           &=& \frac{426880 \sqrt{10005}}{13591409a + 545140134b} \\
    \end{eqnarray*}

Finally note that we can calculate the next ``a`` term from the
previous one, and the ``b`` terms from the ``a`` terms which
simplifies the calculations rather a lot.

.. latex::
    \begin{eqnarray*}
    a_k &=& \frac{(-1)^k (6k)!}{(3k)!(k!)^3 640320^{3k}} \\
    b_k &=& k \cdot a_k \\
    \frac{a_{k}}{a_{k-1}} &=& - \frac{(6k-5)(6k-4)(6k-3)(6k-2)(6k-1)6k}{3k(3k-1)(3k-1)k^3 640320^3} \\
                          &=& - \frac{24(6k-5)(2k-1)(6k-1)}{k^3 640320^3} \\
    \end{eqnarray*}

OK that was a lot of maths!  But it is now in an easy to compute state, which we can do like this::

    #!python
    def pi_chudnovsky(one=1000000):
        """
        Calculate pi using Chudnovsky's series
    
        This calculates it in fixed point, using the value for one passed in
        """
        k = 1
        a_k = one
        a_sum = one
        b_sum = 0
        C = 640320
        C3_OVER_24 = C**3 // 24
        while 1:
            a_k *= -(6*k-5)*(2*k-1)*(6*k-1)
            a_k //= k*k*k*C3_OVER_24
            a_sum += a_k
            b_sum += k * a_k
            k += 1
            if a_k == 0:
                break
        total = 13591409*a_sum + 545140134*b_sum
        pi = (426880*sqrt(10005*one, one)*one) // total
        return pi

We need to be able to take the square root of long integers which
python doesn't have a built in for.  Luckily this is easy to provide.
This uses a `square root algorithm devised by Newton`_ which doubles
the number of significant places in the answer (quadratic convergence)
each iteration::

   #!python
    def sqrt(n, one):
        """
        Return the square root of n as a fixed point number with the one
        passed in.  It uses a second order Newton-Raphson convergence.  This
        doubles the number of significant figures on each iteration.
        """
        # Use floating point arithmetic to make an initial guess
        floating_point_precision = 10**16
        n_float = float((n * floating_point_precision) // one) / floating_point_precision
        x = (int(floating_point_precision * math.sqrt(n_float)) * one) // floating_point_precision
        n_one = n * one
        while 1:
            x_old = x
            x = (x + n_one // x) // 2
            if x == x_old:
                break
        return x

.. _square root algorithm devised by Newton: http://en.wikipedia.org/wiki/Newton's_method#Square_root_of_a_number

It uses normal floating point arithmetic to make an initial guess then refines it using Newton's method.

See `pi_chudnovsky.py`_ for the complete program.  When I run it I get this:

.. _pi_chudnovsky.py: /nick/pub/pymath/pi_chudnovsky.py

======= =========================
Digits  Time (seconds)
======= =========================
     10 4.696e-05
    100 0.0001530
   1000 0.002027
  10000 0.08685
 100000 8.453
1000000 956.3
======= =========================

Which is nearly 3 times quicker than the best result in `part 3`_, and gets us 1,000,000 places of π in about 15 minutes.

Amazingly there are still two major improvements we can make to this.  The first is to recast the calculation using something called `binary splitting`_.  Binary splitting is a general purpose technique for speeding up this sort of calculation.  What it does is convert the sum of the individual fractions into one giant fraction.  This means that you only do one divide at the end of the calculation which speeds things up greatly, because division is slow compared to multiplication.

.. _binary splitting: http://numbers.computation.free.fr/Constants/Algorithms/splitting.html

Consider the general infinite series

.. latex::
    \[
    S(0,\infty) = \frac{a_0p_0}{b_0q_0}
    + \frac{a_1p_0p_1}{b_1q_0q_1}
    + \frac{a_2p_0p_1p_2}{b_2q_0q_1q_2}
    + \frac{a_3p_0p_1p_2p_3}{b_3q_0q_1q_2q_3}
    + \cdots
    \]

This could be used as a model for all the infinite series we've looked at so far.  Now lets consider the partial sum of that series from terms ``a`` to ``b`` (including a, not including b).

.. latex::
    \begin{eqnarray*}
    S(a,b) &=& \frac{a_ap_a}{b_aq_a}
    + \frac{a_{a+1}p_ap_{a+1}}{b_{a+1}q_aq_{a+1}}
    + \frac{a_{a+2}p_ap_{a+1}p_{a+2}}{b_{a+2}q_aq_{a+1}q_{a+2}}
    + \cdots
    + \frac{a_{b-1}p_ap_{a+1}p_{a+2}\cdots p_{b-1}}{b_{b-1}q_aq_{a+1}\cdots p_{b-1}} \\
    \end{eqnarray*}

This is a part of the infinite series, and if a=0 and b=∞ it becomes the infinite series above.

Now lets define some extra functions:

.. latex::
    \begin{eqnarray*}
    P(a,b) &=& p_ap_{a+1}\cdots p_{b-1} \\
    Q(a,b) &=& q_aq_{a+1}\cdots q_{b-1} \\
    B(a,b) &=& b_ab_{a+1}\cdots b_{b-1} \\
    T(a,b) &=& B(a,b)Q(a,b)S(a,b) \\
    \end{eqnarray*}

Let's define m which is a <= m <= b.  Making m as near to the middle of a and b will lead to the quickest calculations, but for the proof, it has to be somewhere between them.  Lets work out what happens to our variables P, Q, R and T when we split the series in two:

.. latex::
    \begin{eqnarray*}
    P(a,b) &=& P(a,m)P(b,m) \\
    Q(a,b) &=& Q(a,m)Q(b,m) \\
    B(a,b) &=& B(a,m)B(b,m) \\
    T(a,b) &=& B(m,b)Q(m,b)T(a,m) + B(a,m)P(a,m)T(m,b) \\
    \end{eqnarray*}

The first three of those statements are obvious from the definitions, but the last deserves proof.

.. latex::
    \begin{eqnarray*}
    \lefteqn{B(m,b)Q(m,b)T(a,m) + B(a,m)P(a,m)T(m,b) = } \\
    & & \left[T(a,b) = B(a,b)Q(a,b)S(a,b)\right] \\
    &=& B(m,b)Q(m,b)B(a,m)Q(a,m)S(a,m) + B(a,m)P(a,m)B(m,b)Q(m,b)S(m,b) \\
    & & \left[Q(a,b) = Q(a,m)Q(b,m)\right] \\
    & & \left[B(a,b) = B(a,m)B(b,m)\right] \\
    &=& B(a,b)Q(a,b)S(a,m) + B(a,b)P(a,m)Q(m,b)S(m,b) \\
    &=& B(a,b)(Q(a,b)S(a,m) + P(a,m)Q(m,b)S(m,b)) \\
    & & \left[Q(m,b) = \frac{Q(a,b)}{Q(a,m)}\right] \\
    &=& B(a,b)\left(Q(a,b)S(a,m) + \frac{Q(a,b)P(a,m)}{Q(a,m)}S(m,b)\right) \\
    &=& B(a,b)Q(a,b)\left(S(a,m) + \frac{P(a,m)}{Q(a,m)}S(m,b)\right) \\
    &=& B(a,b)Q(a,b)\left(
    \frac{a_ap_a}{b_aq_a}
    + \frac{a_{a+1}p_ap_{a+1}}{b_{a+1}q_aq_{a+1}}
    + \frac{a_{a+2}p_ap_{a+1}p_{a+2}}{b_{a+2}q_aq_{a+1}q_{a+2}}
    + \cdots
    + \frac{a_{m-1}p_ap_{a+1}p_{a+2}\cdots p_{m-1}}{b_{m-1}q_aq_{a+1}\cdots p_{m-1}}
    + \frac{p_ap_{a+1}\cdots p_{m-1}}{q_aq_{a+1}\cdots q_{m-1}}
    + \left(\frac{a_mp_m}{b_mq_m}
    + \frac{a_{m+1}p_mp_{m+1}}{b_{m+1}q_mq_{m+1}}
    + \frac{a_{m+2}p_mp_{m+1}p_{m+2}}{b_{m+2}q_mq_{m+1}q_{m+2}}
    + \cdots
    + \frac{a_{b-1}p_mp_{m+1}p_{m+2}\cdots p_{b-1}}{b_{b-1}q_mq_{m+1}\cdots p_{b-1}}
    \right)\right) \\
    &=& B(a,b)Q(a,b)\left(
    \frac{a_ap_a}{b_aq_a}
    + \frac{a_{a+1}p_ap_{a+1}}{b_{a+1}q_aq_{a+1}}
    + \frac{a_{a+2}p_ap_{a+1}p_{a+2}}{b_{a+2}q_aq_{a+1}q_{a+2}}
    + \cdots
    + \frac{a_{m-1}p_ap_{a+1}p_{a+2}\cdots p_{m-1}}{b_{m-1}q_aq_{a+1}\cdots p_{m-1}}
    + \frac{p_ap_{a+1}\cdots p_{m-1}}{q_aq_{a+1}\cdots q_{m-1}}
    + \frac{a_mp_ap_{a+1}\cdots p_m}{b_mq_aq_{a+1}\cdots q_m}
    + \frac{a_{m+1}p_ap_{a+1}\cdots p_{m+1}}{b_{m+1}q_aq_{a+1}\cdots q_{m+1}}
    + \frac{a_{m+2}p_ap_{a+1}\cdots p_{m+2}}{b_{m+2}q_aq_{a+1}\cdots q_{m+2}}
    + \cdots
    + \frac{a_{b-1}p_ap_{a+1}\cdots p_{b-1}}{b_{b-1}q_aq_{a+1}\cdots p_{b-1}}
    \right) \\
    &=& B(a,b)Q(a,b)S(a,b) \\
    &=& T(a,b) \\
    \end{eqnarray*}

We can use these relations to expand the series recursively, so if we
want S(0,8) then we can work out S(0,4) and S(4,8) and combine them.
Likewise to calculate S(0,4) and S(4,8) we work out S(0,2), S(2,4),
S(4,6), S(6,8) and combine them, and to work out those we work out
S(0,1), S(1,2), S(2,3), S(3,4), S(4,5), S(5,6), S(6,7), S(7,8).
Luckily we don't have to split them down any more as we know what
P(a,a+1), Q(a,a+1) etc is from the definition above.

.. latex::
    \begin{eqnarray*}
    P(a,a+1) &=& p_a \\
    Q(a,a+1) &=& q_a \\
    B(a,a+1) &=& b_a \\
    S(a,a+1) &=& \frac{a_ap_a}{b_aq_a} \\
    T(a,a+1) &=& B(a,a+1)Q(a,a+1)S(a,a+1) \\
             &=& b_aq_a\frac{a_ap_a}{b_aq_a} \\
             &=& a_ap_a \\
    \end{eqnarray*}

And when you've finally worked out P(0,n),Q(0,n),B(0,n),T(0,n) you can work out S(0,n) with

.. latex::
    \begin{eqnarray*}
    S(0,n) &=& \frac{T(0,n)}{B(0,n)Q(0,n)} \\
    \end{eqnarray*}

If you want a more detailed and precise treatment of binary splitting then see `Bruno Haible and Thomas Papanikolaou's paper`_.

.. _Bruno Haible and Thomas Papanikolaou's paper: http://www.ginac.de/CLN/binsplit.pdf

So back to Chudnovksy's series.  We can now set these parameters in the above general formula:

.. latex::
    \begin{eqnarray*}
    p_0 &=& 1 \\
    p_a &=& (6a-5)(2a-1)(6a-1) \\
    q_0 &=& 1 \\
    q_a &=& a^3\cdot640320^3/24 \\
    b_a &=& 1 \\
    a_a &=& (13591409 + 545140134a) \\
    \end{eqnarray*}

This then makes our Chudnovksy pi function look like this::

    #!python
    def pi_chudnovsky_bs(digits):
        """
        Compute int(pi * 10**digits)
    
        This is done using Chudnovsky's series with binary splitting
        """
        C = 640320
        C3_OVER_24 = C**3 // 24
        def bs(a, b):
            """
            Computes the terms for binary splitting the Chudnovsky infinite series
    
            a(a) = +/- (13591409 + 545140134*a)
            p(a) = (6*a-5)*(2*a-1)*(6*a-1)
            b(a) = 1
            q(a) = a*a*a*C3_OVER_24
    
            returns P(a,b), Q(a,b) and T(a,b)
            """
            if b - a == 1:
                # Directly compute P(a,a+1), Q(a,a+1) and T(a,a+1)
                if a == 0:
                    Pab = Qab = 1
                else:
                    Pab = (6*a-5)*(2*a-1)*(6*a-1)
                    Qab = a*a*a*C3_OVER_24
                Tab = Pab * (13591409 + 545140134*a) # a(a) * p(a)
                if a & 1:
                    Tab = -Tab
            else:
                # Recursively compute P(a,b), Q(a,b) and T(a,b)
                # m is the midpoint of a and b
                m = (a + b) // 2
                # Recursively calculate P(a,m), Q(a,m) and T(a,m)
                Pam, Qam, Tam = bs(a, m)
                # Recursively calculate P(m,b), Q(m,b) and T(m,b)
                Pmb, Qmb, Tmb = bs(m, b)
                # Now combine
                Pab = Pam * Pmb
                Qab = Qam * Qmb
                Tab = Qmb * Tam + Pam * Tmb
            return Pab, Qab, Tab
        # how many terms to compute
        DIGITS_PER_TERM = math.log10(C3_OVER_24/6/2/6)
        N = int(digits/DIGITS_PER_TERM + 1)
        # Calclate P(0,N) and Q(0,N)
        P, Q, T = bs(0, N)
        one = 10**digits
        sqrtC = sqrt(10005*one, one)
        return (Q*426880*sqrtC) // T

Hopefully you'll see how the maths above relates to this as I've used
the same notation in each.  Note that we calculate the number of
digits of pi we expect per term of the series (about 14.18) to work
out how many terms of the series we need to compute, as the binary
splitting algorithm needs to know in advance how many terms to
calculate.  We also don't bother calculating ``B(a)`` as it is always
``1``.  Defining a function inside a function like this makes what is
known as a closure.  This means that the inner function can access the
variables in the outer function which is very convenient in this
recursive algorithm as it stops us having to pass the constants to
every call of the function.

See `pi_chudnovsky_bs.py`_ for the complete program.  When I run it I get this:

.. _pi_chudnovsky_bs.py: /nick/pub/pymath/pi_chudnovsky_bs.py

======= =========================
Digits  Time (seconds)
======= =========================
     10 1.096e-05
    100 3.194e-05
   1000 0.0004899
  10000 0.03403
 100000 3.625
1000000 419.1
======= =========================

This is a bit more than twice as fast as `pi_chudnovsky.py`_ giving us
our 1,000,000 places in just under 7 minutes.  If you profile it
you'll discover that almost all the time spent in the square root
calculations (86% of the time) whereas only 56 seconds is spent in
the binary splitting part.  We could spend time improving the square
root algorithm, but it is time to bring out the big guns: gmpy.

Gmpy_ is a python interface to the `gmp library`_ which is a C library
for arbitrary precision arithmetic.  It is very fast, much faster than
the built in ``int`` type in python for large numbers. Luckily gmpy
provides a type (``mpz``) which works exactly like normal python
``int`` types, so we have to make hardly any changes to our code to
use it.  These are using initialising variables with the ``mpz`` type,
and using the ``sqrt`` method on ``mpz`` rather than our own home made
``sqrt`` algorithm::

    #!python
    import math
    from gmpy2 import mpz
    from time import time

    def pi_chudnovsky_bs(digits):
        """
        Compute int(pi * 10**digits)
    
        This is done using Chudnovsky's series with binary splitting
        """
        C = 640320
        C3_OVER_24 = C**3 // 24
        def bs(a, b):
            """
            Computes the terms for binary splitting the Chudnovsky infinite series
    
            a(a) = +/- (13591409 + 545140134*a)
            p(a) = (6*a-5)*(2*a-1)*(6*a-1)
            b(a) = 1
            q(a) = a*a*a*C3_OVER_24
    
            returns P(a,b), Q(a,b) and T(a,b)
            """
            if b - a == 1:
                # Directly compute P(a,a+1), Q(a,a+1) and T(a,a+1)
                if a == 0:
                    Pab = Qab = mpz(1)
                else:
                    Pab = mpz((6*a-5)*(2*a-1)*(6*a-1))
                    Qab = mpz(a*a*a*C3_OVER_24)
                Tab = Pab * (13591409 + 545140134*a) # a(a) * p(a)
                if a & 1:
                    Tab = -Tab
            else:
                # Recursively compute P(a,b), Q(a,b) and T(a,b)
                # m is the midpoint of a and b
                m = (a + b) // 2
                # Recursively calculate P(a,m), Q(a,m) and T(a,m)
                Pam, Qam, Tam = bs(a, m)
                # Recursively calculate P(m,b), Q(m,b) and T(m,b)
                Pmb, Qmb, Tmb = bs(m, b)
                # Now combine
                Pab = Pam * Pmb
                Qab = Qam * Qmb
                Tab = Qmb * Tam + Pam * Tmb
            return Pab, Qab, Tab
        # how many terms to compute
        DIGITS_PER_TERM = math.log10(C3_OVER_24/6/2/6)
        N = int(digits/DIGITS_PER_TERM + 1)
        # Calclate P(0,N) and Q(0,N)
        P, Q, T = bs(0, N)
        one_squared = mpz(10)**(2*digits)
        sqrtC = (10005*one_squared).sqrt()
        return (Q*426880*sqrtC) // T

See `pi_chudnovsky_bs_gmpy.py`_ for the complete program.  When I run it I get this:

.. _pi_chudnovsky_bs_gmpy.py: /nick/pub/pymath/pi_chudnovsky_bs_gmpy.py
.. _gmp library: http://gmplib.org/
.. _Gmpy: https://code.google.com/p/gmpy/

========= =========================
Digits    Time (seconds)
========= =========================
       10 1.597e-05
      100 3.409e-05
     1000 0.003403
    10000 0.003571
   100000 0.09120
  1000000 1.760
 10000000 30.11
100000000 542.2
========= =========================

So we have achieved our goal of calculating 100,000,000 million places
of π in just under 10 minutes!  What is limiting the program now is
memory...  100,000,000 places takes about 600MB of memory to run.
With 6 GB of free memory it could probably calculate one billion
places in a few hours.

What if we wanted to go faster?  Well you could use
`gmp-chudnovsky.c`_ which is a C program which implements the
Chudnovsky Algorithm.  It is heavily optimised and rather difficult to
understand, but if you untangle it you'll see it does exactly the same
as above, with one extra twist.  The twist is that it factors the
fraction in the binary splitting phase as it goes along.  If you
examine the `gmp-chudnovsky.c results`_ page you'll see that the
little python program above acquits itself very well - the python
program only takes 75% longer than the optimised C program on the same
hardware.

.. _gmp-chudnovsky.c: ftp://ftp.gmplib.org/pub/misc/gmp-chudnovsky.c
.. _gmp-chudnovsky.c results: http://gmplib.org/pi-with-gmp.html

One algorithm which has the potential to beat Chudnovsky is the
`Arithmetic Geometric Mean`_ algorithm which doubles the number of
decimal places each iteration.  It involves square roots and full
precision divisions which makes it tricky to implement well.  In
theory it should be faster than Chudnovsk but, so far, in practice
Chudnovsky is faster.

.. _Arithmetic Geometric Mean: http://en.wikipedia.org/wiki/Gauss-Legendre_algorithm

Here is a chart of all the different π programs we've developed in
`Part 1`_, `Part 2`_, `Part 3`_ and `Part 4`_ with their timings on my
2010 Intel® Core™ i7 CPU Q820 @ 1.73GHz running 64 bit Linux:

.. image:: /nick/pub/pymath/pi_timings.png
   :alt: Chart of timings for calculating π with various methods

.. _Part 1: /nick/articles/pi-gregorys-series/
.. _Part 2: /nick/articles/pi-archimedes/
.. _Part 3: /nick/articles/pi-machin/
.. _Part 4: /nick/articles/pi-chudnovsky/
