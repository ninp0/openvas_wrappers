#!/bin/bash
ca_cert_path=$1
client_cert_path=$2
client_key_path=$3
scan_task=$4
output_dir=$5

omp --use-certs \
    --client-ca-cert $ca_cert_path \
    --client-cert $client_cert_path \
    --client-key $client_key_path \
    -S $scan_task

scan_status=$(omp --use-certs --client-ca-cert $ca_cert_path --client-cert $client_cert_path --client-key $client_key_path -G | grep $scan_task | awk {'print $2}')
while [[ $scan_status != 'Done' ]]; do
  scan_status=$(omp --use-certs --client-ca-cert $ca_cert_path --client-cert $client_cert_path --client-key $client_key_path -G | grep $scan_task | awk {'print $2}')
  scan_status_detail=$(omp --use-certs --client-ca-cert $ca_cert_path --client-cert $client_cert_path --client-key $client_key_path -G | grep $scan_task)
  echo $scan_status_detail
  sleep 180 # sleep 3 mins
done

last_report_id=$(omp --use-certs --client-ca-cert $ca_cert_path --client-cert $client_cert_path --client-key $client_key_path -G $scan_task --details | tail -n 1 | awk '{print $1}')

# Generate HTML Report
omp --use-certs \
    --client-ca-cert $ca_cert_path \
    --client-cert $client_cert_path \
    --client-key $client_key_path \
    -R $last_report_id \
    -f 6c248850-1f62-11e1-b082-406186ea4fc5 > $output_dir/latest_report.html

# Generate CSV Results Report
omp --use-certs \
    --client-ca-cert $ca_cert_path \
    --client-cert $client_cert_path \
    --client-key $client_key_path \
    -R $last_report_id \
    -f c1645568-627a-11e3-a660-406186ea4fc5 > $output_dir/latest_results.csv
