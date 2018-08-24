---
title:   "Building on a framework: Core Image, Vision or DLib?"
date:    2018-06-20 23:42:05
excerpt: "Should I build solution on a framework like iOS Vision or DLib?"
published: true

---
Using the Pursuits method, only *relative* pupil movements are needed rather
than everything needed for tracking gaze. At first glance, this seems a lot
simpler but -- relative to *what*?

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

One idea is to build on a framework that provides facial features.

OpenCV
------
OpenCV uses HAAR-cascades to detect faces, which goes back to Viola and
Jones (2001).



Core Image
----------

<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/BioID_1170.jpg" alt="">
  <figcaption>Facial landmarks provided by the Core Image framework for iOS.</figcaption>
</figure>

Vision
------
During the summer of 2017, Apple introduced their new Vision framework, based
more on modern methods of machine learning. Vision promises better accuracy
at the cost of slower performance compared to Core Image.

<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/BioID_1170.jpg" alt="">
  <figcaption>Facial landmarks provided by the Vision framework for iOS.</figcaption>
</figure>

DLIB
----
Dlib uses a trained model for 


One problem with the first set of landmarks is that it doesn't seem to
do provide a particularly close boundary around the eye, which could be
a problem as algorithms for finding pupil centers seem to be on the slow
side. On the other hand, it does not underestimate the boundary either,
which also could be a problem.


 The second problem
might be tha

