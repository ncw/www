---
title: FCFS - FileCore Image Filing System
description: FCFS - FileCore Image Filing System
---

<img src="../../icon/fcfs.gif" alt="[FCFS]" align="left" vspace="4" hspace="4" width="33" height="33" /> <strong>FCFS (1.10) - FileCore Image Filing System<br /> © <a href="mailto:nick@craig-wood.com">Nick Craig-Wood</a> &amp; <a href="mailto:msergio@tin.it">Sergio Monesi</a> 1995-7<br clear="left" /></strong>

FCFS allows you to create, read and restore images of FileCore discs.

This means that you can copy a whole floppy or hard disc image to your
hard disc and then access it as if it were a directory via the FCFS
image filing system. A desktop front end for the multitasking creation
and restoration of these disc images is provided. This is very useful
for back up purposes.

FCFS requires RISC OS 3.10 or later (it has been fully tested on Risc
PC and StrongARM) and supports interactive help.

FCFS is SHAREWARE. If you use it for more than 30 days you must
register; see <a href="legal.html">Conditions of use</a> for more
info.

## Index

<table border="0" width="100%">
<tr>
<td><a href="#introduction"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Introduction</a><br /></td>
<td><a href="images/"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> FCFS images</a><br /></td>
<td><a href="making/"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Making images</a><br /></td>
</tr>
  
<tr>
<td><a href="restoring/"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Restoring images</a><br /></td>
<td><a href="multi/"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Multitasking operations</a><br /></td>
<td><a href="using/"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Using images</a><br /></td>
</tr>
  
<tr>
<td><a href="legal/"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Legal notes</a><br /></td>
<td><a href="legal.html#registering"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Registering</a><br /></td>
<td><a href="history/"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> History &amp; Credits</a><br /></td>
</tr>
  
<tr>
<td><a href="#contact"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Contacting the Authors</a><br /></td>
<td><a href="#download"><img src="../../icon/radiooff.gif" border="0" alt="*" align="top" width="18" height="18" /> Download FCFS</a><br /></td>
</tr>
</table>

## Introduction {#introduction}

Why would anyone want to copy a FileCore disc into an image file? Well
FCFS was conceived to do this for 2 main reasons.

Firstly when backing up a hard disc onto another hard disc, we noticed
that FileCore took about 10 times longer to copy the contents of the
disc as it did to read and write all the sectors at a low level. This
is because FileCore is creating file and directories, altering the
directory images and generally having to do a lot of work. FCFS allows
you to copy an entire disc (floppy or hard) to a file, sector by
sector, very quickly.

The second use of FCFS is to write these files back to a disc. This
might be used by the maintainer of a PD library, who keeps a lot of
floppy disc images on hard disc, and when he wants to write them to
floppy he just uses FCFS to do so. This again is much quicker than
copying the files directly.

We created an image filing to read the files out of these images (as
if they were still attached as a disc drive). The image filing system
is read only for the time being though.

FCFS is used every day by one of the authors for backing up his 420 Mb
disc onto an external SCSI disc. This chore which used to take nearly
an hour, is all over in 8 minutes! The created image is then readable
with the image filing system.

## Contacting the Authors {#contact}

<a href="../index.html">Nick Craig-Wood</a> is at <a href="mailto:nick@craig-wood.com">nick@craig-wood.com</a><br />
<a href="http://www.monesi.com/sergio/">Sergio Monesi</a> is at <a href="mailto:msergio@tin.it">msergio@tin.it</a>

More information is available within the FCFS package.

## Download FCFS {#download}

The latest release version can be found at Hensa or its mirrors <a href="ftp://micros.hensa.ac.uk/micros/arch/riscos/d/d148/"><img src="../../icon/dl1.gif" alt="[1]" align="top" border="0" width="18" height="14" /></a><a href="ftp://ftp.demon.co.uk/pub/mirrors/hensa/micros/arch/riscos/d/d148/"><img src="../../icon/dl2.gif" alt="[2]" align="top" border="0" width="18" height="14" /></a><a href="ftp://sunsite.doc.ic.ac.uk/computing/systems/archimedes/collections/hensa/riscos/d/d148/"><img src="../../icon/dl3.gif" alt="[3]" align="top" border="0" width="18" height="14" /></a>.<br />
The latest version can be always be found here <a href="../../pub/riscos/"><img src="../../icon/dl0.gif" alt="[0]" align="top" border="0" width="18" height="14" /></a>.

See also <a href="http://www.monesi.com/sergio/fcfs.html">Sergio's FCFS page</a>.
