//
//  DownloadOperation.h
//  DownloadFile
//
//  Created by 明亮 on 15/6/12.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadOperation : NSOperation

+ (instancetype)operationWithUrl:(NSURL *)url;

@end
