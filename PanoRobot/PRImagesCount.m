#import "PRImagesCount.h"

@interface PRImagesCount ()

@end

@implementation PRImagesCount

+ (NSInteger)defaultValue {
    return 10;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _value = [[self class] defaultValue];
    }
    return self;
}

@end
