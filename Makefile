%.gb: %.o
	rgblink -o $@ -n $(@:.gb=.sym) -m $(@:.gb=.map) $^
	rgbfix -v $@

%.o: %.asm
	rgbasm -o $@ $^

clean:
	rm *.gb *.o

run: bootstrap.gb
	wine ~/Downloads/bgb\ \(1\)/bgb.exe bootstrap.gb
