//
//  TFConcurrentOperation.h
//  TestNSOperation
//
//  Created by tantan fan on 2018/8/23.
//  Copyright © 2018年 tantan fan. All rights reserved.
//

/** 并发的NSOperation 子类 */
#import <Foundation/Foundation.h>

typedef void(^TFCompletionBlock)(NSData *imageData);

@interface TFConcurrentOperation : NSOperation

@property (copy, nonatomic) TFCompletionBlock comBlock;

@end
