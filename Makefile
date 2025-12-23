ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:16.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppLibrarySwipe

AppLibrarySwipe_FILES = Tweak.x
AppLibrarySwipe_CFLAGS = -fobjc-arc
AppLibrarySwipe_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
