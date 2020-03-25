##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
import sys
####
def usage():
    print('## USAGE: ' + sys.argv[0])
    HELP_TEXT = """
    ##############################################################################
    ## THIS PYTHON SCRIPT USES AI LDA ALGORITHM TO CLASSIFY MGGK POSTS.
    ##############################################################################
    """
    print(HELP_TEXT)
####
## Calling the usage function
## First checking if there are more than one argument on CLI .
print()
if (len(sys.argv) > 1) and (sys.argv[1] == "--help"):
    print('## USAGE HELP IS PRINTED BELOW. SCRIPT WILL EXIT AFTER THAT.')
    usage()
    ## EXITING IF ONLY USAGE IS NEEDED
    quit()
else:
    print('## USAGE HELP IS PRINTED BELOW. NORMAL PROGRAM RUN WILL CONTINE AFTER THAT.')
    usage()  # Printing normal help and continuing script run.
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
##################################################################################
import gensim
from gensim.utils import simple_preprocess
from gensim.parsing.preprocessing import STOPWORDS
from nltk.stem import WordNetLemmatizer, SnowballStemmer
from nltk.stem.porter import *
import numpy as np
np.random.seed(400)

##

import nltk
nltk.download('wordnet')

print(WordNetLemmatizer().lemmatize('went', pos = 'v')) # past tense to present tense

##

import pandas as pd
stemmer = SnowballStemmer("english")
original_words = ['caresses', 'flies', 'dies', 'mules', 'denied','died', 'agreed', 'owned',
           'humbled', 'sized','meeting', 'stating', 'siezing', 'itemization','sensational',
           'traditional', 'reference', 'colonizer','plotted']
singles = [stemmer.stem(plural) for plural in original_words]

pd.DataFrame(data={'original word':original_words, 'stemmed':singles })

##

'''
Write a function to perform the pre processing steps on the entire dataset
'''
def lemmatize_stemming(text):
    return stemmer.stem(WordNetLemmatizer().lemmatize(text, pos='v'))

# Tokenize and lemmatize
def preprocess(text):
    result=[]
    for token in gensim.utils.simple_preprocess(text) :
        if token not in gensim.parsing.preprocessing.STOPWORDS and len(token) > 3:
            result.append(lemmatize_stemming(token))

    return result

##


#####################################
#####################################
import frontmatter
import io
import os
from os.path import basename, splitext
import glob
import sys

#################################################################################
## WHERE ARE THE FILES TO MODIFY
MYHOME = os.environ['HOME'] ## GETTING THE ENVIRONMENT VALUE FOR HOME
ROOTDIR = MYHOME+"/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/"

## printing all filenames found in ROOTDIR
for filename in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    print(filename)
#################################################################################
d=[] ; ## empty list
# LOOPING THROUGH ALL MARKDOWN FILES
for fname in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    with io.open(fname, 'r') as f:
        # Parse file's front matter
        post = frontmatter.load(f)

        allPostData = post.content

        ## replacing some unnecessary characters and words with spaces
        allPostData = allPostData.replace("/", " ")
        allPostData = allPostData.replace(":", " ")
        allPostData = allPostData.replace(".", " ")
        allPostData = allPostData.replace("-", " ")
        allPostData = allPostData.replace("_", " ")
        allPostData = allPostData.replace("[", " ")
        allPostData = allPostData.replace("]", " ")
        allPostData = allPostData.replace("=", " ")
        allPostData = allPostData.replace("href", " ")
        allPostData = allPostData.replace("https", " ")
        allPostData = allPostData.replace("upload", " ")
        allPostData = allPostData.replace("span", " ")
        allPostData = allPostData.replace("widgettitle", " ")
        allPostData = allPostData.replace("width", " ")
        allPostData = allPostData.replace("recipe", " ")


        ##### DELETE UNNECESSARY WORDS APPEARING VERY FREQUENTLY ####
        words_to_delete = ['https','www','com','mygingergarlickitchen','anupama','paliwal','upload','content','recipe','itemprop','span','video','style']

        querywords = allPostData.split() ;

        allPostData_new  = [word for word in querywords if word.lower() not in words_to_delete]
        result_finalData = ' '.join(allPostData_new)
        #print result_finalData

        d.append(result_finalData) ;
