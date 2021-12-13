SRCS = main0.c main1.c main2.c main3.c main4.c main5.c main6.c main7.cpp func.c
OBJS =
MAINS =

READELF = eu-readelf
OBJDUMP = eu-objdump
READELF_OUT = readelf.out

CC_COMMON_OPTS = -Wall -Wextra

CC_TYPES = gcc clang
O_TYPES = -O0 -O2 -Og
G_TYPES = -g2 -g3
D_TYPES = -gdwarf-4 -gdwarf-5

ifdef TEST_SUBSET
CC_TYPES = gcc
O_TYPES = -O2
G_TYPES = -g3
D_TYPES = -gdwarf-5
endif

all:

#
# recipe for making .* and executable files
#
# $(1) = ID
# $(2) = cc command
# $(3) = cc options
#
define compile
C_OBJS$(1) = $$(patsubst %.c,%$(1).o,$$(filter %.c,$$(SRCS)))
CPP_OBJS$(1) = $$(patsubst %.cpp,%$(1).o,$$(filter %.cpp,$$(SRCS)))
OBJS$(1) = $$(C_OBJS$(1)) $$(CPP_OBJS$(1))
MAINS$(1) = $$(filter main%,$$(patsubst %.o,%,$$(OBJS$(1))))
CC_CMD$(1) = $(2)
CPP_CMD$(1) = $$(patsubst clang,clang++,$$(patsubst gcc,g++,$(2)))
CC_OPTS$(1) = $(3)
CPP_OPTS$(1) = $(3)
CC$(1) =$$(CC_CMD$(1)) $$(CC_OPTS$(1))
CPP$(1) =$$(CPP_CMD$(1)) $$(CPP_OPTS$(1))
$$(C_OBJS$(1)): %$(1).o: %.c
	$$(CC$(1)) -c -o $$@ $$<

$$(CPP_OBJS$(1)): %$(1).o: %.cpp
	$$(CPP$(1)) -c -o $$@ $$<

$$(MAINS$(1)): %: %.o
	$$(CC$(1)) -o $$@ $$+

$$(OBJS$(1)): func.h
main1$(1) main2$(1) main5$(1) main6$(1): func$(1).o

MAINS += $$(MAINS$(1))
OBJS += $$(OBJS$(1))

endef

#
# make *.o and executable files
#
$(foreach c,$(CC_TYPES),$(foreach o,$(O_TYPES),$(foreach g,$(G_TYPES),$(foreach d,$(D_TYPES),$(eval $(call compile,-$(c)$(o)$(g)$(d),$(c),$(CC_COMMON_OPTS) $(o) $(g) $(d)))))))
CLEAN_FILES = $(OBJS) $(MAINS)

all: $(MAINS)

#
# make readelf.out file
#
readelf: $(READELF_OUT)
CLEAN_FILES += $(READELF_OUT)
$(READELF_OUT): $(MAINS)
	(e=''; for f in $(MAINS); do printf -- "$$e----------\n%s\n----------\n\n" "$$f"; e='\n\n\n'; $(READELF) --debug-dump=info $$f; echo; done) > $@

#
# make *.readelf files
#
READELF_FILES = $(addsuffix .readelf,$(MAINS))
readelfs: $(READELF_FILES)
CLEAN_FILES += $(READELF_FILES)
$(READELF_FILES): %.readelf: %
	$(READELF) --debug-dump=info $< > $@

#
# make *.disassembly files
#
DISASSEMBLY_FILES = $(addsuffix .disassembly,$(MAINS))
disassembly: $(DISASSEMBLY_FILES)
CLEAN_FILES += $(DISASSEMBLY_FILES)
$(DISASSEMBLY_FILES): %.disassembly: %
	$(OBJDUMP) -d $< > $@

MORE_TARGETS = readelf readelfs disassembly
.PHONY: $(MORE_TARGETS)
more: $(MORE_TARGETS)

clean:
	rm -rf $(CLEAN_FILES)


ECHO=@echo
%_printvar %_pv:
	$(info $*($(origin $*))=$($*))
	@:
%_printvardebugonly %_pvdo:
	$(info $*($(origin $*))[$(value $*)])
	@:
%_printvardebug %_pvd:
	$(info $*($(origin $*))[$(value $*)]=$($*))
	@:
%_printvarvalue %_pvo:
	$(info $($*))
	@:
%_printvarlistvalue %_plvo:
	@for i in $($*); do echo $$i; done
%_printvarlist %_plv:
	@echo '$* ='; for i in $($*); do echo "    $$i"; done
%_printvarnumberedlist %_pnlv:
	@echo '$* ='; counter=0; for i in $($*); do counter=`expr $$counter + 1`; printf "%4d. %s\n" $$counter $$i; done
debug-all-vars: $(sort $(addsuffix _pvdo,$(.VARIABLES)))
debug-all-var-values: $(sort $(addsuffix _pvd,$(.VARIABLES)))
