%hook UIWindow

- (BOOL)_shouldCreateContextAsSecure {
    return [self isKindOfClass:%c(FLEXWindow)] ? YES : %orig;
}

%end
