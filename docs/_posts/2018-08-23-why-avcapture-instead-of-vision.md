---
title:   "AVCapture, Core Image and Vision"
date:    2018-08-23 14:43:29
excerpt: "Three generations of iOS detectors"
published: true

---
Instead of letting OpenCVs (or Dlibs) face detectors work on the entirety of
the image, I leverage Apples own (much faster in this case) face detection,
pick the largest face (which is presumably the user of the app), and send
that to OpenCV (DLib).

<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/face-detector-landscape.png" alt="">
  <figcaption>Image from [Vision Framework: Building on Core ML](https://developer.apple.com/videos/play/wwdc2017/506/).</figcaption>
</figure>

What was a bit surprising is that Apples oldest face detector generation
AVCapture turned out to be perfect for this. The detection is done in hardware
at image capture time and does not provide any specific landmarks, just a
bounding box for the face, which is all I need.

I would have imagined that the two newer frameworks, Vision and Core Image,
would be outstanding in comparison but that is definitely not the case. Most
surprising is that AVCapture is the only framework of the three that provides
face yaw and pitch.
