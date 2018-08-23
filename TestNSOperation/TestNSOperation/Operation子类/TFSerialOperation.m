//
//  TFSerialOperation.m
//  TestNSOperation
//
//  Created by tantan fan on 2018/8/23.
//  Copyright © 2018年 tantan fan. All rights reserved.
//

#import "TFSerialOperation.h"

@implementation TFSerialOperation

- (void)main {
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        NSURL *url = [NSURL URLWithString:@"http://img03.tooopen.com/uploadfile/downs/images/20110714/sy_20110714135215645030.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if (!imageData) {
            imageData = nil;
        }
        if (self.isCancelled) {
            return;
        }
        [self performSelectorOnMainThread:@selector(completionAction:) withObject:imageData waitUntilDone:false];
    }
}

- (void)completionAction:(NSData *)imageData {
    if (self.comBlock) {
        self.comBlock(imageData);
    }
}

@end
