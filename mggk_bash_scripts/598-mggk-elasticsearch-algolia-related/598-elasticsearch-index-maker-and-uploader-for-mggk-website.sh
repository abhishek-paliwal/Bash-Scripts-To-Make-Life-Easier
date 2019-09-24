#!/bin/bash
##############################################################################
cat << EOF
  ##############################################################################
  ## This script creates a JSON index file from all the md files in hugo content
  directory and then pushes that mggk index json data to an elasticsearch
  ## cluster locally or remotely for indexing and searching.
  ##############################################################################
  ## REQUIREMENTS:
  ## THIS SCRIPT NEEDS NODE-NPM PACKAGE = hugo-elasticsearch.
  ## YOU CAN LEARN MORE ABOUT IT, AND DOWNLOAD IT FROM THE FOLLOWING URL:
  ## https://www.npmjs.com/package/hugo-elasticsearch
  ##############################################################################
  ## NOTE: Use a chrome extension named as 'Elasticsearch-Head' for playing
  ## with the indexed data.
  ##############################################################################
  ## CODED ON: Tuesday September 24, 2019
  ## CODED by: PALI
  ##############################################################################
EOF
##############################################################################

CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL" ;
OUTPUT_DIR="$HOME/Desktop/Y" ;

DATE_PREFIX="$(date '+%Y%m%d')"

## ELASTICSEARCH CLUSTER CONNECTION DETAILS
ELASTIC_HOST="vps.abhishekpaliwal.com"
PORT="9200"
INDEX_NAME="mggksiteallcontent" ;
TYPE="type"
ELASTIC_JSON_INDEX_FILENAME="$DATE_PREFIX-elasticsearch-mggksiteallcontent-index.json" ;

##############################################################################
cd $OUTPUT_DIR ;
echo; echo ">> CURRENT PWD = $(pwd)" ;

##############################################################################
## STEP 0: MAKE SURE THAT ELASTIC SEARCH IS RUNNING LOCALLY (WITH/WITHOUT) DOCKER
#### We are using docker in our case (so run the following two commands to run
#### elasticsearch instance on docker)
##############################################################################
# docker pull docker.elastic.co/elasticsearch/elasticsearch:7.3.2
# docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.3.2
## OR IF NEEDED, ALSO RUN KIBANA ON DOCKER (UNCOMMENT IF NEEDED)
#docker run --link ELASTICSEARCH_CONTAINER_NAME_OR_ID:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:7.3.2

echo;
echo "====> NOTE: Make sure that Elasticsearch is runnnig locally OR remotely, by going to http://$ELASTIC_HOST:$PORT/" ;

##############################################################################
##############################################################################
## STEP 1: CREATING the JSON DATA FROM RAW MARKDOWN FILESFOR INDEXING LATER TO ELASTIC SEARCH
##############################################################################

echo;
echo "RUNNING STEP 1 => CREATING the JSON DATA FROM RAW MARKDOWN FILESFOR INDEXING LATER TO ELASTIC SEARCH";

hugo-elasticsearch --input "$CONTENT_DIR/content/**/*.md" --output "$OUTPUT_DIR/$ELASTIC_JSON_INDEX_FILENAME" --language "yaml" --delimiter "---" --index-name "$INDEX_NAME"

##############################################################################
## STEP 2: Pushing the JSON DATA TO LOCALLY RUNNING ELASTIC SEARCH FOR INDEXING
##############################################################################
echo "RUNNING STEP 2 => Deleting the existing Index on HOST machine and then Pushing the JSON DATA TO the cluster RUNNING ELASTIC SEARCH FOR INDEXING";

## Deleting existing index
curl -X DELETE "$ELASTIC_HOST:$PORT/$INDEX_NAME" ;
echo ">> Existing index (= $INDEX_NAME) deleted on $ELASTIC_HOST " ;
echo; echo;

## ADDING ALL JSON DATA IN BULK. IT WILL RECREATE THE INDEX.
echo ">> ADDING ALL JSON DATA IN BULK. IT WILL RECREATE THE INDEX.";
echo; echo;

curl \
  -H "Content-Type: application/x-ndjson" \
  -XPOST "$ELASTIC_HOST:$PORT/$INDEX_NAME/$TYPE/_bulk" \
  --data-binary "@$OUTPUT_DIR/$ELASTIC_JSON_INDEX_FILENAME"

###############################################################################
echo; echo;
echo "====> ELASTICSEARCH INDEXING IS DONE AND ALL JSON DATA HAS BEEN PUSHED. ALL DONE! PROGRAM COMPLETED <====";
echo;
echo "IMPORTANT NOTE: To play with the resulting elasticsearch index and ranking data residing on any elasticsearch server, you can install and use a Google Chrome extension 'Elasticsearch Head' and play with the indexed data and search." ;
echo;
echo ">> OPTIONAL // CHECK THIS PAGE IN BROWER = http://$ELASTIC_HOST:$PORT/" ;
