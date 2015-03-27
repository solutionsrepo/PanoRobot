#import <Foundation/Foundation.h>

@interface ThreadSafeMutableSet : NSObject

- (void)addObject:(id)object;
- (BOOL)containsObject:(id)object;

@end
