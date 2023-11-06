#!/bin/sh
echo "Enter Nhentai ID or URL"
read input
id=$(echo "$input" | grep -Eo '[0-9]*')
url="https://nhentai.to/g/$id"
mkdir -p "./.temp" && rm -rf ./.temp/*
html=$(curl -s "$url")
id=$(echo "$url" | grep -Eo '[0-9]*')
image_domain=$(echo "$html" |  grep -Eo 'https://[a-zA-Z0-9?%-_]*/galleries/[0-9]*/cover.[a-z]*' | grep -Eo 'https://[a-zA-Z0-9?%-_]*/galleries/[0-9]*' | head -n 1)
total_pages=$(echo "$html" | grep -Eo '<span class="name">[0-9]*</span>' | grep -Eo '[0-9]*')
header_1="accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/jxl,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
header_2="user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
header_3="referer: https://nhentai.to/"
for (( i=1 ; i<="$total_pages" ; i++ ))
do
is_png=$(curl -s -H $header_1 -H $header_2 -H $header_3 "$image_domain/$i.png" |  grep -Eo '403 Forbidden' | head -n 1)
if [[ -z "$is_png" ]]; then
ext="png"
else
ext="jpg"
fi
wget -P "./.temp/" --header="$header_1" --header="$header_2" --header="$header_3" "$image_domain/$i.$ext"
done
zip "$id.cbz" ./.temp/* && rm -rf ./.temp/*
echo "Title is $(echo "$html" | grep -o '<title>.*' | sed 's/<title>//g')"
echo "Total Pages $total_pages"
echo "Nhentai ID $id"
