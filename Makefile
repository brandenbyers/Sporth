#default: hash stacks func
#default: func
default: sporth

MASTER_MAKEFILE=1

CFLAGS += -O3 -fPIC -L./ -I ./ -Wall

ifdef DEBUG_MODE
CFLAGS += -DDEBUG_MODE -DPOLY_DEBUG
endif

UGENS = \
allpass \
atone \
autowah \
bal \
basic \
biscale \
bitcrush \
blsaw \
blsquare \
bltriangle \
butbp \
butbr \
buthp \
butlp \
clip \
comb \
conv \
count \
dcblock \
delay \
diskin \
dist \
dmetro \
drip \
dtrig \
dust \
expon \
f \
fm \
gbuzz \
gen_file \
gen_line \
gen_padsynth \
gen_sine \
gen_sinesum \
gen_vals \
in \
jcrev \
jitter \
line \
ling \
loadfile \
maygate \
maytrig \
metro \
mincer \
mode \
moogladder \
noise \
nsmp \
osc \
oscmorph \
p \
pan \
phasor \
pinknoise \
pluck \
poly \
port \
prop \
randh \
randi \
reverse \
revsc \
rpt \
rms \
samphold \
scale \
streson \
switch \
t \
tabread \
tadsr \
tblrec \
tenv \
tenv2 \
tenvx \
thresh \
tin \
tick \
tog \
tone \
tphasor \
trand \
tseq \
vdelay \
zeros \
zitarev

include ugens/ling/Makefile
include ugens/poly/Makefile

BIN += sporth examples/parse examples/user_function util/jack_wrapper util/val \
	  util/float2bin util/jacksporth


OBJ += $(addprefix ugens/, $(addsuffix .o, $(UGENS)))

OBJ += func.o plumber.o stack.o parse.o hash.o

SPORTHLIBS = libsporth.a



ifdef BUILD_DYNAMIC
SPORTHLIBS += libsporth_dyn.so
endif

%.o: %.c h/ugens.h
	$(CC) $(CFLAGS) -g -c -Ih $< -o $@

ugens/%.o: ugens/%.c
	$(CC) $(CFLAGS) -g -Ih -c $< -o $@

util/jack_wrapper: util/jack_wrapper.c
	$(CC) $< -ljack -lsoundpipe -lsndfile -o jack_wrapper -lm

val: util/val

util/val: util/val.c
	$(CC) $< -o $@

float2bin: util/float2bin

util/float2bin: util/float2bin.c
	$(CC) $< -o $@

jacksporth: util/jacksporth
util/jacksporth: util/jacksporth.c libsporth.a
	$(CC) $< -L. -lsporth -lsoundpipe -ljack -lsndfile -lm -o $@

sporth: sporth.c $(OBJ) h/ugens.h
	$(CC) sporth.c $(CFLAGS) -g -Ih -o $@ $(OBJ) -lsoundpipe -lsndfile -lm

libsporth_dyn.so: $(OBJ)
	ld -shared -fPIC -o $@ $(OBJ)

libsporth.a: $(OBJ) tmp.h
	ar rcs libsporth.a $(OBJ)

tmp.h: $(OBJ)
	sh util/header_gen.sh

examples/parse: examples/parse.c libsporth.a h/ugens.h
	gcc $< $(CFLAGS) -g -Ih -o $@ libsporth.a -lsoundpipe -lsndfile -lm

examples/user_function: examples/user_function.c libsporth.a h/ugens.h
	gcc $< $(CFLAGS) -g -Ih -o $@ libsporth.a -lsoundpipe -lsndfile -lm

include util/luasporth/Makefile

install: $(SPORTHLIBS) sporth tmp.h
	install sporth /usr/local/bin
	install tmp.h /usr/local/include/sporth.h
	install $(SPORTHLIBS) /usr/local/lib
	mkdir -p /usr/local/share/sporth
	install ugen_reference.txt /usr/local/share/sporth
	install util/ugen_lookup /usr/local/bin

clean:
	rm -rf $(OBJ)
	rm -rf $(BIN)
	rm -rf tmp.h
	rm -rf libsporth.a libsporth_dyn.so

