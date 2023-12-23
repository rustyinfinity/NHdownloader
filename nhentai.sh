#!/bin/bash

############### PREQUISTE ###############
CONFIG_PATH="./main.config"
source $CONFIG_PATH

if [ -z $DOWNLOAD_DIR ]
then
DOWNLOAD_DIR="."
fi

if [ -z $LINKS_PATH ]
then
touch "./links.txt"
fi

if [[ -z $FILENAMING ]];
then
FILENAMING="{id} TITLE"
fi


############### HEADERS ###############

header_1="accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/jxl,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7,image/jxl,image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8"
header_2="user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
header_3="referer: https://nhentai.net/"
header_4="cookie: cf_clearance=${cf_clearance}; csrftoken=${csrftoken}"
header_5="authority: nhentai.net"
h2r_header="referer: https://hentai2read.com/"

############### FUNCTIONS ###############

default_downloader(){
   #echo "${links[@]}"
   wget2  -t 2 -T 15 -P "./.temp" --header="$header_1" --header="$header_2"  "${links[@]}"
   echo "Downloaded !"
}

bulk_download_check(){
clear
echo -e "(1) Download Single File \n(2) Download in Bulk ( Make Sure you have ${LINKS_PATH} file! )"
echo -en "\n-> "
read download_choice

if [ $download_choice == 1 ]
then
   clear
   links=()
   mkdir -p "./.temp" && rm -rf ./.temp/*
   echo "Enter ID or URL"
   echo -en "\n-> "
   read input
   id=$(echo "$input" | grep -Eo '[0-9]*')
   $(echo $site_name) && worker
elif [ $download_choice == 2 ]
then
   clear
   bulk_download
else
   clear
   echo "ERROR: Please Choose a Valid Option!"
   exit
fi
}

bulk_download(){
totalLinks=$(cat ${LINKS_PATH} | sed '/^[[:space:]]*$/d' | wc -l)
if [ $totalLinks == 0 ]
then
clear
echo "ERROR: No Links in ${LINKS_PATH} exiting ..."
exit
fi
echo "Total Links Found: $totalLinks"
for (( m=1; m<=$totalLinks; m++ ));
do
   links=()
   mkdir -p "./.temp" && rm -rf ./.temp/*
   input=$(cat ${LINKS_PATH} | sed -n $m\p)
   id=$(echo $(cat ${LINKS_PATH} | sed -n $m\p) | grep -Eo '[0-9]*' | head -n 1)
   echo "Downloading ${id}"
   $(echo $site_name) && worker
done
}

#-O "./.temp/${i}.${ext}"


convert_cleanup(){
TITLE=$(echo "$html" | grep -o '<title>.*</title>' | sed 's/<title>//g' | sed 's/<\/title>//g' | sed 's/\///g')
FILENAMING=$(echo $FILENAMING  | sed "s/id/${id}/g" | sed "s/TITLE/${TITLE}/g" )
filename="$(echo ${FILENAMING}).cbz"
zip  "${DOWNLOAD_DIR}/${filename}"  ./.temp/* && rm -rf ./.temp
}

summary(){
echo "Title :- $(echo "$html" | grep -o '<title>.*</title>' | sed 's/<title>//g' | sed 's/<\/title>//g')" 
echo "Total Pages :- $total_pages"
echo "Hentai ID :- $id"
}

pages_error(){
if [ -z ${total_pages} ]
then
clear
echo "ERROR: TOTAL PAGES NULL! "
exit
fi
}
images_error(){
if [ -z ${image_link} ]
then
clear
echo "ERROR: IMAGE LINK NULL! "
exit
fi
}

Nhentai.net(){
if [ -z ${cf_clearance} ] && [ -z ${csrftoke} ]
then
clear
echo "ERROR: EMPTY cf_clearance & csrftoken in config File please add or try another Website!"
exit
fi
url="https://nhentai.net/g/$id/"
html=$(curl -s "$url" -H "${header_5}" -H "${header_1}" -H "${header_4}" -H "${header_3}" -H "${header_2}" )
total_pages=$(echo "$html" | grep -Eo '<span class="name">[0-9]*</span>' | grep -Eo '[0-9]*')
sub_link="${url}${i}/"
image_link=$(curl -s "${sub_link}" -H "${header_5}" -H "${header_1}" -H "${header_4}" -H "${header_3}" -H "${header_2}" | grep -Eo 'https://[a-zA-Z0-9?%-_]*/galleries/[0-9]*/[0-9]*.[a-z]*' )
pages_error
images_error
for (( i=1 ; i<="$total_pages" ; i++ ));
do
sub_link="${url}${i}/"
image_link=$(curl -s "${sub_link}" -H "${header_5}" -H "${header_1}" -H "${header_4}" -H "${header_3}" -H "${header_2}" | grep -Eo 'https://[a-zA-Z0-9?%-_]*/galleries/[0-9]*/[0-9]*.[a-z]*' )

links+=([$i]="${image_link}")
echo -n "#"
done
echo " "
}
Nhentai.to(){
url="https://nhentai.to/g/$id"
header_3="referer: https://nhentai.to/"
html=$(curl -s "$url" -H "${header_1}" -H "${header_2}" -H "${header_3}"  )
total_pages=$(echo "$html" | grep -Eo '<span class="name">[0-9]*</span>' | grep -Eo '[0-9]*')
pages_error
for (( i=1 ; i<="$total_pages" ; i++ ));
do
sub_link="${url}/${i}"
image_link=$(curl -s "${sub_link}"  -H "${header_1}" -H "${header_3}" -H "${header_2}" | grep -Eo 'https://[a-zA-Z0-9?%-_]*/galleries/[0-9]*/[0-9]*.[a-z]*' )

links+=([$i]="${image_link}")
echo -n "#"
done
echo " "
}

