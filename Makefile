include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FLEXit
FLEXit_FILES = FLEXitListener.m Tweak.xm $(wildcard Sources/*.m)
FLEXit_CFLAGS = -fobjc-arc -w
FLEXit_LIBRARIES = sqlite3 z activator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
