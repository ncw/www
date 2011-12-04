---
categories: maths, python
date: 2011/12/04 20:00:00
title: How I Solved the GCHQ challenge
draft: False
permalink: /nick/articles/how-i-solved-the-gchq-challenge
---

This is an unsanitised account of how I solved the GCHQ challenge at
http://www.canyoucrackit.co.uk/.  `According to the BBC`_ the
competition began in secret on the 3rd of November 2011 and will
continue until the 12th of December.  I was going to hold back this
publication until the contest ended but `a solution`_ has just made it
to the front page of slashdot so I think the jig is up!

This writeup includes the wrong turnings I took and the bad
assumptions I made along the way so any reader can see the kind of
thought processes necessary.  I very deliberately did no searching on
the Internet about the puzzle so all the work below (and the mistakes)
are mine alone!

The programs linked to in the article are the final versions, I didn't
keep the intermediate versions which I talk about in the text, so
you'll have to imagine what they looked like.

.. warning:: This article contains spoilers on how to do the challenge - don't read any further if you want to solve it yourself!

.. _According to the BBC: http://www.bbc.co.uk/news/technology-15968878
.. _a solution: http://news.slashdot.org/story/11/12/04/1725253/gchq-challenge-solution-explained

Stage 1
-------

The challenge opens showing a single image with a load of hex digits
in and a form to submit your answer.  The image looks like this:

.. image:: /nick/pub/gchq-challenge/cyber.png
   :alt: GCHQ cyber challenge

The first thing I did was to decode the hex data.  Using a python
program of course!  I played around with trying to get it to display
an image.  It is obviously low entropy but what is it?  Not an image
anyway.

I used `cyber.py`_ to save it to a binary file and ran the unix "file"
utility on it which told me it was x86 code::

    $ file cyber.bin
    cyber.bin: DOS executable (COM)

Interesting. A disassembly was required `cyber.disassembly.asm`_::

    x86dis -r 0 160  -s intel < cyber.bin > cyber.disassembly.asm

The code appeared to be linux flavour, exiting politely with the
correct ``int 0x80`` call.

The obvious next step is to run the code.  It is bare code which you
can't just run on any modern OS.  I could have added headers to it but
I decided to write `cyber.c`_ to load it into memory instead.  I used
``mmap`` to map a padded version of the code so I could get the code
and the stack under my control and examine it after the code had
exited::

    gcc -g -m32 -Wall -static -o cyber cyber.c

Running the code, it seemed to be early terminating - needing
0x42424242 or "BBBB" on the end to continue according to this bit of
code::

    0000004A 58                           	pop	eax
    0000004B 3D 42 42 42 42               	cmp	eax, 0x42424242
    00000050 75 3B                        	jnz	0x0000008D ; exit

I tried padding with "BBBB" and it core dumped this time.  After
studying the disassembly some more and experimenting I noted that it
needed "BBBB" **and** a 4 byte length.  Running that it appears to
decrypt something on the stack this time, so I'm getting somewhere.

But what to decrypt?  I needed a string starting with "BBBB".  I
recursively downloaded the entire website and grepped it for "BBBB"
without success.  However on really close examination of a hex dump of
cyber.png I discovered this::

    00000050: 1233 7e39 c170 0000 005d 6954 5874 436f  .3~9.p...]iTXtCo
    00000060: 6d6d 656e 7400 0000 0000 516b 4a43 516a  mment.....QkJCQj
    00000070: 4941 4141 4352 3250 4674 6343 4136 7132  IAAACR2PFtcCA6q2
    00000080: 6561 4338 5352 2b38 646d 442f 7a4e 7a4c  eaC8SR+8dmD/zNzL
    00000090: 5143 2b74 6433 7446 5134 7178 384f 3434  QC+td3tFQ4qx8O44
    000000a0: 3754 4465 755a 7735 502b 3053 7362 4563  7TDeuZw5P+0SsbEc
    000000b0: 5952 0a37 386a 4b4c 773d 3d32 cabe f100  YR.78jKLw==2....

