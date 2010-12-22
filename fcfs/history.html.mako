<%inherit file="/fcfs/nav.inc" />
<%def name="title()">FCFS: History and Credits</%def>
<h3>History</h3>

  <dl>
    <dt>0.00 -- 24Mar94</dt>

    <dd>The first version of the FCFS filing system: itself a FileCore filing system. However a huge problem appeared: FileCore isn't re-entrant! So it would work over a network quite happily but not on a local FileCore disc.</dd>

    <dt>1.00 -- 20Sep95</dt>

    <dd>First fully working version, with an image filing system (with its own code to read from FileCore disc images), image creation and restoration.</dd>

    <dt>1.01 -- 26Sep95</dt>

    <dd>Fixed a bug that prevented some files (especially fragmented ones) from being correctly read from an image.<br />
    Now works with new FSes running with old FileCore.</dd>

    <dt>1.02 -- 23Feb96</dt>

    <dd>Fixed problems with hidden files when used together with FilerPatch.<br />
    Objects that shared sectors with the root directory are now correctly read from images.<br />
    Added support for compressed images.<br />
    Fixed problems with RISCiX or RiscBSD partitioned hard discs (the partition is no longer copied to the image).</dd>

    <dt>1.10 -- 22Feb97</dt>

    <dd>Multitasking while compressing an image tidied up<br />
    Fixed a few typos in program text and redid manual<br />
    Fixed adjust clicking on MakeImage radios<br />
    Added images information window</dd>
  </dl>

  <h3>Credits</h3>We'd like to thank the following people who contributed in some way to the development of FCFS:

  <ul>
    <li>Martin J Ebourne for his memory allocation functions, used in the desktop frontend and his module code.</li>

    <li>Jason Williams (and all the other collaborators) for DeskLib.</li>

    <li>Dave Lawrence, Mike Brown and George Foot for being diligent beta testers.</li>
  </ul>
