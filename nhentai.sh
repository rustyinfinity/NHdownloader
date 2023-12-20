#!/bin/bash

############### PREQUISTE ###############

CONFIG_PATH="./main.config"
source $CONFIG_PATH

if [ -z $DOWNLOAD_DIR ]
then
DOWNLOAD_DIR="./"
fi

############### INPUT ###############

echo "1) Nhentai
2) Hentaifox.com
3) E-Hentai.org (Enter Full URL !)
4) 3Hentai.net
5) Pururin.to
6) Asmhentai.com
7) Hentai2read.com (Enter Full URL !)"
echo -n "-> "
read website

if [ $website == 1 ]
then
echo "1) nhentai.net (Make Sure You Added cf_clearance and csrftoken in config file ! ie $CONFIG_PATH)
2) nhentai.to"

echo -n "-> "
read nhentai_domain
fi

echo "Enter ID or URL"
echo -n "-> "
read input

############### HEADERS ###############

header_1="accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/jxl,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7,image/jxl,image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8"
header_2="user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
header_3="referer: https://nhentai.net/"
header_4="cookie: cf_clearance=${cf_clearance}; csrftoken=${csrftoken}"
header_5="authority: nhentai.net"
h2r_header="referer: https://hentai2read.com/"

############### ID ###############

id=$(echo "$input" | grep -Eo '[0-9]*')

############### TEMP ###############

mkdir -p "./.temp" && rm -rf ./.temp/*

declare -a links

############### FUNCTIONS ###############

default_downloader(){
   #echo "${links[@]}"
   wget2  -t 2 -T 15 -P "./.temp" --header="$header_1" --header="$header_2"  "${links[@]}"
   echo "Downloaded !"
}

#-O "./.temp/${i}.${ext}"

convert_cleanup(){
zip -r "${DOWNLOAD_DIR}/${id}_${site_name}.cbz"  ./.temp/* && rm -rf ./.temp
}

summary(){
echo "Title :- $(echo "$html" | grep -o '<title>.*</title>' | sed 's/<title>//g' | sed 's/<\/title>//g')" 
echo "Total Pages :- $total_pages"
echo "Hentai ID :- $id"
}


nhentai(){

if [ $nhentai_domain == 1 ]
then
url="https://nhentai.net/g/$id/"
html=$(curl -s "$url" -H "${header_5}" -H "${header_1}" -H "${header_4}" -H "${header_3}" -H "${header_2}" )
total_pages=$(echo "$html" | grep -Eo '<span class="name">[0-9]*</span>' | grep -Eo '[0-9]*')
sub_link="${url}${i}/"
image_link=$(curl -s "${sub_link}" -H "${header_5}" -H "${header_1}" -H "${header_4}" -H "${header_3}" -H "${header_2}" | grep -Eo 'https://[a-zA-Z0-9?%-_]*/galleries/[0-9]*/[0-9]*.[a-z]*' )
for (( i=1 ; i<="$total_pages" ; i++ ));
do
sub_link="${url}${i}/"
image_link=$(curl -s "${sub_link}" -H "${header_5}" -H "${header_1}" -H "${header_4}" -H "${header_3}" -H "${header_2}" | grep -Eo 'https://[a-zA-Z0-9?%-_]*/galleries/[0-9]*/[0-9]*.[a-z]*' )

links+=([$i]="${image_link}")
echo -n "#"
done
echo " "

elif [ $nhentai_domain == 2 ]
then
url="https://nhentai.to/g/$id"
header_3="referer: https://nhentai.to/"
html=$(curl -s "$url" -H "${header_1}" -H "${header_2}" -H "${header_3}"  )
total_pages=$(echo "$html" | grep -Eo '<span class="name">[0-9]*</span>' | grep -Eo '[0-9]*')

for (( i=1 ; i<="$total_pages" ; i++ ));
do
sub_link="${url}/${i}"
image_link=$(curl -s "${sub_link}"  -H "${header_1}" -H "${header_3}" -H "${header_2}" | grep -Eo 'https://[a-zA-Z0-9?%-_]*/galleries/[0-9]*/[0-9]*.[a-z]*' )

links+=([$i]="${image_link}")
echo -n "#"
done
echo " "
else 
exit
fi


}

hentaifox(){
   url="https://hentaifox.com/gallery/$id/"
   header_3="referer: https://hentaifox.com/"
   html=$(curl -s "$url" -H "${header_1}" -H "${header_2}" -H "${header_3}" )
   total_pages=$(echo "$html" | grep -Eo 'Pages: [0-9]*' | sed 's/Pages: //g')
   image_domain=$(echo "$html" | grep -Eo 'https://[a-zA-Z0-9?%-_]*/[0-9]*/[0-9]*/[a-zA-Z0-9?%-_]*cover.jpg' | grep -Eo 'https://i.hentaifox.com/[0-9]*/[0-9]*')
   
   

   for (( i=1 ; i<="$total_pages" ; i++ ));
   do
   is_png=$(curl -s "$image_domain/$i.png" -H $header_1 -H $header_2 -H $header_3  | grep -Eo 'Not Found' | head -n 1)
   if [[ -z "$is_png" ]]; 
   then
   ext="png"
   else
   ext="jpg"
   fi
   links+=(
      [$i]="${image_domain}/${i}.${ext}"
   )
   echo -n "#"
   done
   echo " "
}

