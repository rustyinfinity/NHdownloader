# Hentai Downloader Bash
Its a bash script to download comic/hentai manga from supported websites and converts it into cbz format.
No bullshit or bloat just a simple bash script !

# Supported Websites !
Nhentai.to , Nhentai.net , Hentaifox.com ,  E-hentai.org , 3hentai.net , Pururin.to ,  Asmhentai.com , Hentai2read.com

# Example



https://github.com/rustyinfinity/nhentai-downloader/assets/115462641/cb67e6ce-cad4-494b-8119-9d779cb31caf





# Output

<img width="417" alt="Screenshot 2023-11-11 at 3 03 07 PM" src="https://github.com/rustyinfinity/nhentai-downloader/assets/115462641/9529e29c-e721-4bfb-81d7-ca365eabda00">


## Installation
First Download wget2 from your distro repo ! I added it because of its parallel downloading feature which makes downloading much faster than traditional wget and its also actively maintained ! 

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
git clone https://github.com/rustyinfinity/nhentai-downloader.git
```
```bash
chmod +x nhentai.sh
```

## Usage

Just enter your Website URL or  ID and it will download in the  directory specified by you in the config ! (default ./ ) 
Make Sure to enter url for the websites specified and not ID there !

For Nhentai.net you have to add cf_clearance and csrftoken to main.config file because of cloudflare :(
Rest all don't need anything and will download just fine !


## Contributing

✅ This is my first release of this code I will be obviously updating it and fixing it and adding nhentai (.com and .net) in future and bulk downloading !

✅ This is my second release of this code Fixed all above problems and also added more websites !

Bulk Downloading  and adding omegascans will be my next priority for the next release !

And If got any Ideas or Issues feel free to Pull a request !
I have not done alot of testing so there will be issues which I don't know pls report them if you find any  Thanks !

For support star the repo thanks !
