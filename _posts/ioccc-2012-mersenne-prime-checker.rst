---
categories: maths, python, c
date: 2012/10/03 00:00:00
title: IOCCC 2012 Mersenne Prime Checker
draft: False
permalink: /nick/articles/ioccc-2012-mersenne-prime-checker
---

This was my entry for the 21\ :superscript:`st` `International Obfuscated C Code Contest`_, a contest whose aims are

.. _International Obfuscated C Code Contest: http://www.ioccc.org/

    * To write the most Obscure/Obfuscated C program under the rules.
    * To show the importance of programming style, in an ironic way.
    * To stress C compilers with unusual code.
    * To illustrate some of the subtleties of the C language.
    * To provide a safe forum for poor C code. :-)

I've been meaning to enter the contest for quite a few years so was
very pleased to see it re-opened for 2012.

Alas my entry didn't win, but maybe you'll enjoy the entry and explanation.

Here is my entry::

    #!c
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<inttypes.h>
    #define H uint32_t
    #define U uint64_t
    #define N void
    #define T int
    #define P calloc(n,sizeof(U))
    #define R return
    #define I for(
    #define M if(
    #define E >>32
    #define S i=0;i<n;i++)
                          U K=-(U)(H)-1,*B,*C
                  ,*x,AC,h;T L,n,F,l,p,D,*_;U e(U x,U
               y){x=K-x;U r=y-x;M y<x)r+=K;R r;}U AB(U x,H
            w,U*c){U s=x+*c;H  t=s<x;*c=(s>>w)+(t<<(64-w));R
         s&((((U)1)<<w)-1             )  ;}  U Q(U x,U y ) {U r
       =x-y;M x<y)r+=K;R r;}                     U AD(U       b,U
      a){H d=b E,c=b;M a >=                      K)a-=           K;a=
      Q(a,c);a=Q(a,d) ;a=e                                         (a
     ,((U)c)<<32);R   a;}U A(                                        U
     x,U y){H a=x,b=  x E,c=y,d
     =y E;x=b*(U)c;y=a*(U)d;U e                                    =a*(
     U)c,f=b*(U)d,t;x+=y;M x<y)f                                   +=1LL
     <<32;t=x<<32;e+=t;M e<t)f+=                                    1;t=
     x E;f+=t;R AD(f,e);}U J(U                                     a,U b
     ){U r= 1;T i;I i=63;i>=0; i--){r=A(r,r);M(b            >>i)&1)r=A(r
      ,a);}R r;}U f(U a){R J(a,K            -2);}N G      (H n,U*x, U*y)
      {T i;I S x[i]=A(x[i],y[i     ]);}N g(   H n,U*x)    {T  i;I S x[i]
    =A(x[i],x[i]);}N AA(){U d       = AC;           T k            ;I k=
    F;k>=1;k--){T m=1<<k,c=m>>                      1,j,               r
    ;U w=1;I j=0;j<c;j++){I r=                     0;r<n              ;r
    +=m){T a=r+j,b=a+c;U u=x[a]                   ,v=x[b]           ;x[a
    ]=e(u,v);x[b]=A(Q(u,v),w);}w=                 A(  w,d        );}d=A
    (d,d);}}N W(){T k;I k=1;k<=F;k    ++         ){T m=1<<   k,   c=m>>
    1,j,r;U z=(U)(1<<((H)F-(H)k)),    d=         J(h,z),w=1;I      j=0
    ;j<c;j++){I r=0;r<n;r+=m){T a   =r+j,   b=a+ c;U u=x[a], v=A   (w
    ,x[b]);x[a]=e(u,v);x[b]=Q(u,v);}w=A(w  ,d);}}}T O(){T o=0,i,  w=L
    /n;U s=J(7,(K-1)/192/n*5);AC=J(s,192)   ;h=f  (AC   );M 2 *w  +F
    >=61)R 0;l=w;D=1<<w;p=w+1;x=P;B=P;C=P;  _= P; *B=1;*C=f(  n);I
    i=0;i<=n;i++){U t=(U)L*(U)i,r=t%n,b=t/n ;H               a;M r
    E)R 0;M(H)r)b++;M b E)R 0;a=b;M i>0){U c=_[              i-1]
    =a-o;M c!=w&&c!=w+1)R 0;M i<n){r=n-r;B[i]=J(s,r);C[i]= f(A(B
    [i],n));}}o=a;}R 1;}U V(){T i=0,j=0;U r=0;I;i<64&&j<n;i+=_
    [j],j++)r|=x[j]<<i;M r)R r;I r=j=0;j<n;j++)r|=x[j];R r;}
    N X(H c,T i){while(c){I;i<n;i++){H y=1<<_[i];x[i]+=c;
    M x[i]>=y)x[             i]-=y,c=1;            else
    R;}i=0;}                     }N Y(H     c){T    i;
    while(c)   {I S{H y=1<<        _[i]     ;x[i    ]-=
    c;M x[i]>=y)x[i]+=y,c=1        ;else    R     ;}}}N
    Z(U c){T i;while(c){I          S{x[    i]=AB(x[i],_[i],
    &c);H t=c;M!(c E)&&t         <D){M t ) X(t,i+1);R;}}}}N q()
    {T i;U c=0;G(n,x,         B);AA(F,x);g(n,x);W(F       ,x);G(n,x
    ,C);I S x[i]=          AB(x[i],_[i],&c);M c)Z(c);Y    (2);}T main(
    T w,char**         v){T i,k,j;M w<2)       {puts("Usage: p [n]");R 1
    ;}L=atoi                       (v[1]       );j=w>2    ?atoi(v[2]):L-
    2;do F++                       ,n=1<<F;while(!O          ());I k=0;k
    <1;k++){*x=4;I i=0;i<j;i++)q();}printf("0x%016"PRIX64"\n",V());R 0;}


