//
//  LifeCycleTrackModel.m
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/7.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "LifeCycleTrackModel.h"

@implementation LifeCycleTrackModel

-(instancetype)initWithControllerName:(NSString *)controllerName
                         viewDuration:(float)viewDuration
                        startDuration:(float)startDuration
                                times:(NSInteger)times
                            timestamp:(NSString *)timestamp
{
    if (self = [super init]) {
        _controllerName = controllerName;
        _viewDuration = viewDuration;
        _startDuration = startDuration;
        _times = times;
        _timestamp = timestamp;
    }
    return self;
}

@end
