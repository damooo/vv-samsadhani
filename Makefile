SHELL = /bin/sh
SHMT = SHMT/prog

all: conv amara AS DP MT HTDOC Navya_Nyaya san sktgen trans SR
server: conv amara AS DP MT HTDOC Navya_Nyaya san sktgen trans SR SPV Geeta
translit: conv trans
sandhi_joiner: conv san
sandhi_spl: conv san_spl
sandhi_dit: conv san_dit
morph: conv morf
morph_san_spl: conv morph_sandhi_splitter
amarakosha: conv amara
SHMT: conv MT
dit: conv san_dit morph_sandhi_splitter HTDOC sktgen_dit trans
SPV: shishu
Geeta: sbg
#all: conv san dict MT amara HTDOC gen trans
#all_as: conv san dict MT amara HTDOC gen AS
#san_spltr 
#morf

conv: converters
	cd converters; ./configure; make

san: sandhi
	cd sandhi; ./configure

san_dit: sandhi
	cd sandhi; ./configure_tools

dict: dictionaries/MW-Eng-Skt dictionaries/Apte-Skt-Hnd
	cd dictionaries/MW-Eng-Skt; ./configure
	cd dictionaries/Apte-Skt-Hnd; ./configure

morf: morph
	cd morph; ./configure

san_spl:
	cd sandhi_splitter; ./configure; make

amara:
	cd amarakosha; ./configure; make

morph_sandhi_splitter:
	cd SHMT; ./configure_tools; make -f Makefile_tools

MT:
	cd SHMT; ./configure; make

DP:
	cd dhaatupaatha; ./configure;

SR:
	cd sankshepa_ramayanam; ./configure;

HTDOC:
	cd htdocs; ./configure

sktgen:
	cd skt_gen; ./configure
	cd skt_gen/compounds; ./configure; make

sktgen_dit:
	cd skt_gen; ./configure_tools

AS:
	cd ashtadhyayi_simulator; ./configure; cd june12; make

trans:
	cd transliteration; ./configure

Navya_Nyaya:
	cd NN; ./configure; cd CG; make; cd ../parser; make; cd ../segmenter; make

shishu:
	cd shishu; ./configure;

sbg:
	cd sbg; ./configure;