I'm going to explain exactly what it does and how, but first here are
the hints and remarks I provided with the code.  Some of the hints
assume you've pre-processed the code into something vaguely legible
first.

Hints
=====

You stare at the source code... Is that a picture of a `monk`_?  What
does that strange mathematical writing say?  You get a subliminal
message...  Hunt for primes? But how?

.. _monk: http://en.wikipedia.org/wiki/Marin_Mersenne

You run the program.  It comes up with a strange usage message. What
could "p" be?  You try running the program with a prime number as an
argument.

    ./prog 23209

It returns after a few seconds with the rather cryptic message

    0x0000000000000000

What could that mean?  Maybe that 2\ :superscript:`23209`-1 (a 6,987 digit number) is
prime after all?

----

OK If you haven't guessed by now, this program proves the primality of
`Mersenne primes`_ of the form 2\ :superscript:`p`-1.  The biggest
known primes are of this form because there is an efficient test for
primality - the `Lucas Lehmer test`_.

.. _Mersenne primes: http://en.wikipedia.org/wiki/Mersenne_prime
.. _Lucas Lehmer test: http://mathworld.wolfram.com/Lucas-LehmerTest.html

If you run the program and it produces ``0x0000000000000000`` (0 in hex)
as an answer then you've found a prime of the form 2\ :superscript:`p`-1.  If it
produces anything else then 2\ :superscript:`p`-1 isn't prime.  The printed result is
the bottom 64 bits of the last iteration of the Lucas Lehmer test.

Have a look at the source code and see if you can work out how it
implements the Lucas Lehmer test...

Your first clue is to work out what the magic number ``-(U)(H)-1`` is. (My
favourite bit of obfuscation!)

Got it?  It is a prime just less than 2\ :superscript:`64`, ``0xFFFFFFFF00000001`` =
2\ :superscript:`64` - 2\ :superscript:`32` + 1 (p from now on),
with some rather special properties.

The most important of which is that arithmetic modulo p can all be
done without using divisions or modulo operations (which are really
slow).  See if you can spot the add, subtract and multiplication
routines.  There are also reciprocal and to the power operations in
there somewhere.

The next important property is that p-1 has the following factors

    2^32 * 3 * 5 * 17 * 257 * 65537

All those factors of 2 suggest that we can do a `Fast Fourier Transform`_
over the `Galois Field`_ GF(p) which is arithmetic modulo p.  See if
you can spot the FFT code!

.. _Fast Fourier Transform: http://mathworld.wolfram.com/FastFourierTransform.html
.. _Galois Field: http://mathworld.wolfram.com/FiniteField.html

To make a truly efficient Mersenne primality prover it is necessary to
implement the `IBDWT`_ a variant of the FFT using an irrational base.
This halves the size of the FFT array by combining the modulo and
multiply steps from the Lucas Lehmer test into one. You might wonder
how you can use an irrational base in a discrete field where every
element is an integer, but as it happens the p chosen has n-th roots
of 2 where n is up to 26, which means that an IBDWT can be defined for
FFT sizes up to 2\ :superscript:`26`.

.. _IBDWT: http://en.wikipedia.org/wiki/Irrational_base_discrete_weighted_transform

