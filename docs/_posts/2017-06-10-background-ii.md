---
layout:  post
title:   Background II. Gaze-driven interaction
date:    2017-06-10 14:34:03
summary: Smooth pursuits
---

Gaze tracking tries to establish where one is looking, like fixated on a
point in space or tracking a moving object, by taking into account relative
pupil position, head position, etc. Usually this is done with specialized
head- or screen-mounted hardware but if gaze-tracking is to become more
common, it is likely that sensors will have to be integrated in the devices
users would like to use hands-free. Lacking special eye-tracking hardware,
many devices today include video calling capapabilites where the video camera
can be used as a sensor (albeit not with the same precision).

As the eyes are a relatively small feature of the face, device-mounted
eye-trackers need very good accuracy if they should be consistently capable to
register minute changes in gaze. At a distance of half a meter from a display,
shifting our eyes as little as one degree represents about one centimeter of
gaze shift on the display. The Tobii Pro X3–120, a very capable screen-mounted
eye tracker, can generally pick up eye movements as small as half a degree
under good conditions.

However, in order to reach this kind of precision, eye tracking sensors need to
be calibrated to each user's eyes. Recalibration is often also needed when
lighting conditions change, especially if moving from indoors to outdoors. This
step could make it cumbersome to just pick up a device and use it. For new
users, it could even be difficult to know when and how to calibrate.


### Enter Pursuits
Pursuits (Vidal 2014, Vidal 2013a, Vidal 2013b) enables calibration-free
interaction with graphical devices using only gaze. It does this by introducing
a new type of graphical user interface element, based on movement (see figure
from Vidal 2014, below). A user selects an element by following its specific
movements.

> ![Vidal 2014](/assets/images/pursuits-illustration.png)

Pursuits utilizes the smooth pursuits movements of the eye, which is a
type of movement that only happens when we are following something with our
eyes. Most people can not reproduce this movement on their own, which means
that triggering false positives while "just looking" can largely be avoided.

As this technique does not depend on having to identify the position on the
screen a user is gazing, only that the gaze is moving in a specific pattern, it
seems to be less dependent on exact readings and, better yet, calibration is
not necessary as only relative eye movements are relied upon.


### References
Vidal et al. (2013a) [Pursuits: Spontaneous Interaction with Displays Based on Smooth Pursuit Eye Movement and Moving Targets](http://doi.acm.org/10.1145/2493432.2493477)

Vidal, M. (2013b) [Pursuits: Spontaneous Interaction with Displays](https://www.youtube.com/watch?v=TTVMB59KvGA)

Vidal et al. (2014) [Pursuits: Spontaneous Eye-Based Interaction for Dynamic Interfaces](http://doi.acm.org/10.1145/2721914.2721917)