That string "QkJCQj...78jKLw==" with upper and lower case letters, '+'
and '/' and the trailing '==' screams `base64 encoding`_ to me.  I
decoded it in python and it decodes to ``BBBB2\x00\x00\x00\x91``... -
hooray a string starting with "BBBB" and a sensible looking length!  I
then modified `cyber.py`_ to add that on the end of the code and ran
the `cyber.c`_ binary.  After it had ran I examined the stack in the
``cyber.bin.padded`` file originally written by ``cyber.py``.  I saw
this::

    00002c0: 00 00 00 00 00 00 00 00 00 00 47 45 54 20 2f 31  ..........GET /1
    00002d0: 35 62 34 33 36 64 65 31 66 39 31 30 37 66 33 37  5b436de1f9107f37
    00002e0: 37 38 61 61 64 35 32 35 65 35 64 30 62 32 30 2e  78aad525e5d0b20.
    00002f0: 6a 73 20 48 54 54 50 2f de e6 fb 2f ef ae 5d aa  js HTTP/.../..].

Which looks very like an HTTP transaction, ie a coded instruction to
fetch a file, so I did::

    $ wget http://www.canyoucrackit.co.uk/15b436de1f9107f3778aad525e5d0b20.js
    
.. _`cyber.c`: /nick/pub/gchq-challenge/cyber.c
.. _`cyber.disassembly.asm`: /nick/pub/gchq-challenge/cyber.disassembly.asm
.. _`cyber.png`: /nick/pub/gchq-challenge/cyber.png
.. _`cyber.py`: /nick/pub/gchq-challenge/cyber.py
.. _base64 encoding: http://en.wikipedia.org/wiki/Base64

Stage 2
-------

The downloaded file `15b436de1f9107f3778aad525e5d0b20.js`_ is a
description of a VM with an initial state, but no code to implement
the VM.  It has a very realistic and amusing initial commment!  It
also says "stage 2 of 3" which is the first indication how long this
challenge is going to be.

Otherwise it seems a reasonably straightforward job to implement the
VM and I got cracking on `vm.py`_ after reading that.  Note that it
has 8 bytes of 'firmware' which don't seem to fit in anywhere which is
a bit puzzling.

Wasted a lot of time trying to get the VM to work.  Tried poking the
firmware in various imaginitive places.  Found a few bugs then finally
re-read the doc again - Ah-ha it is 16 byte segment size, not a 16 bit
register... Duh!

Fixed that and it runs much better now actually decrypting stuff and
halts properly.

Found this in the memory in ``final.core`` after `vm.py`_ had run::

    00001c0: 47 45 54 20 2f 64 61 37 35 33 37 30 66 65 31 35  GET /da75370fe15
    00001d0: 63 34 31 34 38 62 64 34 63 65 65 63 38 36 31 66  c4148bd4ceec861f
    00001e0: 62 64 61 61 35 2e 65 78 65 20 48 54 54 50 2f 31  bdaa5.exe HTTP/1
    00001f0: 2e 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .0..............

That seems like an instruction to fetch something from the web site again::

    $ wget http://www.canyoucrackit.co.uk/da75370fe15c4148bd4ceec861fbdaa5.exe

Haven't used the firmware - wonder where that fits in...

.. _`15b436de1f9107f3778aad525e5d0b20.js`: /nick/pub/gchq-challenge/15b436de1f9107f3778aad525e5d0b20.js
.. _`vm.py`: /nick/pub/gchq-challenge/vm.py

Stage 3
-------

I looked in `da75370fe15c4148bd4ceec861fbdaa5.exe`_ - and found it to
be a windows x86 executable.  It seems to be using the cygcrypt dll
from cygwin and the ``crypt()`` function.  It has a string in it which
looks exactly like a DES password crypt "hqDTK7b8K2rvw".  I then set
`John the Ripper`_ and `crack`_ off on it for good measure to find
the encrypted password.

.. _John the Ripper: http://www.openwall.com/john/
.. _crack: http://packages.debian.org/squeeze/crack

John the Ripper found the password ``cyberwin`` in 2 hours. The easy
one was my test to make sure it was working::

    Loaded 2 password hashes with 2 different salts (Traditional DES [128/128 BS SSE2-16])
    easy             (trivial)
    cyberwin         (test)
    guesses: 2  time: 0:02:01:42 (3)  c/s: 1537K  trying: cufqnm5! - cyberwen
    Use the "--show" option to display all of the cracked passwords reliably

And double checking with python::

    >>> crypt("cyberwin", "hq") == "hqDTK7b8K2rvw"
    True

Meanwhile I tried running the exe on windows but it doesn't run
without that dll.

