---
title:   "App with camera and a little lag"
date:    2018-06-12 12:15:53
excerpt: "Getting camera to work on iPad (with some lag)."

---
I've set up an Xcode project for an iPad app, coded in Swift, that takes
video input from the front camera and displays the individual frames on
screen.

<iframe width="560" height="315"
src="https://www.youtube.com/embed/sCoxR4UzHTM" frameborder="0"
allow="autoplay; encrypted-media" allowfullscreen></iframe>

As can be seen in the video above, there is a little lag that I do not
(yet) know the source of. There are a few potential experiments one could
do here:

1. Find out if this is display lag, image processing lag (only conversions
   between sensor data and displayable images at the moment), or a
   combination?
2. How much lag can the statistical correlation handle between eye and
   on-screen movement before drifting apart and causing problems?

In regards to (1), since the front camera can't provide more than 30 fps there
will be some lag but I think this looks like more than that. I have double
checked that the profiler reports the app updating the image view at 30
fps so that part seem to work as it should.

In regards to (2), eye movements should be small and slow compared to me
waving my hand in front of the camera. My initial guess is that this lag is
not significant enough to pursue, at least not at this point.
