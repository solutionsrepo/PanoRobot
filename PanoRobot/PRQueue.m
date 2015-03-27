#import "PRQueue.h"
#import "PRQueueInstance.h"

@interface PRQueue ()

@end

@implementation PRQueue {
    NSTimer * _timer;
    
    NSArray * _imageListBuffer;
    ThreadSafeMutableSet * _passedIndicies;
    NSInteger _downloadingIndex;
    
    PRQueueInstance * _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _timer =
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
        _passedIndicies = [[ThreadSafeMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    [_instance stop];
}

// = filter (not . elem $ exclusions) $ [startIndex .. size - 1] ++ [0 .. startIndex - 1]
static NSArray * circularFilteredOrderedIndicies(NSInteger startIndex, NSInteger size, ThreadSafeMutableSet * exclusions) {
    NSMutableArray * indicies = [[NSMutableArray alloc] init];
    
    void (^addIfNotExcluded)(NSInteger) = ^(NSInteger i){
        if (![exclusions containsObject:@(i)]) {
            [indicies addObject:@(i)];
        }
    };
    
    for (int i = startIndex; i < size; ++i) {
        addIfNotExcluded(i);
    }
    for (int i = 0; i < startIndex; ++i) {
        addIfNotExcluded(i);
    }
    
    return indicies;
}

- (void)reset {
    _showingIndex.value = @0;
    _imageListBuffer = _imageList.value;
    _passedIndicies = [[ThreadSafeMutableSet alloc] init];
}

- (void)createNewQueueInstance:(NSArray *)queueOrderedIndicies {
    PRQueueInstance * instance = [[PRQueueInstance alloc] init];
    instance.imageItems = _imageList.value;
    instance.passedIndicies = _passedIndicies;
    instance.queueOrderedIndicies = queueOrderedIndicies;
    
    [_instance stop];
    _instance = instance;
    [_instance start];
}


- (void)timerTick {
    if ([_imageList.value count] == 0) {
        return; // TODO: cancel all
    }
    
    
    BOOL areImagesUpdated = ![_imageListBuffer isEqual:_imageList.value];
    
    if (areImagesUpdated) {
        [self reset];
    }
    
    NSArray * newQueueOrderedIndicies =
    circularFilteredOrderedIndicies([_showingIndex.value integerValue], [_imageListBuffer count], _passedIndicies);
    
    if (areImagesUpdated || [newQueueOrderedIndicies[0] integerValue] != _downloadingIndex) {
        [self createNewQueueInstance:newQueueOrderedIndicies];
    }
}

@end
