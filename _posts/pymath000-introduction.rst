---
categories: pymath
date: 2011/07/16 00:00:00
title: Fun with Maths and Python - Introduction
draft: False
permalink: /nick/articles/fun-with-maths-and-python-introduction
---

This is going to be a series of articles which are all about having fun with maths and Python_.  I'm going to show you a bit of maths and then how to apply it with a python program, then work out how to improve it.

.. _Python: http://www.python.org/

I decided to write these after looking in my doodles folder on my computer and finding 100s of programs to calculate this bit of maths, or explore that bit of maths, and I thought it would be interesting for me to share them.  Hopefully you'll find it interesting too!

I'm going to use python 3 for all python code.  This enables me to future proof these articles and encourage everyone who hasn't tried Python 3 to have a go.  The programs will run with minor modifications on python 2 - just watch out for `division which has changed from python 2 to 3`_.  In fact if you run any of these programs under python 2 then put ``from __future__ import division`` at the top of them.

.. _division which has changed from python 2 to 3: http://www.python.org/dev/peps/pep-0238/

Python is a really excellent language for investigations into maths.  It is easy to read and has excellent long number support with infinite precision integers and the `decimal module`_.  I'm going to attempt to demonstrate what I want to demonstrate not using any third party modules, but I may occasionally use the `gmpy module`_.

.. _decimal module: http://docs.python.org/library/decimal.html
.. _gmpy module: https://code.google.com/p/gmpy/

I'm going to pitch the level of maths below calculus, no more than the maths that everyone should have learnt at school.  If I want to use some bit of maths outside that range I'll explain it first.  This does means that sometimes I won't be able to show a proof for things, but I'll add a link to an online proof if I can find one.

You are going to see maths written both in traditional style:

.. latex::
    \begin{equation*}
    x=\frac{-b \pm \sqrt {b^2-4ac}}{2a}
    \end{equation*}

And in computer style which every programmer knows anyway.  This involves a few more brackets, but it is much easier to translate to computer code.  For example::

  (-b +/- sqrt(b**2 - 4*a*c)) / (2*a)

In Python computer maths we write:

  *  ``*`` to mean multiply
  * ``/`` to mean divide
  * ``**`` to mean to the power
  * ``//`` to mean divide but give the result as an integer
  * ``%`` to mean the same as the ``modulo`` or ``mod`` operator, ie do the division and take the remainder.

I'm going to make free with unicode fonts so you'll see:

  * π - pi
  * x² - x squared
  * √x - square root of x
  * ± - plus or minus

If these aren't appearing properly, then you'll need to try a different browser, or install some more fonts.

As for the programming level, anyone who knows a little bit of python should be able to work out what is happening - I won't be doing anything too fancy!

I'll tag all the articles with pymath_ so you can find them or subscribe to the rss_.

.. _pymath: /nick/articles/category/pymath/
.. _rss: /nick/articles/category/pymath/feed

Happy Calculating!

Nick Craig-Wood

nick@craig-wood.com
