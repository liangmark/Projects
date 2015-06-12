//
//  DownloadManager.m
//  DownloadFile
//
//  Created by 明亮 on 15/6/12.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadOperation.h"

@interface DownloadManager ()

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableDictionary *operationCache;

@end

@implementation DownloadManager

+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)downloadWithUrl:(NSURL *)url progressBlock:(void (^)(float))progress finishedBlock:(void (^)(id))finished
{
    if (self.operationCache[url] != nil) {
        // 当前正在下载中
        NSLog(@"下载正在进行中...");
        return;
    }
    DownloadOperation *operation = [DownloadOperation operationWithUrl:url progressBlock:progress finishedBlock:^(id obj) {
        // 下载完成，从缓存中移除operation
        [self.operationCache removeObjectForKey:url];
        // 调用回调函数
        finished(obj);
    }];
    // 将operation添加到队列中
    [self.queue addOperation:operation];
    // 将operation添加到缓存中
    [self.operationCache setObject:operation forKey:url];
}

- (void)pause:(NSURL *)url
{
    if (self.operationCache[url] == nil) {
        NSLog(@"没有找到指定的下载任务哟!");
    }
    else {
        // 这里不能用operation的cancel，应为operation的cancel是要执行完当前操作，不执行下次操作
        [self.operationCache[url] pause];
        [self.operationCache removeObjectForKey:url];
    }
}


- (NSMutableDictionary *)operationCache
{
    if (_operationCache == nil) {
        _operationCache = [NSMutableDictionary dictionary];
    }
    return _operationCache;
}

- (NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

@end
