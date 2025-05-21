#!/usr/bin/bash
echo "please run with root user"
sudo apt install stardict
sudo apt install unrar
wget https://pdn.sharezilla.ir/d/software/StarDict.English.To.Farsi.hfarsi_p30download.com.rar

unrar e -r StarDict.English.To.Farsi.hfarsi_p30download.com.rar -pwww.p30download.com

sudo cp Hfarsi_p30download.com.ifo Hfarsi_p30download.com.idx.oft Hfarsi_p30download.com.idx Hfarsi_p30download.com.dict /usr/share/stardict/dic/stardict-dict/

