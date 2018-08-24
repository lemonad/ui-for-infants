---
title:   "Kalman filters to the rescue (?)"
date:    2018-07-24 10:33:59
excerpt: "Relative pupil movements need some kind of stabile reference point"
published: true

---
Using the Pursuits method, only *relative* pupil movements are needed rather
than everything needed for tracking gaze. At first glance, this seems a lot
simpler but -- relative movements to *what*?

As an example, what if a person is nodding while looking straight ahead, how
do we distinguish that from the person looking up and down with a fixed
head, if we are only looking at the eye region? We don't, at least if we want
to avoid complicating things. It's not really a problem unless the person
keeps switching head alignment (which, on the other hand, might very well be
the case with infants, I don't know yet).

So assuming the user is not moving their head, we still need some feature
to relate pupil movements to. A common choice is tracking the eye corners
but then we have three points per eye to find and track accurately. Are there
perhaps other choices that can provide stabile reference points?

One idea is to build on the eye regions detected by OpenCV. Only one problem
-- they are not very stabile, as can be seen in the video of the previous
post.

Now, I had heard about Kalman filters before but did not really know what
they were and had never used them. It did look like they could be really
useful here so I experimented and finally managed to implement filters for
face and eye rectangles (position as well as width and height). Afterward,
the results look a lot better:

<iframe width="560" height="315"
src="https://www.youtube.com/embed/o54Bd3Du_Kg" frameborder="0"
allow="autoplay; encrypted-media" allowfullscreen></iframe>

Again, the difficulty here is finding a good set of parameters, weighing
responsiveness to actual movements against noise invariance (see video
below).

<iframe width="560" height="315"
src="https://www.youtube.com/embed/pFVXfsdOOhw" frameborder="0"
allow="autoplay; encrypted-media" allowfullscreen></iframe>

Kalman filtering also comes with the benefit of handling spurious missed
detections. Question is if this is good enough to provide a reference
point for us or if eye corner detection or similar is needed?
