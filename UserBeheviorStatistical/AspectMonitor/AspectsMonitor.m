//
//  AspectsMonitor.m
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/2.
//  Copyright © 2019 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AspectsMonitor.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import <Aspects/Aspects.h>

#ifdef DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

typedef enum : NSUInteger {
    EventTypeDefultWithoutParams,
    EventTypeDefultWithParams,
    EventTypeTableView,
} EventType;

@implementation AspectsMonitor

+ (instancetype)setupMonitor{
    static AspectsMonitor *shareMonitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMonitor = [[self alloc] init];
    });
    return shareMonitor;
}


-(void)statisticVCLifeCycleWith:(NSString *)fileName viewControllerKey:(NSString *)kViewController{

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //读取配置文件，获取需要统计停留时长、点击次数的页面
        [weakSelf trackViewTimeWithClass:(NSArray *)[self getConfigurationFrom:fileName kItem:kViewController]];

    });
}


-(void)statisticEventWith:(NSString *)fileName EventKey:(NSString *)kEvent{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSDictionary *eventTrack = [self getConfigurationFrom:fileName kItem:kEvent];
        for (NSString *classNameString in eventTrack.allKeys) {
            
            const char * className = [classNameString UTF8String];
            Class newClass = objc_getClass(className);
            NSArray *pageEventList = [eventTrack objectForKey:classNameString];
            
            for (NSDictionary *eventDict in pageEventList) {
                NSString *eventMethodName = eventDict[@"mSelector"];
                SEL seletor = NSSelectorFromString(eventMethodName);
                NSString *eventId = eventDict[@"eventId"];
                NSInteger eventType = [eventDict[@"eventType"] integerValue];
                switch (eventType) {
                        
                        //事件类型：0：带参 普通按钮等控件响应事件
                        //        1：不带参 按钮等控件响应事件
                        //        2：tableview的代理事件
                        // 这个可以通过plist文件自定义，然后在这里针对不同类型的事件进行扩充
                    case 0:
                        [weakSelf trackParameterEventWithClass:newClass selector:seletor eventID:eventId];
                        break;
                        
                    case 1:
                        [weakSelf trackEventWithClass:newClass selector:seletor eventID:eventId];
                        break;
                        
                    case 2:
                        [weakSelf trackTableViewEventWithClass:newClass selector:seletor eventID:eventId];
                        break;
                        
                    default:
                        break;
                }
                
            }
        }
    });
}


- (void)trackViewTimeWithClass:(NSArray *)classes{
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        if ([classes containsObject:NSStringFromClass([info.instance class])]){
            
            //用户统计代码写在此处
            NSLog(@"统计:%@ viewWillAppear",NSStringFromClass([info.instance class]));
            
        }


    } error:NULL];
    
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>info){
        if ([classes containsObject:NSStringFromClass([info.instance class])]){
            //用户统计代码写在此处
            NSLog(@"统计:%@ viewDidLoad",NSStringFromClass([info.instance class]));
        }
    } error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        if ([classes containsObject:NSStringFromClass([info.instance class])]){
            //用户统计代码写在此处
            NSLog(@"统计:%@ viewWillDisappear",NSStringFromClass([info.instance class]));
        }
    }error:NULL];
    
}

//MARK: -  不带参数的按钮等事件
- (void)trackEventWithClass:(Class)class selector:(SEL)selector eventID:(NSString*)eventID{
    
    [class aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        //vc
        NSString *className = NSStringFromClass([aspectInfo.instance class]);
        NSLog(@"className--->%@",className);
        NSLog(@"event----->%@",eventID);
        //针对指定事件进行统计
        if ([eventID isEqualToString:@"xxx"]) {

        }else{

        }
    } error:NULL];
}


//MARK: -  带参数的按钮等事件
- (void)trackParameterEventWithClass:(Class)class selector:(SEL)selector eventID:(NSString*)eventID{
    
    [class aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,UIButton *button) {
        
        NSLog(@"button---->%@",button);
        NSString *className = NSStringFromClass([aspectInfo.instance class]);
        NSLog(@"className--->%@",className);
        NSLog(@"event----->%@",eventID);
        
    } error:NULL];
}


//MARK: -  监控tableview的代理函数等
- (void)trackTableViewEventWithClass:(Class)class selector:(SEL)selector eventID:(NSString*)eventID{
    NSLog(@"%s",object_getClassName(class));
    
    [class aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,NSSet *touches, UIEvent *event) {
        
        NSString *className = NSStringFromClass([aspectInfo.instance class]);
        NSLog(@"className--->%@",className);
        NSLog(@"event----->%@",eventID);
        NSLog(@"section---->%@",[event valueForKeyPath:@"section"]);
        NSLog(@"row---->%@",[event valueForKeyPath:@"row"]);
        NSInteger section = [[event valueForKeyPath:@"section"]integerValue];
        NSInteger row = [[event valueForKeyPath:@"row"]integerValue];
        
        //针对指定事件进行统计
        if (section == 0 && row == 1) {

        }
        
    } error:NULL];
}


/**
 从源配置plist文件中获取需要统计的配置信息

 @param fileName plist文件名
 @param kItem 指定的统计的项目
 e.g.:我这里定义的AspectsList.plist包括2个item：EventTrack（时间追踪）、LiftCycleTrack（页面生命周期追踪，统计页面停留时长，页面启动时长等）
 @return 返回指定item的内容 NSDictionary类型
 */
- (NSDictionary *)getConfigurationFrom:(NSString *)fileName kItem:(NSString *)kItem{
    NSArray * file = [fileName componentsSeparatedByString:@"."];
    NSString *path = [[NSBundle mainBundle] pathForResource:file[0] ofType:file[1]];
    NSDictionary *sourceDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *trackItem = sourceDict[kItem];
    return [trackItem copy];
}

@end
