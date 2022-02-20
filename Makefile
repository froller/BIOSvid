.AUTODEPEND

.PATH.lib = LIB
.PATH.obj = OBJS
.PATH.c   = SOURCE
.PATH.h   = INCLUDE

#               *Translator Definitions*
CC = bcc +BIOSVID.CFG
TASM = TASM
TLIB = tlib
TLINK = tlink
INCLUDEPATH = \BC\INCLUDE
LIBPATH = \BC\LIB


#               *Implicit Rules*
.c.obj:
  $(CC) -c {$< }

.cpp.obj:
  $(CC) -c {$< }

#               *List Macros*


LIB_dependencies =  \
 biosvid.obj \
 bprintf.obj

all: dirs biosvid.lib

#               *Explicit Rules*
biosvid.lib: biosvid.cfg $(LIB_dependencies)
        - del $(.PATH.lib)\biosvid.lib
        $(TLIB) $< /C/0/E @&&|
+$(.PATH.obj)\biosvid.obj \
+$(.PATH.obj)\bprintf.obj,$*.lst
|

#+$(.PATH.obj)\biosvid.obj,$*.lst


#               *Individual File Dependencies*
biosvid.obj: biosvid.cfg biosvid.c
        $(CC) -c $(.PATH.c)\biosvid.c

bprintf.obj: biosvid.cfg bprintf.c
        $(CC) -c $(.PATH.c)\bprintf.c

#               *Compiler Configuration File*
biosvid.cfg: makefile
  copy &&|
-mt
-f-
-k-
-vi-
-wpro
-weas
-wpre
-nOBJS
-I$(INCLUDEPATH)
-L$(LIBPATH)
-P
| biosvid.cfg


clean:
        - del $(.PATH.obj)\biosvid.obj
        - del $(.PATH.obj)\bprintf.obj
        - del biosvid.cfg
        - rmdir $(.PATH.obj)

distclean: clean
        - del $(.PATH.lib)\biosvid.lib
        - del $(.PATH.lib)\biosvid.lst

dirs:
        - mkdir $(.PATH.obj)

install:
        - copy $(.PATH.lib)\biosvid.lib $(LIBPATH)
        - copy $(.PATH.h)\biosvid.h $(INCLUDEPATH)
        - copy $(.PATH.h)\bprintf.h $(INCLUDEPATH)
