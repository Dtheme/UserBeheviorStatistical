//
//  AspectsLocalStorage.h
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/7.
//  Copyright © 2019 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTrackModel.h"
#import "LifeCycleTrackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AspectsLocalStorage : NSObject

+ (instancetype)setupStorage;

- (void)saveDataWithEventTrackModel:(EventTrackModel *)model;
- (void)saveDataWithLifeCycleTrackModel:(LifeCycleTrackModel *)model;
- (NSDictionary *)getData;

/**
 清空数据库里的统计数据
 */
- (void)resetDataBase;

@end

NS_ASSUME_NONNULL_END
