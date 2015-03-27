#import <Foundation/Foundation.h>

#import "PRImageList.h"
#import "PRImageStorage.h"
#import "PRShowingIndex.h"


@interface PRQueue : NSObject

@property (weak, nonatomic) PRImageList * imageList;
@property (weak, nonatomic) PRImageStorage * imageStorage;
@property (weak, nonatomic) PRShowingIndex * showingIndex;

@end
