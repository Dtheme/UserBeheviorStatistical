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
                      tViewWillAppear:(double)tViewWillAppear
                         tViewDidLoad:(double)tViewDidLoad
                   tViewWillDisappear:(double)tViewWillDisappear
                                times:(NSInteger)times
                     viewControllerID:(NSString *)viewControllerID;
{
    if (self = [super init]) {
        _controllerName = controllerName;
        _viewControllerID = controllerName;
        _tViewDidLoad = tViewDidLoad;
        _tViewWillAppear = tViewWillAppear;
        _tViewWillDisappear = tViewWillDisappear;
        _times = times;
        _viewControllerID = viewControllerID;
    }
    return self;
}

@end