You'll find the code to generate the roots of 1 and 2 necessary for
the IBDWT if you search for 7 in the code.  7 is a primitive root of
GF(p) so all follows from that!

This all integer IBDWT isn't susceptible to the round off errors that
plague the floating point implementation, but does suffer in the speed
stakes from the fact that modern CPUs have much faster floating point
units than integer units.

For example to check if 2\ :superscript:`18000000`-1 is prime (a
5,418,539 digit number) `Prime95`_ (the current speed demon) uses a
2\ :superscript:`20` FFT size and each iteration takes it about 25ms. On similar
hardware it this program takes about 1.2s also using an FFT size of
2\ :superscript:`20`!  Prime95 is written in optimised assembler to use SSE3 whereas
this program was squeezed into 2k of portable C with a completely
unoptimised FFT!

.. _Prime95: http://www.mersenne.org/freesoft/

This program can do an FFT of up to 2\ :superscript:`26` entries.
Each entry can have up to 18 bits in (as ``2*18+26 <= 63``), which
means that the biggest exponent that it can test for primality is
18*2\ :superscript:`26`-1 = 1,207,959,551.  This would be number of
363 million decimal digits so could be used to find a 100 million
digit prime and scoop the `EFF $150,000 prize`_!  It would take rather
a long time though...

.. _EFF $150,000 prize: https://www.eff.org/awards/coop

The second argument to the program allows the number of iterations to
be put in, and using this it has been validated against the Prime95
test suite.  There is a unit test for the program but I thought
including it was probably against the spirit of the contest!

Speed of the FFT could be improved greatly, but unfortunately there
wasn't space in the margin to do so ;-)

Remarks about the Code
======================

This should compile on any compiler which supports ``inttypes.h`` from
the C99 standard (eg gcc).

It runs a lot quicker when compiled as a 64 bit binary!

I have successfully compiled and run this program without changes or
compiler warnings for:

  * 64 bit Ubuntu Linux 11.10
  * 32 bit Debian Linux (Lenny)
  * Windows using `MINGW`_
  * OS X 10.7 using Apple's gcc based compiler

.. _MINGW: http://www.mingw.org/

If you don't have a compiler which supports ``inttypes.h`` from C99 (hello
it is 2012 Microsoft!) then you'll need to go platform specific:

  * comment out the ``#include <inttypes.h>`` line
  * change the ``#define`` for ``uint32_t`` to be an unsigned 32 bit type
    ``unsigned int`` or ``unsigned __int32``
  * change the ``#define`` for ``uint64_t`` to be an unsigned 64 bit type
    ``unsigned long long`` or ``unsigned __int64``
  * add ``#define PRIX64 "llX"`` or ``"lX"`` or ``"I64X"``


How it was written
==================

I wrote most of this code some time ago as a view to publishing a full
description of how my `ARMprime`_ code works in easy to understand C
rather than a twisty turny mess of ARM assembler macros.

.. _ARMprime: /nick/armprime/

However I never got round to finishing it, so I used the IOCCC as a
spur to get me to finish it properly!

I've opensourced the code and the build chain at `github`_.

