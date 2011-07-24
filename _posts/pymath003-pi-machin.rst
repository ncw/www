---
categories: pymath, maths, python
date: 2011/07/19 00:00:00
title: Pi - Machin
draft: False
permalink: /nick/articles/pi-machin
---
In `Part 2`_ we managed to calculate 100 decimal places of π with Archimedes' recurrence relation for π which was a fine result, but we can do bigger and faster.

.. sidebar:: Fun with Maths and Python

    This is a having fun with maths and python article.  See `the introduction`_ for important information!

.. _the introduction: /nick/articles/fun-with-maths-and-python-introduction/

To go faster we'll have to use a two pronged approach - a better algorithm for π, and a better implementation.

In 1706 `John Machin`_ came up with the first really fast method of calculating π and used it to calculate π to 100 decimal places.  Quite an achievement considering he did that entirely with pencil and paper.  Machin's formula is::

  π/4 = 4cot⁻¹(5) - cot⁻¹(239)
      = 4tan⁻¹(1/5) - tan⁻¹(1/239)
      = 4 * arctan(1/5) - arctan(1/239)

We can prove Machin's formula using some relatively easy math!  Hopefully you learnt this `trigonometric formula`_ at school:

.. latex::
    \[
    tan(a + b) = \frac{tan(a) + tan(b)}{1 - tan(a) \cdot tan(b)}
    \]

Substitute ``a = arctan(x)`` and ``b = arctan(y)`` into it, giving:

