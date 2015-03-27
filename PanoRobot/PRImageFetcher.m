#import <UIKit/UIKit.h>
#import "PRImageFetcher.h"

typedef void (^CompletionHandler)(id, UIImage *);


//@interface RWObject : NSObject
//
//- (int)read;
//- (void)write:(int)value;
//
//@end
//
//@implementation RWObject {
//    id v1;
//    id v2;
//    id v3;
//    dispatch_semaphore_t s;
//    dispatch_queue_t q2;
//}
//
//- (int)read {
//    dispatch_semaphore_wait(s, DISPATCH_TIME_NOW);
//    
//    if (v1 != v2) {
//        v1 = v2;
//        v2 = nil;
//    }
//    
//    dispatch_semaphore_signal(s);
//    
//    return v1;
//}
//
//- (void)write:(void (^)(id))block {
//    dipatch_sync(q2, ^{
//        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
//        
//        v1
//        v2
//        v3
//        
//        v3 = [v1 copy];
//        //v2 = value;
//        
//        dispatch_semaphore_signal(s);
//        
//        
//    });
//}
//
//@end

//@implementation Map
//
//- (void)setImage:(UIImage *)image forUrl:(NSURL *)url {
//    for (id o in _map) {
//        t = _map[o]
//        if (t.url == url) {
//            t.image = image
//        }
//    }
//}
//
//@end

@interface Triple : NSObject
@property (strong, nonatomic) id object;
@property (strong, nonatomic) NSURL * url;
@property (strong, nonatomic) UIImage * image;
@end

@implementation PRImageFetcher {
    NSMapTable/*object -> (object, url, image)*/ * _map1;
    NSMapTable/*object -> (object, url, image)*/ * _map2;
    
}

- (void)deferredAssignUrl:(NSURL *)url toObject:(id)object {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        localUrl <- localForRemote url
        image <- createImage localUrl
        [_map setImage:image forUrl:url]
    });
}

- (void)timerTick {
    for (id object in _map) {
        ObjectWithCompletion * oc = _map[_map];
        oc.completion(oc.object, image)
        
    }
    
//    NSMapTable *
}

@end
