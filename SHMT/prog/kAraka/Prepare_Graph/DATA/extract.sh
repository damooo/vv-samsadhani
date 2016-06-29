grep xvi1 Master_verb_data | cut -f1 > xvikarmaka_XAwu_list1
grep xvi2 Master_verb_data | cut -f1 > xvikarmaka_XAwu_list2
grep sakarmaka Master_verb_data | cut -f1 > sakarmaka_XAwu_list
grep '	akarmaka' Master_verb_data | cut -f1 > akarmaka_XAwu_list

grep gawi Master_verb_data | grep sakarmaka | cut -f1 > gawyarWa_XAwu_list
grep buxXi Master_verb_data | grep sakarmaka | cut -f1 > buxXyarWa_XAwu_list
grep Sabxakarma Master_verb_data | grep sakarmaka | cut -f1 > Sabxakarma_XAwu_list
grep prawyavAsAnArWa Master_verb_data | grep sakarmaka | cut -f1 > prawyavasAnArWa_XAwu_list

grep vAkyakarma Master_verb_data | cut -f1 > vAkyakarma_XAwu_list
grep Axikarma Master_verb_data | cut -f1 > Axikarma_XAwu_list
grep karwqsamAnAXikaraNa Master_verb_data | cut -f1 > karwqsamAnAXikaraNa_XAwu_list
grep karmasamAnAXikaraNa Master_verb_data | cut -f1 > karmasamAnAXikaraNa_XAwu_list

grep '	SliR' Master_verb_data | cut -f1 > SliR_Axi_list
grep '	Sak' Master_verb_data | cut -f1 > SakAxi_list
