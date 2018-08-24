---
title:   "Proof of concept I: Pupil tracking correlates with on-screen movement"
date:    2018-08-24 11:21:45
excerpt: "Success, it looks like the idea might actually hold."
published: true

---
Finally, I think I am getting somewhere. After a night of debugging, I
realized that my choice of reference in terms of inner or outer eye corner
must be the same for both eyes (obvious afterwards but I figured positive
offsets for both pupils would be practical). If the sign of the left pupil
offset is different to the right pupil offset, it is as if the user is
following two different objects at the same time!

The underlying statistical measurement I am using, which is also what is used
in the Pursuits paper, is the [Pearson's Product Moment Correlation Coefficient](https://en.wikipedia.org/wiki/Pearson_correlation_coefficient).
That is, how much linear correlation there is between two variables. If the
value is one, there is perfect linear correlation and if it is zero, there is
*no* linear correlation.

In the video below, I use bar graphs `[-1, 1]` to present the correlation
over a number of time steps. On the left is the left and right pupil
correlations with the movement of the object at the top of the screen. On
the right is the pupil correlations with the object at bottom of the screen.

<iframe width="560" height="315"
src="https://www.youtube.com/embed/wR77t5kgYU4" frameborder="0"
allow="autoplay; encrypted-media" allowfullscreen></iframe>

From the bars, it is pretty easy to see which object is being followed at the
moment. if you need a pointer though, a heart lights up underneath the object
when there has been a certain amount of correlation during the last time
steps. The correlation drops when the object switches direction so the heart
disappears, hopefully I can fix this by just adjusting the thresholds or...

    TODO Apply Kalman filtering on the correlation?

The correlation can also be negative, which I think means that large pupil
offsets correlate with small object offsets. From the bars in the video,
looking at one object seems to maximize the negative correlation of the
other object, so that sounds right.

The idea now is to move the hearts along the arrows whenever there is
correlation so one can see which object has caught the most attention of the
infant/toddler that is using the app.
