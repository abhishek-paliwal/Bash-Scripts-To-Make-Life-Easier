import datetime
##################################################################################

##
html_output_file="_OUTPUT_01-mantra-print-logos-on-various-background-colors.html" ;
##
html_header="""<!DOCTYPE html><html><head><style>
.MyStyle {
    display: inline-block; 
    width: 300px; 
    padding-top: 15px;
    padding-bottom: 15px;
}
</style></head><body>""" ; 
##
html_footer=""" </body></html> """
##

##################################################################################
## Main function definition
##################################################################################
def print_html_page(url):
    f = open(html_output_file, "a") ;
    f.write("<hr style='height: 10px; background: black; '>");
    f.write ("<h3>Using this logo:</h3><div class='MyStyle' style='width: auto; background: black;'><center><img width='500px' src='" + url + "'</img></center></div><br><br>") ;
    ## We are choosing colors 60 numbers apart to keep the color choices manageable
    for r in range(0, 255, 60):
        for g in range(0, 255, 60):
            for b in range(0, 255, 60):
                f.write("<div class='MyStyle' style='background: rgb({}, {}, {});'><center><img width='80%' alt='Color is rgb({}, {}, {})' src='".format(r, g, b, r ,g , b) + url + "'</img></center></div>");
    f.write("<div class='MyStyle' style='background: rgb(255,255,255);'><center><img width='80%' src='" + url + "'</img></center></div>");
    f.close() ;
##################################################################################

## Image URLs to print html page for
url1="https://downloads.concepro.com/dropbox-public-files/logos/7-logos-clients/mantra-wide-logo-dark-10Kpx.png" ;
url2="https://downloads.concepro.com/dropbox-public-files/logos/7-logos-clients/mantra-wide-logo-dark-byline-white-10Kpx.png" ;
url3="https://downloads.concepro.com/dropbox-public-files/logos/7-logos-clients/mantra-wide-logo-light-10Kpx.png" ;
url4="https://downloads.concepro.com/dropbox-public-files/logos/7-logos-clients/mantra-wide-logo-light-byline-white.png" ;

## Actually printing to HTML file
f = open(html_output_file, "w")
f.write(html_header) ;
time_now = datetime.datetime.now() ;
f.write("<p>Page last updated: " + str(time_now) + "</p>")
f.write("<h1>Choose your favorite background color for any of the 4 Mantra logos</h1>") ;
f.close()
## Calling the main function for all urls
url_list=(url1, url2, url3, url4) ;
for my_url in url_list:
     print_html_page(my_url)
##
f = open(html_output_file, "a")
f.write(html_footer) ;
f.close()
