################################################################################
## Python program => Hindi to english transliterator.
## This program converts hindi to hinglish, as in transliteration.
####
## Run as > python3 THIS_PROGRAM_PATH
#### 
## CREATED ON: 2023-03-14
## CREATED BY: PALI
################################################################################
####
import os
## get user homepath dir
os_home = os.path.expanduser('~') ; 
####
filedir = os_home + '/Desktop/Y/' ; 
infilename= filedir + '00221_INPUT_FILE_FOR_HINDI_ENGLISH_TRANSLITERATION.txt' ; 
outfilename= filedir + '00221_OUTPUT_TRANSLITERATED_TEXT.csv' ; 
####
print('\n\n##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++') ; 
print ('>> IMPORTANT NOTE: This program needs this file containing hindi text. Make sure it is present. => ' + infilename) ;
print('##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n') ; 
################################################################################

mydict = {'अ' : 'a',
'आ' : 'aa',
'इ' : 'i',
'ई' : 'ee',
'उ' : 'u',
'ऊ' : 'oo',
'ए'  : 'e',
'ऐ' : 'ai',
'ओ' : 'o',
'औ' : 'au',
'ऍ' : 'ai',
'ऎ' : 'ae',
'ऑ' : 'o',
'ऒ' : 'o',
'अं' : 'an',
'अः' : 'ah',
'्' : '',
'ं' : 'n',
'ः' : 'h',
'ा' : 'a',
'ि' : 'i',
'ी' : 'ee',
'ू' : 'oo',
'ु' : 'u',
'े' : 'e',
'ै' : 'ai',
'ौ' : 'au',
'ो' : 'o',
'क' : 'ka',
'क्' : 'k',
'का' : 'kaa',
'कि' : 'ki',
'कू' : 'koo',
'कु' : 'ku',
'की' : 'kee',
'के' : 'ke',
'कै' : 'kai',
'को' : 'ko',
'कौ' : 'kau',
'कं' : 'kan',
'कः' : 'kah',
'ख' : 'kha',
'ख्' : 'kh',
'खा' : 'khaa',
'खि' : 'khi',
'खी' : 'khee',
'खु' : 'khu',
'खू' : 'khoo',
'खे' : 'khe',
'खै' : 'khai',
'खो' : 'kho',
'खौ' : 'khau',
'खं' : 'khan',
'खः' : 'khah',
'ग' : 'ga',
'ग्' : 'g',
'गा' : 'gaa',
'गि' : 'gi',
'गी' : 'gee',
'गु' : 'gu',
'गू' : 'goo',
'गे' : 'ge',
'गै' : 'gai',
'गो' : 'go',
'गौ' : 'gau',
'गं' : 'gan',
'गः' : 'gah',
'घ' : 'gha',
'घ्' : 'gh',
'घा' : 'ghaa',
'घि' : 'ghi',
'घी' : 'ghee',
'घु' : 'ghu',
'घू' : 'ghoo',
'घे' : 'ghe',
'घै' : 'ghai',
'घो' : 'gho',
'घौ' : 'ghau',
'घं' : 'ghan',
'घः' : 'ghah',
'च' : 'cha',
'चा' : 'chaa',
'च्' : 'ch',
'चि' : 'chi',
'ची' : 'chee',
'चु' : 'chu',
'चू' : 'choo',
'चे' : 'che',
'चै' : 'chai',
'चो' : 'cho',
'चौ' : 'chau',
'चौ' : 'chau',
'चौ' : 'chau',
'चं' : 'chan',
'चः' : 'chh',
'छ' : 'chha',
'छा' : 'chhaa',
'छि' : 'chhi',
'छी' : 'chhee',
'छु' : 'chhu',
'छू' : 'chhoo',
'छे' : 'chhe',
'छै' : 'chhai',
'छो' : 'chho',
'छौ' : 'chhau',
'छं' : 'chhan',
'छः' : 'chhah',
'छ्' : 'chh',
'ज' : 'ja',
'ज्' : 'j',
'जा' : 'jaa',
'जि' : 'ji',
'जी' : 'jee',
'जु' : 'ju',
'जू' : 'joo',
'जे' : 'je',
'जै' : 'jai',
'जो' : 'jo',
'जौ' : 'jau',
'जं' : 'jan',
'जः' : 'jah',
'झ' : 'jha',
'झा' : 'jhaa',
'झ्' : 'jh',
'झि' : 'jhi',
'झी' : 'jhee',
'झु' : 'jhu',
'झू' : 'jhoo',
'झे' : 'jhe',
'झै' : 'jhai',
'झो' : 'jho',
'झौ' : 'jhau',
'झं' : 'jhan',
'झः' : 'jhah',
'ट' : 'ta',
'टा' : 'taa',
'ट्' : 't',
'टि' : 'ti',
'टी' : 'tee',
'टु' : 'tu',
'टू' : 'too',
'टे' : 'te',
'टै' : 'tai',
'टं' : 'tan',
'टः' : 'tah',
'टो' : 'to',
'टौ' : 'tau',
'ठ' : 'tha',
'ठ्' : 'th',
'ठा' : 'thaa',
'ठि' : 'thi',
'ठी' : 'thee',
'ठु' : 'thu',
'ठू' : 'thoo',
'ठे' : 'the',
'ठै' : 'thai',
'ठो' : 'tho',
'ठौ' : 'thau',
'ठं' : 'than',
'ठः' : 'thah',
'ड' : 'da',
'ड्' : 'd',
'डा' : 'daa',
'डि' : 'di',
'डी' : 'dee',
'डु' : 'du',
'डू' : 'doo',
'डे' : 'de',
'डै' : 'dai',
'डो' : 'do',
'डौ' : 'dau',
'डं' : 'dan',
'डः' : 'dah',
'ढ' : 'dha',
'ढ्' : 'dh',
'ढा' : 'dhaa',
'ढि' : 'dhi',
'ढी' : 'dhee',
'ढु' : 'dhu',
'ढू' : 'dhoo',
'ढे' : 'dhe',
'ढै' : 'dhai',
'ढो' : 'dho',
'ढौ' : 'dhau',
'ढं' : 'dhan',
'ढः' : 'dhah',
'त' : 'ta',
'त्' : 't',
'ता' : 'taa',
'ती' : 'tee',
'ति' : 'ti',
'तु' : 'tu',
'तू' : 'too',
'ते' : 'te',
'तै' : 'tai',
'तो' : 'to',
'तौ' : 'tau',
'तं' : 'tan',
'तः' : 'tah',
'थ' : 'tha',
'थ्' : 'th',
'था' : 'thaa',
'थि' : 'thi',
'थी' : 'thee',
'थु' : 'thu',
'थू' : 'thoo',
'थे' : 'the',
'थै' : 'thai',
'थो' : 'tho',
'थौ' : 'thau',
'थं' : 'than',
'थः' : 'thah',
'द' : 'da',
'द्' : 'd',
'दा' : 'daa',
'दि' : 'di',
'दी' : 'dee',
'दु' : 'du',
'दू' : 'doo',
'दे' : 'de',
'दै' : 'dai',
'दो' : 'do',
'दौ' : 'dau',
'दं' : 'dan',
'दः' : 'dah',
'ध' : 'dh',
'ध्' : 'dha',
'धा' : 'dhaa',
'धि' : 'dhi',
'धी' : 'dhee',
'धु' : 'dhu',
'धू' : 'dhoo',
'धे' : 'dhe',
'धै' : 'dhai',
'धो' : 'dho',
'धौ' : 'dhau',
'धं' : 'dhan',
'धः' : 'dhah',
'न' : 'na',
'न्' : 'n',
'ना' : 'naa',
'नि' : 'ni',
'नी' : 'nee',
'नु' : 'nu',
'नू' : 'noo',
'ने' : 'ne',
'नै' : 'nai',
'नो' : 'no',
'नौ' : 'nau',
'नं' : 'nan',
'नः' : 'nah',
'प' : 'pa',
'प्' : 'p',
'पा' : 'paa',
'पि' : 'pi',
'पी' : 'pee',
'पु' : 'pu',
'पू' : 'poo',
'पे' : 'pe',
'पै' : 'pai',
'पो' : 'po',
'पौ' : 'pau',
'पं' : 'pan',
'पः' : 'pah',
'फ' : 'fa',
'फ्' : 'f',
'फा' : 'faa',
'फी' : 'fee',
'फि' : 'fi',
'फु' : 'fu',
'फू' : 'foo',
'फे' : 'fe',
'फै' : 'fai',
'फो' : 'fo',
'फौ' : 'fau',
'फं' : 'fan',
'फः' : 'fah',
'ब' : 'ba',
'ब्' : 'b',
'बा' : 'baa',
'बि' : 'bi',
'बी' : 'bee',
'बु' : 'bu',
'बू' : 'boo',
'बे' : 'be',
'बै' : 'bai',
'बो' : 'bo',
'बौ' : 'bau',
'बं' : 'ban',
'बः' : 'bah',
'भ' : 'bha',
'भ्' : 'bh',
'भा' : 'bhaa',
'भि' : 'bhi',
'भी' : 'bhee',
'भु' : 'bhu',
'भू' : 'bhoo',
'भे' : 'bhe',
'भै' : 'bhai',
'भो' : 'bho',
'भौ' : 'bhau',
'भं' : 'bhan',
'भः' : 'bhah',
'म' : 'ma',
'म्' : 'm',
'मा' : 'maa',
'मि' : 'mi',
'मी' : 'mee',
'मु' : 'mu',
'मू' : 'moo',
'मे' : 'me',
'मै' : 'mai',
'मो' : 'mo',
'मौ' : 'mau',
'मं' : 'man',
'मः' : 'mah',
'य' : 'ya',
'य्' : 'y',
'या' : 'yaa',
'यि' : 'yi',
'यी' : 'yee',
'यु' : 'yu',
'यू' : 'yoo',
'ये' : 'ye',
'यै' : 'yai',
'यो' : 'yo',
'यौ' : 'yau',
'यं' : 'yan',
'यः' : 'yah',
'र' : 'ra',
'र्' : 'r',
'रा' : 'raa',
'रि' : 'ri',
'री' : 'ree',
'रु' : 'ru',
'रू' : 'roo',
'रे' : 're',
'रै' : 'rai',
'रो' : 'ro',
'रौ' : 'rau',
'रं' : 'ran',
'रः' : 'rah',
'ल' : 'la',
'ल्' : 'l',
'ला' : 'laa',
'लि' : 'li',
'ली' : 'lee',
'लु' : 'lu',
'लू' : 'loo',
'ले' : 'le',
'लै' : 'lai',
'लो' : 'lo',
'लौ' : 'lau',
'लं' : 'lan',
'लः' : 'lah',
'व' : 'va',
'व्' : 'v',
'वा' : 'vaa',
'वि' : 'vi',
'वी' : 'vee',
'वु' : 'vu',
'वू' : 'voo',
'वे' : 've',
'वै' : 'vai',
'वो' : 'vo',
'वौ' : 'vau',
'वं' : 'van',
'वः' : 'vah',
'स' : 'sa',
'स्' : 's',
'सा' : 'saa',
'सि' : 'si',
'सी' : 'see',
'सु' : 'su',
'सू' : 'soo',
'से' : 'se',
'सै' : 'sai',
'सो' : 'so',
'सौ' : 'sau',
'सं' : 'san',
'सः' : 'sah',
'श' : 'sha',
'श्' : 'sh',
'शा' : 'shaa',
'शि' : 'shi',
'शी' : 'shee',
'शु' : 'shu',
'शू' : 'shoo',
'शे' : 'she',
'शै' : 'shai',
'शो' : 'sho',
'शौ' : 'shau',
'शं' : 'shan',
'शः' : 'shah',
'ष' : 'shha',
'ष्' : 'shh',
'षा' : 'shhaa',
'षि' : 'shhi',
'षी' : 'shhee',
'षु' : 'shhu',
'षू' : 'shhoo',
'षे' : 'shhe',
'षै' : 'shhai',
'षो' : 'shho',
'षौ' : 'shhau',
'षं' : 'shhan',
'षः' : 'shhah',
'ह' : 'ha',
'ह्' : 'h',
'हा' : 'haa',
'हि' : 'hi',
'ही' : 'hee',
'हु' : 'hu',
'हू' : 'hoo',
'हे' : 'he',
'है' : 'hai',
'हो' : 'ho',
'हौ' : 'hau',
'हं' : 'han',
'हः' : 'hah',
'क्ष' : 'ksha',
'त्र' : 'tra',
'ज्ञ' : 'gya',
'ळ' : 'li',
'ऌ' : 'lri',
'ऴ' : 'll',
'ॡ' : 'lree',
'ङ' : 'ada',
'ञ' : 'nia',
'ण' : 'na',
'ऩ' : 'n',
'ॐ' : 'oms',
'क़' : 'q',
'ऋ' : 'hri',
'ॠ' : 'hri',
'ऱ' : 'r',
'ड़' : 'ad',
'ढ़' : 'dh',
'य़' : 'y',
'ज़' : 'za',
'फ़' : 'f',
'ग़' : 'gh',
'कॉ': 'Ko',
'!' : '!',
'(' : '(',
')' : ')',
'+': '+',
'*': '*',	
':' : ':',
'?' : '?',
'_' : '_',	
' ' : ' ',
'-' : ' - ',
"'" : "'",
'.' : '.',
',' : ',',
'|' : '|',
'।' : '. ',
'़' : 'a',
'ँ' : 'n',
'ॉ' : 'a',
'ृ' : 'ri',
' ं' : 'm',
'0' : '0',
'1' : '1',
'2' : '2',
'3' : '3',
'4' : '4',
'5' : '5',
'6' : '6',
'7' : '7',
'8' : '8',
'9' : '9',
'१' : '1',
'२' : '2',
'३' : '3',
'४' : '4',
'५' : '5',
'६' : '6',
'७' : '7',
'८' : '8',
'९' : '9',
'०' : '0'
}