After installing cygwin with the "crypt" package which has the correct
dll in, I copied ``cygcrypt-0.dll`` and ``cygwin1.dll`` into my
working directory.  The exe now runs and gives::

    >da75370fe15c4148bd4ceec861fbdaa5.exe

    keygen.exe

    usage: keygen.exe hostname

    >da75370fe15c4148bd4ceec861fbdaa5.exe localhost

    keygen.exe

    error: license.txt not found

I then tried it with "cyberwin" in license.txt::

    >da75370fe15c4148bd4ceec861fbdaa5.exe localhost

    keygen.exe

    error: license.txt invalid

Hmm, I was expecting that to work.

Looking through the `keygen.edit.asm`_ (my annotated version) I
discovered that the password should be prefixed with "gchq".  The
first hint as to who set this puzzle! ::

    cmp    [ebp+var_38], 71686367h ; gchq
    jnz    short invalid_license

Putting "gchqcyberwin" into the ``license.txt`` and running the
program goes better this time.  It fetches a page this time, but it is
a 404 not found.  Note that this isn't the normal 404 page because the
exe uses HTTP/1.0 rather than HTTP/1.1::

    >da75370fe15c4148bd4ceec861fbdaa5.exe www.canyoucrackit.co.uk

    keygen.exe

    loading stage1 license key(s)...
    loading stage2 license key(s)...

    request:

    GET /hqDTK7b8K2rvw/0/0/0/key.txt HTTP/1.0
    
    response:
    
    HTTP/1.1 404 Not Found
    Content-Type: text/html; charset=us-ascii
    Server: Microsoft-HTTPAPI/2.0
    Date: Sat, 03 Dec 2011 09:29:29 GMT
    Connection: close
    Content-Length: 315
    
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN""http://www.w3.org/TR/html4/strict.dtd">
    <HTML><HEAD><TITLE>Not Found</TITLE>
    <META HTTP-EQUIV="Content-Type" Content="text/html; charset=us-ascii"></HEAD>
    <BODY><h2>Not Found</h2>
    <hr><p>HTTP Error 404. The requested resource is not found.</p>
    </BODY></HTML>

Trying the above in the web browser gives the normal 404 message.
Trying with telnet see that it needs HTTP/1.0. HTTP/1.1 with host
header gives normal page.  Trying "GET / HTTP/1.0" gives the same
message so probably a red herring to do with the server (or not see
later!).

The fact that the page isn't found means that there is something
missing.  But what? The code is executing the equivalent of this to
make the GET string to fetch the page::

    sprintf(buffer, "GET /%s/%x/%x/%x/key.txt HTTP/1.0\r\n\r\n", crypted_string, key1, key2, key2);

However key1, key2 and key3 are all 0 which doesn't look right. I
tried some things for those missing %x parameters::

    >>> t = "gchqcyberwin"
    >>> from struct import *
    >>> [ "%x" %x  for x in unpack(">iii", t) ]
    ['67636871', '63796265', '7277696e']
    >>> [ "%x" %x  for x in unpack("<iii", t) ]
    ['71686367', '65627963', '6e697772']

Try::

    wget http://www.canyoucrackit.co.uk/hqDTK7b8K2rvw/71686367/65627963/6e697772/key.txt
    wget http://www.canyoucrackit.co.uk/hqDTK7b8K2rvw/67636871/63796265/7277696e/key.txt

But no luck.

More study of the `keygen.edit.asm`_ disassembly reveals that key1,
key2, key3 come from the end of the ``license.txt`` file after
"gchqcyberwin".  So that makes 24 bytes of secrets read from the
licence file which is the size of the buffer the code allocates.

Ah-Ha! The clue is in the "loading stageX license key(s)..." messages.

This bit of assembler code gives it away (annotations by me)::

    loc_4011A5:             ; "loading stage1 license key(s)...\n"
    mov     [esp+78h+var_78], offset aLoadingStage1L
    call    printf
    mov     eax, [ebp+var_2C]       ; copy 4 bytes of the licence file
    mov     [ebp+var_48], eax
    mov     [esp+78h+var_78], offset aLoadingStage2L ; "loading stage2 license key(s)...\n\n"
    call    printf
    mov     eax, [ebp+var_28]       ; ...and another 4 bytes
    mov     [ebp+var_44], eax
    mov     eax, [ebp+var_24]       ; ..and another 4 bytes
    mov     [ebp+var_40], eax

