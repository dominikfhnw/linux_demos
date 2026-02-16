                   _
 _ __  ___ __ _ __| |_ _  _
| '_ \/ -_) _` / _| ' \ || |
| .__/\___\__,_\__|_||_\_, |
|_|                    |__/

Life is peachy

64b framebuffer demo for Linux/x86 by dominikr

There's a disconcerting lack of 64b graphics demos for Linux.
This demo tries to fix that.

Before you run it:
Normal users don't have access to the /dev/fb0 framebuffer device.
Run this demo as root (not recommended), or set group permissions.
For Ubuntu:
$ sudo usermod -a -G video $(whoami)
And log out/in to load the new group permissions

After that, run:
$ ./peachy <>/dev/fb0
(the '<>' is not a typo)