As you can imagine it isn't possible to develop the code in the form
above from scratch!  I created an unobfuscated version `mersenne.c`_
first and then wrote two programs, one which compresses the code (it
uses a manual version of LZ77 compression with ``#define`` statements)
and another which makes it into the pretty picture.

This means that I can change the code and just type make to create the
final pretty code for the entry, and to run the unit tests with.

.. _github: https://github.com/ncw/ioccc2012
.. _crush.py: https://github.com/ncw/ioccc2012/blob/master/crush.py
.. _artify.py: https://github.com/ncw/ioccc2012/blob/master/artify.py
.. _unit_test.py: https://github.com/ncw/ioccc2012/blob/master/unit_test.py
.. _check.py: https://github.com/ncw/ioccc2012/blob/master/check.py
.. _mersenne.c: https://github.com/ncw/ioccc2012/blob/master/mersenne.c

The first challenge was cutting the code down to size.  It needed to
be less than 2k of non-whitespace characters and less than 4k total.
I went through it getting rid of all extraneous functions, compacting
definitions, removing optimisations, obfuscating and it was still far
too big.

With the help of `crush.py`_ and after many hours of work I managed to
get it small enough.  I then wrote `check.py`_ to see whether the code
was within the competition rules and `unit_test.py`_ to validate the
code against Prime95's test suite.

Finally I wrote `artify.py`_ which reads the crushed source code and
uses it to paint the image.  It treats each character (or sometimes a
group of characters so the C remains valid) as a pixel and paints the
image with code!

Note that none of the python programs are particularly tidy, but that
python is a really good language for doing this in - I'd hate to be
doing it in C!


How it works
============

Now I've introduced the unobfuscated version, I can show how each part
of the code works.

Firstly all good obfuscated programs have lots of global variables to shorten the code down::

    #!c
    u64 MOD_P =  -(u64)(u32)-1,         /* 0xFFFFFFFF00000001 - the magic number */
        *digit_weight,                  /* Array of weghts for IBDWT */
        *digit_unweight,                /* Inverse of the above */
        *x,                             /* pointer to array of n 64 bit integers - the current number */
        MOD_W,                          /* The root of 2 for the fft so that 2**MOD_W == 1 mod p */
        MOD_INVW;                       /* The inverse of the above so that MOD_W * MOD_INVW == 1 mod p */
    
    int exponent,                       /* The mersenne exponent - we are testing 2^exponent -1 is prime or not */
        n,                              /* The number of 64 bit numbers in the FFT */
        log_n,                          /* n = 2^log_n */
        digit_width0,                   /* Digit width for the IBDWT */
        digit_width1,
        digit_width_0_max,
        *digit_widths;                  /* Array of number of bits in each element of the FFT */

From the top down there is the main loop which contains the Lucas Lehmer algorithm::

    #!c
    int main(int w, char ** v)
    {
        int i,k,j;
        if (w < 2)
        {
            puts("Usage:@p@[n]");
            return 1;
        }
        
        exponent = atoi(v[1]);
        j = w > 2 ? atoi(v[2]) : exponent - 2; /* iterations */
        /* initialise, finding correct FFT size */
        do log_n++, n = 1 << log_n;
        while(!mersenne_initialise());
    
        for (k = 0; k < 1; k++)
        {
            *x = 4;
            for (i = 0; i < j; i++)
                mersenne_mul();
        }
        printf("0x%016" PRIX64 "\n", mersenne_residue());
        return 0;
    }

It reads the exponent and optional number of iterations from the
command line, then initialises the program, starting with a small FFT
size ``n`` and increasing until it finds one which fits.

It then does the Lucas Lehmer test setting the initial value to 4,
iterating it for exponent times and printing the residue.

The core of the Lucas Lehmer test (and the `IBDWT`_) is the
``mersenne_mul`` function which squares the current number and
subtracts 2, returning it modulo 2\ :superscript:`p` - 1 ::

    #!c
    void mersenne_mul()
    {
        int i;
        u64 c = 0;
    
        /* weight the input */
        mod_vector_mul(n, x, digit_weight);
        
        /* transform */
        fft_fastish(log_n, x);
    
        /* point multiply */
        mod_sqr_vector(n, x);
    
        /* untransform */
        invFft_fastish(log_n, x);
    
        /* unweight and normalise the output */
        mod_vector_mul(n, x, digit_unweight);
        
        /* carry propagation */
        for (i = 0; i < n; i++)
            x[i] = mod_adc(x[i], digit_widths[i], &c);
        if (c)
            mersenne_add64(c);
    
        /* subtract 2 */
        mersenne_sub32(2);
    }

This the FFT, point multiply and inverse FFT perform a convolution.
This does the bulk of the work of the multiplication.  The weight and
unweight and the start and end is the IBDWT which ensures that the
result is modulo 2 :superscript:`p` - 1.  The carries are propagated and
2 is subtracted from the end.

The FFT is a completely standard FFT with bit reversed output, the
only unusal thing being that all the operations are mod p rather than
with complex numbers.  If you compare the code for the FFT with a
standard implementation you will see it is very similar::

    #!c
    void fft_fastish()
    {
        u64 d = MOD_W;
        int k;
    
        for (k = log_n; k >= 1; k--)
        {
            int m = 1 << k,
                c = m >> 1,
                j,
                r;
            u64 w = 1;
            for (j = 0; j < c; j++)
            {
                for (r = 0; r < n; r += m)
                {
                    int a = r + j,
                        b = a + c;
                    u64 u = x[a],
                        v = x[b];
                    x[a] = mod_add(u, v);
                    x[b] = mod_mul(mod_sub(u, v), w);
                }
                w = mod_mul(w, d);
            }
            d = mod_mul(d, d);
        }
    }

``MOD_W`` is the root of unity the FFT is built on.  It happens to be
an integer in GF(p) such that ``MOD_W``\ :superscript:`n` == 1 mod
p. You can see the FFT calculating the twiddles (``w``).
Precalculating them would be better obviously but not in 2k of code!
The inner loop shows the butterfly.

Now for the fundamental operations over GF(p).  First thing to note is
that in the code p = ``MOD_P`` = 2\ :superscript:`64` - 2\
:superscript:`32` + 1.  ``MOD_P`` was chosen so that it has quite a
few special properties, one of them being that it is possible to do
modulo p operations without doing divisions (which are really slow!).

The easiest operation to define is subtraction::

    #!c
    u64 mod_sub(u64 x, u64 y)
    {
        u64 r = x - y;
        /* if borrow generated - hopefully the compiler will optimise this! */
        if (x < y)
            r += MOD_P;        /* Add back p if borrow */
        return r;
    }

The C code was designed so that the if statement should be optimised
into a jump on carry flag if the compiler is doing its job properly.
Addition can then be defined as subtracting a negative number::

    #!c
    u64 mod_add(u64 x, u64 y)
    {
        x = MOD_P - x;        /* do addition by negating y then subracting */
        u64 r = y - x;        /* y - (-x) */
        /* if borrow generated - hopefully the compiler will optimise this! */
        if (y < x)
            r += MOD_P;        /* Add back p if borrow */
        return r;
    }

To do multiplication, first it is necessary to work out how to do reduce a 128 bit number mod p.  We use these facts:

|    2\ :superscript:`64` == 2\ :superscript:`32` -1 mod p
|    2\ :superscript:`96` == -1 mod p
|    2\ :superscript:`128` == -2\ :superscript:`32` mod p
|    2\ :superscript:`192` == 1 mod p
|    2\ :superscript:`n` * 2\ :superscript:`(192-n)` = 1 mod p

Thus to reduce a 128 bit number mod p (split into 32 bit chunks x3,x2,x1,x0):

|    x3 * 2\ :superscript:`96` + x2 * 2\ :superscript:`64` + x1 * 2\ :superscript:`32` + x0 mod p
|    = x2 * 2\ :superscript:`64` + x1*2\ :superscript:`32` + x0-x3) [using 2\ :superscript:`96` mod p = -1]
|    = (x1+x2) * 2\ :superscript:`32` + x0 - x3 - x2 [using 2\ :superscript:`64` mod p = 2\ :superscript:`32` -1]

