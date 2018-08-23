//
//  TFConcurrentOperation.m
//  TestNSOperation
//
//  Created by tantan fan on 2018/8/23.
//  Copyright © 2018年 tantan fan. All rights reserved.
//

#import "TFConcurrentOperation.h"

@interface TFConcurrentOperation ()

@property (strong, nonatomic) NSURLConnection *connection;

@property (strong, nonatomic) NSMutableData *data;

@property (assign, nonatomic) CFRunLoopRef operationRunLoop;

@end

@implementation TFConcurrentOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

/**
 重写
 */
- (BOOL)isConcurrent {
    return true;
}

/**
 重写
 */
- (void)start {
    if (self.cancelled) {
        [self finish];
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = true;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSURL *url = [NSURL URLWithString:@"http://img03.tooopen.com/uploadfile/downs/images/20110714/sy_20110714135215645030.jpg"];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [weakSelf finish];
        }else {
            if (!weakSelf.data) {
                weakSelf.data = [NSMutableData data];
            }
            [weakSelf.data appendData:data];
//            if (weakSelf.operationRunLoop) {
//                CFRunLoopStop(weakSelf.operationRunLoop);
//            }
            if (weakSelf.isCancelled) {
                return;
            }
            [weakSelf finish];
        }
    }];
    
    [task resume];
    
//    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
//    BOOL backgroundQueue = (currentQueue != nil && currentQueue != [NSOperationQueue mainQueue]);
//
//    NSRunLoop *targetRunLoop = backgroundQueue ? [NSRunLoop currentRunLoop] : [NSRunLoop mainRunLoop];
    
//    [self.connection scheduleInRunLoop:targetRunLoop forMode:NSRunLoopCommonModes];
//
//    // make NSRunLoop stick around until operation is finished
//    if (backgroundQueue) {
//        self.operationRunLoop = CFRunLoopGetCurrent();
//        CFRunLoopRun();
//    }
}

/**
 重写
 */
- (void)cancel {
    if (!_executing) {
        return;
    }
    [super cancel];
    [self finish];
}

- (void)finish {
    self.connection = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _executing = false;
    _finished = true;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    if (self.comBlock) {
        self.comBlock(_data);
    }
}

@end
