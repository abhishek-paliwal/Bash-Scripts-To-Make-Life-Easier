#!/bin/bash

#Link: https://api.cloudflare.com/#cloudflare-images-images-usage-statistics

################################################################################
function FUNC_GET_IMAGES_INFO_FROM_CLOUDFLARE_IMAGES () 
{
    curl -X GET "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/images/v1?page=1&per_page=100" \
    -H "X-Auth-Email:$CLOUDFLARE_EMAIL" \
    -H "X-Auth-Key:$API_KEY_CLOUDFLARE_PURGE" \
    -H "Content-Type: application/json"
}

function FUNC_GET_IMAGES_USAGE_STATISTICS () 
{
    curl -X GET "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/images/v1/stats" \
    -H "X-Auth-Email:$CLOUDFLARE_EMAIL" \
    -H "X-Auth-Key:$API_KEY_CLOUDFLARE_PURGE" \
    -H "Content-Type: application/json"
}

################################################################################


outFile="$DIR_Y/file.json" ;

## Getting images info and parsing json output
FUNC_GET_IMAGES_INFO_FROM_CLOUDFLARE_IMAGES ;
FUNC_GET_IMAGES_INFO_FROM_CLOUDFLARE_IMAGES > $outFile ;
jq '.result.images[].id , " " , .result.images[].filename' $outFile

FUNC_GET_IMAGES_USAGE_STATISTICS

