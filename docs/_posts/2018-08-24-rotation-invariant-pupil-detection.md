---
title:   "Rotation invariant pupil detection (well, almost)"
date:    2018-08-24 17:37:21
excerpt: "Always transforming face to be level makes the eye corner and pupil detection rotation invariant. At least until the head tilt becomes too large."
published: true

---
The advantage of first transforming the face so that is level and then
performing eye corner and pupil detection is that we get a high degree of
rotation invariance:

<iframe width="560" height="315"
src="https://www.youtube.com/embed/6lGbhUPvzYo" frameborder="0"
allow="autoplay; encrypted-media" allowfullscreen></iframe>

With that said, once the head tilt becomes large enough, the horizontal pupil
movements will be too small compared to the noise. Considering a 90 degree
tilt, the pupils will only move vertically when tracking the moving objects.

To fix this, one would probably have to adjust for the head tilt angle by
combining the corresponding proportion of horizontal and vertical pupil
movement.
