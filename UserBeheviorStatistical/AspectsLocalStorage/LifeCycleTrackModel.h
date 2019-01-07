//
//  LifeCycleTrackModel.h
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/7.
//  Copyright © 2019 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCycleTrackModel : NSObject

@property (nonatomic, strong) NSString *controllerName;
@property (nonatomic, assign) float viewDuration;
@property (nonatomic, assign) float startDuration;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) NSString *timestamp;

-(instancetype)initWithControllerName:(NSString *)controllerName
                         viewDuration:(float)viewDuration
                        startDuration:(float)startDuration
                                times:(NSInteger)times
                            timestamp:(NSString *)timestamp;


@end

NS_ASSUME_NONNULL_END
