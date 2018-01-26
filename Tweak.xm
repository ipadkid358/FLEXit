#import <Foundation/Foundation.h>
#import <notify.h>

#import "Sources/FLEXManager.h"

@interface UIStatusBarWindow : UIWindow
@end

%hook UIStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;
    
    [self addGestureRecognizer:[UILongPressGestureRecognizer.alloc initWithTarget:FLEXManager.sharedManager action:@selector(showExplorer)]];
    
    return self;
}

%end
