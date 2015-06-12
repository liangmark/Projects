//
//  DownloadManager.h
//  DownloadFile
//
//  Created by 明亮 on 15/6/12.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

+ (instancetype)sharedManager;
/**
 *  下载指定URL的文件
 *
 *  @param url      <#url description#>
 *  @param progress <#progress description#>
 *  @param finished <#finished description#>
 */
- (void)downloadWithUrl:(NSURL *)url progressBlock:(void(^)(float progress))progress finishedBlock:(void(^)(id obj))finished;
/**
 *  暂停指定URL的下载任务
 */
- (void)pause:(NSURL *)url;

@end