It prints "loading stage1 license keys(s)..." loads 4 bytes, then
"loading stage2 license key(s)..." and loads 8 bytes.  Stage 1 is the
first stage of the puzzle - need 4 bytes from this - how about the
unused 4 bytes at the start of the code that is jumped over "af c2 bf
a3".  Stage2 is the second stage from which we need 8 bytes - the
mysteriously unused firmware seems appropriate.

I wrote `keyfetch.py`_ to fiddle with the endianess and after a bit of
trial and error it worked::

  GET 'http://www.canyoucrackit.co.uk/hqDTK7b8K2rvw/a3bfc2af/d2ab1f05/da13f110/key.txt'
  Pr0t3ct!on

Fetched using ``HTTP/1.1`` and the ``GET`` program.  Which looks like
it could be the password! But it doesn't work :-(

The headers showed nothing interesting.  I then tried using
``keygen.exe`` with a corrected license file - it didn't work as I
expected as the webserver doesn't support HTTP/1.0 (or maybe I did
something wrong).

However trying it by hand using telnet and ``HTTP/1.0`` does do
something different::

    $ telnet www.canyoucrackit.co.uk 80
    Trying 31.222.164.161...
    Connected to www.canyoucrackit.co.uk.
    Escape character is '^]'.
    GET http://www.canyoucrackit.co.uk/hqDTK7b8K2rvw/a3bfc2af/d2ab1f05/da13f110/key.txt HTTP/1.0
    
    HTTP/1.1 200 OK
    Content-Type: text/plain
    Last-Modified: Wed, 26 Oct 2011 08:40:14 GMT
    Accept-Ranges: bytes
    ETag: "bc46bae1ba93cc1:0"
    Server: Microsoft-IIS/7.5
    Date: Sun, 04 Dec 2011 11:14:54 GMT
    Connection: close
    Content-Length: 37

    Pr0t3ct!on#cyber_security@12*12.2011+Connection closed by foreign host.
    $ 

I reworked `keyfetch.py`_ to make the fetch using ``HTTP/1.0`` to double check.

Trying ``Pr0t3ct!on#cyber_security@12*12.2011+`` as the key does
indeed work and produces this page: http://www.canyoucrackit.co.uk/soyoudidit.asp:

    So you did it. Well done! Now this is where it gets
    interesting. Could you use your skills and ingenuity to combat
    terrorism and cyber threats? As one of our experts, you'll help
    protect our nation's security and the lives of thousands. Every
    day will bring new challenges, new solutions to find – and new
    ways to prove that you're one of the best.

I'm not going to apply for a job as I'm rather fully employed elsewhere, but it was a fun challenge!

.. _`da75370fe15c4148bd4ceec861fbdaa5.exe`: /nick/pub/gchq-challenge/da75370fe15c4148bd4ceec861fbdaa5.exe
.. _keygen.edit.asm: /pub/gchq-challenge/keygen.edit.asm
.. _`keyfetch.py`: /nick/pub/gchq-challenge/keyfetch.py


Postmortem
----------

I didn't see this until the 1st December 2011 when a colleague at work
(thanks Tom!)  mentioned it to me and I didn't have time to work on it
until Friday the 2nd of December.  It took me one very late night on
Friday and intermittent hacking on Saturday and Sunday to complete the
challenge - about 12 hours in total.  I spent 3 hours tracking down
that mis-understanding in `vm.py`_ about 16 byte segments and 2 hours
trying to work out what the missing 12 bytes were in the URL in stage
3.

I think Stage 1 was very hard - perhaps deliberately so.  Stage 2 was
much easier - there was a defined goal and any competent computer
scientist would be able to knock up the VM code.  Stage 3 involved an
awful lot of reading C compiler created x86 assembler which was
painful.  I suspect I could have done it a lot quicker if I'd had some
better tools.  An interactive disassembling debugger would have been
useful - I used to have such a thing when I did 68000 programming and
it was a wonder.

I note that I didn't actually have to crack the encrypted password in
Stage 3.  I could have just changed one byte and have it ignore the
check but I was expecting that the code would actually need to use it.
Alas no and so much for `John the Ripper`_!

Finally thanks to GCHQ for making the challenge - it was a good one!
