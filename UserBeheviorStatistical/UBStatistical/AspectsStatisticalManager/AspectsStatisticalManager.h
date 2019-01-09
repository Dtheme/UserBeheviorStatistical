//
//  AspectsStatisticalManager.h
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/9.
//  Copyright © 2019 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AspectsMonitor.h"
#import "AspectsLocalStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AspectsStatisticalManager : NSObject

+ (instancetype)shareManager;

- (void)runMonitorWithConfiguration:(NSString *)plistFileName;

- (NSDictionary *)getDataFromLocalStorage;

- (void)cleanUpLocalStorage;
@end

NS_ASSUME_NONNULL_END
