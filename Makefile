export ARCHS = arm64
export TARGET = iphone:clang:latest:13.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HyperXStore
HyperXStore_FILES = Tweak.x
HyperXStore_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable

include $(THEOS)/makefiles/tweak.mk
