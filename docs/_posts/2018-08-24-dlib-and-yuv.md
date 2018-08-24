---
title:   "Switched to Dlib and YUV color space"
date:    2018-08-24 01:25:39
excerpt: "Dlib produces better reference points and yuv is a lot faster than RGBA"
published: true

---
OpenCV with Kalman filtering produced pretty good stability of the boxes
around the eyes but it would definitely be better to have eye corners
as reference points. Also the OpenCV eye detectors were unreliable in that
it sometime took a lot longer time to analyze than other times, resulting
in dropped frames.

Dlib has a 5-point detector that produces just the right landmarks for my
purpose. The landmarks can be used to realign the face so that the eyes
are always level. This way the eye corners provide horizontal as well as
vertical reference points, both invariant to head tilt. The eye corner
detection also turned out more stabile in terms of position compared to
OpenCVs eye area detection.

### YUV color space
Using 32 bit RGBA for each camera sample meant a lot of bandwidth and cpu
wasted in transfers and conversions since detection is made in grayscale
anyway. Switching to [YUV420p](https://en.wikipedia.org/wiki/YUV) has two
big advantages in this case: a *lot* less data to handle and the luminance
Y channel can be used as the grayscale image to perform detection on.

The downside is that it is not as simple to draw colored geometric figures
on, which is why the video of the result uses black and white markers:

<iframe width="560" height="315"
src="https://www.youtube.com/embed/ULyGdubtRK4" frameborder="0"
allow="autoplay; encrypted-media" allowfullscreen></iframe>
