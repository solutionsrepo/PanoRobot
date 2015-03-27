#import "PRQueueInstance.h"
#import "AsyncToSync.h"

@interface PRQueueInstance ()

@property (strong, nonatomic) NSURLSessionDownloadTask * task;

@end

@implementation PRQueueInstance {
    BOOL _stopped;
}

- (void)_start {
    for (NSNumber * index in _queueOrderedIndicies) {
        NSDictionary * item = _imageItems[ [index integerValue] ];
        NSURL * remoteFileURL = [NSURL URLWithString:item[@"photo_file_url"]];
        
        if (![_imageStorage getLocalUrlByRemoteUrl:remoteFileURL]) {
            __typeof__(self) __weak weakSelf = self;
            NSURL * downloadedFileURL =
            asyncToSync(^(SuccessBlock success, FailureBlock failure) {
                weakSelf.task =
                [[NSURLSession sharedSession]
                 downloadTaskWithURL:remoteFileURL
                 completionHandler:^(NSURL * downloadedFileURL, NSURLResponse *response, NSError *error) {
                     if (!error) {
                         success(downloadedFileURL);
                     } else {
                         failure(error);
                     }
                 }];
                [weakSelf.task resume];
            })();
            
            if (downloadedFileURL) {
                [_imageStorage saveFileWithLocalUrl:downloadedFileURL forUrl:remoteFileURL];
            }
        }
        
        [_passedIndicies addObject:index];
        
        
        if (_stopped) {
            break;
        }
    }
}

- (void)start {
    __typeof__(self) __weak weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf _start];
    });
}


- (void)stop {
    _stopped = YES;
    [_task cancel];
}

@end
