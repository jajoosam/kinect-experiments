# Kinect Experiments
Experimenting with the Microsoft Kinect using Processing


### The music visualizer
[![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/495a8d25-4291-4651-abf4-603e6879ffe2/giphy_%289%29.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20201127%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20201127T112124Z&X-Amz-Expires=86400&X-Amz-Signature=67c1bab16f7f83b1466d33682e5f9dc0f31e2aac836370a2e0ba77f025f712b0&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22giphy_%289%29.gif%22)](https://www.youtube.com/watch?v=isH8I-eUYlU)

`music-visualizer.pde` takes an audio stream from the microphone, and uses `minim` to detect beat onsets - which generate a new color for the dancer's image to change to, along with a cool glitch effect.

To take a stream of high quality music playing on the same computer, use [Soundflower](https://rogueamoeba.com/freebies/soundflower/) for mac - which generates a virtual micrphone.
