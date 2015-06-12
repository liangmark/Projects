//
//  DownloadOperation.m
//  DownloadFile
//
//  Created by 明亮 on 15/6/12.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

#import "DownloadOperation.h"

@interface DownloadOperation ()<NSURLConnectionDataDelegate>
/**
 *  下载文件
 */
@property (nonatomic, strong) NSURL *url;
/**
 *  当前文件大小
 */
@property (nonatomic, assign) long long currFileSize;
/**
 *  文件总大小
 */
@property (nonatomic, assign) long long totalFileSize;
/**
 *  下载文件保存的全路径
 */
@property (nonatomic, copy) NSString *targetFilePath;
/**
 *  文件输出流对象
 */
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, copy) void (^progressBlock)(float progress);

@property (nonatomic, copy) void (^finishedBlock)(id obj);

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation DownloadOperation

+ (instancetype)operationWithUrl:(NSURL *)url progressBlock:(void (^)(float))progress finishedBlock:(void (^)(id))finished
{
    // 断言
    NSAssert(finished != nil, @"必须设置完成回调函数！");
    DownloadOperation *operation = [[self alloc] init];
    operation.url = url;
    operation.progressBlock = progress;
    operation.finishedBlock = finished;
    return operation;
}

- (void)start
{
    [super start];
}

// 重写main方法，执行下载操作
- (void)main
{
    @autoreleasepool {
        [self download];
    }
    
}

- (void)pause
{
    [self.connection cancel];
}

- (void)download
{
    // 服务器文件信息
    if (![self serverFileInfo])
    {
        // 无法连接到网络
        self.finishedBlock(@"网络异常");
        return;
    }
    // 本地文件信息
    [self localFileInfo];
    if (self.currFileSize == self.totalFileSize) {
        // 文件已经下载到本地
        if (self.progressBlock != nil) {
            self.progressBlock(1.0);
        }
        self.finishedBlock(self.targetFilePath);
        NSLog(@"文件已经被下载了哦！");
        return;
    }
    
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:self.url];
    // 断点续传
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.currFileSize];
    [requestM setValue:range forHTTPHeaderField:@"Range"];
    
     self.connection = [[NSURLConnection alloc] initWithRequest:requestM delegate:self];
    
    // 启动runloop
    [[NSRunLoop currentRunLoop] run];
}

- (BOOL)serverFileInfo
{
    // 创建一个请求
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    // 设置请求的方法为“HEAD”
    requestM.HTTPMethod = @"HEAD";
    
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:requestM returningResponse:&response error:NULL];
    
    if (response != nil) {
        self.totalFileSize = response.expectedContentLength;
        self.targetFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        return YES;
    }
    else {
        NSLog(@"无法获取到服务器文件信息哟！");
        return NO;
    }
}

- (void)localFileInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.targetFilePath]) {
        // 文件存在
        NSDictionary *attrs = [fileManager attributesOfItemAtPath:self.targetFilePath error:NULL];
        self.currFileSize = [attrs fileSize];
        if (self.currFileSize > self.totalFileSize) {
            // 本地文件大于服务器文件
            [fileManager removeItemAtPath:self.targetFilePath error:NULL];
            self.currFileSize = 0;
        }
    }
}

#pragma mark - 代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"接收到响应");
    // 实例化文件输出流
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.targetFilePath append:YES];
    // 打开文件输出流
    [self.outputStream open];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"接收到二进制数据");
    self.currFileSize += data.length;
    float progress = (float)self.currFileSize / self.totalFileSize;
    NSLog(@"%f----%@", progress, [NSThread currentThread]);
    if (self.progressBlock != nil) {
        self.progressBlock(progress);
    }
    // 通过NSFileHandle将数据写入文件
    //[self writeDataByHandle:data];
    
    // 通过文件输出流将数据写入到文件中
    [self.outputStream write:data.bytes maxLength:data.length];
    
}

- (void)writeDataByHandle:(NSData *)data
{
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.targetFilePath];
    if (fileHandle == nil) {
        // 本地还没有目标文件
        [data writeToFile:self.targetFilePath atomically:YES];
    }
    else {
        // 调到文件末尾
        [fileHandle seekToEndOfFile];
        // 写入二进制数据
        [fileHandle writeData:data];
        // 关闭文件
        [fileHandle closeFile];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"失败啦");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 关闭文件输出流
    [self.outputStream close];
    NSLog(@"完成!");
    //NSLog(@"%@", self.targetFilePath);
    self.finishedBlock(self.targetFilePath);
}

@end
