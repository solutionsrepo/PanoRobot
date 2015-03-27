#import <UIKit/UIKit.h>

#import "PRImageList.h"
#import "PRImageStorage.h"
#import "PRShowingIndex.h"
#import "PRDuration.h"

@interface PRSlidesVC : UIViewController

@property (weak, nonatomic) PRImageList * imageList;
@property (weak, nonatomic) PRImageStorage * imageStorage;
@property (weak, nonatomic) PRShowingIndex * showingIndex;
@property (weak, nonatomic) PRDuration * duration;

@end
