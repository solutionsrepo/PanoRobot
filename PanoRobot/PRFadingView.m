#import "PRFadingView.h"

@implementation PRFadingView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.alpha = 0.0f;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

@end
