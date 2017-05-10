all: main.gb

%.gb: %.o
	rgblink -o $@ -n $(@:.gb=.sym) -m $(@:.gb=.map) $^
	rgbfix -v $@

%.o: %.asm
	rgbasm -o $@ $^

clean:
	rm *.gb *.o

run: main.gb
	wine ~/Downloads/bgb\ \(1\)/bgb.exe $^
