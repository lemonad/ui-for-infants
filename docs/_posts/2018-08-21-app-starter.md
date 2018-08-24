---
title:   "Apply pupil detection here"
date:    2018-08-20 16:18:02
excerpt: "Here's a little starting app I've prepared beforehand"
published: true

---
Like any good cooking show -- here's a little app I've prepared beforehand:

<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/app-start.png" alt="">
  <figcaption>iPad app prepared for pupil detection. Personal image by author. August 2018.</figcaption>
</figure>

This app does basically what I set out to do in
the [project specification](https://lemonad.github.io/ui-for-infants/assets/pdf/jonas-nockert-specification-20180525.pdf):

<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/app-start.png" alt="">
  <figcaption>Sketch from my project specification. Personal image by author. May 2018.</figcaption>
</figure>

It's coded in Swift, using SpriteKit, so animations are a smooth 60 fps even
though the face, eye, and pupil detection might run slower than that in the
background. I'm also using Vision, Apple's computer vision framework, for
face and eye detections (a bit faster than OpenCV but seems to have about
the same accuracy and also needs Kalman filtering).

The goal at the moment is just to visualize which of the two images that is
followed. That is, if the pupil detection I'm using is good enough.

Obviously, there is a lot more I would like to do with it but it's got a
picture of a cat and that is enough for my child to pay close attention.