#print("Current Dict is: ", mydict)

################################################################################
def read_each_line_and_transliterate_to_hinglish (myline):
    ######################################
    ## split into words
    var_words = myline.split() ;
    print(var_words)
    #var_chars = [x for x in var] ; 
    #print (var_chars)
    ######################################
    ## create and append the list for words
    mylist1 = [] ## empty list of english characters
    for word in var_words:
        ## create a list of character for each word in word list
        var_chars1 = [x for x in word] ;
        print (word + ' = ' + " + ".join([str(i) for i in var_chars1])) ; 
        ## transliterate hindi char to english
        for c in var_chars1:
            try:
                tr_letter = mydict[c] ;
            except:
                tr_letter = c ;
            #print(tr_letter)   
            mylist1.append(tr_letter)
        ##
        mylist1.append(' ') ## insert space into list after every word
    ##
    ## finally join the whole list
    x="".join([str(i) for i in mylist1])
    ######################################
    #### step 1 = change some character-combinations to special words, bcoz we don't want to replace them.
    #### It's bcoz they appear at the beginning of the words.
    x = x.replace(' ae','XX1')
    x = x.replace(' au','XX2')
    x = x.replace(' ao','XX3')
    x = x.replace(' ai','XX4')
    ####
    #### step 2 = replace character combinations if appearing within words.
    x = x.replace('ae','e')
    x = x.replace('au','u')
    x = x.replace('ao','o')
    x = x.replace('ai','i')
    x = x.replace('ee','i')
    x = x.replace('a ',' ')
    x = x.replace('jania','gya') ## as in pragya
    x = x.replace('parag','prag') ## as in pragaya
    ####
    #### step 2 = finally put them back (from step 1).
    x = x.replace('XX1',' ae')
    x = x.replace('XX2',' au')
    x = x.replace('XX3',' ao')
    x = x.replace('XX4',' ai')
    ####
    transliterated_output = x ; 
    print('>> English Result for this line = ' + transliterated_output)
    return transliterated_output ;
################################################################################
################################################################################

##
with open(infilename) as file:
    lines = [line.rstrip() for line in file]
##########
f = open(outfilename, "w")
f.write('HINDI_LINE;ENGLISH_TRANSLITERATED\n') ;
f.close()
##
for line in lines:
    #print(line) ; 
    #line_s = line.split(';') ;
    myline = line ; 
    print('========')
    print(myline) ; 
    transliterated_output = read_each_line_and_transliterate_to_hinglish (myline)
    ## open a result file and write output to it
    f = open(outfilename, "a")
    f.write(myline + ';' + transliterated_output + '\n')
    f.close()
##########

#### Final message
print('##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++') ; 
print('SUMMARY: ') ; 
print('>> INPUT FILE  = ' + infilename) ; 
print('>> OUTPUT FILE = ' + outfilename) ; 
print('##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++') ; 