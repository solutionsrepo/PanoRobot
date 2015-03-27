#import "PRLocationGetter.h"
#import <CoreLocation/CoreLocation.h>

@interface PRLocationGetter () <CLLocationManagerDelegate>

@end

@implementation PRLocationGetter {
    CLLocationManager * _locationManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 100.0f;
        
        [_locationManager requestWhenInUseAuthorization];
        
        [_locationManager startUpdatingLocation];
        // [_locationManager startMonitoringSignificantLocationChanges];
    }
    return self;
}

- (void)updateLocation:(CLLocation *)location {
    dispatch_async(dispatch_get_main_queue(), ^{
        _location.value = location;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LocationAcquiredNotification"
         object:nil];
    });
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * newLocation = [locations lastObject];
    [self updateLocation:newLocation];
    
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"User has denied location services");
    } else {
        NSLog(@"Location manager did fail with error: %@", error.localizedFailureReason);
    }
}

@end
