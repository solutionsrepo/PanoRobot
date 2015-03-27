#import "PRSettingsVC.h"
#import "PRSlidesVC.h"

@interface PRSettingsVC ()

@property (weak, nonatomic) IBOutlet UILabel * durationLabel;
@property (weak, nonatomic) IBOutlet UISlider * durationSlider;

@property (weak, nonatomic) IBOutlet UILabel * imagesLabel;
@property (weak, nonatomic) IBOutlet UISlider * imagesSlider;

@end


static const float minDuration = 0.5;
static const float maxDuration = 60;

static const NSInteger minImagesCount = 1;
static const NSInteger maxImagesCount = 100;


@implementation PRSettingsVC {
    NSInteger _imagesCountBuffer;
    float _durationBuffer;
    
    NSTimer * _notificationSenderTimer;
}

#pragma mark - init/deinit

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _notificationSenderTimer =
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [_notificationSenderTimer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - duration data manipulation

- (float)durationInBuffer {
    return _durationBuffer;
}

- (float)durationValue {
    return _duration.value;
}

- (void)loadDuration {
    _durationBuffer = _duration.value;
}

- (void)saveDuration {
    _duration.value = _durationBuffer;
}

- (void)getDurationFromSlider {
    // f: [0; 1] -> [0.5; 60]
    // f(x) = x * (60 - 0.5) + 0.5
    
    _durationBuffer = _durationSlider.value * (maxDuration - minDuration) + minDuration;
}

- (void)setDurationInSlider {
    // f^-1: [0.5; 60] -> [0; 1]
    // f^-1(x) = (x - 0.5) / (60 - 0.5)
    
    _durationSlider.value = (_durationBuffer - minDuration) / (maxDuration - minDuration);
}

- (void)setDurationInLabel {
    _durationLabel.text = [NSString stringWithFormat:@"Duration: %1.1f s", _durationBuffer];
}

#pragma mark - images count data manipulation

- (NSInteger)imagesCountInBuffer {
    return _durationBuffer;
}

- (NSInteger)imagesCountValue {
    return _duration.value;
}

- (void)loadImagesCount {
    _imagesCountBuffer = _imagesCount.value;
}

- (void)saveImagesCount {
    _imagesCount.value = _imagesCountBuffer;
}

- (void)getImagesCountFromSlider {
    // f: [0; 1] -> [1; 100]
    // f(x) = x * (100 - 1) + 1
    
    _imagesCountBuffer = _imagesSlider.value * (maxImagesCount - minImagesCount) + minImagesCount;
}

- (void)setImagesCountInSlider {
    // f^-1: [1; 100] -> [0; 1]
    // f^-1(x) = (x - 1) / (100 - 1)
    
    _imagesSlider.value = (float)(_imagesCountBuffer - minImagesCount) / (float)(maxImagesCount - minImagesCount);
}

- (void)setImagesCountInLabel {
    _imagesLabel.text = [NSString stringWithFormat:@"Images: %ld", (long)_imagesCountBuffer];
}

#pragma mark - events

- (IBAction)durationSliderMoved:(UISlider *)slider {
    [self getDurationFromSlider];
    [self setDurationInLabel];
}

- (IBAction)imagesCountSliderMoved:(UISlider *)slider {
    [self getImagesCountFromSlider];
    [self setImagesCountInLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadDuration];
    [self setDurationInSlider];
    [self setDurationInLabel];
    
    [self loadImagesCount];
    [self setImagesCountInSlider];
    [self setImagesCountInLabel];
}

- (void)timerTick {
    if ([self durationInBuffer] != [self durationValue]) {
        [self saveDuration];
        [self postNewDurationNotification];
    }
    
    if ([self durationInBuffer] != [self durationValue]) {
        [self saveImagesCount];
        [self postNewImagesCountNotification];
    }
}

#pragma mark - notifications senders

- (void)postNewDurationNotification {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"DurationUpdatedNotification"
     object:nil];
}

- (void)postNewImagesCountNotification {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ImagesCountUpdatedNotification"
     object:nil];
}

#pragma mark - segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"startSlideshow"]) {
        
    }
}

@end