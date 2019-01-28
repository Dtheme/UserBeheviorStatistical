//
//  AspectsStatisticalManager.m
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/9.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "AspectsStatisticalManager.h"
#import <objc/runtime.h>
@implementation AspectsStatisticalManager

+ (instancetype)shareManager{
    static AspectsStatisticalManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    NSLog(@"");
    return singleton;
}

- (void)runMonitorWithConfiguration:(NSString *)plistFileName{
    [UBS_Monitor statisticEventWith:plistFileName EventKey:kEventTrack];
    [UBS_Monitor statisticEventWith:plistFileName EventKey:kLiftCycleTrack];
}

- (NSString *)getDataFromLocalStorage{
    
    /*
     {
     EventTrack =     (
     "<EventTrackModel: 0x6000001bcc90>",
     "<EventTrackModel: 0x6000001ba3a0>",
     );
     LiftCycleTrack =     (
     "<LifeCycleTrackModel: 0x600001a648c0>",
     "<LifeCycleTrackModel: 0x600001a64e80>"
     );
     */
    NSDictionary *dict = [UBS_Storage getData];
    NSMutableArray *ETs = [NSMutableArray array];
    NSMutableArray *LCTs = [NSMutableArray array];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (EventTrackModel* model in dict[kEventTrack]) {
        NSDictionary * modelDic = [self deserializationObject:model];
        [ETs addObject:modelDic];
        [resultDic setObject:ETs forKey:kEventTrack];
    }
    for (LifeCycleTrackModel *model in dict[kLiftCycleTrack]) {
        NSDictionary * modelDic = [self deserializationObject:model];
        [LCTs addObject:modelDic];
        [resultDic setObject:LCTs forKey:kLiftCycleTrack];
    }

     NSError *parseError = nil;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:&parseError];
     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonString copy];
}

- (void)cleanUpLocalStorage{
    [UBS_Storage resetDataBase];
}



- (NSDictionary *)deserializationObject:(id)object {
    NSMutableDictionary *propsDic = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [propsDic setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return propsDic;
}
@end