hentaifox(){
   url="https://hentaifox.com/gallery/$id/"
   header_3="referer: https://hentaifox.com/"
   html=$(curl -s "$url" -H "${header_2}" )
   total_pages=$(echo "$html" | grep -Eo 'Pages: [0-9]*' | sed 's/Pages: //g')
   pages_error
   for (( i=1 ; i<="$total_pages" ; i++ ));
   do
   image_url=$(curl -s "https://hentaifox.com/g/${id}/${i}/" -H "${header_2}" | grep -Eo 'data-src="https://.*[0-9]*\.[a-z]*"' | sed 's/data-src=//g' | sed 's/"//g')
   links+=(
      [$i]=${image_url}
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
   pages_error

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
   pages_error
   for (( i=1 ; i<=$total_pages ; i++ ));
   do
   link=$(curl -s $(echo "$sub_page_links" | sed -n $i\p ) | grep -Eo 'https://[a-zA-Z0-9?%-_]*/[a-zA-Z0-9]*/[0-9]*\.[a-z]*' )
   links+=([$i]=${link})
   echo -n "#"
   done
   echo " "
}

Pururin(){
   id=$(echo "${input}" | grep -Eo 'gallery/.[0-9]*' | sed 's/gallery\///g')
   url="https://pururin.to/gallery/$id"
   html=$(curl -s "${url}" -H "${header_1}" -H "${header_2}" -H "${header_3}" )
   total_pages=$(echo "$html" | grep -Eo '"numberOfPages">[0-9]*' | grep -Eo '[0-9]*')
   sub_page_links=$(echo "$html" | grep -Eo 'https://pururin.to/read/[a-zA-Z0-9?%-_/]*' | awk '!seen[$0]++' )
   pages_error
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
   pages_error
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
pages_error
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

############### WORKER ###############
worker(){
default_downloader && convert_cleanup && summary
}


############### NHLOGO ###############
logo(){
echo "CiAgXyAgXyBfICBfICAgIF8gICAgICAgICAgICAgICAgIF8gICAgICAgICAgICAgIF8gICAgICAgICAKIHwgXHwgfCB8fCB8X198IHxfX19fXyBfXyBfX18gXyB8IHxfX18gIF9fIF8gX198IHxfX18gXyBfIAogfCAuYCB8IF9fIC8gX2AgLyBfIFwgViAgViAvICcgXHwgLyBfIFwvIF9gIC8gX2AgLyAtXykgJ198CiB8X3xcX3xffHxfXF9fLF9cX19fL1xfL1xfL3xffHxffF9cX19fL1xfXyxfXF9fLF9cX19ffF98ICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAo="  | base64 -d 
}
############### INPUT ###############

choose_website(){
echo -e "(1) Nhentai.net
(2) Hentaifox.com
(3) E-Hentai.org ( Enter Full URL! )
(4) 3Hentai.net
(5) Pururin.to
(6) Asmhentai.com
(7) Hentai2read.com ( Enter Full URL! )
(8) Nhentai.to"
echo -en "\n-> "
read website
}

############### EXECUTION ###############
logo && choose_website

case "$website" in
    "1")
         site_name="Nhentai.net"
         bulk_download_check
        ;;
    "2")
         site_name="hentaifox"
         bulk_download_check
        ;;
    "3")
         site_name="e-hentai"
         bulk_download_check
        ;;
    "4")
         site_name="3Hentai"
         bulk_download_check
         ;;
   "5")
         site_name="Pururin"
         bulk_download_check
         ;;
   "6")
         site_name="Asmhentai"
         bulk_download_check
         ;;
   "7")
         site_name="Hentai2read"
         echo "I will fix it later :( [ Rest are Working! ]"
         ;;
   "8")
         site_name="Nhentai.to"
         bulk_download_check
         ;;
    *)
         clear
         echo "ERROR: Please choose a valid option ! "
         exit
        ;;
esac