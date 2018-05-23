include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FLEXit
FLEXit_FILES = Tweak.xm $(wildcard Sources/*.m)
FLEXit_CFLAGS = -fobjc-arc -w
FLEXit_FRAMEWORKS = IOKit
FLEXit_LIBRARIES = sqlite3 z

include $(THEOS_MAKE_PATH)/tweak.mk
