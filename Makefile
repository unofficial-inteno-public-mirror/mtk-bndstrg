LDFLAGS += -lpthread
BNDSTRG_EXEC = bndstrg

#PLATFORM = x86
PLATFORM = mipsel

ifeq ($(PLATFORM),x86)
CROSS_COMPILE=""
endif

ifeq ($(PLATFORM),mipsel)
CROSS_COMPILE = mipsel-linux-
endif

CFLAGS = -O2 -Wall -g -lrt
#CC = $(CROSS_COMPILE)gcc
CC = gcc

BNDSTRG_OBJS = bndstrg.o driver_wext.o eloop.o os_internal.o main.o util.o debug.o netlink.o
#ctrl_iface_unix.o

all: $(BNDSTRG_EXEC)

$(BNDSTRG_EXEC): $(BNDSTRG_OBJS)
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(LDFLAGS) -o $(BNDSTRG_EXEC) $(BNDSTRG_OBJS)

romfs_dir = $(ROOTDIR)/romfs

romfs_dirs = etc_ro/wifi
   
romfs:
	[ -d $(romfs_dir)/$$i ] || mkdir -p $(romfs_dir)
	for i in $(romfs_dirs); do \
		[ -d $(romfs_dir)/$$i ] || mkdir -p $(romfs_dir)/$$i; \
	done 
	$(ROMFSINST) /bin/$(BNDSTRG_EXEC)

clean:
	rm -f *.o $(BNDSTRG_EXEC)
