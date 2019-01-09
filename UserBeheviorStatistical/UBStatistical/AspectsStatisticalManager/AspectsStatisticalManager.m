//
//  AspectsStatisticalManager.m
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/9.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "AspectsStatisticalManager.h"

@implementation AspectsStatisticalManager

+ (instancetype)shareManager{
    static AspectsStatisticalManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (void)runMonitorWithConfiguration:(NSString *)plistFileName{
    [UBS_Monitor statisticEventWith:plistFileName EventKey:kEventTrack];
    [UBS_Monitor statisticEventWith:plistFileName EventKey:kLiftCycleTrack];
}

- (NSDictionary *)getDataFromLocalStorage{
    
    return [UBS_Storage getData];
    
}

- (void)cleanUpLocalStorage{
    [UBS_Storage resetDataBase];
}

@end
