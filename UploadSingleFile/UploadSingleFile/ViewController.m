//
//  ViewController.m
//  UploadSingleFile
//
//  Created by 明亮 on 15/6/10.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

#import "ViewController.h"

#define UPLOAD_BOUNDARY @"zhssit_upload_boundary"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 要上传的文件URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"demo.jpg" withExtension:nil];
    // 将要上传的文件转换成二进制数据
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    // 上传
    [self uploadFileData:fileData fieldName:@"userfile" fileName:@"test.jpg"];
}


- (void)uploadFileData:(NSData *)fileData fieldName:(NSString *)fieldName fileName:(NSString *)fileName
{
    // 创建URL
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload.php"];
    // 创建请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    // 设置请求的Method
    requestM.HTTPMethod = @"POST";
    // 设置Content-Type
    NSString *type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", UPLOAD_BOUNDARY];
    [requestM setValue:type forHTTPHeaderField:@"Content-Type"];
    // 设置请求体
    requestM.HTTPBody = [self fileData:fileData fieldName:fieldName fileName:fileName];
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:requestM queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"Upload Completed!");
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@-----%@", [result class], result);
    }];
}

- (NSData *)fileData:(NSData *)data fieldName:(NSString *)fieldName fileName:(NSString *)fileName
{
    NSMutableData *dataM = [NSMutableData data];
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"--%@\r\n", UPLOAD_BOUNDARY];
    [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName];
    [strM appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
    [dataM appendData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
    // 追加文件数据
    [dataM appendData:data];
    NSString *end = [NSString stringWithFormat:@"\r\n--%@--", UPLOAD_BOUNDARY];
    [dataM appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    return dataM.copy;
}


@end
