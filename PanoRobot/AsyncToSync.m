#import "AsyncToSync.h"

/*
asyncToSync :: ((success -> IO ()) -> (failure -> IO ()) -> IO ()) -> IO (Maybe success)
asyncToSync async = do
 mSuccess <- newEmptyMVar
 async (\s -> putMVar mSuccess $ Just s) (\_ -> putMVar mSuccess Nothing)
 takeMVar mSuccess
 */

SyncBlock asyncToSync(AsyncBlock async) {
    return ^id{
        __block id mSuccess; // will be nil in failure case
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        async(^(id success){
            dispatch_semaphore_signal(semaphore);
            mSuccess = success;
        }, ^(id failure){
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // dispatch_release(semaphore);
        
        return mSuccess;
    };
}
