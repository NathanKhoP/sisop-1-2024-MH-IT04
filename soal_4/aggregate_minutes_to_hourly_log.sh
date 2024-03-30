#!/bin/bash

# initialization
path_="/home/$(whoami)/log"
cd "$path_"
cur_time=$(date +"%Y%m%d%H")
aggr_hour=$(date -d '-1 hour' +%Y%m%d%H) # aggregate the hour before since this runs hourly based on the previous hours log

# # crontab to run every hour
# 0 * * * * "/home/etern1ty/sisop_works/modul_1/soal_4/aggregate_minutes_to_hourly_log.sh"

# make a tempfile for the aggregated data (1 hour before)
find ! -name '*agg*' -name "metrics_*.log" -name "*$aggr_hour*" -exec awk -F "," 'END{log_=sprintf("numfmt --from=iec %s",$11);
log_ | getline fix_log; close(log_); print $0","  fix_log}' {} \; > tempaggr.txt

# make header
echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "metrics_agg_$cur_time.log"

# minimum values (set t[12] to a very big number)
awk -F "," 'BEGIN {for (i=1; i<=9; i++) t[i] = ""; t[12] = 999999} 
{for (i=1; i<=9; i++) if (NR==1 || $i < t[i]) t[i] = $i; if ($12 < t[12]) t[12] = $12} 
END {printf "minimum,"; for (i=1; i<=9; i++) printf t[i]","; printf $10","; disk=sprintf("numfmt --to=iec %d",t[12]); disk | getline fixed; close(disk); print fixed}
' tempaggr.txt | paste -s -d '' >> "metrics_agg_$cur_time.log"

# maximum values (set t[12] to a very small number)
awk -F "," 'BEGIN {for (i=1; i<=9; i++) t[i] = ""; t[12] = -999999}
{for (i=1; i<=9; i++) if (NR==1 || $i > t[i]) t[i] = $i; if ($12 > t[12]) t[12] = $12} 
END {printf "maximum,"; for (i=1; i<=9; i++) printf t[i]","; printf $10","; disk=sprintf("numfmt --to=iec %d",t[12]); disk | getline fixed; close(disk); print fixed}
' tempaggr.txt | paste -s -d '' >> "metrics_agg_$cur_time.log"

# average values
awk -F "," 'BEGIN {for (i=1; i<=9; i++) t[i] = 0; t[12] = 0} 
{for (i=1; i<=9; i++) t[i]+=$i; t[12]+=$12} 
END {printf "average,";  for (i=1; i<=9; i++) printf t[i]/NR","; printf $10","; disk=sprintf("numfmt --to=iec %d",t[12]/NR); disk | getline fixed; close(disk); print fixed}
' tempaggr.txt | paste -s -d '' >> "metrics_agg_$cur_time.log"

# change perms
chmod 600 $"metrics_agg_$cur_time.log"

# delete temp file
rm tempaggr.txt

# type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size
# minimum,5759,1226,117,29,1548,1352,2047,0,183,/home/etern1ty/,21G
# maximum,5759,3941,2909,404,2240,4247,2047,1864,2047,/home/etern1ty/,34G
# average,5759,2959.48,882.047,146.156,1916.5,2363.7,2047,1053.88,993.125,/home/etern1ty/,22G