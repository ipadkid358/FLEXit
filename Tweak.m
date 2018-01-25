#import <libactivator/libactivator.h>
#import <notify.h>

#import "Sources/FLEXManager.h"

@interface SBApplication
- (NSString *)bundleIdentifier;
@end

@interface SpringBoard
- (SBApplication *)_accessibilityFrontMostApplication;
@end


@interface FLEXitListener : NSObject <LAListener>
@end

@implementation FLEXitListener

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
    SBApplication *frontmostApp = [(SpringBoard *)UIApplication.sharedApplication _accessibilityFrontMostApplication];
    
    if (frontmostApp) {
        notify_post([[NSString stringWithFormat:@"com.ipadkid.flexit/%@", frontmostApp.bundleIdentifier] UTF8String]);
    } else {
        [FLEXManager.sharedManager showExplorer];
    }
}

+ (void)load {
    NSString *currentID = NSBundle.mainBundle.bundleIdentifier;
    if ([currentID isEqualToString:@"com.apple.springboard"]) {
        // This string just needs to match whatever is in layout/Library/Activator/Listeners
        [LAActivator.sharedInstance registerListener:self.new forName:@"com.ipadkid.flexit"];
    } else {
        int regToken;
        NSString *notifForBundle = [NSString stringWithFormat:@"com.ipadkid.flexit/%@", currentID];
        notify_register_dispatch(notifForBundle.UTF8String, &regToken, dispatch_get_main_queue(), ^(int token) {
            [FLEXManager.sharedManager showExplorer];
        });
    }
}

@end
