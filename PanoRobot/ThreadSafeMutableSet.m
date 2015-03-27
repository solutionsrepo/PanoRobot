#import "ThreadSafeMutableSet.h"

@implementation ThreadSafeMutableSet {
    NSMutableSet * _set;
    dispatch_queue_t _lockQueue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lockQueue = dispatch_queue_create("ru.redmadrobot.ThreadSafeMutableSetLockQueue", nil);
    }
    return self;
}

- (void)addObject:(id)object {
    dispatch_sync(_lockQueue, ^{
        [_set addObject:object];
    });
}

- (BOOL)containsObject:(id)object {
    __block BOOL result = NO;
    dispatch_sync(_lockQueue, ^{
        result = [_set containsObject:object];
    });
    return result;
}

@end
