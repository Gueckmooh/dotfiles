############################################################
#####                                                  #####
#####     @FILE : Makefile                             #####
#####     @AUTHOR : Enzo Brignon                       #####
#####                                                  #####
############################################################
##########     CONFIGURATION OF THE TOOLCHAIN     ##########
#####                                                  #####
-include config.mk
.SECONDEXPANSION:
#####
QUIET := @
MKDIR := $(QUIET)mkdir
CD := $(QUIET)cd
ECHO := $(QUIET)echo
RM := $(QUIET)rm -rf

#####
CPPEXT =cc

DEPDIR := .deps
INCDIR := include
OBJDIR := .obj
SRCDIR := src

CURDIR := $(notdir $(shell pwd))
STATIC := lib$(CURDIR).a
DYNAMIC := lib$(CURDIR).so

MODULES := $(sort $(dir $(wildcard src/*/*)))
MODOBJS := $(addsuffix $(notdir $(MODULES:/=)).o, $(MODULES))

#####
EXEC := $(notdir $(shell pwd))

FFILES = $(wildcard $(SRCDIR)/*.l)
BFILES = $(wildcard $(SRCDIR)/*.y)

LPFILES = $(addsuffix .c, $(basename $(BFILES)))
LPFILES += $(addsuffix .c, $(basename $(FFILES)))

SRC := $(notdir $(wildcard $(SRCDIR)/*.c)) $(notdir $(wildcard $(SRCDIR)/*.$(CPPEXT)))

OBJ := $(SRC:.c=.o) $(notdir $(LPFILES:.c=.o))
OBJ := $(OBJ:.$(CPPEXT)=.o)

#####
CC := gcc
CXX := g++
AR := ar
FLEX := flex
BISON := bison
ifneq ("$(wildcard src/*.$(CPPEXT))", "")
LD := g++
else
LD := gcc
endif

#####
FLAGS = -Wall
#FLAGS+= -Werror

ifeq ($(DEBUG), yes)
FLAGS+= -O0
FLAGS+= -gdwarf-2
FLAGS+= -D__DEBUG
else
FLAGS+= -O0
endif

LDFLAGS := $(addprefix -L, $(MODULES))
LDFLAGS += $(addprefix -l, $(notdir $(MODULES:/=)))
INCFLAGS := $(addprefix -I, $(addsuffix src, $(MODULES)))
INCFLAGS += $(addprefix -I, $(CONFIG_HEADER))

CFLAGS += $(FLAGS)
CFLAGS += -std=gnu99


CXXFLAGS += $(FLAGS)
CXXFLAGS += -std=c++11

# Messages
CCMESSAGE=@echo "\t CC \t\t $(notdir $@)"
CXXMESSAGE=@echo "\t CXX \t\t $(notdir $(basename $@))$(CPPEXT)"
LDMESSAGE=@echo "\t LINGING \t $@"

.PHONY: all clean mrproper modules $(MODULES)

all: modules $(EXEC)

$(SRCDIR)/%.c: $(SRCDIR)/%.l
	$(FLEX) -o $@ $<

$(SRCDIR)/%.c: $(SRCDIR)/%.y
	$(BISON) -o $@ --defines=$(basename $<).h $<

$(EXEC): $(addprefix $(OBJDIR)/, $(OBJ))
	$(QUIET)$(LD) -o $@ $^ $(LDFLAGS)
	$(LDMESSAGE)

$(EXEC).o: $(MODOBJS) $(addprefix $(OBJDIR)/, $(OBJ))
	$(QUIET)ld -r $^ -o $@
	$(LDMESSAGE)

$(MODOBJS):
	$(MAKE) $(notdir $@) -C $(dir $@)

$(STATIC): $(addprefix $(OBJDIR)/, $(OBJ)) $(MODOBJS)
	$(AR) rcs $@ $^

modules: $(MODULES)

$(MODULES):
	$(MAKE) lib$(notdir $(@:/=)).a -C $@

$(addprefix $(OBJDIR)/, $(OBJ)): $(OBJDIR)/%.o: $(DEPDIR)/%.d

$(DEPDIR)/%.d: $(SRCDIR)/%.c $$(@D)/.f
	$(QUIET)$(CC) $(CFLAGS) -MM -MT '$(OBJDIR)/$(notdir $(@:.d=.o))' $< -o $@ $(INCFLAGS)

ifneq ($(MAKECMDGOALS),clean, mrproper)
-include $(DEPDIR)/$(SRC:.c=.d)
endif

$(DEPDIR)/%.d: $(SRCDIR)/%.$(CPPEXT) $$(@D)/.f
	$(QUIET)$(CXX) $(CXXFLAGS) -MM -MT '$(OBJDIR)/$(notdir $(@:.d=.o))' $< -o $@ $(INCFLAGS)

ifneq ($(MAKECMDGOALS),clean, mrproper)
-include $(DEPDIR)/$(SRC:.$(CPPEXT)=.d)
endif

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(DEPDIR)/%.d $$(@D)/.f
	$(QUIET)$(CC) $(CFLAGS) -c -o $@ $< $(INCFLAGS)
	$(CCMESSAGE)

$(OBJDIR)/%.o: $(SRCDIR)/%.$(CPPEXT) $(DEPDIR)/%.d $$(@D)/.f
	$(QUIET)$(CXX) $(CXXFLAGS) -c -o $@ $< $(INCFLAGS)
	$(CXXMESSAGE)

$(DEPDIR) $(INCDIR) $(OBJDIR):
	$(QUIET)$(MKDIR) $@

%/.f:
	$(QUIET)mkdir -p $(dir $@)
	$(QUIET)touch $@

.PRECIOUS: %/.f

clean:
	$(RM) $(OBJDIR)
	$(RM) $(DEPDIR)

mrproper: clean
	$(RM) $(STATIC)
	$(RM) $(EXEC)
	$(QUIET)for module in $(MODULES); do $(MAKE) mrproper -C $$module; done
	$(QUIET) $(RM) $(LPFILES)
