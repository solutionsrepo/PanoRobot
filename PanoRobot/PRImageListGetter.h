#import <Foundation/Foundation.h>

#import "PRImagesCount.h"
#import "PRLocation.h"
#import "PRImageList.h"


@interface PRImageListGetter : NSObject

@property (weak, nonatomic) PRImagesCount * imagesCount;
@property (weak, nonatomic) PRLocation * location;
@property (weak, nonatomic) PRImageList * imageList;

@end
