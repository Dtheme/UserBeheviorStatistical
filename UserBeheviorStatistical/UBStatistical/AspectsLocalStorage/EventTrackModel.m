//
//  EventTrackModel.m
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/7.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "EventTrackModel.h"

@implementation EventTrackModel

- (instancetype)initWithControllerName:(NSString *)controllerName
                                      eventID:(NSString *)eventID
                                    mSelector:(NSString *)mSelector
                                        times:(NSInteger)times
                                    timestamp:(NSString *)timestamp
{
    if (self = [super init]) {
        _controllerName = controllerName;
        _eventID = eventID;
        _mSelector = mSelector;
        _times = times;
        _timestamp = timestamp;
    }
    return self;
}



@end
