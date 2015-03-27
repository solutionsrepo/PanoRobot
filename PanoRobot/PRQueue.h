#import <Foundation/Foundation.h>

#import "PRImageList.h"
#import "PRImageStorage.h"


@interface PRQueue : NSObject

@property (weak, nonatomic) PRImageList * imageList;
@property (weak, nonatomic) PRImageStorage * imageStorage;

@end
