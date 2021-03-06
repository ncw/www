---
title: "FCFS: Image files"
description: "FCFS: Image files"
---


FCFS images are files of type FCD or FileCore. This file type hasn't been allocated for us by Acorn, but it was allocated for FileCore and so our use is probably OK. If you know otherwise then let us know!

<p>FCFS images come in three types, standard, compacted and compressed.</p>

<p>The standard image has <strong>all</strong> the sectors on the disc, used and unused, and if the FCFS image filing system ever becomes write as well as read then it will only be able to write to this type of disc.</p>

<p>The compacted image has had all the unused sectors removed from it, making it smaller.</p>

<p>The compressed image has had all the unused sectors removed from it and the remaining sectors compressed using a very fast compression routine.</p>

<p>For example, if you had a disc with (from Free space display)</p>

<table border="1">
  <tr>
    <td>Free:</td>
    
    <td>125 Mb<br /></td>
  </tr>
  
  <tr>
    <td>Used:</td>
    
    <td>280 Mb<br /></td>
  </tr>
  
  <tr>
    <td>Size:</td>
    
    <td>406 Mb<br /></td>
  </tr>
</table>

<p>An un-compressed image would be 406 Mb in size, a compacted image would be 280 Mb in size and a compressed image would be smaller still, typically about 170 Mb but this varies with exactly what you have on the disc.</p>
