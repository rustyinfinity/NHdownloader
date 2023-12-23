# NHdownloader Bash
Its a bash script to download comic/hentai manga from supported websites and converts it into cbz format.
No bullshit or bloat just a simple bash script !

# Supported Websites !
Nhentai.net , Nhentai.to , Hentaifox.com ,  E-hentai.org , 3hentai.net , Pururin.to ,  Asmhentai.com , Hentai2read.com

#



<img width="789" alt="Screenshot 2023-12-21 at 4 27 17 AM" src="https://github.com/rustyinfinity/nhentai-downloader/assets/115462641/02e6845c-f0c4-4b49-93e0-120e825a229a">




# Default Output
<img width="735" alt="Screenshot 2023-12-23 at 1 17 18 PM" src="https://github.com/rustyinfinity/nhentai-downloader/assets/115462641/25dfb5d2-dc4a-4cde-9f76-6188bd86eb37">



## Installation

Make Sure you have these installed
```bash
zip grep curl wget2
```

Download wget2 from your distro repo ! I added it because of its parallel downloading feature which makes downloading much faster than traditional wget and its also actively maintained ! 

For Arch
Download from AUR "https://aur.archlinux.org/packages/wget2"
```bash
yay -S wget2
```
For Fedora
```bash
sudo dnf install wget2
```
For Ubuntu
```
sudo apt install wget2
```

or Build it Yourself from https://gitlab.com/gnuwget/wget2


# Secondly clone repo and make it an executable !

```bash
[git clone https://github.com/rustyinfinity/nhentai-downloader.git](https://github.com/rustyinfinity/NHdownloader.git)
```
```bash
chmod +x NHdownloader.sh
```

## Usage

Just enter your Website URL or  ID and it will download in the  directory specified by you in the config ! (default ./ ) 
Make Sure to enter url for the websites specified and not ID there !

If you want to bulk Download enter Links to links.txt file and add its path to config file 

For Nhentai.net you have to add cf_clearance and csrftoken to main.config file because of cloudflare :(
Rest all don't need anything and will download just fine !


## Contributing

✅ This is my first release of this code I will be obviously updating it and fixing it and adding nhentai (.com and .net) in future and bulk downloading !

✅ This is my second release of this code Fixed all above problems and also added more websites !

✅ Added Bulk Downloading  
 
Adding omegascans and Manhawa websites will be my next priority for the next release ! with parallel downloading !

And If got any Ideas or Issues feel free to Pull a request !
I have not done alot of testing so there will be issues which I don't know pls report them if you find any  Thanks !

For support star the repo thanks !
