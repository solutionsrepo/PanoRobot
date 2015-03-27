#import <Foundation/Foundation.h>

#import "PRImageList.h"
#import "PRImageStorage.h"
#import "ThreadSafeMutableSet.h"


@interface PRQueueInstance : NSObject

@property (strong, nonatomic) NSArray/*NSDictionary*/ * imageItems;
@property (strong, nonatomic) NSArray/*NSNumber*/ * queueOrderedIndicies;
@property (weak, nonatomic) ThreadSafeMutableSet * passedIndicies;

@property (weak, nonatomic) PRImageStorage * imageStorage;

- (void)start;
- (void)stop;

@end
