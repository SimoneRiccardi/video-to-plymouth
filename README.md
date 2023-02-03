#  Video to plymouth theme

script that permits to reproduce a video at boot with plymout ([example here](https://github.com/SimoriccITA/plymouth-i_use_arch_btw))

it takes 3 argument:
1. input video filename
2. resolution of the screen
3. (optional: destination folder of the plymouth theme, by default  installs the theme on the system)

the theme'll have the same name of the video (excluding the extention), so to select it use
```
plymouth-set-default-theme {{name of the video (extention excluded)}}
```
