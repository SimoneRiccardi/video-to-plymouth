#!/bin/sh

#<screen resolution> with ffmpeg is useful to avoid use plymouth's "image[i].Scale(Window.GetWidth(),Window.GetHeight());" for every image, It's too slow

if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg with ffprobe required"
    exit 1
fi

if ! command -v ffprobe &> /dev/null
then
    echo "ffprobe required"
    exit 1
fi

if [ $# -lt 2 ]; then
    echo "Usage <input file name> <screen resolution> [output folder, default plymouth theme folder]"
    exit 1
fi


OUTPUT=""
INPUT="$1"
INPUTNAME="${INPUT##*/}"
INPUTNAMENOEXT="${INPUT%.*}"

if [ -z $3 ]; then
    if ! command -v plymouth &> /dev/null
    then
        echo "plymouth required"
        exit 1
    fi
    OUTPUT="/usr/share/plymouth/themes/"
else
    OUTPUT="$3"
fi
if  [[ ! -w "$OUTPUT" ]];
then
    echo "permission denided for the output folder"
    exit 1
fi

OUTPUT="$3/$INPUTNAMENOEXT"

echo $INPUT $OUTPUT


mkdir "$OUTPUT"

ffmpeg -i "$INPUT" -vf "scale=$2" "$OUTPUT/progress-%01d.png"

NFRAMES="$(ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -print_format default=nokey=1:noprint_wrappers=1 "$INPUT")"
NSECONDS="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT")"
cp -r ./themefiles/* $OUTPUT



OUTPUTPLY="$OUTPUT/$INPUTNAMENOEXT.plymouth"

echo "[Plymouth Theme]" > "$OUTPUTPLY"
echo "Name=i_use_arch_btw" >> "$OUTPUTPLY"
echo "Description=animation from $INPUTNAME video" >> "$OUTPUTPLY"
echo "ModuleName=script" >> "$OUTPUTPLY"
echo "" >> "$OUTPUTPLY"
echo "[script]" >> "$OUTPUTPLY"
echo "ImageDir=/usr/share/plymouth/themes/$INPUTNAMENOEXT" >> "$OUTPUTPLY"
echo "ScriptFile=/usr/share/plymouth/themes/$INPUTNAMENOEXT/script.script" >> "$OUTPUTPLY"


OUTPUTSCRIPT="$OUTPUT/script.script"

echo "nframes = $NFRAMES;" > "$OUTPUTSCRIPT"
echo "nseconds = $NSECONDS;" >> "$OUTPUTSCRIPT"
echo "for (i = 1; i <= nframes; i++)" >> "$OUTPUTSCRIPT"
echo "  frames_buffer[i] = Image(\"progress-\" + i + \".png\");" >> "$OUTPUTSCRIPT"
echo "video = Sprite();" >> "$OUTPUTSCRIPT"
echo "#Place in the center (useful if image is not scaled at Window resolution)" >> "$OUTPUTSCRIPT"
echo "video.SetX(Window.GetWidth() / 2 - frames_buffer[1].GetWidth() / 2);" >> "$OUTPUTSCRIPT"
echo "video.SetY(Window.GetHeight() / 2 - frames_buffer[1].GetHeight() / 2);" >> "$OUTPUTSCRIPT"
echo "progress = 1;" >> "$OUTPUTSCRIPT"
echo "frame = null;" >> "$OUTPUTSCRIPT"
echo "fun refresh_callback (){" >> "$OUTPUTSCRIPT"
echo "    if(Math.Int(progress)<=nframes){" >> "$OUTPUTSCRIPT"
echo "       frame = frames_buffer[Math.Int(progress)];" >> "$OUTPUTSCRIPT"
echo "       progress = progress + ((nframes/nseconds)/50) ;" >> "$OUTPUTSCRIPT"
echo "    }" >> "$OUTPUTSCRIPT"
echo "    video.SetImage(frame);" >> "$OUTPUTSCRIPT"
echo "  }" >> "$OUTPUTSCRIPT"
echo "Plymouth.SetRefreshFunction (refresh_callback);" >> "$OUTPUTSCRIPT"
