#!/usr/bin/python

import subprocess
import sys
import re
import json
from indic_transliteration import sanscript

arguments = sys.argv[1:]
count = len(arguments)

# Given two words in WX format, this word produces their samhita form in WX form
# along with the sandhi detected and the sutras and prakriya used.
def sandhi_join2_wx(word1, word2):
    args = ["perl", "mysandhi.pl"]
    args.extend(["WX", "any", word1, word2])
    #print args
    result=subprocess.Popen(args, stderr=subprocess.PIPE, stdout=subprocess.PIPE).communicate()[0]
    output = [re.sub('^:', '', val) for val in result.split(",")]
    res=dict(zip(output[5:],output[0:5]))
    #print res
    return res

# Given a list of words/morphemes, this function will join them according to sandhi rules
# and give the final samhita word.
def sandhi_join(words, encoding):
    samhita = sanscript.transliterate(words[0], encoding, sanscript.WX)
    analysis = []
    for w in words[1:]:
        w = sanscript.transliterate(w, encoding, sanscript.WX)
        res = sandhi_join2_wx(samhita, w)
        samhita = res['saMhiwapaxam']
        analysis.append(res)
        #print samhita

    analysis_str = sanscript.transliterate(json.dumps(analysis), sanscript.WX, encoding)
    analysis = json.loads(analysis_str)
    #print analysis
    samhita = sanscript.transliterate(samhita, sanscript.WX, encoding)
    return {'words' : words, 'result' : samhita, 'analysis' : analysis }

encoding = sys.argv[1].upper()
encoding = eval('sanscript.' + encoding)
samhita = sandhi_join(sys.argv[2:], encoding)
print json.dumps(samhita, indent=4, ensure_ascii=False, separators=(',', ': '))
