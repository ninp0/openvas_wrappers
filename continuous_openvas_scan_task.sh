#!/bin/bash
username=$1
password=$2
scan_task=$3
output_dir=$4

omp -u $username -w $password -S $scan_task

scan_status=$(omp -u $username -w $password -G | grep $scan_task | awk {'print $2}')
while [[ $scan_status != 'Done' ]]; do
  scan_status=$(omp -u $username -w $password -G | grep $scan_task | awk {'print $2}')
  scan_status_detail=$(omp -u $username -w $password -G | grep $scan_task)
  echo $scan_status_detail
  sleep 180 # sleep 3 mins
done

last_report_id=$(omp -u $username -w $password -G $scan_task --details | tail -n 1 | awk '{print $1}')

# Generate HTML Report
omp -u $username -w $password -R $last_report_id -f 6c248850-1f62-11e1-b082-406186ea4fc5 > $output_dir/latest_report.html
