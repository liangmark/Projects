//
//  ViewController.m
//  UploadFiles
//
//  Created by 明亮 on 15/6/10.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

#import "ViewController.h"

#define UPLOAD_BOUNDARY @"upload_zhssit_boundary"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i = 0; i < 3; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%03d.jpg", i + 1];
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [dict setObject:data forKey:url];
    }
    
    NSDictionary *params = @{@"status":@"What a nice day it is today."};
    
    [self uploadFiles:dict.copy fieldName:@"userfile[]" params:params];
}



- (void)uploadFiles:(NSDictionary *)fileDatas fieldName:(NSString *)fieldName params:(NSDictionary *) params
{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload-m.php"];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.HTTPMethod = @"POST";
    NSString *type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", UPLOAD_BOUNDARY];
    [requestM setValue:type forHTTPHeaderField:@"Content-Type"];
    // 设置请求体
    requestM.HTTPBody = [self fileDatas:fileDatas fieldName:fieldName params:params];
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:requestM queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"Upload Completed!");
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@----%@", [result class], result);
    }];
}

- (NSData *)fileDatas:(NSDictionary *)fileDatas fieldName:(NSString *)fieldName params:(NSDictionary *)params
{
    NSMutableData *dataM = [NSMutableData data];
    
    // 1. 上传文件 - 遍历字典
    /**
     --随便\r\n
     Content-Disposition: form-data; name="userfile[]"; filename="aaa.txt"\r\n
     Content-Type: text/plain\r\n\r\n
     
     文件的二进制数据
     \r\n
     */
    [fileDatas enumerateKeysAndObjectsUsingBlock:^(NSString *fileName, NSData *fileData, BOOL *stop) {
        NSMutableString *strM = [NSMutableString string];
        
        [strM appendFormat:@"--%@\r\n", UPLOAD_BOUNDARY];
        [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName];
        [strM appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
        
        // 插入 strM
        [dataM appendData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
        // 文件数据
        [dataM appendData:fileData];
        
        [dataM appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    // 文本内容
    /**
     --随便\r\n
     Content-Disposition: form-data; name="status"\r\n\r\n
     
     文字的字符串
     \r\n
     */
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableString *strM = [NSMutableString string];
        
        [strM appendFormat:@"--%@\r\n", UPLOAD_BOUNDARY];
        [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
        [strM appendFormat:@"%@\r\n", obj];
        
        // 添加到 dataM
        [dataM appendData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
    }];


    NSString *end = [NSString stringWithFormat:@"--%@--", UPLOAD_BOUNDARY];
    [dataM appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    return dataM.copy;
}



@end
