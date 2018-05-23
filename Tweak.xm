#import "Sources/FLEXManager.h"
#import "Sources/FLEXWindow.h"

#import <IOKit/hid/IOHIDEventSystem.h>
#import <IOKit/hid/IOHIDEventSystemClient.h>

OBJC_EXTERN IOHIDEventSystemClientRef IOHIDEventSystemClientCreate(CFAllocatorRef allocator);

#define kIOHIDEventUsageVolumeUp 233
#define kIOHIDEventUsageVolumeDown 234

void ioEventHandler(void *target, void *refcon, IOHIDEventQueueRef queue, IOHIDEventRef event) {
    static BOOL volumeUpPressed = NO;
    static BOOL volumeDownPressed = NO;
    
    if (IOHIDEventGetType(event) == kIOHIDEventTypeKeyboard) {
        int keyDown = IOHIDEventGetIntegerValue(event, kIOHIDEventFieldKeyboardDown);
        int button = IOHIDEventGetIntegerValue(event, kIOHIDEventFieldKeyboardUsage);
        switch (button) {
            case kIOHIDEventUsageVolumeUp:
                volumeUpPressed = keyDown;
                break;
            case kIOHIDEventUsageVolumeDown:
                volumeDownPressed = keyDown;
                break;
            default:
                break;
        }
        
        if (volumeUpPressed && volumeDownPressed) {
            [FLEXManager.sharedManager showExplorer];
        }
    }
}

// allows FLEX to show on the lockscreen
%hook UIWindow

- (BOOL)_shouldCreateContextAsSecure {
    return [self isKindOfClass:FLEXWindow.class] ? YES : %orig;
}

%end

// thanks https://github.com/ipadkid358/personal-tweaks/blob/master/Touchr/Tweak.x#L147
static IOHIDEventSystemClientRef ioHIDClient;
static CFRunLoopRef ioHIDRunLoopScedule;

%ctor {
    ioHIDClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    ioHIDRunLoopScedule = CFRunLoopGetMain();
    
    IOHIDEventSystemClientScheduleWithRunLoop(ioHIDClient, ioHIDRunLoopScedule, kCFRunLoopDefaultMode);
    IOHIDEventSystemClientRegisterEventCallback(ioHIDClient, ioEventHandler, NULL, NULL);
}

%dtor {
    IOHIDEventSystemClientUnregisterEventCallback(ioHIDClient);
    IOHIDEventSystemClientUnscheduleWithRunLoop(ioHIDClient, ioHIDRunLoopScedule, kCFRunLoopDefaultMode);
}
