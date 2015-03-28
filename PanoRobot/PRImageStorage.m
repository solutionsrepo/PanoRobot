#import "PRImageStorage.h"
#import <Realm/Realm.h>


@interface RLMImageCacheEntry: RLMObject
@property NSString * remoteUrl;
@property NSString * localFileName;
@end
RLM_ARRAY_TYPE(RLMImageCacheEntry)

@implementation RLMImageCacheEntry
@end


@implementation PRImageStorage {
    dispatch_queue_t _lockQueue;
//    RLMRealm * _realm;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lockQueue = dispatch_queue_create("ru.rtnews.ImageStorageLockQueue", nil);
//        _realm = [[self class] realm];
    }
    return self;
}

+ (RLMRealm *)realm {
    NSURL * url = [[self cacheDirectoryUrl] URLByAppendingPathComponent:@"imageCache.realm"];
    return [RLMRealm realmWithPath:[url path]];
}

+ (NSURL *)cacheDirectoryUrl {
    return
    [NSURL fileURLWithPath:
     NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]];
}


- (NSURL *)getLocalUrlByRemoteUrl:(NSURL *)url {
    __block NSURL * localUrl;
    
    dispatch_sync(_lockQueue, ^{
        RLMResults * result =
        [RLMImageCacheEntry objectsInRealm:[[self class] realm] where:[NSString stringWithFormat:@"remoteUrl = '%@'", [url absoluteString]]];
        if ([result count] > 0) {
            NSString * localFileName = [(RLMImageCacheEntry *)[result firstObject] localFileName];
            localUrl = [[[self class] cacheDirectoryUrl] URLByAppendingPathComponent:localFileName];
        }
    });
    
    return localUrl;
}

- (void)saveFileWithLocalUrl:(NSURL *)localUrl forUrl:(NSURL *)url {
    NSURL * randomFileUrl =
    [[[self class] cacheDirectoryUrl] URLByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
    
    NSError * error;
    [[NSFileManager defaultManager] copyItemAtURL:localUrl toURL:randomFileUrl error:&error];
    
    dispatch_sync(_lockQueue, ^{
        RLMRealm * r = [[self class] realm];
        
        RLMResults * result =
        [RLMImageCacheEntry objectsInRealm:[[self class] realm] where:[NSString stringWithFormat:@"remoteUrl = '%@'", [url absoluteString]]];
        
        if ([result count] == 0) {
            RLMImageCacheEntry * entry = [[RLMImageCacheEntry alloc] init];
            
            entry.remoteUrl = [url absoluteString];
            entry.localFileName = [randomFileUrl lastPathComponent];
            
            NSLog(@"saving file: %@", randomFileUrl);
            
            [r transactionWithBlock:^{
                [r addObject:entry];
            }];
        }
    });
}

@end
