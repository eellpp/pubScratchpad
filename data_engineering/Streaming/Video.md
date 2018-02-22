
### Netflix use TCP and not UDP for its streaming video

Usually a live video stream is somewhat fault tolerant. So if some packages get lost (due to some router along the way being overloaded, for example), then it will still be able to display the content, but with reduced quality.
If your live stream was using TCP/IP, then it would be forced to wait for those dropped packages before it could continue processing newer data.

That's doubly bad:
- old data be re-transmitted (that's probably for a frame that was already displayed and therefore worthless) and new data can't arrive until after old data was re-transmitted
- If your goal is to display as up-to-date information as possible (and for a live-stream you usually want to be up-to-date, even if your frames look a bit worse), then TCP will work against you.

For a recorded stream the situation is slightly different: you'll probably be buffering a lot more (possibly several minutes!) and would rather have data re-transmitted than have some artifacts due to lost packages. In this case TCP is a good match (this could still be implemented in UDP, of course, but TCP doesn't have as much drawbacks as for the live stream case).
