<%inherit file="/fcfs/nav.inc" />
<%def name="title()">FCFS: Making images</%def>
<img src="make.gif" alt="[Create image window]" align="right" vspace="8" hspace="8" width="295" height="260" /><br />
  Clicking with Select on the iconbar icon will open the 'Make Image' window. To create a new FCFS image from a disc you need to select the source disc (using the pop-up menu), choose the Image type, the filename and drag the icon to a filer window.

  <p>If you choose a compressed image type then you may drag the slider from fast to slow. Fast is speedy but gives worse compression than Slow. The default setting is probably about right for most people.<br clear="right" /></p>

  <p>You may adjust how FCFS multitasks with the Options box - see the <a href="multi.html">Multitasking operations</a> section.</p>

  <p>FCFS will copy the disc sectors (only the used ones) to the image file compressing if you asked for a compressed image and when the copying is finished the image is ready to be opened.</p>

  <p>This is the only way to create FCFS images: there are floppy copy programs that can save the disc image to a file but FCFS can't access them (even if they are filetyped correctly) since they don't include some data that is essential for FCFS. (It may be possible to write a converter though, ask the Authors!)</p>
