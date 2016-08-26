#!/bin/bash

rsync -avz --progress --bwlimit=5500 --log-file=rsync-job.log -e "ssh -p 2022" images_bck/* david@10.23.0.2:/home/david/download/ffmsn
