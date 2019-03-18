#!/bin/bash

data_dir=./data
goes_url=https://cdn.star.nesdis.noaa.gov/GOES16/ABI/FD/GEOCOLOR

while :
do
        # Get list of images
        for image in $(GET $goes_url/ | grep -oe "[0-9]\{0,11\}_GOES16-ABI-FD-GEOCOLOR-10848x10848.jpg" | uniq)
        do
                # Check if images exist already
                if [ ! -f $data_dir/images/"$image" ]
                then
                        # Download images that don't exist
                        wget -q --limit-rate=128k -O $data_dir/images/"$image".temp --show-progress -c $goes_url/"$image"
                        mv $data_dir/images/"$image".temp $data_dir/images/"$image"
                fi
        done

        # Generate a random number between 55 and 65
        wait=$(( RANDOM % 10 + 55 ));

        # Sometimes it will download a zero-byte file
        # Search and delete zero byte files in the images directory
        find $data_dir/images -type f -empty -delete

        # Grab the GMT date
        datecode=$(date +%Y%j%H%M)

        # Generate the video compilation
        # We're going to skip this for now because it takes too long
        # ffmpeg -hide_banner -loglevel panic -y -f image2 -framerate 24 -pattern_type glob -i "$data_dir/images/*.jpg" -c:v libx264 -qp 30 -vf scale=1280:720 -preset veryfast -tune stillimage -movflags faststart $data_dir/videos/$datecode.mp4

        # Symlink latest video

        # Delete old videos

        # Sleep and wait, then loop again
        sleep "$wait"m
done
