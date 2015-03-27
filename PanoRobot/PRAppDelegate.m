#import "PRAppDelegate.h"

#import "PRImagesCount.h"
#import "PRDuration.h"
#import "PRShowingIndex.h"

#import "PRLocation.h"
#import "PRImageList.h"
#import "PRImageStorage.h"

#import "PRQueue.h"
#import "PRImageListGetter.h"
#import "PRLocationGetter.h"

#import "PRSettingsVC.h"


@interface PRAppDelegate ()

@property (strong, nonatomic) PRImagesCount * imagesCount;
@property (strong, nonatomic) PRDuration * duration;
@property (strong, nonatomic) PRShowingIndex * showingIndex;

@property (strong, nonatomic) PRLocation * location;
@property (strong, nonatomic) PRImageList * imageList;
@property (strong, nonatomic) PRImageStorage * imageStorage;

@property (strong, nonatomic) PRQueue * queue;
@property (strong, nonatomic) PRImageListGetter * imageListGetter;
@property (strong, nonatomic) PRLocationGetter * locationGetter;

@property (weak, nonatomic) PRSettingsVC * settingsVC;

@end

@implementation PRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _imagesCount = [[PRImagesCount alloc] init];
    _duration = [[PRDuration alloc] init];
    _showingIndex = [[PRShowingIndex alloc] init];
    
    
    _location = [[PRLocation alloc] init];
    _imageList = [[PRImageList alloc] init];
    _imageStorage = [[PRImageStorage alloc] init];
    
    
    _queue = [[PRQueue alloc] init];
    _queue.imageList = _imageList;
    _queue.imageStorage = _imageStorage;
    _queue.showingIndex = _showingIndex;
    
    _imageListGetter = [[PRImageListGetter alloc] init];
    _imageListGetter.imagesCount = _imagesCount;
    _imageListGetter.location = _location;
    _imageListGetter.imageList = _imageList;
    
    _locationGetter = [[PRLocationGetter alloc] init];
    _locationGetter.location = _location;

    
    _settingsVC = (PRSettingsVC *)((UINavigationController *)self.window.rootViewController).viewControllers[0];
    _settingsVC.imagesCount = _imagesCount;
    _settingsVC.duration = _duration;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
