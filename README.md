# Background

In June 2011, a coworker pointed me at a bike event in my own neighborhood in Portland: the "Ladd's Addition Streets & Alleys" ride.  Here's the description from [the Shift2Bikes website](http://shift2bikes.org/cal/viewpp2011.php?#14-2374):

> Kid-focused ride will attempt to trace every foot of street & alleyway in Ladd's Addition.  Kids can mark off on maps where we've been & choose where to turn to cover as much of the neighborhood as possible-- without backtracking!  Start in Ladd's Circle, and end at Palio coffeehouse for some sweet treats.

I missed the ride, but a week or two later I emailed [Katie Proctor](http://civilizedconveyance.blogspot.com/), the ride organizer, to ask her about the ride.  She was kind enough to send me the rule sheet she passed out (it's the .doc file in this folder), as well as answer a bunch of my follow-up questions about her scoring system.

Based on that, I produced another image with all the intersections numbered (I sorta knew there were a lot, but 99 seemed crazy), and then used that to manually encode a simple graph.

# Map

<img src="https://github.com/geeksam/ladds_graph/raw/master/Map%20of%20Ladd's%20Addition.png">

# Quick Scoring Summary

For those of you who don't want to open a random .doc file, here's the tl;dr:

* Teams ride through the Ladd's Addition neighborhood, marking their path as they go.  At the end, they're scored based on how many streets they've ridden, with a scoring penalty for backtracking.
* For the purposes of this ride, a "street" is any segment of street or alleyway inside Ladd's Addition from one intersection to another intersection.  (On the PNG map, it's the path between the numbered green dots.)
* Teams GAIN one point for each street they traverse once and ONLY ONCE.
* Teams LOSE one point for each street they traverse MORE THAN ONCE.
* The four major streets that border Ladd's are neutral streets -- riding these streets does not affect the score either way.

(Note that backtracks effectively cost you two points, because the second time you ride down a street, its contribution from your score changes from +1 to -1!)

# Real-World Results

According to Katie,

> Turn-out for the ride was split, [...] with a few game geek dads trying to optimize the problem and a lot of 7-to-9-year-olds exploring the notion of a random walk.

As for the results:

> Top score was 93, second best was 91, after that we were down in the 70s & below.

# If you'd like to play with this

Please do -- that's why I've put it on github.

## SPOILER ALERT!

Most of the code I've written to solve this particular problem lives in lib/map.rb.  The scoring mechanism is built into the class Map::MapPath, but there should be enough examples in tests/map_tests.rb (under the describe block for the #score method) for you to be able to build your own scoring mechanism.  Or, if you want to peek at my scoring implementation without seeing, most of my solution is in the Map::MapPath#go_forth_and_multiply method, so if you just fold that method up, you should be able to remain mostly unbiased.  (=

## Enjoy!

Feel free to email me:  geeksam at gmail.

## See also

My coworker Dave's [JavaScript code](https://github.com/mildavw/ladds) playing with the same problem, from a different angle.

-Sam
