#!/bin/bash

# initialization
path_="/home/$(whoami)"
log_path="$path_/log"
cur_time=$(date +"%Y%m%d%H%M%S")

cd "$path_"
ram_usage=$(free -m)
disk=$(du -sh $path_)

# # crontab to run every min
# * * * * * "/home/etern1ty/sisop_works/modul_1/soal_4/minute_log.sh"

# create log directory if it doesnt exist
if [[ ! -d "$log_path" ]]; 
then
    mkdir "$log_path"
fi

cd "$log_path"

# logging
mem_total=$(echo $ram_usage | cut -d ' ' -f8) # ' ' -> delimiter from free -m output
mem_used=$(echo $ram_usage | cut -d ' ' -f9) # using cut to get the desired field of free -m output for every variable
mem_free=$(echo $ram_usage | cut -d ' ' -f10)
mem_shared=$(echo $ram_usage | cut -d ' ' -f11)
mem_buff=$(echo $ram_usage | cut -d ' ' -f12)
mem_available=$(echo $ram_usage | cut -d ' ' -f13)

swap_total=$(echo $ram_usage | cut -d ' ' -f15) 
swap_used=$(echo $ram_usage | cut -d ' ' -f16)
swap_free=$(echo $ram_usage | cut -d ' ' -f17)

path_size=$(echo $disk | cut -d ' ' -f1)

# output to log
echo mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size >> "metrics_$cur_time.log" # header format
echo $mem_total,$mem_used,$mem_free,$mem_shared,$mem_buff,$mem_available,$swap_total,$swap_used,$swap_free,$path_/,$path_size >> "metrics_$cur_time.log"

# change perms
chmod 600 "metrics_$cur_time.log"