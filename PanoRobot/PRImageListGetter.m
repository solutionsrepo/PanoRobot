#import "PRImageListGetter.h"
#import <MapKit/MapKit.h>

@interface PRImageListGetter ()

@end

static const CLLocationDistance defaultRegionSizeInMeters = 3000;

@implementation PRImageListGetter {
    NSNumber * _imagesCountBuffer;
    CLLocation * _locationBuffer;
    
    NSURLSessionDataTask * _task;
    
    NSTimer * _timer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _timer =
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    [self stopTask];
}

- (void)timerTick {
    if (![_locationBuffer isEqual:_location.value] || ![_imagesCountBuffer isEqualToNumber:_imagesCount.value]) {
        _imagesCountBuffer = _imagesCount.value;
        _locationBuffer = _location.value;
        
        [self stopTask];
        [self startTask];
    }
}

- (void)startTask {
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(_locationBuffer.coordinate, defaultRegionSizeInMeters, defaultRegionSizeInMeters);
    
    CLLocationCoordinate2D topLeftCorner =
    CLLocationCoordinate2DMake
    (region.center.latitude - region.span.latitudeDelta / 2, region.center.longitude - region.span.longitudeDelta / 2);
    CLLocationCoordinate2D bottomRightCorner =
    CLLocationCoordinate2DMake
    (region.center.latitude + region.span.latitudeDelta / 2, region.center.longitude + region.span.longitudeDelta / 2);
    
    NSString * url =
    [NSString stringWithFormat:
     @"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=%@&minx=%f&miny=%f&maxx=%f&maxy=%f",
     _imagesCount.value,
     topLeftCorner.longitude,
     topLeftCorner.latitude,
     bottomRightCorner.longitude,
     bottomRightCorner.latitude];
    
    void (^handleError)(NSError *) = ^(NSError * error) {
        NSLog(@"error: %@", error);
    };
    
    _task =
    [[NSURLSession sharedSession]
     dataTaskWithURL:[NSURL URLWithString:url]
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (error) {
             handleError(error);
             return;
         }
         
         NSError * e;
         NSDictionary * json =
         [NSJSONSerialization
          JSONObjectWithData:data
          options:NSJSONReadingAllowFragments
          error:&e];
         
         if ([json isKindOfClass:[NSDictionary class]]) {
             NSArray * photos = json[@"photos"];
             NSLog(@"photos: %@", photos);
             _imageList.value = photos;
         } else {
             handleError(e);
         }
    }];
    [_task resume];
}

- (void)stopTask {
    [_task cancel];
}

@end
