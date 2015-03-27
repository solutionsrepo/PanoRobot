#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id);
typedef void (^FailureBlock)(id);

typedef void (^AsyncBlock)(SuccessBlock, FailureBlock);
typedef id (^SyncBlock)();

SyncBlock asyncToSync(AsyncBlock async);
