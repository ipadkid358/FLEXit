#import "Sources/FLEXManager.h"
#import "Sources/FLEXWindow.h"

@interface UIStatusBarWindow : UIWindow
@end

%hook UIStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;
    
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:FLEXManager.sharedManager action:@selector(showExplorer)]];
    
    return self;
}

%end

%hook UIWindow

- (BOOL)_shouldCreateContextAsSecure {
    return [self isKindOfClass:FLEXWindow.class] ? YES : %orig;
}

%end
