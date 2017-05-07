%.gb: %.o
	rgblink -o $@ $^

%.o: %.asm
	rgbasm -o $@ $^

clean:
	rm *.gb *.o
