# Gtkada-minesweeper
A minesweeper writed in ada and using Gtk. I made it to practice the ada language.

## License
I release this code under the GPL V3 license, the text of this license is in LICENSE.txt.

## Building
I didn't spend many time on the building system, it's only tested on Debian 9 but should on many system.

This project require the following librairies/packages:
- libgtkada* (I used 3.8.3)
- libgtkada*-dev (I used 3.8.3)
- libgtk* (I used -3-0)
- libgtk*-dev (I used -3)

Ensure you have them installed, then use `gprbuild -p` to run the build.
