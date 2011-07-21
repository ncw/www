---
categories: maths, python
date: 2011/01/16 21:41:00
title: How fast can we multiply - part 1
draft: True
permalink: /nick/articles/how-fast-can-we-multiply-1
---

Schoolboy multiplication

Examples of schoolboy multiplication

Explain big O notation

Show that it is O(n²)

Demonstrate

multiply_how_fast_decimal.py

Digits      32 Time   0.000080 Ratio 0.000
Digits      64 Time   0.000045 Ratio 0.562
Digits     128 Time   0.000053 Ratio 1.175
Digits     256 Time   0.000074 Ratio 1.396
Digits     512 Time   0.000159 Ratio 2.152
Digits    1024 Time   0.000461 Ratio 2.900
Digits    2048 Time   0.001636 Ratio 3.548
Digits    4096 Time   0.006097 Ratio 3.727
Digits    8192 Time   0.023050 Ratio 3.781
Digits   16384 Time   0.090655 Ratio 3.933
Digits   32768 Time   0.357791 Ratio 3.947
Digits   65536 Time   1.416060 Ratio 3.958
Digits  131072 Time   5.651114 Ratio 3.991
Digits  262144 Time  22.509614 Ratio 3.983
Digits  524288 Time  89.845051 Ratio 3.991
Digits 1048576 Time 358.869641 Ratio 3.994

Now demonstrate with integers

Formula for time would be n ** log2(4) = n²

multiply_how_fast_int.py

Digits      32 Time   0.000001 Ratio 0.000
Digits      64 Time   0.000001 Ratio 1.000
Digits     128 Time   0.000001 Ratio 1.250
Digits     256 Time   0.000002 Ratio 1.800
Digits     512 Time   0.000006 Ratio 2.778
Digits    1024 Time   0.000021 Ratio 3.520
Digits    2048 Time   0.000060 Ratio 2.864
Digits    4096 Time   0.000161 Ratio 2.679
Digits    8192 Time   0.000486 Ratio 3.019
Digits   16384 Time   0.001504 Ratio 3.095
Digits   32768 Time   0.004392 Ratio 2.920
Digits   65536 Time   0.014495 Ratio 3.300
Digits  131072 Time   0.039558 Ratio 2.729
Digits  262144 Time   0.118557 Ratio 2.997
Digits  524288 Time   0.356460 Ratio 3.007
Digits 1048576 Time   1.070429 Ratio 3.003
Digits 2097152 Time   3.210340 Ratio 2.999
Digits 4194304 Time   9.634686 Ratio 3.001
Digits 8388608 Time  28.973120 Ratio 3.007
Digits 16777216 Time  86.856577 Ratio 2.998

That's funny, the time only goes up by a factor of 3 when we double the number of digits.  (Also note that multiplying ``int`` is over 300 times quicker at 1,000,000 digits)

Formula for time would be n ** log2(3) = n**1.584

Explain karatsuba multiplication

Explain that we can do better than karatsuba, will talk about in part 2