.. latex::
    \[
    tan(arctan(x) + arctan(y)) = \frac{tan(arctan(x)) + tan(arctan(y)}{1 - tan(arctan(x)) \cdot tan(arctan(y))}
    \]

Note that ``tan(arctan(x))`` = ``x`` which gives:

.. latex::
    \[
    tan(arctan(x) + arctan(y)) = \frac{x + y}{1 - xy}
    \]

arctan both sides to get:

.. latex::
    \[
    arctan(x) + arctan(y) = arctan\left(\frac{x + y}{1 - xy}\right)
    \]

This gives us a method for adding two ``arctans``.  Using this we can prove Machin's formula with a bit of help from python's `fractions module`_::

    >>> from fractions import Fraction
    >>> def add_arctan(x, y): return (x + y) / (1 - x * y)
    ... 
    >>> a = add_arctan(Fraction(1,5), Fraction(1,5))
    >>> a # 2*arctan(1/5)
    Fraction(5, 12)
    >>> b = add_arctan(a, a)
    >>> b # 4*arctan(1/5)
    Fraction(120, 119)
    >>> c = add_arctan(b, Fraction(-1,239))
    >>> c # 4*arctan(1/5) - arctan(1/239)
    Fraction(1, 1)
    >>> 

So Machin's formula is equal to ``arctan(1/1)`` = π/4 QED!  Or if you prefer it written out in mathematical notation:

.. latex::
    \begin{eqnarray*}
    4arctan\left(\frac{1}{5}\right) - arctan\left(\frac{1}{239}\right)
      &=& 2\left(arctan\left(\frac{1}{5}\right) + arctan\left(\frac{1}{5}\right)\right) - arctan\left(\frac{1}{239}\right) \\
      &=& 2arctan\left(\frac{5}{12}\right) - arctan\left(\frac{1}{239}\right) \\
      &=& arctan\left(\frac{5}{12}\right) + arctan\left(\frac{5}{12}\right) - arctan\left(\frac{1}{239}\right) \\
      &=& arctan\left(\frac{120}{119}\right) - arctan\left(\frac{1}{239}\right) \\
      &=& arctan\left(\frac{1}{1}\right) \\
      &=& \frac{\pi}{4} \\
    \end{eqnarray*}

So how do we use Machin's formula to calculate π?  Well first we need to calculate ``arctan(x)`` which sounds complicated, but we've seen the infinite series for it already in `Part 1`_ :

.. latex::
    \[
    arctan(x) = x - \frac{x^3}{3} + \frac{x^5}{5} - \frac{x^7}{7} + \frac{x^9}{9} - \cdots ( -1 <= x <= 1 )
    \]

We can see that if x=1/5 then the terms get smaller very quickly, which means that the series will converge quickly.  Let's substitute ``x = 1/x`` and get:

.. latex::
    \[
    arctan(1/x) = \frac{1}{x} - \frac{1}{3x^3} + \frac{1}{5x^5} - \frac{1}{7x^7} + \frac{1}{9x^9} - \cdots ( x >= 1 )
    \]

Each term in the series is created by dividing the previous term by a small integer.  Dividing two 100 digit numbers is hard work as I'm sure you can imagine from your experiences with long division at school!  However it is much easier to divide a short number (a single digit) into a 100 digit number.  We called this short division at school, and that is the key to making a much faster π algorithm.  In fact if you are dividing an N digit number by an M digit number it takes rougly N*M operations.  That square root we did in `Part 2`_ did dozens of divisions of 200 digit numbers.  So if we could somehow represent the current term in a ``int`` [1]_ then we could use this speedy division to greatly speed up the calculation.

The way we do that is to multiply everything by a large number, lets say 10 :superscript:`100`.  We then do all our calculations with integers, knowing that we should shift the decimal place 100 places to the left when done to get the answer.  This needs a little bit of care, but is a well known technique known as fixed point arithmetic.

The definition of the ``arctan(1/x)`` function then looks like this::

    #!python
    def arctan(x, one=1000000):
        """
        Calculate arctan(1/x)
    
        arctan(1/x) = 1/x - 1/3*x**3 + 1/5*x**5 - ... (x >= 1)
    
        This calculates it in fixed point, using the value for one passed in
        """
        power = one // x            # the +/- 1/x**n part of the term
        total = power               # the total so far
        x_squared = x * x           # precalculate x**2
        divisor = 1                 # the 1,3,5,7 part of the divisor
        while 1:
            power = - power // x_squared
            divisor += 2
            delta = power // divisor
            if delta == 0:
                break
            total += delta
        return total

The value ``one`` passed in is the multiplication factor as described above.  You can think of it as representing ``1`` in the fixed point arithmetic world.  Note the use of the ``//`` operator which does integer divisions.  If you don't use this then python will make floating point values [2]_.  In the loop there are two divisions, ``power // x_squared`` and ``power // divisor``.  Both of these will be dividing by small numbers, ``x_squared`` will  be 5² = 25 or 239² = 57121 and ``divisor`` will be 2 * the number of iterations which again will be small.

So how does this work in practice?  On my machine it calculates 100 digits of π in 0.18 ms which is over 30,000 times faster than the previous calculation with the decimal module in `Part 2`_!

Can we do better?

Well the answer is yes!  Firstly there are better arctan formulae.  Amazingly there are other formulae which will calculate π too, like these, which are named after their inventors::

    #!python
    def pi_machin(one):
        return 4*(4*arctan(5, one) - arctan(239, one))

    def pi_ferguson(one):
        return 4*(3*arctan(4, one) + arctan(20, one) + arctan(1985, one))

    def pi_hutton(one):
        return 4*(2*arctan(3, one) + arctan(7, one))

    def pi_gauss(one):
        return 4*(12*arctan(18, one) + 8*arctan(57, one) - 5*arctan(239, one))

It turns out that Machin's formula is really very good, but Gauss's formula is slightly better.

The other way we can do better is to use a better formula for ``arctan()``.  Euler_ came up with this `accelerated formula for arctan`_:

.. latex::
    \[
    arctan(1/x) = \frac{x}{1+x^2}
                + \frac{2}{3}\frac{x}{(1+x^2)^2}
                + \frac{2\cdot4}{3\cdot5}\frac{x}{(1+x^2)^3}
                + \frac{2\cdot4\cdot6}{3\cdot5\cdot7}\frac{x}{(1+x^2)^4}
                + \cdots
    \]

This converges to ``arctan(1/x)`` at the roughly the same rate per term than the formula above, however each term is made directly from the previous term by multiplying by ``2n`` and dividing by ``(2n+1)(1+x²)``.  This means that it can be implemented with only one (instead of two) divisions per term, and hence runs roughly twice as quickly.  If we implement this in python in fixed point, then it looks like this::

    #!python
    def arctan_euler(x, one=1000000):
        """
        Calculate arctan(1/x) using euler's accelerated formula
    
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
            term = term // divisor
            if term == 0:
                break
            total += term
            two_n += 2
        return total

Notice how we pre-calculate as many things as possible (like ``x_squared_plus_1``) to get them out of the loop.

See the complete program: `pi_artcan_integer.py`_.  Here are some timings [3]_ of how the Machin and the Gauss arctan formula fared, with and without the accelerated arctan.

======= ======= ============= ============
Formula Digits  Normal Arctan Euler Arctan
                (seconds)     (seconds)
======= ======= ============= ============
Machin       10 3.004e-05     2.098e-05
Gauss        10 2.098e-05     1.907e-05
Machin      100 0.0001869     0.0001471
Gauss       100 0.0001869     0.0001468
Machin     1000 0.005599      0.003520
Gauss      1000 0.005398      0.003445
Machin    10000 0.3995        0.2252
Gauss     10000 0.3908        0.2186
Machin   100000 38.33         21.69
Gauss    100000 37.44         21.12
Machin  1000000 3954.1        2396.8
Gauss   1000000 3879.4        2402.1
======= ======= ============= ============

There are several interesting things to note.  Firstly that we just calculated 1,000,000 decimal places of π in 40 minutes! Secondly that to calculate 10 times as many digits it takes 100 times as long.  This means that our algorithm scales as O(n²) where n is the number of digits.  So if 1,000,000 digits takes an hour, 10,000,000 would take 100 hours (4 days) and 100,000,000 would take 400 days (13 months).  Your computer might run out of memory, or explode in some other fashion when calculating 100,000,000 digits, but doesn't seem impossible any more.

The Gauss formula is slightly faster than the Machin for nearly all the results.  The accelerated arctan formula is 1.6 times faster than the normal arctan formula so that is a definite win.

A billion (1,000,000,000) digits of pi would take about 76 years to calculate using this program which is a bit out of our reach!  There are several ways we could improve this.  If we could find an algorithm for calculating π which was quicker than O(n²), or if we could find an O(n²) algorithm which just ran a lot faster.  We could also throw more CPUs at the problem.  To see how this might be done, we could calculate all the odd terms on one processor, and all the even terms on another processor for the ``arctan`` formula and add them together at the end..  That would run just about twice as quickly.  That could easily be generalised to lots of processors::

  arctan(1/x) = 1/x - 1/3x³ + 1/5x⁵ - 1/7x⁷ + ...
              = 1/x         + 1/5x⁵ -       + ... # run on cpu 1
              +     - 1/3x³         - 1/7x⁷ + ... # run on cpu 2

So if we had 76 CPU cores, we could probably calculate π to 1,000,000,000 places in about a year.

There are better algorithms for calculating π though, and there are faster ways of doing arithmetic than python's built in long integers.  We'll explore both in `Part 4`_!

.. [1] Python's integer type was called called ``long`` in python 2, just ``int`` in python 3
.. [2] Unless you are using python 2
.. [3] All timings generated on my 2010 Intel® Core™ i7 CPU Q820 @ 1.73GHz running 64 bit Linux

.. _Part 1: /nick/articles/pi-gregorys-series/
.. _Part 2: /nick/articles/pi-archimedes/
.. _Part 4: /nick/articles/pi-chudnovsky/
.. _`pi_artcan_integer.py`: /nick/pub/pymath/pi_arctan_integer.py
.. _John Machin: http://en.wikipedia.org/wiki/John_Machin
.. _trigonometric formula: http://mathworld.wolfram.com/TrigonometricAdditionFormulas.html
.. _fractions module: http://docs.python.org/library/fractions.html
.. _accelerated formula for arctan: http://mathworld.wolfram.com/InverseTangent.html
.. _Euler: http://en.wikipedia.org/wiki/Leonhard_Euler
