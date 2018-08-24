---
title:   "Simple feature-based adaptive pupil detection based on histogram CDF (featuring Harry, 21 months old)"
date:    2018-08-20 16:18:02
excerpt: "Finally found a starting point for pupil detection."
published: true

---
After reading and trying a lot of different things, the paper *Low Cost Eye
Tracking: The Current Panorama* (Ferhat and Vilariño, 2016) led me to a paper
I had the skills to implement from scratch: *Automatic Adaptive Center of
Pupil Detection Using Face Detection and CDF Analysis* (Mansour and
Shanbezadeh, 2010). Finally.

Even though the algorithm as described is for use on smaller BioID images,
it seems to work pretty well with higher resolution images too. Although,
the difference is not that great as with a greater distance from the iPad
camera, the number of pixels representing an eye becomes closer and closer
to the number of pixels of the eyes in the BioID images.

This is the result, after applying Kalman filtering on the pupil position:

<iframe width="560" height="315"
src="https://www.youtube.com/embed/pU_13qWlJxo" frameborder="0"
allow="autoplay; encrypted-media" allowfullscreen></iframe>

It's not perfect but will have to do for now!


### Bibliography
Ferhat, Onur and Vilariño, Fernando (2016) ["Low Cost Eye Tracking: The Current Panorama](https://dl.acm.org/citation.cfm?id=2985914).
Computational Intelligence and Neuroscience. 2016. 1-14. 10.1155/2016/8680541.

Mansour, Asadifard and Shanbezadeh, Jamshid (2010) ["Automatic Adaptive Center of Pupil Detection Using Face Detection and CDF Analysis"](http://www.iaeng.org/publication/IMECS2010/IMECS2010_pp130-133.pdf).
Lecture Notes in Engineering and Computer Science. 2180.

