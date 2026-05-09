TARGET = iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HyperXStore

HyperXStore_FILES = Tweak.x
HyperXStore_FRAMEWORKS = UIKit CoreGraphics QuartzCore
HyperXStore_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
