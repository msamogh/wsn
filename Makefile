COMPONENT=TrackingAppC
TINYOS_ROOT_DIR?=../..
BUILD_EXTRA_DEPS = TrackingMsg.py
TrackingMsg.py: Tracker.h
        nescc-mig python $(CFLAGS) $(NESC_PFLAGS) -python-classname=TrackingMsg Tracker.h TrackerMsg -o $@
        
include $(TINYOS_ROOT_DIR)/Makefile.include
