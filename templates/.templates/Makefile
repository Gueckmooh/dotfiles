############################## MAKEFILE ##############################
#          Author : Enzo Brignon                                     #
######################################################################

-include config.mk
.SECONDEXPANSION:

QUIET?=@
SHELL=/bin/bash
CC = $(TARGET)gcc
CXX = $(TARGET)g++
AS = $(TARGET)as
AR = ar
VALGRIND = valgrind

ifneq (`find -regex '.*\.\(cc\|C\|cpp\)`, "")
LD := $(TARGET)g++
else
LD := $(TARGET)gcc
endif

LEX = flex
YACC = bison

MKDIR := $(QUIET)mkdir -p
CD := $(QUIET)cd
ECHO := $(QUIET)echo -e
RM := $(QUIET)rm -rf

SRCDIR ?= src

DEPDIR ?= .deps
INCDIR ?= include
OBJDIR ?= .objs

CURDIR := $(notdir $(shell pwd))
EXEC ?= $(CURDIR)
STATIC := lib$(EXEC).a
DYNAMIC := lib$(CURDIR).so

FFILES = $(wildcard $(SRCDIR)/*.l)
BFILES = $(wildcard $(SRCDIR)/*.y)

CBFILES = $(addsuffix .c, $(basename $(BFILES)))
CFFILES += $(addsuffix .c, $(basename $(FFILES)))

CBOBJ = $(notdir $(CBFILES:.c=.o))
CFOBJ = $(notdir $(CFFILES:.c=.o))

CEXT = c
CXXEXT = cc cpp C
ASMEXT = s S

ALLEXT = $(CEXT) $(CXXEXT) $(ASMEXT)

SRC = $(foreach VAR, $(ALLEXT), $(wildcard $(addsuffix *.$(VAR), $(SRCDIR)/)))

OBJ := $(foreach EXT, $(ALLEXT), $(patsubst %.$(EXT), %.o, \
                                  $(notdir $(filter %.$(EXT), $(SRC)))))

FLAGS += -Wall
FLAGS += $(DBGFLAGS)
FLAGS += $(addprefix -I, $(INCDIR))

DEBUG_LEVEL ?=1

DBG += -gdwarf-2
DBG += -D__DEBUG

ifneq ($(DEBUG_LEVEL),1)
DBG += -D__DEBUG_LEVEL=$(DEBUG_LEVEL)
endif

OPTLEVEL ?= -O2
DBGOPT ?= -Og

DBGFLAGS := $(OPTLEVEL)

CCMESSAGE=@$(ECHO) "\t CC \t\t $(notdir $@)"
CXXMESSAGE=@$(ECHO) "\t CXX \t\t $(notdir $@)"
ASMESSAGE=@$(ECHO) "\t AS \t\t $(notdir $@)"
LDMESSAGE=@$(ECHO) "\t LD \t\t $@"
ARMESSAGE=@$(ECHO) "\t AR \t\t $@"
LEXMESSAGE=@$(ECHO) "\t FLEX \t\t $@"
YACCMESSAGE=@$(ECHO) "\t BISON \t\t $@"

CFLAGS += $(FLAGS)
CFLAGS += -std=gnu99

CXXSTD?= c++11
CXXFLAGS += $(FLAGS)
CXXFLAGS += -std=$(CXXSTD)

CFFLAGS += -std=c99
CFFLAGS += -Wno-implicit-function-declaration

VALFLAGS = --leak-check=full
VALFLAGS += --show-reachable=yes
VALFLAGS += --show-possibly-lost=yes
VALFLAGS += -v

NOINC = clean, mrproper
.PHONY: all clean mrproper static valgrind doxygen

.DEFAULT_GOAL = all

all: $(EXEC)

debug: DBGFLAGS = $(DBGOPT) $(DBG)
debug: all

valgrind: debug
	@$(VALGRIND) $(VALFLAGS) ./$(EXEC) $(ARGS)

$(EXEC): $(addprefix $(OBJDIR)/, $(OBJ)) $(addprefix $(OBJDIR)/, $(CBOBJ)) \
$(addprefix $(OBJDIR)/, $(CFOBJ))
	$(LDMESSAGE)
	$(QUIET)$(LD) -o $@ $^ $(LDFLAGS)

$(EXEC).o: $(addprefix $(OBJDIR)/, $(OBJ)) $(addprefix $(OBJDIR)/, $(CBOBJ)) \
$(addprefix $(OBJDIR)/, $(CFOBJ))
	$(LDMESSAGE)
	$(QUIET)ld -r -o $@ $^

static: $(STATIC)

$(STATIC): $(addprefix $(OBJDIR)/, $(OBJ))
	$(ARMESSAGE)
	$(QUIET)$(AR) rcs $@ $^

dynamic: FLAGS += -fPIC
dynamic: $(DYNAMIC)

$(DYNAMIC): $(addprefix $(OBJDIR)/, $(OBJ))
	$(LDMESSAGE)
	$(QUIET)$(LD) -shared -o $@ $^ $(LDFLAGS)

$(addprefix $(OBJDIR)/, $(OBJ)): $(OBJDIR)/%.o: $(DEPDIR)/%.d

%.c: %.l
	$(LEXMESSAGE)
	$(QUIET)$(LEX) -o $@ $<

%.c: %.y
	$(YACCMESSAGE)
	$(QUIET)$(YACC) -o $@ --defines=$(basename $<).h $<


$(DEPDIR)/%.d: $(SRCDIR)/%.c $$(@D)/.f
	$(QUIET)$(CC) $(CFLAGS) -MM -MT '$(OBJDIR)/$(notdir $(@:.d=.o))' \
                                                            $< -o $@ $(INCFLAGS)

$(DEPDIR)/%.d: $(SRCDIR)/%.s $$(@D)/.f
	$(QUIET)$(CC) $(CFLAGS) -MM -MT '$(OBJDIR)/$(notdir $(@:.d=.o))' \
                                                            $< -o $@ $(INCFLAGS)

$(DEPDIR)/%.d: $(SRCDIR)/%.S $$(@D)/.f
	$(QUIET)$(CC) $(CFLAGS) -MM -MT '$(OBJDIR)/$(notdir $(@:.d=.o))' \
                                                            $< -o $@ $(INCFLAGS)

$(DEPDIR)/%.d: $(SRCDIR)/%.cc $$(@D)/.f
	$(QUIET)$(CXX) $(CXXFLAGS) -MM -MT '$(OBJDIR)/$(notdir $(@:.d=.o))' \
                                                            $< -o $@ $(INCFLAGS)

$(DEPDIR)/%.d: $(SRCDIR)/%.C $$(@D)/.f
	$(QUIET)$(CXX) $(CXXFLAGS) -MM -MT '$(OBJDIR)/$(notdir $(@:.d=.o))' \
                                                            $< -o $@ $(INCFLAGS)

$(DEPDIR)/%.d: $(SRCDIR)/%.cpp $$(@D)/.f
	$(QUIET)$(CXX) $(CXXFLAGS) -MM -MT '$(OBJDIR)/$(notdir $(@:.d=.o))' \
                                                            $< -o $@ $(INCFLAGS)


ifneq ($(MAKECMDGOALS),$(NOINC))
-include $(addprefix $(DEPDIR)/, $(foreach EXT, $(ALLEXT),$(patsubst %.$(EXT),\
                                     %.d,$(filter %.$(EXT), $(notdir $(SRC))))))
endif

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(DEPDIR)/%.d $$(@D)/.f
	$(CCMESSAGE)
	$(QUIET)$(CC) $(CFLAGS) -c -o $@ $< $(INCFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(DEPDIR)/%.d $$(@D)/.f
	$(CXXMESSAGE)
	$(QUIET)$(CXX) $(CXXFLAGS) -c -o $@ $< $(INCFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cc $(DEPDIR)/%.d $$(@D)/.f
	$(CXXMESSAGE)
	$(QUIET)$(CXX) $(CXXFLAGS) -c -o $@ $< $(INCFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.C $(DEPDIR)/%.d $$(@D)/.f
	$(CXXMESSAGE)
	$(QUIET)$(CXX) $(CXXFLAGS) -c -o $@ $< $(INCFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.s $(DEPDIR)/%.d $$(@D)/.f
	$(ASMESSAGE)
	$(QUIET)$(AS) -o $@ $<

$(OBJDIR)/%.o: $(SRCDIR)/%.S $(DEPDIR)/%.d $$(@D)/.f
	$(ASMESSAGE)
	$(QUIET)$(AS) -o $@ $<

%/.f:
	$(QUIET)mkdir -p $(dir $@)
	$(QUIET)touch $@

.PRECIOUS: %/.f %.c .deps/%.d

doxygen:
	$(QUIET)doxygen doc/Doxyfile
	$(QUIET)$(MAKE) -C doc/latex/

clean:
	$(RM) $(OBJDIR)
	$(RM) $(DEPDIR)
	$(RM) $(CBFILES)
	$(RM) $(CFFILES)
	$(RM) $(OBJDIR)/$(CBOBJ)
	$(RM) $(OBJDIR)/$(CFOBJ)

mrproper: clean
	$(RM) $(STATIC)
	$(RM) $(DYNAMIC)
	$(RM) $(EXEC)
	$(RM) doc/{latex,html}
