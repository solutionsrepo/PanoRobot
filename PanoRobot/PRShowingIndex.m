#import "PRShowingIndex.h"

@interface PRShowingIndex ()

@end

@implementation PRShowingIndex

+ (NSNumber *)defaultValue {
    return @0;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _value = [[self class] defaultValue];
    }
    return self;
}

@end
