SRCS = main0.c main1.c main2.c main3.c main4.c main5.c main6.c func.c
OBJS =
MAINS =

GCC_CMD = gcc
CC_COMMON_OPTS = -Wall -Wextra
GCC = $(GCC_CMD) $(GCC_COMMON_OPTS)

C_TYPES = gcc clang
O_TYPES = -O0 -O2 -Og
G_TYPES = -g2 -g3
D_TYPES = -gdwarf-4 -gdwarf-5

all:

# $(1) = ID
# $(2) = cc command
# $(3) = cc options
#
define compile
OBJS$(1) = $$(patsubst %.c,%$(1).o,$$(SRCS))
MAINS$(1) = $$(addsuffix $(1),$$(filter main%,$$(patsubst %.c,%,$$(SRCS))))
CC_CMD$(1) = $(2)
CC_OPTS$(1) = $(3)
CC$(1) =$$(CC_CMD$(1)) $$(CC_OPTS$(1))
$$(OBJS$(1)): %$(1).o: %.c
	$$(CC$(1)) $(3) -c -o $$@ $$<

$$(MAINS$(1)): %: %.o
	$$(CC$(1)) $(3) -o $$@ $$+

$$(OBJS$(1)): func.h
main1$(1) main2$(1) main5$(1) main6$(1): func$(1).o

MAINS += $$(MAINS$(1))
OBJS += $$(OBJS$(1))

endef

$(foreach c,$(C_TYPES),$(foreach o,$(O_TYPES),$(foreach g,$(G_TYPES),$(foreach d,$(D_TYPES),$(eval $(call compile,-$(c)$(o)$(g)$(d),$(c),$(CC_COMMON_OPTS) $(o) $(g) $(d)))))))

all: $(MAINS)

clean:
	rm -rf $(OBJS) $(MAINS)
