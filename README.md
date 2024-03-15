#  Video to plymouth theme

Script that permits to reproduce a video at boot with plymouth ([example here](https://github.com/SimoriccITA/plymouth-i_use_arch_btw))

Dependences:
1. ffmpeg
2. ffprobe (usually shipped with ffmpeg)
3. plymouth, but by modifing the 3th argument it's not necessary, useful if you want execute the script then install the theme on another computer

The script takes 3 arguments:
1. Input video filename
2. Resolution of the screen that have to show at boot the video, WIDTH_PIXELSxHEIGHT_PIXELS  format (example ```1920x1080```)
3. (optional: destination folder of the plymouth theme, by default is the plymouth themes folder, if you want have the theme where you execute the script leave the default)

The theme'll have the same name of the video (excluding the extension), so to select it use
```
plymouth-set-default-theme {{name of the video (extension excluded)}}
```
