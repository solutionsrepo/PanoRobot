#import <UIKit/UIKit.h>

#import "PRImagesCount.h"
#import "PRDuration.h"
#import "PRImageList.h"
#import "PRImageStorage.h"
#import "PRShowingIndex.h"

@interface PRSettingsVC : UIViewController

@property (weak, nonatomic) PRImagesCount * imagesCount;
@property (weak, nonatomic) PRDuration * duration;

@property (weak, nonatomic) PRImageList * imageList;
@property (weak, nonatomic) PRImageStorage * imageStorage;
@property (weak, nonatomic) PRShowingIndex * showingIndex;

@end
