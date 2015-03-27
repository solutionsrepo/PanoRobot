#import "PRSlidesVC.h"
#import "PRSlideCell.h"

@interface PRSlidesVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;

@end

@implementation PRSlidesVC {
    NSTimer * _timer;
    NSTimer * _switchSlideTimer;
    
    NSArray * _imageListBuffer;
    NSNumber * _showingIndexBuffer;
    
}


#pragma mark - init/deinit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _collectionView.pagingEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _timer =
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    _switchSlideTimer =
    [NSTimer scheduledTimerWithTimeInterval:_duration.value target:self selector:@selector(switchSlideTick) userInfo:nil repeats:YES];
    
    [self fullReload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    [_switchSlideTimer invalidate];
}

#pragma mark -

//override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//    
//    collectionView.collectionViewLayout.invalidateLayout()
//    
//    reload()
//}
- (void)
viewWillTransitionToSize:(CGSize)size
withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [_collectionView.collectionViewLayout invalidateLayout];
    
    [self reload];
}

//func reload() {
//    UIView.animateWithDuration(0, animations: {
//    }, completion: { _ in
//        self.collectionView.reloadData()
//        self.scrollToSelectedItem()
//    })
//}
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
        _showingIndexBuffer = @(index);
        
        _imageListBuffer = _imageList.value;
        [self reload];
    }
}

//func scrollToSelectedItem() {
//    self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: data.selectedItemIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
//}

- (void)scrollToItem:(NSInteger)index {
    [_collectionView
     scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
     animated:NO];
    _showingIndex.value = @(index);
    _showingIndexBuffer = @(index);
}

- (void)scrollToSelectedItem {
    if (_showingIndexBuffer) {
        [self scrollToItem:[_showingIndexBuffer integerValue]];
    }
}

#pragma mark - events

- (void)timerTick {
    
    [self fullReload];

}

- (NSInteger)nextSlideIndex {
    assert(_showingIndexBuffer);
    assert(_imageListBuffer);
    
    return ([_showingIndexBuffer integerValue] + 1) % [_imageListBuffer count];
}

- (void)switchSlideTick {
    if (!_showingIndexBuffer || !_imageListBuffer) {
        return;
    }
    
    [self scrollToItem:[self nextSlideIndex]];
}

#pragma mark - collection view data


//func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return data.items.count;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_imageListBuffer count];
}

//func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//    
//    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("detailsCell", forIndexPath: indexPath) as! NewsItemDetailsCell
//    
//    let item = data.items[indexPath.row]
//    let likeState = data.likeStatesMap[item.id]
//    
//    cell.setItem(item)
//    cell.setLikeState(likeCount: item.like_count, likeState: likeState)
//    
//    cell.scrollContentToTop()
//    
//    if let details = data.detailsMap[item.id] {
//        cell.setDetails(details)
//    } else {
//        cell.clearDetails()
//        self.dataModel.requestNewsItemDetails(item.id)
//    }
//    
//    return cell
//}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PRSlideCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"slideCell" forIndexPath:indexPath];
    cell.imageStorage = _imageStorage;
    
    NSDictionary * item = _imageListBuffer[indexPath.row];
    
    [cell setItem:item];
    
    return cell;
}

//func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//    return CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
//}

- (CGSize)
collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout *)collectionViewLayout
sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
}

//func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//    data.selectedItemIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
//    checkCurrentPage()
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSNumber * index = @((NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width));
    _showingIndex.value = index;
    _showingIndexBuffer = index;
}

@end
