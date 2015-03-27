#import <UIKit/UIKit.h>

#import "PRImagesCount.h"
#import "PRDuration.h"

@interface PRSettingsVC : UIViewController

@property (weak, nonatomic) PRImagesCount * imagesCount;
@property (weak, nonatomic) PRDuration * duration;

@end

