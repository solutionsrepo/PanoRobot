#import "PRSlidesVC.h"
#import "PRSlideCell.h"
#import "PRFadingView.h"

@interface PRSlidesVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;
@property (weak, nonatomic) IBOutlet PRFadingView * fadingView;

@end

@implementation PRSlidesVC {
    NSTimer * _timer;
    NSTimer * _switchSlideTimer;
    
    NSArray * _imageListBuffer;
}

#pragma mark - init/deinit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _collectionView.pagingEnabled = YES;
}

- (void)createTimer {
    [_timer invalidate];
    _timer =
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

- (void)createSwitchSlideTimer {
    [_switchSlideTimer invalidate];
    _switchSlideTimer =
    [NSTimer scheduledTimerWithTimeInterval:_duration.value target:self selector:@selector(switchSlideTick) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self createTimer];
    [self createSwitchSlideTimer];
    
    [self fullReload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    [_switchSlideTimer invalidate];
}

#pragma mark -

- (void)
viewWillTransitionToSize:(CGSize)size
withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [_collectionView.collectionViewLayout invalidateLayout];
    
    [self reload];
}

- (void)reload {
    __typeof__(self) __weak weakSelf = self;
    [UIView animateWithDuration:0 animations:^{
    } completion:^(BOOL finished) {
        [weakSelf.collectionView reloadData];
        [weakSelf scrollToSelectedItem];
    }];
}

- (void)fullReload {
    if (_imageListBuffer != _imageList.value) {
        NSInteger index = 0;
        _showingIndex.value = @(index);
        
        _imageListBuffer = _imageList.value;
        [self reload];
    }
}

- (void)scrollToItem:(NSInteger)index {
    [_collectionView
     scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
     animated:NO];
    _showingIndex.value = @(index);
}

- (void)scrollToSelectedItem {
    if (_showingIndex.value) {
        [self scrollToItem:[_showingIndex.value integerValue]];
    }
}

#pragma mark - events

- (void)timerTick {
    
    [self fullReload];

}

- (NSInteger)nextSlideIndex {
    assert(_showingIndex.value);
    assert(_imageListBuffer);
    
    return ([_showingIndex.value integerValue] + 1) % [_imageListBuffer count];
}

- (UIImage *)currentImage {
    UIGraphicsBeginImageContextWithOptions(_collectionView.bounds.size, NO, self.view.window.screen.scale);
    [_collectionView drawViewHierarchyInRect:_collectionView.frame afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (void)switchSlideTick {
    if (!_showingIndex.value || !_imageListBuffer) {
        return;
    }
    
    float animationDuration = MIN(2.0f, _duration.value);
    
    UIImage * currentImage = [self currentImage];
    
    _fadingView.imageView.image = currentImage;
    _fadingView.alpha = 1.0f;
    
    [self scrollToItem:[self nextSlideIndex]];
    
    [UIView animateWithDuration:animationDuration animations:^{
        _fadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
    }];
    
//    //fade in
//    [UIView animateWithDuration:animationDuration animations:^{
//        
//        [_collectionView setAlpha:0.0f];
//        
//    } completion:^(BOOL finished) {
//        
//        [self scrollToItem:[self nextSlideIndex]];
//        
//        //fade out
//        [UIView animateWithDuration:animationDuration animations:^{
//            
//            [_collectionView setAlpha:1.0f];
//            
//        } completion:nil];
//        
//    }];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self scrollToItem:[self nextSlideIndex]];
//    } completion:^(BOOL finished) {
//    }];
}

#pragma mark - collection view data

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_imageListBuffer count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PRSlideCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"slideCell" forIndexPath:indexPath];
    cell.imageStorage = _imageStorage;
    
    NSDictionary * item = _imageListBuffer[indexPath.row];
    
    [cell setItem:item];
    
    return cell;
}

- (CGSize)
collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout *)collectionViewLayout
sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSNumber * index = @((NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width));
    _showingIndex.value = index;
    [self createSwitchSlideTimer];
}

@end