This is explained in more detail in my `ARMprime`_ pages.  This division free code then looks like this::

    #!c
    u64 mod_reduce(u64 b, u64 a)
    {
        u32 d = b >>32,
            c = b;
        if (a >= MOD_P)                /* (x1, x0) */
            a -= MOD_P;
        a = mod_sub(a, c);
        a = mod_sub(a, d);
        a = mod_add(a, ((u64)c)<<32);
        return a;
    }

.. _ARMprime maths page: /nick/armprime/math.html

Given ``mod_reduce``, multiplication is relatively straight forward::

    #!c
    u64 mod_mul(u64 x, u64 y)
    {
        u32 a = x,
            b = x >>32,
            c = y,
            d = y >>32;
    
        /* first synthesize the product using 32*32 -> 64 bit multiplies */
        x = b * (u64)c;
        y = a * (u64)d;
        u64 e = a * (u64)c,
            f = b * (u64)d,
            t;
    
        x += y;                        /* b*c + a*d */
        /* carry? */
        if (x < y)
            f += 1LL << 32;            /* carry into upper 32 bits - can't overflow */
    
        t = x << 32;
        e += t;                        /* a*c + LSW(b*c + a*d) */
        /* carry? */
        if (e < t)
            f += 1;                    /* carry into upper 64 bits - can't overflow*/
        t = x >>32;
        f += t;                        /* b*d + MSW(b*c + a*d) */
        /* can't overflow */
    
        /* now reduce: (b*d + MSW(b*c + a*d), a*c + LSW(b*c + a*d)) */
        return mod_reduce(f, e);
    }

The definitions for the other arithmetic operations are straight
forward now.  Power is just repeated multiplication and squaring.
Inverse is to the power of -1.

All those things come together in the ``mersenne_mul`` function above!

If you want to look at the complete (mostly) unobfuscated code then
take look through `mersenne.c`_.

Conclusion
==========

The IOCCC was a fun challenge and it got me to finally complete my C
conversion of a lot of really difficult ARM assembly code.  Hopefully
I'll find the time to demonstrate some more optimised FFTs and an FFT
with a factor of 3 in too.

Getting the code small enough was really, really difficult, but helped
immensely by Python.  It started off life as pretty obscure so that
process made it more so!  I'm afraid even as explained above it
probably isn't accessible to very many people - my apologies for that.

Happy Prime Hunting!
