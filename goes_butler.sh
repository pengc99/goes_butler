#!/bin/bash

data_dir=./data
goes_url=https://cdn.star.nesdis.noaa.gov/GOES16/ABI/FD/GEOCOLOR

while :
do
        # Check and see if the data directory exists
        if [ ! -d $data_dir ]
        then
                # Create the data directory if it doesn't exist
                mkdir $data_dir
        fi

        # Get list of images
        for image in `GET $goes_url/ | grep -oe "[0-9]\{0,11\}_GOES16-ABI-FD-GEOCOLOR-10848x10848.jpg" | uniq`
        do
                # Check if images exist already
                if [ ! -f $data_dir/$image ]
                then
                        # Download images that don't exist
                        wget -q --limit-rate=128k -O $data_dir/$image.temp --show-progress -c $goes_url/$image
                        mv $data_dir/$image.temp $data_dir/$image
                fi
        done

        # Generate a random number between 55 and 65
        wait=$(( $RANDOM % 10 + 55 ));

        # Sometimes it will download a zero-byte file
        # Search and delete zero byte files in the images directory
        find $data_dir -type f -empty -delete

        # Grab the GMT date
        datecode=`date +%Y%j%H%M`

        # Sleep and wait, then loop again
        sleep "$wait"
done