#################################################################################

count=0
for doc in d:
    print("//////////////////////////////////////////////////////////////////")
    count=count+1
    print(doc)
    print("COUNT: " + str(count) )

processed_docs = []
for doc in d:
    processed_docs.append(preprocess(doc))

print(processed_docs)

'''
Creating dictionary
'''
dictionary = gensim.corpora.Dictionary(processed_docs)
print( 'TOTAL ELEMENTS IN DICTIONARY: ' + str(len(dictionary)) );

'''
Checking dictionary created
'''
count = 0
for k, v in dictionary.iteritems():
    print(k, v)
    count += 1
    if count > 20:
        break

##


'''
Create the Bag-of-words model for each document i.e for each document we create a dictionary reporting how many
words and how many times those words appear. Save this to 'bow_corpus'
'''
bow_corpus = [dictionary.doc2bow(doc) for doc in processed_docs]

'''
Train your lda model using gensim.models.LdaMulticore and save it to 'lda_model'
'''
# TODO
lda_model =  gensim.models.LdaMulticore(bow_corpus,
                                   num_topics = 80,
                                   id2word = dictionary,
                                   passes = 10,
                                   workers = 2)

'''
For each topic, we will explore the words occuring in that topic and its relative weight
'''
for idx, topic in lda_model.print_topics(-1):
    print("Topic: {} \nWords: {}".format(idx, topic ))
    print("\n")


