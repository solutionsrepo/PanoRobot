#import <UIKit/UIKit.h>
#import "PRImageStorage.h"
#import "PRImageFetcher.h"

@interface PRSlideCell : UICollectionViewCell

@property (weak, nonatomic) PRImageStorage * imageStorage;
//@property (weak, nonatomic) PRImageFetcher * imageFetcher;

- (void)setItem:(NSDictionary *)item;

@end
