---
title:   "Movement along a bezier curve"
date:    2018-08-25 18:01:53
excerpt: "I want the hearts to move along the arrows at the sides but this is remarkably difficult"
published: true

---
When looking at the moving objects, I want the heart at the sides to move along
their respective arrows until one heart reaches the tip and "wins". That is,
I want to map a value `[0, 1]` to positions on the path, starting at the base
and ending at the tip.

<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/looped-curve.png" alt="">
  <figcaption>Arrow drawn in Sketch.app. Personal illustration by author. June 2018.</figcaption>
</figure>

However, this proved more difficult than I thought. I figured I would draw
a bezier path in Sketch.app and use the same coordinates in a Python program
using the [Bezier package](https://bezier.readthedocs.io), which can extract
points along a path with arbitrary subdivisions. Only, it turned out that
there was a disconnect between how bezier paths are constructed in GUI
programs and how they are constructed programmatically. Perhaps I just didn't
look deep enough into the problem. I also tried guessing coordinates for a
long time but getting the loop right was too difficult.

SpriteKit can move sprites along bezier paths but once you start them, they
will move with a set speed, i.e. one can't step forward arbitrarily along
the path. Perhaps I can pause when the pupil-to-object correlation is low
and unpause when the correlation is high? Then only the problem of creating
a nice bezier curve remained.

After trying far too long to recreate the curve by umpteen methods, I found
[PaintCode](https://www.paintcodeapp.com), which can give me the Swift
code for any bezier path I would draw. Easy!

<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/bezier-curve.png" alt="">
  <figcaption>Bezier path along looped arrow, drawn in [PaintCode](https://www.paintcodeapp.com). Personal illustration by author. August 2018.</figcaption>
</figure>

