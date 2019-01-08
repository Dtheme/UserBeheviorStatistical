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
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, assign) NSString *viewControllerID;
@property (nonatomic, assign) double tViewWillAppear;
@property (nonatomic, assign) double tViewDidLoad;
@property (nonatomic, assign) double tViewWillDisappear;

-(instancetype)initWithControllerName:(NSString *)controllerName
                      tViewWillAppear:(double)tViewWillAppear
                         tViewDidLoad:(double)tViewDidLoad
                   tViewWillDisappear:(double)tViewWillDisappear
                                times:(NSInteger)times
                     viewControllerID:(NSString *)viewControllerID;


@end

NS_ASSUME_NONNULL_END
