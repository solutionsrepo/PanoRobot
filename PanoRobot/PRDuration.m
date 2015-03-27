#import "PRDuration.h"

@interface PRDuration ()

@end

@implementation PRDuration

+ (float)defaultValue {
    return 5;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _value = [[self class] defaultValue];
    }
    return self;
}

@end
