KICK_ASSEMBLER_URL := http://www.theweb.dk/KickAssembler/KickAssembler.zip

.PHONY: bootstrap
bootstrap: vendor/KickAssembler/KickAss.jar vendor/64spec


.PHONY: clean
clean:
	-rm -rf .asminfo.txt
	-rm -rf *.sym
	-rm -rf .source.txt
	-rm -rf *.prg
	-rm -rf *.vs
	-rm -rf **/.asminfo.txt
	-rm -rf **/*.sym
	-rm -rf **/.source.txt
	-rm -rf **/*.prg
	-rm -rf **/*.vs


.PHONY: clean-deps
clean-deps:
	-rm -rf vendor/*
	touch vendor/.gitkeep

# vendor/64spec:

vendor/KickAssembler:
	-mkdir $@

vendor/KickAssembler.zip: vendor
	curl -L $(KICK_ASSEMBLER_URL) -o $@

vendor/KickAssembler/KickAss.jar: vendor/KickAssembler vendor/KickAssembler.zip
	unzip -o vendor/KickAssembler.zip -d $<

vendor/64spec:
	git clone https://github.com/64bites/64spec.git $@

vendor/64spec/6502_tester: vendor/64spec
	pushd $<; make; popd