unseen_document_to_check="Besan Ladoo Recipe | How to make Besan Ke Laddu (बेसन के लड्डू)Anupama Paliwal14-18 minutesLast Updated: Wed Oct 09, 2019 by Anupama Paliwal | 13 MIN READShare thisBesan Ladoo Recipe or Besan Ke Laddu is one of the most popular Indian desserts. These ladoos are so fragrant, delicious and have a melt-in-mouth texture. You can cook them during festivals and special celebrations at home for your loved ones.Go Directly to Recipebesan-ke-ladoo-recipe-my-ginger-garlic-kitchen-6.jpgBesan ladoos are usually made and served during festive occasions as prasad (offerings to God) in many temples. These easy to make healthy and gratifying ladoos are energy bombs. Have a ladoo or two for breakfast and you are set for the day. In Besan ladoo recipe, gram flour is roasted slowly in ghee and then combined with sugar and other flavorings, and afterwards molded into a ball shape.Besan Ladoo is made with very basic and minimal ingredients such as, gram flour (besan), sugar, and ghee. These ladoos taste amazing without any additional flavorings. But if you are into flavorings, then the addition of some cardamom powder and the touch of your favorite nuts (almonds/pistachios) is all you need to glorify this beautiful dessert.besan-ke-ladoo-recipe-my-ginger-garlic-kitchen-8.jpgEverywhere as we know, festivals and celebrations are imperfect without some sweets and snacks. This is the case in India too. We have a long list of our beloved desserts, and these dessert balls are one of the most favored amongst the ladoos. Some other popular ladoos are: coconut ladoo, motichur ladoo, rava ladoo, mawa ladoo, atta ladoo, moong dal ladoo, and gond (edible gum) ladoo.Besan ladoo has a special place in my heart. These are the ladoos I grew up eating as prasad almost every day. My grandmother used to make besan ladoos as prasad for offering to God. Those were the most amazing besan ladoos I ever tasted.Also, there was a temple near my home, where a ladoo seller used to sell this besan ladoo prasad. It was an untold agreement between the elder members of my family that whosoever visits this temple would return home with besan ladoo prasad. And almost every other day someone visited the temple and brought a packet full of these auspicious ladoos. So you can say my home was always full of besan ladoos. :)What is Ladoo?Ladoo, Laddu or laddoo is a name for a sphere-shaped Indian sweet. These ball-shaped sweet delights are one of its kind delicacies of Indian cuisine which are usually made during festivals & celebrations. Basic ladoos are made with some kind of flour, ghee, and sugar. Ladoo can be made with the addition of various ingredients like chopped nuts or dried raisins. But they are always shaped into round solid balls. Laddus are made with some kind of flour, fat (ghee/butter/oil), and sugar, along with other ingredients which vary by recipe. These ingredients include chopped nuts and raisins.besan-ke-ladoo-recipe-my-ginger-garlic-kitchen-1.jpgWhat is Besan ladoo or Besan Laddu?Besan ladoo, or Besan Ke Laddu is a round-shaped Indian dessert made of besan aka chickpea flour/gram flour, sugar, and ghee. Gram flour is known as besan in Hindi, and ladoo is a common name for any sphere shape sweet. Thus, these ladoos are an accurate translation of gram flour balls. How do you make Besan Ladoo?For making besan ladoo, besan is roasted in an ample amount of ghee (clarified butter) over low heat. This is roasted till it turns golden brown appearance, and has an aromatic nutty fragrance. This roasting time takes about 25 minutes. I know it sounds like a long time, but this is the only laborious task you need to do for making besan ladoo.Once the besan is roasted completely and turns light and fluffy, it is then kept aside for cooling slightly. After that, the powdered sugar, cardamom powder, and chopped almonds/pistachios/cashews are added to the warm mixture.Sugar and nuts are then mixed with the besan, and sweet round balls are then molded from this mixture. Ladoos are done! Further, you can decorate them with some almonds or pistachios and store them at a room temperature in an airtight container. Besan ladoos have a long shelf life.besan-ke-ladoo-recipe-my-ginger-garlic-kitchen-7.jpgWhen to make Besan Ladoo?There’s no particular occasion to relish this delectable delicacy. You can make them anytime you want to please your family or friends, or make them when you have sudden sweet cravings. These quick ladoos are best for family get-togethers, festivals, and celebrations. How to serve Besan Ladoo?Besan ladoo can be served as an after meal dessert with a luxurious meal of paneer curry, stuffed naan, rice and raita, or serve them as a side dish along with your favourite spicy savory festive snacks such as chakli, punjabi samosa, namak pare, poha, pakora, kachori, vada pav, khaman dhokla or palak patta chaat. You can also serve these as breakfast to your kids along with a glass of milk. They have a long shelf life, so you can pack them for your road trips and complement them with some mathri and namak pare.What are the ingredients for Besan Ladoo?For making homemade besan ladoo you will only need 5 basic ingredients. These ingredients are:    Besan (Gram Flour)    Ghee (Clarified Butter)    Powdered Sugar Or Boora    Cardamom Powder (Ilaichi Powder)    Chopped Nutsbesan-ke-ladoo-recipe-my-ginger-garlic-kitchen-4.jpgWhat type of gram flour is used for making besan ladoo?Traditional besan ladoo recipe requires a slightly thick coarse variety of besan which has a little coarse texture. We also call it mota besan in the Hindi language, which means thick gram flour in the English language. So it is best to use thick besan if you can easily get it locally. However, if you don’t find mota besan where you live, then you can use the regular fine besan. When using regular besan, you will get the melt-in-mouth texture without any crunch. You can still get the texture of perfect nutty besan ladoo with a little change if you are using regular besan.There are two ways you can use regular besan for besan ladoo:    Add water: After roasting besan, splash it with 1-2 tablespoons of water. The addition of water will puff up besan granules and you would get some nice texture and crunch in besan.    Add semolina (suji): To get a comparable coarse texture, you can also add 1 tablespoon of suji to besan. If you are planning to add suji, then add it to the besan when it is half done. This way you will get a nice nutty texture in besan ladoo.besan-ke-ladoo-recipe-my-ginger-garlic-kitchen-2.jpgWhat are some important tips and variations to make your best besan ladoo?Following are some tips and variations:    Always use the freshly bought gram flour for making besan ladoo. This is because it starts getting bitter after a few months of milling. So always check the manufacturing date before buying the besan for making besan ladoo.    Remember to roast besan flour at low heat and keep stirring continuously. This is very important because if you stop stirring besan, then there are chances that besan might get burnt from the bottom.     A lot of handwork is needed while slow roasting the besan. Keep in mind that roasting is the only tough part of the recipe, and it will take time. So you need to be patient. It would take about 20 to 25 minutes, but believe me, all the efforts are worth it.    The most important thing is to make sure that besan is roasted well. This is because roasting besan precisely is the key to fragrant and delightful ladoos. If you do not follow this step carefully then you either end up with raw tasting, or burnt tasting besan laddos.    You need to roast the besan until it changes its color and emits a nice aroma. If you over roast the besan then your ladoos will have burnt and bitter flavor.     Once the besan is roasted, it will change its color and you will be able to smell a nice aroma, and it will turn into a smooth paste. This is the time when you need to splash it with some water.    Adding an ample amount of ghee is the key to making the most aromatic and luscious ladoo. Use the best quality desi or pure ghee possible.      I have added 1 tablespoon of ghee when the besan was almost roasted. This is because the addition of 1 tablespoon ghee, in the end, brings out caramelized ghee flavors in ladoos and they taste richer.     After roasting, let the besan cool down for 10 minutes or until it is slightly warm.     Before adding sugar to roasted besan make sure it is slightly warm and not hot. If you add sugar to besan while besan is hot, then the sugar will melt and the mixture will become thin. And it would be tricky to shape ladoos with wet mixture.    For some reason if it is hard to mold besan mixture into ladoos, then you can keep the mixture in the refrigerator for 5-10 minutes. This refrigeration time will solidify the ghee in the mixture and you will easily be able to mold the balls out of it.     You can also add 1-2 tablespoons of toasted coconut to these ladoos. They add a nice crunch and taste.    Traditional ladoo is made with tagar/boora sugar (made with sugar syrup), but finding boora everywhere is not so easy. So simply replace the boora with store-bought powdered sugar.     For making powdered sugar at home, simply add your regular crystal sugar to a blending jar and powder it.    I added sliced almonds to my ladoos. You can add any other chopped nuts or you can simply omit to add any nuts to besan ladoo recipe.    I personally don’t like raisins in my besan ladoo, but if you like you can also add some raisins to the besan mixture along with sugar.    Halwai style ladoos sometimes have muskmelon seeds, so if you like, you can also add some toasted muskmelon seeds (kharbuje ke beej) to it.    I have added finely powdered sugar to this recipe, but if you want a slight crunch in besan ladoo, then add powdered sugar which has grains in it.Try this traditional besan ladoo recipe at home and relish its sweet flavours with your loved ones.besan-ke-ladoo-recipe-my-ginger-garlic-kitchen-3.jpgBesan Ladoo Recipe | How to make Besan Laddu [RECIPE]Besan Ladoo Recipe or Besan Laddu is one of the most popular Indian desserts. These ladoos are so fragrant, delicious and have a melt-in-mouth texture. You can cook them during festivals and special celebrations at home for your loved ones.♥ ♥ ♥ ♥ ♥ (Rating: 5 from 1 reviews)INGREDIENTSFor Besan ladoo:• 1 & 1/4 cups besan (gram flour)• 1/4 cup + 2 tablespoons + 1 tablespoon ghee (You can add more ghee, if the mixture feels dried)• 3/4 cup + 2 tablespoons powdered sugar or boora sugar/tagar (You can add more sugar, if you like)• 1/4 tsp cardamoms powder (hari ilaichi powder)• 2 tablespoons sliced almonds or cashews (optional)For Garnish:• Almonds or pistachios🕐 Prep time 	🕐 Cook time 	🕐 Total time10 minutes 	30 minutes 	40 minutes☶ Category 	♨ Cuisine 	☺ ServesDessert 	Indian 	10 LadoosNutrition Info: 198 calories // Servings: 1 LadooINSTRUCTIONS:How to make roast besan:    Heat 1/4 cup + 2 tablespoons ghee in a heavy bottom pan over low heat.    Add besan and stir well to combine the besan (gram flour) with ghee.    Roast over low heat and keep stirring continuously. At first, it would resemble to crumbs, and after 6-7 minutes it will form a clump.    Keep stirring besan on low heat, and after 18-20 minutes besan will turn slightly aromatic and it would also start changing its color to golden.    At this point add 1 tablespoon ghee and mix well.    After adding ghee, the mixture will turn into a smooth paste.    Roast for five more minutes. The mixture would now turn airy, light and fluffy.    Splash roasted besan with 1 tablespoon of water and mix well. Keep stirring for 2 minutes.    After 2 minutes the besan granules would puff up and you will have a grainy mixture.    Immediately turn off the heat and transfer roasted besan to the mixing bowl.    Keep aside and let it cool for 10 minutes or until slightly warm.How to make besan ladoo:    Once the mixture is warm and easy to touch, add the powdered sugar, chopped almonds, chopped cashews, and cardamom powder. (Do not add sugar to hot besan.)    Mix everything well together until the sugar, cardamom, and nuts are well combined. (At first, the mixture might seem a bit dry, so keep mixing it with your hand until it is greasy and well combined.)    When the mixture is greasy and good enough to hold a shape, take a small portion from the mixture and roll it into a smooth ball. (For making a round shape, roll and press the mixture between your palms.)    Repeat the same with the remaining dough. You can make about 8-10 ladoos with this mixture.    They might not look perfectly round at this point. So let them set for about 10 minutes and roll them again.    Top each ladoo with a slice of almond or sliced pistachios.    Store besan ladoo in an airtight container lined with a parchment paper. They stay fresh for up to 3-4 weeks at room temperature.NOTES:1. Traditional ladoo is made with tagar/boora sugar (made with sugar syrup), but finding boora everywhere is not so easy. So simply replace the boora with store-bought powdered sugar.2. Remember to roast besan flour at low heat and keep stirring continuously. This is very important because if you stop stirring besan, then there are chances that besan might get burnt from the bottom.3. I added sliced almonds to my ladoos. You can add any other chopped nuts or you can simply omit to add any nuts to besan ladoo recipe.4. I personally don’t like raisins in my besan ladoo, but if you like you can also add some raisins to the besan mixture along with sugar.5. Halwai (Confectioner) style ladoos sometimes have muskmelon seeds, so if you like, you can also add some toasted muskmelon seeds (kharbuje ke beej) to it.5. If the roasted ladoo mixture looks too dry, then add 1 tablespoon of melted ghee to it.6. If the roasted ladoo mixture looks too wet, then keep it in the refrigerator for 10 minutes. The mixture would harden and you would be able to roll ladoos.WATCH VIDEO BELOW: Besan Ladoo Recipe | How to make Besan Ke Laddu (बेसन के लड्डू)(Please wait for a couple of seconds for loading)Direct Video link: https://www.youtube.com/embed/1ZwKC75vh1E"

# Data preprocessing step for the unseen document
bow_vector = dictionary.doc2bow(preprocess(unseen_document_to_check))

for index, score in sorted(lda_model[bow_vector], key=lambda tup: -1*tup[1]):
    print("Score: {}\t Topic: {}".format(score, lda_model.print_topic(index, 5)))
