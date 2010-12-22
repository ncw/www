<%inherit file="/fcfs/nav.inc" />
<%def name="title()">FCFS: Restoring images</%def>
<img src="restore.gif" alt="[Restore image window]" align="right" vspace="8" hspace="8" width="404" height="219" /><br />
  Once you have created an image, you can read the files from it just using the filer (ie drag the files from the image to the disc).

  <p>This is a rather slow process (especially on floppies), so if you want to restore all the files you can use the 'Restore&nbsp;Image' window (opened by clicking Adjust on the iconbar FCFS icon).</p>

  <p>To use this, just drag an FCFS image to this window (its details will be shown), choose the destination disc using the pop-up menu and click on Restore.</p>

  <p>You may adjust how FCFS multitasks with the Options box - see the <a href="multi.html">Multitasking operations</a> section.</p>

  <p>FCFS will copy the image content (only the used 'sectors') decompressing if necessary to the destination disc and when the copying is finished the disc will be an exact copy of the disc that the image was generated from.</p>

  <p>Be *careful* when you use this feature, since it will completely remove the content of the destination disc and will replace it with the content of the FCFS image. If the destination disc is not empty, FCFS will prompt you for confirmation before performing this operation.</p>

  <p>FCFS can restore an image only to a disc whose 'shape' is the same as disc which the image was generated from. In other words, you can't restore an image of a 40Mb hard disc to a 100Mb hard disc, nor you can restore a 800Kb floppy image to a 1.6Mb floppy or vice versa.</p>

  <p>However, you can restore a 800Kb floppy image to a 800Kb RAM disc since their shape is similar (FCFS will tell you that the shape is different, but you can click on 'Continue' and restore it anyway), but you can't restore a 1.6Mb floppy image to a 1.6Mb RAM disc because of RAM disc limitations (it doesn't support the bootblock).</p>
