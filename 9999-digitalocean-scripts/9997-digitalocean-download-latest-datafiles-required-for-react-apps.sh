#/bin/bash
## This program downloads files from listed urls (on digitalocean server)

################################################################################
outDir1="/var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs/data-reactapps/mggk" ; 
mkdir -p "$outDir1" ; ## make dir (if does not exist)
## Download all files ...
######
url1="http://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_ImagesUrlsWPcontentUploads.txt" ;
url2="http://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_AllValidSiteUrls.txt" ; 
url3="http://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_FilesUrlsWPcontent.txt" ;
url4="http://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_AllValidRecipesUrls.txt" ; 
url5="http://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_AllValidNONRecipesUrls.txt" ;   
wget "$url1" -O $outDir1/$(basename $url1) ;
wget "$url2" -O $outDir1/$(basename $url2) ;
wget "$url3" -O $outDir1/$(basename $url3) ;
wget "$url4" -O $outDir1/$(basename $url4) ;
wget "$url5" -O $outDir1/$(basename $url5) ;
################################################################################
