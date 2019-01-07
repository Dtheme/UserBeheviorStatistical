//
//  AspectsMonitor.h
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/2.
//  Copyright © 2019 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AspectsMonitor : NSObject

+ (instancetype)setupMonitor;

/**
 配置需要监控生命周期的页面

 @param fileName plist文件名
 @param kViewController plist中配置的需要监控声明周期的vc数组的key
 */
- (void)statisticVCLifeCycleWith:(NSString *)fileName viewControllerKey:(NSString *)kViewController;

/**
 配置需要监控的事件

 @param fileName plist文件名
 @param kEvent plist中配置的需要监控的事件的key
 */
- (void)statisticEventWith:(NSString *)fileName EventKey:(NSString *)kEvent;

@end
