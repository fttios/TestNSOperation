//
//  ViewController.m
//  TestNSOperation
//
//  Created by tantan fan on 2018/8/22.
//  Copyright © 2018年 tantan fan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self invocationOperation];
//    [self blockOperationAddTask];
    
//    [self addOperationToQueue];
//    [self addOperationWithBlockToQueue];
    
    [self operateDependency];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// MARK: - NSInvocationOperation
- (void)invocationOperation {
    NSInvocationOperation *invOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(runOperation) object:nil];
    [invOperation setCompletionBlock:^{
        NSLog(@"invOperation --- 任务完成回调");
    }];
    [invOperation start];
}

- (void)runOperation {
    NSLog(@"当前线程 invocationOperation --- %@",[NSThread currentThread]);
}


// MARK: - NSBlockOperation
- (void)blockOperationAddTask {
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation --- %@",[NSThread currentThread]);
    }];
    for (int i = 0; i < 5; i++) {
        [blockOp addExecutionBlock:^{
            NSLog(@"%d --- blockOperationaddExecution --- %@",i, [NSThread currentThread]);
        }];
    }
    [blockOp start];
}


// MARK: - NSOperationQueue
- (void)addOperationToQueue {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(testQueue) object:nil];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"op2---->%d-----%@", i,[NSThread currentThread]);
        }
    }];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    
}

- (void)testQueue {
    for (int i = 0; i < 5; i++) {
        NSLog(@"op1---->%d-----%@", i,[NSThread currentThread]);
    }
}

- (void)addOperationWithBlockToQueue {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    queue.maxConcurrentOperationCount = 5;
    
    for (int i = 0; i < 5; i++) {
        [queue addOperationWithBlock:^{
            NSLog(@"%d-----%@",i, [NSThread currentThread]);
        }];
    }
}


// MARK: - 操作依赖
#pragma mark --------------操作依赖
- (void)operateDependency {
    
    // 创建任务
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"________第%d个任务%@____",i,[NSThread currentThread]);
        }];
        op.name = [NSString stringWithFormat:@"op%d",i];
        [arr addObject:op];
    }
    
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.name = @"queue";
    
    //设置依赖，可以跨队列依赖
    for (int i = 0; i < arr.count - 1; i++) {
        // 依次依赖，等同于同步执行
        NSBlockOperation *op1 = arr[i];
        NSBlockOperation *op2 = arr[i+1];
        [op2 addDependency:op1];
        
//        // 修改 operation 在队列中的优先级
//        if (i == 6) {
//            op1.queuePriority = NSOperationQueuePriorityVeryHigh;
////            [op1 setQueuePriority:NSOperationQueuePriorityVeryHigh];
//        }
//
//        //删除依赖
//        if (i > 4) {
//            [op2 removeDependency:op1];
//        }
    }
    
//    // 需求：第 5 个任务完成后取消队列任务
//    NSBlockOperation *operation = arr[4];
//    [operation setCompletionBlock:^{
//        [queue cancelAllOperations];
//    }];
    
    [queue addOperations:arr waitUntilFinished:false];
}



// MARK: - NSOperation 方法使用
/**
 
 ******************************NSOperation方法：************************************
     BOOL cancelled;//判断任务是否取消
     BOOL executing; //判断任务是否正在执行
     BOOL finished; //判断任务是否完成
     BOOL concurrent;//判断任务是否是并发
     NSOperationQueuePriority queuePriority;//修改 Operation 执行任务线程的优先级
     void (^completionBlock)(void) //用来设置完成后需要执行的操作
     - (void)cancel; //取消任务
     - (void)waitUntilFinished; //阻塞当前线程直到此任务执行完毕
 
 
 ******************************NSOperation Queue方法：************************************
     NSUInteger operationCount; //获取队列的任务数
     - (void)cancelAllOperations; //取消队列中所有的任务
     - (void)waitUntilAllOperationsAreFinished; //阻塞当前线程直到此队列中的所有任务执行完毕
     [queue setSuspended:YES]; // 暂停queue
     [queue setSuspended:NO]; // 继续queue
 */



@end
