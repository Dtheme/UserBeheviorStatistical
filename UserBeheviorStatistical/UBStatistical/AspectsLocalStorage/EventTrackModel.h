//
//  EventTrackModel.h
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/7.
//  Copyright © 2019 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTrackModel : NSObject

@property (nonatomic, strong) NSString *controllerName;
@property (nonatomic, strong) NSString *eventID;
//@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *mSelector;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) NSString *timestamp;

- (instancetype)initWithControllerName:(NSString *)controllerName
                                      eventID:(NSString *)eventID
                                    mSelector:(NSString *)mSelector
                                        times:(NSInteger)times
                                    timestamp:(NSString *)timestamp;


@end

NS_ASSUME_NONNULL_END