e-hentai(){
   url="$input"
   id=$(echo "$url" | grep -Eo 'g/[0-9]*/' | grep -Eo "[0-9]*" )
   html=$(curl  -s "$url")
   total_pages=$(echo "$html" | grep -Eo 'https://e-hentai.org/s/[a-zA-Z0-9?%-_]*/[a-zA-Z0-9?%-_]*"><img alt=' | sed 's/"><img alt=//g' | wc -l )
   sub_page_links=$(echo "$html" | grep -Eo 'https://e-hentai.org/s/[a-zA-Z0-9?%-_]*/[a-zA-Z0-9?%-_]*"><img alt=' | sed 's/"><img alt=//g' )
   
   

   for (( i=1 ; i<=$total_pages ; i++ ));
   do

   link=$(curl -s $(echo "$sub_page_links" | sed -n $i\p ) | grep -Eo 'https://[a-zA-Z0-9?%-_]*/h/[a-zA-Z0-9?%-_/]*.[a-z]*' | sed 's/"//g' )
   is_png=$(echo "$link" | grep -Eo "\.png" )

   if [[ -z $is_png ]]; then
   ext="jpg"
   else
   ext="png"
   fi
   
   links+=(
      [$i]="${link}","${i}.${ext}"
   )
   
   echo -n  "#"

   done
   echo " "


}

3Hentai(){
   id=$(echo "${id}" | tail -n 1)
   url="https://3hentai.net/d/$id"
   html=$(curl -s $url)
   sub_page_links=$(echo "$html" | grep -Eo 'https://3hentai.net/d/[0-9]*/[0-9]*')
   total_pages=$(echo "$html" | grep -Eo 'https://3hentai.net/d/[0-9]*/[0-9]*' | wc -l )


   for (( i=1 ; i<=$total_pages ; i++ ));
   do
   link=$(curl -s $(echo "$sub_page_links" | sed -n $i\p ) | grep -Eo 'https://[a-zA-Z0-9?%-_]*/[a-zA-Z0-9]*/[0-9]*\.[a-z]*' )
   is_png=$(echo "$link" | grep -Eo "\.png" )
   if [[ -z $is_png ]]; 
   then
   ext="jpg"
   else
   ext="png"
   fi

   links+=([$i]="$link")
   echo -n "#"
   done
   
   echo " "

}

Pururin(){
   url="https://pururin.to/gallery/$id"
   html=$(curl -s "${url}" -H "${header_1}" -H "${header_2}" -H "${header_3}" )
   total_pages=$(echo "$html" | grep -Eo '"numberOfPages">[0-9]*' | grep -Eo '[0-9]*')
   sub_page_links=$(echo "$html" | grep -Eo 'https://pururin.to/read/[a-zA-Z0-9?%-_/]*' | awk '!seen[$0]++' )

   for (( i=1 ; i<=$(echo "$sub_page_links" | wc -l ) ; i++ ));
   do
   link=$(curl -s $(echo "$sub_page_links" | sed -n $i\p ) | grep -Eo 'https://i.pururin.co/[0-9]*/[0-9]*.[a-z]*' | awk '!seen[$0]++' )
   links+=(
      [$i]="${link}"
   )
   echo -n "#"
   done
   echo " "
}

Asmhentai(){
   url="https://asmhentai.com/g/$id/"
   html=$(curl -s $url )
   total_pages=$(echo "$html" |  grep -Eo 'Pages: [0-9]*' | grep -Eo '[0-9]*')
   for (( i=1 ; i<=$total_pages ; i++ ));
   do
   image_link=$(curl -s $(echo "${url}${i}/" | sed 's/g/gallery/g') | grep -Eo "https://images.asmhentai.com/[0-9]*/[0-9]*/[a-z0-9?%-_]*" )
   links+=(
      [$i]="$image_link" 
   )
   echo -n "#"
   done
   echo " "

}

Hentai2read(){
url="$input"
html=$(curl -s $url)
id=$(echo "$url" | sed 's/https:\/\/hentai2read.com\///g' | sed 's/\///g' )
total_pages=$(echo "$html" | grep -Eo '[0-9]* pages' | grep -Eo '[0-9]*' )
for (( i=1 ; i<=$total_pages ; i++ ));
do
image_link=$(curl -s "${url}1/${i}/" | grep -Eo 'https://static.hentai.direct/hentai/[0-9]*/[0-9]*/[a-zA-Z0-9?%-_]*' )
links+=(
   [$i]="$image_link"
)
echo -n "#"
done

echo " "

wget2  -t 2 -T 15 -P "./.temp" --header="$header_1" --header="$header_2" --header="$h2r_header" "${links[@]}"
echo "Downloaded !"

}


############### EXECUTION ###############

if [ $website == 1 ]
then
site_name="nhentai"
nhentai
default_downloader
#echo "${links[@]}"
convert_cleanup
summary

elif [ $website == 2 ]
then
site_name="hentaifox"
hentaifox
default_downloader
convert_cleanup
summary

elif [ $website == 3 ]
then
site_name="e-hentai"
e-hentai
#echo "${links[@]}"
default_downloader
convert_cleanup
summary
elif [ $website == 4 ]
then
site_name="3Hentai"
3Hentai
default_downloader
convert_cleanup
summary
elif [ $website == 5 ]
then
site_name="Pururin"
Pururin
default_downloader
convert_cleanup
summary
elif [ $website == 6 ]
then
site_name="Asmhentai"
Asmhentai
default_downloader
convert_cleanup
summary
elif [ $website == 7 ] 
then
site_name="Hentai2read"
Hentai2read
convert_cleanup
summary
#Custom Download config !
else
exit
fi
