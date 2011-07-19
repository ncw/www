---
categories: pymath, maths, python
date: 2011/07/17 00:00:00
title: Pi - Gregory's Series
draft: False
---

Lets calculate π (or Pi if you prefer)!  π is an irrational number (amongst other things) which means that it isn't one whole number divided by another whole number.  In fact the digits of π are extremely random - if you didn't know they were the digits of π they would be perfectly random.

.. sidebar:: Fun with Maths and Python

    This is a having fun with maths and python article.  See `the introduction`_ for important information!

.. _the introduction: /nick/articles/fun-with-maths-and-python-introduction/

π has been calculated to billions of decimal places, but in this series of articles, we're going to aim for the more modest target of 100,000,000 decimal places calculated by a python program in a reasonable length of time.  We are going to try some different formulae and algorithms following a roughly historical path.

You were probably taught at school that 22/7 is a reasonable approximation to π.  Maybe you were even taught that 355/113 was a better one.  You were unlikely to have been taught how π is actually calculated.  You could draw a circle and measure the circumference, but that is very hard to do accurately.

Luckily maths comes to the rescue.  There are 100s of formulae for calculating π, but the simplest one I know of is this:

.. latex::
    \begin{equation*}
    \frac{\pi}{4} = 1 - \frac{1}{3} + \frac{1}{5} - \frac{1}{7} + \frac{1}{9} - \frac{1}{11} + \frac{1}{13} - \frac{1}{15} + \frac{1}{17} - \cdots
    \end{equation*}

This is known as `Gregory's Series`_  (or sometimes the Leibnitz formula) for π.  That ``...`` stands for keep going forever.  To make the next term in the series, alternate the sign, and add 2 to the denominator of the fraction, so ``+ 1/19`` is next then ``- 1/21`` etc.

To see why this is true, we need to look at the Leibnitz_ formula for ``arctan`` (or ``tan⁻¹``).  This is:

.. latex::
    \begin{equation*}
    arctan(x) = x - \frac{x^3}{3} + \frac{x^5}{5} - \frac{x^7}{7} + \frac{x^9}{9} - \cdots ( -1 <= x <= 1 )
    \end{equation*}

Note that the result of ``arctan(x)`` is in radians. I'm not going to prove that formula here as it involves calculus, but you can see `a proof of the arctan formula`_ if you want.

``arctan`` is the inverse of ``tan``, so ``arctan(tan(x)) = x``.  ``tan(x)`` is the familiar (hopefully) ratio of the opposite and adjacent sides of a right angled triangle and how that relates to the angle.

If we set the angle to 45°, which is π/4 radians, then::

    tan(45°) = 1
 ⇒ tan(π/4) = 1
 ⇒ arctan(1) = π/4

which when substituted in the above becomes:

.. latex::
    \begin{equation*}
    \frac{\pi}{4} = 1 - \frac{1}{3} + \frac{1}{5} - \frac{1}{7} + \frac{1}{9} - \cdots
    \end{equation*}

This may be the simplest infinite series formula for π but it has the disadvantage that you'll need to add up a great number of terms to get an acceptably accurate answer.

Here is a bit of python to calculate it (`pi_gregory.py`_)::

    #!python
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
        
All the important stuff happens in ``pi_gregory`` and hopefully you'll see how that relates to the infinite series for ``arctan``.  Note the trick of keeping the sign of the term in a variable as ``1`` or ``-1`` and then multiplying by this.  This is a common trick, easier to write than an if statement and probably faster.

The program above prints:

========== ============ =============
Iterations Result       Error
========== ============ =============
       10  3.0418396189 -0.0997530347
      100  3.1315929036 -0.0099997500
     1000  3.1405926538 -0.0009999997
    10000  3.1414926536 -0.0001000000
   100000  3.1415826536 -0.0000100000
  1000000  3.1415916536 -0.0000010000
 10000000  3.1415925536 -0.0000001000
========== ============ =============

That looks like our old friend π doesn't it!  However you can see that it takes 10 times as many iterations to add another decimal place of accuracy to the result.  That isn't going to get us even 10 decimal places in a reasonable length of time... We'll have to get a bit cleverer. (If the program printed out something very different then you need to run it with python 3 not python 2 see `the introduction`_.)  You can also see something very odd in the error terms - the result is correct to 10 decimal places, all except for one digit.  This is a known oddity and you can read up about it `The Leibniz formula for pi`_ .

Those of you paying attention will have noted that we used ``math.pi`` from the python standard library in the above program to calculate the difference of the result from π.  So python already knows the value of π! However that is only a double precison value (17 digits or so) and we are aiming for much more.  We are going to leave the world of double precision floating point behind, and calculate a lot more digits of π, much quicker, in the next exciting episode (`Part 2`_)!


.. _Part 2: /nick/articles/pi-archimedes/
.. _pi_gregory.py: /nick/pub/pymath/pi_gregory.py
.. _Leibnitz: http://mathworld.wolfram.com/LeibnizSeries.html
.. _Gregory's Series: http://mathworld.wolfram.com/GregorySeries.html
.. _a proof of the arctan formula: http://www.math.wpi.edu/IQP/BVCalcHist/calc3.html
.. _The Leibniz formula for pi: http://en.wikipedia.org/wiki/Leibniz_formula_for_pi
