import sys
import yaml 
import json 


############ JSON 

myfile_json = sys.argv[1] ;
print ('>>> FILE = ' + myfile_json)

with open(myfile_json,"r") as json_file:
    data = json.load(json_file)

## json_validate
print(data) ;

###############################
###############################
## Remove some unwanted elements from json
ELEMENTS_TO_DELETE_FROM_JSON=("@context", "@type", "name", "image", "description", "datePublished", "author", "video" ,"url") ;
##
JSON_FILE_WITH_DELETED_ELEMENTS = sys.argv[2] ; 
##
with open(JSON_FILE_WITH_DELETED_ELEMENTS, 'w') as dest_file:
    with open(myfile_json, 'r') as source_file:
        for line in source_file:
            #print(line.strip())
            element = json.loads(line.strip())
            ##
            for delete_this in ELEMENTS_TO_DELETE_FROM_JSON:    
                if delete_this in element:
                    del element[delete_this]
            ####
            print (""); print('+++++++++++++++ NEW JSON DATA +++++++++++++++++++') ; print (""); 
            print(json.dumps(element)) ;
            ####        
            dest_file.write(json.dumps(element))

#################################
#################################

############ YAML 
myfile_yaml = JSON_FILE_WITH_DELETED_ELEMENTS + '.yaml'
##
with open(JSON_FILE_WITH_DELETED_ELEMENTS,"r") as json_file:
    newdata = json.load(json_file)
    my_dict = newdata

## json data formatting and taking only relevant fields
def iterate_multidimensional(my_dict):
    for k,v in my_dict.items():
        if(isinstance(v,dict)):
            print();
            print(k+":::")
            iterate_multidimensional(v)
            continue
        print(k+": "+str(v))

iterate_multidimensional(my_dict)

my_dict1 = newdata['recipeIngredient']
print(my_dict1)
print('recipeIngredient:') ;
for x in my_dict1:
    #print('==> ' + x)
    x = x.replace('"','\"') ;
    x = x.replace(':',' //') ;
    lookforthis="!!"
    if lookforthis in x:
        print ( '  - recipeIngredientTitle: "' + x.replace('!!','') + '"' ) ;
        print ( '    recipeIngredientList: ')
    else:
        print ( '    - "' + x + '"') ;



#############
recipeInstructions = newdata['recipeInstructions']
#print(recipeInstructions)
print("////////////////////////////////////////////////") ;
print('recipeInstructions:') ;
for HowToSection in recipeInstructions:
    #iterate_multidimensional(HowToSection)
    nameOfSection = HowToSection['name']
    nameOfSection = nameOfSection.replace('"','\"')
    nameOfSection = nameOfSection.replace(":"," //")
    print('  - recipeInstructionsTitle: "' + nameOfSection + '"')
    print('    recipeInstructionsList: ')
    itemListElement = HowToSection['itemListElement']
    for HowToStep in itemListElement:
        #print(HowToStep) ; print() ;
        HowToStepText = HowToStep['text']
        HowToStepText = HowToStepText.replace('"','\"') ;
        HowToStepText = HowToStepText.replace(':',' //') ;
        print('    - "' + HowToStepText + '"');
        #print() ;

    


## DUMPING ALL JSON DATA TO YAML FILE
#data_yaml = yaml.dump({"prepTime" : newdata['prepTime'], "cookTime" : newdata['cookTime']})
data_yaml = yaml.dump(newdata)

## yaml data validate
yaml.safe_load(data_yaml)
##
f = open(myfile_yaml, "w")
f.write(data_yaml)
f.close()

## yaml2json_pretty
#print(json.dumps(yaml.safe_load(data_yaml), indent=2, sort_keys=False))

