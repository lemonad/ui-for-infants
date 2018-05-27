---
title:   "General algorithm for pupil tracking"
date:    2018-05-27 22:50:58
excerpt: "General algorithm for pupil tracking"
published: true

---
Given an image as input, the traditional sequence is to detect faces, resulting in a bounded area for each face (1). Given this bound and general anatomical proportions, detect the areas around the eyes (2). For each eye, localize the pupil in the center of the iris (4).

<figure>
  <img src="{{ site.url }}{{ site.baseurl }}/assets/images/harrys-face.png" alt="Illustration of pupil detection">
  <figcaption>Face detection (1), eye detection (2), palpebral fissure reference points (3), and (4) pupil localization. Personal photograph/illustration by author. May 27, 2018.</figcaption>
</figure>

For direction of the gaze, the algorithm must approximate configuration and position of the head in 3D space as well as the position of the pupil in relation to the palpebral fissure.

Tracking the gaze must then robustly and very precisely handle changes in all the above variables (as well as other variables such as lighting) over time. Like it sounds, this is a difficult problem to solve and why most applications where gaze direction is important use special hardware like head-mounted gaze trackers using infrared light, calibrated for each person using them.

Pursuits, instead of using the direction of gaze to deduce which object is being looked at, deduces the object being looked at by the statistical correlation between the movement of the pupils and the movement of objects. This way the configuration and position of the head is no longer needed and individual differences in the dimensions of palpebral fissure can be ignored, making for a much simpler algorithm.

#### Modern approach
Since deep neural networks became feasible to use in realtime applications, parts of the traditional approach are no longer needed as facial landmarks can be found directly. With that said, face detection is both robust and fast it is often useful to limit facial landmark detection only to the areas where a face has been found. Similarly for pupil and palpebral fissure localization, it is useful to limit the search to the smaller areas around the eyes.