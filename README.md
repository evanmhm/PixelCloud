# PixelCloud

A short project I'm working on in Processing 3 which takes an image and creates a point cloud out of the pixels. The depth of the pixels in 3D space is decided by the brightness value of each pixel, creating a pretty cool effect.

# Screenshots

Source picture:

![Original Picture](./sunset.png?raw=true "Source Picture")

Result:

![Screenshot](./screen.png?raw=true "Screenshot")

# Requirements

To run this project, you need the Processing desktop app which can be found [here.](https://processing.org/download/) The plugins for this project are:
- PeasyCam, which can be installed by going to Sketch>Import Library>Add Library... + search for PeasyCam. Required for mouse movement/navigation. Click and drag to rotate, scroll to zoom. More info [here](http://mrfeinberg.com/peasycam/)
- GifAnimation, which has to be installed separately because the version in the Add Library window doesn't support Processing 3. It is used for loading in animated gifs easily. The ported version can be found [here](https://github.com/01010101/GifAnimation).
