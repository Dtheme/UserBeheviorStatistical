//
//  AspectsLocalStorage.m
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/7.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "AspectsLocalStorage.h"
#import "FMDB.h"
#import <pthread.h>

#define kControllerName @"controllerName"
#define kViewWillAppear tViewWillAppear
#define kViewDidLoad tViewDidLoad
#define kViewWillDisappear tViewWillDisappear
#define kTimes times

@interface AspectsLocalStorage ()
@property (nonatomic,strong) FMDatabase *database;
@end

@implementation AspectsLocalStorage

pthread_mutex_t lock;

+ (instancetype)setupStorage{
    static AspectsLocalStorage *shareStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareStorage = [[self alloc] init];
        pthread_mutex_init(&lock, NULL);
    });
    return shareStorage;
}

//done
-(void)saveDataWithEventTrackModel:(EventTrackModel *)model{
    pthread_mutex_lock(&lock);
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/userbehevior.db"];
    self.database = [FMDatabase databaseWithPath:path];
    if (![_database open]) {
        [_database close];
    }
    
    if (![_database tableExists:@"EventTrackTable"]) {
        [_database executeUpdate:@"CREATE TABLE EventTrackTable (controllerName TEXT,event_id INTEGER,mSelector TEXT,times INTEGER, timestamp TEXT)"];
        [_database executeUpdate:@"INSERT INTO EventTrackTable VALUES(?,?,?,?,?)",model.controllerName,model.eventID,model.mSelector,model.times,model.timestamp];
        
        NSLog(@"EventTrackTable表添加成功");
    }else{
        NSMutableArray *EventTrackArray = [NSMutableArray array];
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM EventTrackTable"];
        while ([resultSet next]) {
            NSString *eventID = [resultSet stringForColumn:@"event_id"];
            [EventTrackArray addObject:eventID];
        }
        if (![EventTrackArray containsObject:model.eventID]) {//如果没有这个id 插入这条数据
            [_database executeUpdate:@"INSERT INTO EventTrackTable VALUES(?,?,?,?,?);",model.controllerName,model.eventID,model.mSelector,@(model.times),model.timestamp];
            NSLog(@"插入数据成功");
            [_database close];
        }else{//如果有这个id的数据，更新这条数据
            FMResultSet *targetData = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM EventTrackTable WHERE event_id = '%@';",model.eventID]];
            while ([targetData next]) {
                NSInteger times = [targetData intForColumn:@"times"];//model.times = 1
                model.times = times + 1;
            }
            NSLog(@"%d",[targetData intForColumn:@"times"]);
            [_database executeUpdate:@"UPDATE EventTrackTable SET times = ? ,timestamp = ? WHERE event_id = ? ;",@(model.times), model.timestamp,model.eventID];
             [_database close];
            NSLog(@"更新数据成功");
        }
    }
    pthread_mutex_unlock(&lock);

}


-(void)saveDataWithLifeCycleTrackModel:(LifeCycleTrackModel *)model{
    pthread_mutex_lock(&lock);
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/userbehevior.db"];
    self.database = [FMDatabase databaseWithPath:path];
    if (![_database open]) {
        [_database close];
        NSLog(@"打开数据库失败");
        return;
    }

    if (![_database tableExists:@"LifeCycleTrackTable"]) {
        [_database executeUpdate:@"CREATE TABLE LifeCycleTrackTable (viewController_id TEXT, controllerName TEXT,tViewWillAppear DOUBLE,tViewDidLoad DOUBLE, tViewWillDisappear DOUBLE,times INTEGER)"];
        [_database executeUpdate:@"INSERT INTO LifeCycleTrackTable  VALUES(?,?,?,?,?,?)",model.controllerName ,model.controllerName, @(model.tViewWillAppear),@(model.tViewDidLoad), @(model.tViewWillDisappear),@(model.times)];
        NSLog(@"LifeCycleTrackTable表添加成功");
    }else{
        NSMutableArray *LifeCycleTrackArray = [NSMutableArray array];
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM LifeCycleTrackTable"];
        while ([resultSet next]) {
            NSString *vc_id = [resultSet stringForColumn:@"controller_id"];
            [LifeCycleTrackArray addObject:vc_id];
        }
//        if (![LifeCycleTrackArray containsObject:model.viewControllerID]) {//如果没有这个viewControllerID 插入这条数据  
            [_database executeUpdate:@"INSERT INTO LifeCycleTrackTable  VALUES(?,?,?,?,?,?)",model.viewControllerID,model.controllerName,  @(model.tViewWillAppear),@(model.tViewDidLoad), @(model.tViewWillDisappear),@(model.times)];
            NSLog(@"插入数据成功");
            [_database close];
//        }else{//如果有这个controllerName的数据，更新这条数据
//
//            FMResultSet *targetData = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM LifeCycleTrackTable WHERE controllerName = '%@';",model.controllerName]];
//            NSInteger times = 0;
//            NSString *vc_name =[NSString string];
//            double tViewWillAppear,tViewDidLoad,tViewWillDisappear;
//            while ([resultSet next]) {
//                times = [targetData intForColumn:@"times"];
//                vc_name = [resultSet stringForColumn:@"controllerName"];
//                tViewWillAppear = [resultSet doubleForColumn:@"tViewWillAppear"];
//                tViewDidLoad = [resultSet doubleForColumn:@"tViewDidLoad"];
//                tViewWillDisappear = [resultSet doubleForColumn:@"tViewWillDisappear"];
//                [LifeCycleTrackArray addObject:vc_name];
//
//            }
//
//            if (model.tViewWillDisappear != 0){
//                [_database executeUpdate:@"UPDATE LifeCycleTrackTable SET TIMES = ? tViewWillAppear = ?  WHERE viewController_id = '?'",@(times + model.times), @(model.tViewWillAppear),model.viewControllerID];
//            }else if(model.tViewDidLoad != 0){
//                [_database executeUpdate:@"UPDATE LifeCycleTrackTable SET TIMES = ? tViewDidLoad = ?  WHERE viewController_id = '?'",@(times + model.times), @(model.tViewDidLoad),model.viewControllerID];
//            }else if(model.tViewWillDisappear != 0){
//                [_database executeUpdate:@"UPDATE LifeCycleTrackTable SET TIMES = ? tViewWillDisappear = ?  WHERE viewController_id = '?'",@(times + model.times), @(model.tViewWillDisappear),model.viewControllerID];
//
//            }
//            [_database close];
//            NSLog(@"更新数据成功");
//        }
    }
    pthread_mutex_unlock(&lock);
}



