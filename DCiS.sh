#!/usr/bin/bash

# masuk pada folder "data" yang terdapat kedua file "2019-Oct-sample.csv" dan "2019-Nov-sample.csv"
cd data/

# membuat gabungan data
csvstack 2019-Oct-sample.csv 2019-Nov-sample.csv > data_joined.csv
# menyeleksi kolom relevan dan memiliki tipe event 'purchase'
cat data_joined.csv | csvcut -C 1,9,10 | csvgrep -c "event_type" -m "purchase" > data_selected-filtered.csv
# melakukan splitting pada category_code untuk mengekstrak category dan product_name
cat data_selected-filtered.csv | csvcut -c "category_code" | sed 1d > category_code.csv
cat category_code.csv | awk -F '.' '{print $1}' | sed '1i\category' > category.csv
cat category_code.csv | awk -F '.' '{print $NF}' | sed  '1i\product_name' > product_name.csv
cat data_selected-filtered.csv | csvcut -C "category_code" | paste -d "," - category.csv product_name.csv > data_cleaned.csv
# validasi hasil
wc data_cleaned.csv
cat data_cleaned.csv | grep electronics | grep smartphone | awk -F ',' '{print $5}'| sort | uniq -c | sort -nr
