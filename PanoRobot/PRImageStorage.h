#import <Foundation/Foundation.h>

@interface PRImageStorage : NSObject

- (NSURL *)getLocalUrlByRemoteUrl:(NSURL *)url;
- (void)saveFileWithLocalUrl:(NSURL *)localUrl forUrl:(NSURL *)url;

@end
