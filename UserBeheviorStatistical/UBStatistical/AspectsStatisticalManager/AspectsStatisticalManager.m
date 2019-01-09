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
        NSDictionary * modelDic = [self dicFromObject:model];
        [ETs addObject:modelDic];
        [resultDic setObject:ETs forKey:kEventTrack];
    }
    for (LifeCycleTrackModel *model in dict[kLiftCycleTrack]) {
        NSDictionary * modelDic = [self dicFromObject:model];
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



- (NSDictionary *)dicFromObject:(id)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        value == nil?[dic setObject:[NSNull null] forKey:name]:[dic setObject:[self dicFromObject:value] forKey:name];
    }
    return [dic copy];
}
@end
