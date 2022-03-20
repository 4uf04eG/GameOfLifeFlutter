# Flutter version of Conway's Game of Life

Long story **!short**. For a long time, I did almost no pet projects and decided that it was time to do something new. I've heard a lot that Conway's Game of life is quite an exciting thing (and in fact it really is). So in two productive days I've made the version with a quite straightforward algorithm, flexible cell spawning, RLE parsing and expandable architecture. There is a lot of room for improvements like HashLife, good UI or, hmm, cleaner code, but I leave it for the future me.

As it does not use HashLife, the maximum board size can be set up to **900x900** due to huge performance problems and big memory consumption. However, RLE files' parsing supports unlimited sizes (but try it at your peril as it could use all your memory)

And be aware that there are problems with the pinching on some OSes as an InteractiveViewer which provides zoom functionality don't handle some native Desktop events yet. If you can use the mouse to zoom. Mobile platforms should work fine especially considering that the design was made for bigger screens. And yeah, plus/minus on the control panel are not for zooming, but for speed change. I know it's a quite bad design decision but who cares.

Tested on **MacOS**


![Screenshot 2022-03-20 at 21 13 16](https://user-images.githubusercontent.com/36332098/159175284-1766b768-f9b5-465e-9899-99c6b1e82bb0.png)
