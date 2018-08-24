---
title:   "Summer Recap"
date:    2018-08-01 17:48:11
excerpt: "Lessons learned during the summer"
published: true

---
During the summer it became increasingly clear that I had yet again
underestimated this project. While I am more knowledgeable in the subject
this year compared to last, there have been setbacks where I did not quite
expect them.

The curse of Timm and Barth
---------------------------
A search at the time of writing the project proposal resulted in heaps of
interesting material on Github and YouTube. I figured I would have a wide
and diverse solution space to learn from but going through it all this summer,
I realized that most of them could be placed in either of the following two
categories:

* Solutions that claimed to do one thing but in reality did another. In
  many cases explicitly leaving the important part for later

      TODO Pupil tracking. Using the midpoint between eye corners for now.

  In other cases, like Apples new Vision API, returning [data points for
  pupils](https://developer.apple.com/documentation/vision/vnfacelandmarks2d/2879436-leftpupil)
  like they are part of the landmark detection when they are actually just
  based on other detected features (so not useful in this context).

* Rewrites of
  [Tristan Hume's implementation of Timm and Barth](https://github.com/trishume/eyeLike)
  abound. I didn't see it at first because the variable names where different
  or they were using Matlab, Python or Java instead of C++. Now, this is not
  a bad solution in itself but the way it is implemented it has quadratic
  time complexity in the number of pixels so it is slow unless one really
  narrows down the area to apply it to (which might not be as easy as it
  sounds).


BioID Face Database
-------------------
There are a few standard datasets that are widely used for comparing the
performance of an algorithm described in a paper to other algorithms trying
to solve the same problem, e.g. [BioID](https://www.bioid.com/facedb/) and
[Gi4E](http://gi4e.unavarra.es/databases/gi4e/) (which I have not looked
into yet as it is not publicly available).

The BioID database has 1521 grayscale photos with a resolution of 384 x 286
pixels, such as the below examples
<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/BioID_0893.jpg" alt="">
  <figcaption>Source: BioID face 893.</figcaption>
</figure>
<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/BioID_1170.jpg" alt="">
  <figcaption>Source: BioID face 1170.</figcaption>
</figure>

For some reason I had assumed algorithms were designed for some dataset but
also generalized to the reference datasets when in reality, they are optimized
for, say, BioID and could generalize poorly to other datasets. At the very
least one would have to adjust parameters like kernel and window sizes for
images of higher resolution.

What is less obvious is that BioID almost exclusively contain front-facing
faces with pupils centered, which means good results on BioID is no guarantee
for localizing pupils in images where the person is looking to the side. That
is, people might do pupil localization for purposes other than what I have in
mind (which is obvious in hindsight).

Since I want to make as few assumptions about the distance to the camera and
to the facial alignment as I can, coming up with something that is invariant
to, say, scale seems trickier than I first thought.