install_dit:
	cd sandhi; make install
	cd SHMT; make -f Makefile_tools install
	cd htdocs; make install
	cd skt_gen; make install
	cd transliteration; make install
	cp -pr ../scl/* SCLINSTALLDIR

install:
	rm -rf HTDOCSDIR
	rm -rf CGIDIR
	cd sandhi; make install
	#cd dictionaries/MW-Eng-Skt; make install
	#cd dictionaries/Apte-Skt-Hnd; make install
	cd SHMT; make install
	cd amarakosha; make install
	cd htdocs; make install
	cd skt_gen; make install
	cd transliteration; make install
	cd NN; make install
	cd ashtadhyayi_simulator/june12; make install
	cp -pr sankshepa_ramayanam HTDOCSDIR
	cp -pr dhaatupaatha HTDOCSDIR
	-@cp -pr shishu HTDOCSDIR
	-@cd sbg && make install
#	cp -pr ../scl/* SCLINSTALLDIR

install_NN:
	cd NN; make install

install_amba:
#This needs to be done only first time when I install the system on my new machine.
	ln -s HTDOCSDIR/*.* SCLINSTALLDIR/htdocs
	ln -s HTDOCSDIR/sandhi/* SCLINSTALLDIR/sandhi/web_interface
	ln -s HTDOCSDIR/dictionaries/MW-Eng-Skt/* SCLINSTALLDIR/dictionaries/MW-Eng-Skt/
	ln -s HTDOCSDIR/amarakosha/* SCLINSTALLDIR/amarakosha/web_interface
	ln -s HTDOCSDIR/SHMT/* SCLINSTALLDIR/SHMT/web_interface/
	ln -s HTDOCSDIR/sandhi_splitter/* SCLINSTALLDIR/SHMT/prog/sandhi_splitter/web_interface/
	ln -s HTDOCSDIR/morph/* SCLINSTALLDIR/SHMT/prog/morph/web_interface/
	ln -s HTDOCSDIR/skt_gen/noun/* SCLINSTALLDIR/skt_gen/noun/web_interface
	ln -s HTDOCSDIR/skt_gen/verb/* SCLINSTALLDIR/skt_gen/verb/web_interface
	ln -s HTDOCSDIR/skt_gen/waxXiwa/* SCLINSTALLDIR/skt_gen/waxXiwa/web_interface
	ln -s HTDOCSDIR/skt_gen/kqw/* SCLINSTALLDIR/skt_gen/kqw/web_interface
	ln -s CGIDIR/SHMT/software/webdot.pl SCLINSTALLDIR/SHMT/software/webdot.pl
	ln -s CGIDIR/sandhi/* SCLINSTALLDIR/sandhi/web_interface
	ln -s CGIDIR/dictionaries/MW-Eng-Skt/* SCLINSTALLDIR/dictionaries/MW-Eng-Skt/
	ln -s CGIDIR/amarakosha/* SCLINSTALLDIR/amarakosha/web_interface
	ln -s CGIDIR/SHMT/* SCLINSTALLDIR/SHMT/web_interface/
	ln -s CGIDIR/SHMT/prog/interface/* SCLINSTALLDIR/SHMT/prog/interface/
	ln -s CGIDIR/sandhi_splitter/* SCLINSTALLDIR/SHMT/prog/sandhi_splitter/web_interface/
	ln -s CGIDIR/morph/* SCLINSTALLDIR/SHMT/prog/morph/web_interface/
	ln -s CGIDIR/skt_gen/noun/* SCLINSTALLDIR/skt_gen/noun/web_interface
	ln -s CGIDIR/skt_gen/verb/* SCLINSTALLDIR/skt_gen/verb/web_interface
	ln -s CGIDIR/skt_gen/waxXiwa/* SCLINSTALLDIR/skt_gen/waxXiwa/web_interface
	ln -s CGIDIR/skt_gen/kqw/* SCLINSTALLDIR/skt_gen/kqw/web_interface

HTDOCS_SRC = htdocs/index.html htdocs/description.html htdocs/modelling-astadhyayi.html htdocs/projects.html htdocs/relevance-of-language-analysis.html htdocs/table.html htdocs/configure htdocs/Makefile htdocs/*.js htdocs/feedback.cgi htdocs/contributors.html css_files js_files imgs morph_bin htdocs/google*.html

CONV_SRC = converters/ir.lex converters/iscii2utf8.py converters/itrans-iscii.sh converters/itrans_ra.lex converters/kyoto_ra.lex converters/logical_itrans.lex converters/Makefile converters/ri.lex converters/ri_skt.lex converters/rm__between_vowels.lex converters/slp2wx.lex converters/utf82iscii.pl converters/utf82wx.sh converters/velthuis-wx.lex converters/wx2utf8.sh converters/configure converters/convert.pl converters/ir_skt.lex converters/wx-velthuis.lex converters/wx2utf8roman.lex converters/utf8roman2wx.lex converters/utfd2r.sh converters/wxHindi-utf8.sh converters/wx2utf8roman.lex converters/kyoto_ra.lex converters/ra_kyoto.lex converters/wx2slp.lex converters/add_vowel_sep.lex converters/ra_itrans.lex


SANDHI_SRC = sandhi/apavAxa_any.pl sandhi/callsandhi.pl sandhi/README sandhi/web_interface/sandhi.cgi sandhi/web_interface/sandhi.html sandhi/any_sandhi.pl sandhi/test_sandhi.pl sandhi/Makefile sandhi/configure sandhi/Makefile.stage2 sandhi/sandhi.pl sandhi/web_interface/info.html 

DICT_SRC = dictionaries/MW-Eng-Skt/index.html dictionaries/MW-Eng-Skt/xmlfiles dictionaries/MW-Eng-Skt/dic.css dictionaries/MW-Eng-Skt/xml_read.cgi dictionaries/MW-Eng-Skt/configure dictionaries/MW-Eng-Skt/Makefile dictionaries/Apte-Skt-Hnd

MORPH_SRC =$(SHMT)/morph/web_interface/run_morph.sh $(SHMT)/morph/web_interface/index.html $(SHMT)/morph/configure $(SHMT)/morph/web_interface/morph.cgi $(SHMT)/morph/web_interface/callmorph.pl $(SHMT)/morph/web_interface/contributors.html $(SHMT)/morph/bin/get_std_spelling.pl $(SHMT)/interface/modify_mo_fn.pl $(SHMT)/interface/modify_mo_for_display.pl $(SHMT)/morph/bin/get_std_spelling_fn.pl $(SHMT)/morph/Makefile.stage2 $(SHMT)/morph/web_interface/morph.html $(SHMT)/morph/Makefile_morph $(SHMT)/morph/web_interface/*.js

SAN_SPL_SRC = $(SHMT)/sandhi_splitter/web_interface/index.html $(SHMT)/sandhi_splitter/web_interface/sandhi_splitter.cgi $(SHMT)/sandhi_splitter/web_interface/description.html $(SHMT)/sandhi_splitter/configure $(SHMT)/sandhi_splitter/web_interface/callsandhi_splitter.pl $(SHMT)/sandhi_splitter/web_interface/add_tooltip.pl $(SHMT)/sandhi_splitter/web_interface/run1.sh $(SHMT)/sandhi_splitter/web_interface/pick_best.pl $(SHMT)/sandhi_splitter/web_interface/run.sh $(SHMT)/sandhi_splitter/web_interface/modify_mo_for_display.pl $(SHMT)/sandhi_splitter/sandhi_samaasa_splitting.cpp $(SHMT)/sandhi_splitter/samAsa_words.txt $(SHMT)/sandhi_splitter/sandhi_words.txt $(SHMT)/sandhi_splitter/samAsa_rules.txt $(SHMT)/sandhi_splitter/sandhi_rules.txt $(SHMT)/sandhi_splitter/word_freq.txt $(SHMT)/sandhi_splitter/all_rules.txt $(SHMT)/sandhi_splitter/Makefile.stage2 $(SHMT)/sandhi_splitter/split.sh $(SHMT)/sandhi_splitter/Makefile $(SHMT)/sandhi_splitter/Makefile_san_spl $(SHMT)/sandhi_splitter/web_interface/*.js

AMARA_SRC = amarakosha/get_all_rel.pl amarakosha/callrel.pl amarakosha/configure amarakosha/Makefile amarakosha/web_interface/interface.cgi amarakosha/web_interface/index.html amarakosha/web_interface/frame.html amarakosha/web_interface/starting.html amarakosha/web_interface/tail.html amarakosha/web_interface/banner.html amarakosha/web_interface/FAQ amarakosha/web_interface/contactUs.html amarakosha/DBM/create_dbm.pl amarakosha/DBM/create_rule_onto.pl amarakosha/DBM/rules_onto amarakosha/DBM/all_kANdas amarakosha/DBM/Makefile amarakosha/DBM/create_onto_dbm.pl amarakosha/DBM/create_dbm_key_value.pl amarakosha/showMsg.pl amarakosha/relations.pl amarakosha/shw_stem.pl amarakosha/Makefile.stage2 amarakosha/web_interface/about.html amarakosha/web_interface/amarakosha_knowledge_structure.pdf amarakosha/web_interface/logouoh.png amarakosha/amara.wx amarakosha/amara.utf8

GEN_SRC = skt_gen/Makefile skt_gen/configure skt_gen/waxXiwa/noun_format_html.pl skt_gen/waxXiwa/gen_noun.pl skt_gen/waxXiwa/web_interface/waxXiwa_gen.html skt_gen/waxXiwa/web_interface/waxXiwa_gen.cgi skt_gen/waxXiwa/web_interface/noun_gen.cgi skt_gen/waxXiwa/waxXiwa_avy_html.pl skt_gen/waxXiwa/gen_waxXiwa.pl skt_gen/waxXiwa/waxXiwa_ind_html.pl skt_gen/waxXiwa/waxXiwa_format_html.pl skt_gen/waxXiwa/web_interface/waxXiwa.html skt_gen/noun/noun_format_html.pl skt_gen/noun/pUraNa.pl skt_gen/noun/saMKyeya.pl skt_gen/noun/saMKyA.pl skt_gen/noun/sarvanAma.pl skt_gen/noun/gen_noun.pl skt_gen/noun/web_interface/noun_gen.html skt_gen/noun/web_interface/noun.html skt_gen/noun/web_interface/noun_gen.cgi skt_gen/verb/gen_verb.pl skt_gen/verb/verb_format_html.pl skt_gen/verb/web_interface/verb_gen.html skt_gen/verb/web_interface/verb_gen.cgi skt_gen/verb/web_interface/verb.html skt_gen/kqw/web_interface/kqw.html skt_gen/kqw/web_interface/kqw_gen.html skt_gen/kqw/web_interface/kqw_gen.cgi skt_gen/kqw/kqw_avy_html.pl skt_gen/kqw/gen_kqw.pl skt_gen/kqw/kqw_format_html.pl skt_gen/Makefile.stage2 skt_gen/skt_gen_server.sh skt_gen/client_gen.sh skt_gen/client_gen_file.sh skt_gen/skt_gen_server_start.pl skt_gen/skt_gen_server_stop.pl skt_gen/compounds

DATE = `date +"%d%b%Y"`

server_upload:
	tar -czf /tmp/a.tgz $(CONV_SRC) $(SANDHI_SRC) $(AMARA_SRC) $(HTDOCS_SRC) $(GEN_SRC) ashtadhyayi_simulator sankshepa_ramayanam shishu sbg transliteration dhaatupaatha NN Makefile configure SPEC COPYING README START start_servers.sh stop_servers.sh -T SHMT/MT_lst --exclude=_dit --exclude-backups --exclude=TRASH --exclude=OLD; mkdir /tmp/scl; cd /tmp/scl; tar -xzf /tmp/a.tgz; cd ../; tar -czf scl.tgz scl; rm a.tgz; rm -r /tmp/scl
	cp /tmp/scl$date.tgz scl_server$(DATE).tgz

distrib:
	tar -czf /tmp/a.tgz $(CONV_SRC) $(SANDHI_SRC) $(AMARA_SRC) $(HTDOCS_SRC) $(GEN_SRC) ashtadhyayi_simulator sankshepa_ramayanam transliteration dhaatupaatha NN Makefile configure SPEC COPYING README START start_servers.sh stop_servers.sh -T SHMT/MT_lst --exclude=_dit --exclude-backups --exclude=TRASH --exclude=OLD; mkdir /tmp/scl; cd /tmp/scl; tar -xzf /tmp/a.tgz; cd ../; tar -czf scl.tgz scl; rm a.tgz; rm -r /tmp/scl
	cp /tmp/scl.tgz scl$(DATE).tgz

#sankshepa_ramayanam 
distrib_dit:
	#tar -czf /tmp/a.tgz $(CONV_SRC) $(SANDHI_SRC) $(HTDOCS_SRC) $(GEN_SRC) transliteration Makefile configure my_spec.txt COPYING README -T SHMT/MT_tools_lst; mkdir /tmp/scl; cd /tmp/scl; tar -xzf /tmp/a.tgz; mv htdocs/index_dit.html htdocs/index.html; cd ../; tar -czf scl_dit.tgz scl; rm a.tgz; rm -r /tmp/scl
	tar -czf /tmp/a.tgz -T dit_lst; mkdir /tmp/scl; cd /tmp/scl; tar -xzf /tmp/a.tgz; mv htdocs/index_dit.html htdocs/index.html; cd ../; tar -czf scl_dit.tgz scl; rm a.tgz; rm -r /tmp/scl
	cp /tmp/scl_dit.tgz .  
distrib_conv:
	tar -czf converters.tgz $(CONV_SRC) COPYING

distrib_sandhi:
	tar -czf /tmp/a.tgz $(CONV_SRC) $(SANDHI_SRC) Makefile configure spec.txt README COPYING; mkdir /tmp/scl_san; cd /tmp/scl_san; tar -xzf /tmp/a.tgz; mv sandhi/Makefile.stage2 Makefile;cd ../;tar -czf scl_san.tgz scl_san; rm a.tgz;rm -r /tmp/scl_san
	cp /tmp/scl_san.tgz .

distrib_sandhi_splitter:
	tar -czf /tmp/a.tgz $(CONV_SRC) $(SAN_SPL_SRC) configure spec.txt README COPYING; mkdir /tmp/scl_san_spl; cd /tmp/scl_san_spl; tar -xzf /tmp/a.tgz;mv $(SHMT)/sandhi_splitter/Makefile_san_spl $(SHMT)/sandhi_splitter/Makefile; mv $(SHMT)/sandhi_splitter/Makefile.stage2 Makefile;cd ../;tar -czf scl_san_spl.tgz scl_san_spl; rm a.tgz; rm -r /tmp/scl_san_spl
	cp /tmp/scl_san_spl.tgz .

distrib_trans:
	tar -czf /tmp/a.tgz $(CONV_SRC) transliteration configure spec.txt README  COPYING; mkdir /tmp/scl_trans; cd /tmp/scl_trans; tar -xzf /tmp/a.tgz;mv transliteration/Makefile.stage2 Makefile;cd ../;tar -czf scl_trans.tgz scl_trans; rm a.tgz;
	rm -r /tmp/scl_trans
	cp /tmp/scl_trans.tgz .

distrib_amara:
	tar -czf /tmp/a.tgz $(CONV_SRC) $(AMARA_SRC) configure_amara SPEC/spec_amara.txt README_amarakosha  COPYING htdocs/jquery.tools.min.js; mkdir /tmp/scl_amara; cd /tmp/scl_amara; tar -xzf /tmp/a.tgz;mv amarakosha/Makefile.stage2 Makefile; mv htdocs/jquery.tools.min.js amarakosha/web_interface/js;cd ../; tar -czf scl_amara.tgz scl_amara; rm a.tgz; rm -r /tmp/scl_amara
	cp /tmp/scl_amara.tgz .

distrib_gen:
	tar -czf /tmp/a.tgz $(CONV_SRC) $(GEN_SRC) configure spec.txt README_morphgen  COPYING; mkdir /tmp/scl_gen; cd /tmp/scl_gen; tar -xzf /tmp/a.tgz;mv skt_gen/Makefile.stage2 Makefile;cd ../; tar -czf scl_gen.tgz scl_gen; rm a.tgz; rm -r /tmp/scl_gen
	cp /tmp/scl_gen.tgz .

distrib_ana:
	tar -czf /tmp/a.tgz $(CONV_SRC) $(MORPH_SRC) configure spec.txt README_morphana  COPYING; mkdir /tmp/scl_ana; cd /tmp/scl_ana; tar -xzf /tmp/a.tgz;mv $(SHMT)/morph/Makefile.stage2 Makefile;mv $(SHMT)/morph/Makefile_morph $(SHMT)/morph/Makefile;cd ../; tar -czf scl_ana.tgz scl_ana; rm a.tgz; rm -r /tmp/scl_ana
	cp /tmp/scl_ana.tgz .

debian_dit:
	tar -czf /tmp/a.tgz -T dit_lst spec_debian.txt debian_control
	mkdir /tmp/scl; cd /tmp/scl; tar -xzf /tmp/a.tgz; mv htdocs/index_dit.html htdocs/index.html; cp spec_debian.txt spec.txt; ./configure; make dit; 
	cd /tmp/scl/sandhi; make debian_install
	cd /tmp/scl/SHMT; make -f Makefile_tools debian_install
	cd /tmp/scl/htdocs; make debian_install
	cd /tmp/scl/skt_gen; make debian_install
	cd /tmp/scl/transliteration; make debian_install
	#mv /tmp/scl/sankshepa_ramayanam HTDOCSDIR
	mkdir /tmp/scl/scl_dit-1.0; cd /tmp/scl; mv debian_control scl_dit-1.0/control; mkdir scl_dit-1.0/DEBIAN; cp scl_dit-1.0/control scl_dit-1.0/DEBIAN; mv var scl_dit-1.0; mkdir -p scl_dit-1.0/usr/local/scl; mv usr/lib scl_dit-1.0/usr; rmdir usr; mv * scl_dit-1.0/usr/local/scl; fakeroot dpkg-deb --build scl_dit-1.0; mv scl_dit-1.0.deb /home/ambaji/SCL-distrib
	
debian:
	tar -czf /tmp/a.tgz $(CONV_SRC) $(SANDHI_SRC) $(DICT_SRC) $(AMARA_SRC) $(HTDOCS_SRC) $(GEN_SRC) ashtadhyayi_simulator sankshepa_ramayanam transliteration Makefile configure spec_debian.txt COPYING README -T SHMT/MT_lst --exclude=_dit debian_control
	mkdir /tmp/scl; cd /tmp/scl; tar -xzf /tmp/a.tgz; cp spec_debian.txt spec.txt; ./configure; make all; 
	cd /tmp/scl/sandhi; make debian_install
#	cd /tmp/scl/dictionaries/MW-Eng-Skt; make debian_install
#	cd /tmp/scl/dictionaries/Apte-Skt-Hnd; make debian_install
	cd /tmp/scl/SHMT; make debian_install
	cd /tmp/scl/amarakosha; make debian_install
	cd /tmp/scl/htdocs; make debian_install
	cd /tmp/scl/skt_gen; make debian_install
	cd /tmp/scl/transliteration; make debian_install
#	cd /tmp/scl/ashtadhyayi_simulator/june12; make debian_install
	mkdir /tmp/scl/scl-1.0; cd /tmp/scl; mv debian_control scl-1.0/control; mkdir scl-1.0/DEBIAN; cp scl-1.0/control scl-1.0/DEBIAN; mv var scl-1.0; mkdir -p scl-1.0/usr/local/scl; mv usr/lib scl-1.0/usr; rmdir usr; mv * scl-1.0/usr/local/scl; fakeroot dpkg-deb --build scl-1.0; mv scl-1.0.deb /home/ambaji/SCL-distrib
	
uninstall:
	rm -r HTDOCSDIR CGIDIR TFPATH
