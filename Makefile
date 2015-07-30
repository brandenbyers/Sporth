#default: hash stacks func
#default: func
default: sporth

UGENS = basic metro tenv

OBJ += $(addprefix ugens/, $(addsuffix .o, $(UGENS)))

OBJ += func.o plumber.o stack.o parse.o hash.o

%.o: %.c
	gcc -g -c -Ih $<

ugens/%.o: ugens/%.c 
	gcc -g -Ih -c $< -o $@

sporth: sporth.c $(OBJ)
	gcc sporth.c -g -Ih -o $@ $(OBJ) -lsoundpipe -lsndfile -lm

clean: 
	rm -rf sporth $(OBJ)

#stacks: stacks.c sporth.h
#	gcc $< -o $@
#hash: hash.c
#	gcc hash.c -o hash
