---
title:   "OpenCV, CIDetector, or Vision for eye detection"
date:    2018-05-25 23:14:49
excerpt: "Trying the new Vision library in iOS 11."

---

When it comes to iOS face feature detection, there are several options and
they all have their pros and cons:

Using OpenCV I have never been able to reach good frame rates, even with just
reading frames from the camera, resizing, and showing. In retrospect, after
having worked much more with OpenCV during the MVK course this spring, I think
there are options left to try.

In regards to CIDetector, I implemented something similar to Pursuits last
summer and with good lighting and some concentration from the person using it,
20 successful selections in a row proved to be remarkably easy. The screen
size of my mobile was so small though that following the movements on screen
caused very little pupil movement, which, in turn, meant precision became a
problem.

Apple just released a new version of their iPad, with an upgraded front
camera, now equal to the one in iPhone 7, as well as a beta version
of iOS 11, in which they are (slowly) moving away from CIDetector towards
a new library called Vision, part of their machine learning efforts.
Vision seems to [trade speed for accuracy][1] so there's a risk that
it will be too slow for using with Pursuits but on the other hand, perhaps
very little post processing is needed in order to get the eye and pupil
readings I need for Pursuits.

All in all, I've decided to give Vision a go and it will be interesting to
see how well it performs. The 10.5" iPad is fast compared to the iPhone 6S+
I've been using before so I think it should be fine.

[1]: https://devstreaming-cdn.apple.com/videos/wwdc/2017/506jgz9rblchh/506/506_vision_framework_building_on_core_ml.pdf