- (NSDictionary *)getData{
    
    NSLog(@"开始查找数据...");
    NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/userbehevior.db"];
    _database=[FMDatabase databaseWithPath:path];
    if (![_database open]) {
        [_database close];
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if ([_database tableExists:@"EventTrackTable"]) {
        FMResultSet *resultset=[_database executeQuery:@"SELECT * FROM EventTrackTable"];
        NSMutableArray *EventTrackArr = [NSMutableArray array];
        while ([resultset next]) {
            NSString *vcName = [resultset stringForColumn:@"controllerName"];
            NSString *eventID = [resultset stringForColumn:@"eventID"];
            NSString *mSelector = [resultset stringForColumn:@"mSelector"];
            NSInteger times = [resultset intForColumn:@"times"];
            NSString *timestamp = [resultset stringForColumn:@"timestamp"];
            EventTrackModel *eventModel = [[EventTrackModel alloc]initWithControllerName:vcName
                                                                                 eventID:eventID
                                                                               mSelector:mSelector
                                                                                   times:times
                                                                               timestamp:timestamp];
            eventModel.controllerName = vcName;
            eventModel.eventID = eventID;
            eventModel.mSelector = mSelector;
            eventModel.times = times;
            eventModel.timestamp = timestamp;
            [EventTrackArr addObject:eventModel];
            [result setObject:EventTrackArr forKey:kEventTrack];
        }
    }
    if ([_database tableExists:@"LifeCycleTrackTable"]){
        FMResultSet *resultset=[_database executeQuery:@"SELECT * FROM LifeCycleTrackTable"];
        NSMutableArray *LifeCycleTrackArr = [NSMutableArray array];
        while ([resultset next]) {
            NSString *vcID  = [resultset stringForColumn:@"viewController_id"];
            NSString *vcName = [resultset stringForColumn:@"controllerName"];
            double tViewWillAppear = [resultset doubleForColumn:@"tViewWillAppear"];
            double tViewDidLoad = [resultset doubleForColumn:@"tViewDidLoad"];
            double tViewWillDisappear = [resultset doubleForColumn:@"tViewWillDisappear"];
            NSInteger times = [resultset intForColumn:@"times"];
            
            LifeCycleTrackModel *vcModel = [[LifeCycleTrackModel alloc]initWithControllerName:vcName tViewWillAppear:tViewWillAppear tViewDidLoad:tViewDidLoad tViewWillDisappear:tViewWillDisappear times:times  viewControllerID:vcID];
            [LifeCycleTrackArr addObject:vcModel];
            [result setObject:LifeCycleTrackArr forKey:kLiftCycleTrack];
        }
    }
    NSLog(@"已查到数据...");
    return [result copy];
    //MARK: -  返回用户点击轨迹数据和用户页面访问轨迹 返回字典
    
}

- (void)resetDataBase{
    
    //清空本地缓存数据 清理自增字段
    [_database executeUpdate:@"DELETE FROM EventTrackTable"];
    [_database executeUpdate:@"DELETE FROM LifeCycleTrackTable"];
    [_database executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='viewController_id'"];
}

@end
