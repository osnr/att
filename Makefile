%.gb: %.o
	rgblink -o $@ $^
	rgbfix -v $@

%.o: %.asm
	rgbasm -o $@ $^

clean:
	rm *.gb *.o

run: bootstrap.gb
	wine ~/Downloads/bgb\ \(1\)/bgb.exe bootstrap.gb
