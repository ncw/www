<%inherit file="/armprime/nav.inc" />
<%def name="title()">ARM Prime</%def>
<div id="content"><img src="armprime.gif" alt="[ARM Prime]" align="left" vspace="4" hspace="4" width="33" height="28" /> <strong>A Mersenne prime tester for <a href="http://www.arm.com">ARM</a> processors<br />
  by <a href="mailto:nick@craig-wood.com">Nick Craig-Wood</a><br clear="left" /></strong>

  <p>This is the home page for my ARM Prime program. This is for testing for Mersenne prime numbers on StrongARM machines for the <a href="http://www.mersenne.org/prime.htm">GIMPS</a> project. The program is work in progress, but if anyone is interested in using or helping to develop the program then please drop me an e-mail to <a href="mailto:nick@craig-wood.com">nick@craig-wood.com</a>.</p>

  <p>At present I haven't released the program formally, because it needs a few vital features added (like save files). However it does work and has contributed a few results to GIMPs already. (See the <a href="todo.html">to do list</a> for further deficiencies!)</p>

  <p>As for speed ARM prime is will be about 1/3 of the speed of an equivalently clocked Pentium. This is because the StrongARM does not have a floating point unit. This also means that ARM prime has been written to use an all integer FFT/DWT which makes it a bit different as explained in the <a href="math.html">math</a> section.</p>
</div>
