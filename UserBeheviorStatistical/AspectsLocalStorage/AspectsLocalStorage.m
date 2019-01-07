//
//  AspectsLocalStorage.m
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/7.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "AspectsLocalStorage.h"
#import "FMDB.h"

@interface AspectsLocalStorage ()

@property (nonatomic,strong) FMDatabase *database;

@end

@implementation AspectsLocalStorage

+ (instancetype)setupStorage{
    static AspectsLocalStorage *shareStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareStorage = [[self alloc] init];
    });
    return shareStorage;
}

-(void)saveDataWithEventTrackModel:(EventTrackModel *)model{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"Documents/userbehevior.db"];
    self.database = [FMDatabase databaseWithPath:path];
    if (![_database open]) {
        [_database close];
    }
    
    if (![_database tableExists:@"EventTrackTable"]) {
        [_database executeUpdate:@"CREATE TABLE EventTrackTable (controllerName TEXT,event_id INTEGER PRIMARY KEY AUTOINCREMENT,eventType TEXT,mSelector TEXT,times INTEGER, timestamp TEXT)"];
         [_database executeUpdate:@"INSERT INTO EventTrackTable VALUES(?,?,?,?,?,?)",model.controllerName,model.eventID,model.eventType,model.mSelector,model.times,model.timestamp];
        NSLog(@"EventTrackTable表添加成功");
    }else{
        NSMutableArray *EventTrackArray = [NSMutableArray array];
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM EventTrackTable"];
        while ([resultSet next]) {
            NSString *eventID = [resultSet stringForColumn:@"event_id"];
            [EventTrackArray addObject:eventID];
        }
        if (![EventTrackArray containsObject:model.eventID]) {//如果没有这个id 插入这条数据
            [_database executeUpdate:@"INSERT INTO EventTrackTable VALUES(?,?,?,?,?,?)",model.controllerName,model.eventID,model.eventType,model.mSelector,model.times,model.timestamp];
            NSLog(@"插入数据成功");
            [_database close];
        }else{//如果有这个id的数据，更新这条数据
            FMResultSet *targetData = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM EventTrackTable WHERE event_id = '%@';",model.eventID]];
            NSInteger times = [targetData intForColumn:@"times"];
            times += 1;
            [_database executeUpdate:@"UPDATE EventTrackTable SET TIMES = ? WHERE event_id = ? timestamp = ?",model.times,model.eventID, model.timestamp];
            NSLog(@"更新数据成功");
        }
    }
}

-(void)saveDataWithLifeCycleTrackModel:(LifeCycleTrackModel *)model{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"Documents/userbehevior.db"];
    self.database = [FMDatabase databaseWithPath:path];
    if (![_database open]) {
        [_database close];
        NSLog(@"打开数据库失败");
        return;
    }
    
    if (![_database tableExists:@"LifeCycleTrackTable"]) {
        [_database executeUpdate:@"CREATE TABLE LifeCycleTrackTable (viewController_id INTEGER PRIMARY KEY AUTOINCREMENT, controllerName TEXT,viewDuration FLOAT,startDuration FLOAT,times INTEGER, timestamp TEXT)"];
        [_database executeUpdate:@"INSERT INTO LifeCycleTrackTable (controllerName,viewDuration,viewDuration,startDuration,times,timestamp) VALUES(?,?,?,?,?)",model.controllerName,model.viewDuration,model.startDuration,model.times,model.timestamp];
        NSLog(@"LifeCycleTrackTable表添加成功");
    }else{
        NSMutableArray *LifeCycleTrackArray = [NSMutableArray array];
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM LifeCycleTrackTable"];
        while ([resultSet next]) {
            NSString *vc_name = [resultSet stringForColumn:@"controllerName"];
            [LifeCycleTrackArray addObject:vc_name];
        }
        if (![LifeCycleTrackArray containsObject:model.controllerName]) {//如果没有这个controllerName 插入这条数据
            [_database executeUpdate:@"INSERT INTO LifeCycleTrackTable (controllerName,viewDuration,viewDuration,startDuration,times,timestamp) VALUES(?,?,?,?,?)",model.controllerName,model.viewDuration,model.startDuration,model.times,model.timestamp];
            NSLog(@"插入数据成功");
            [_database close];
        }else{//如果有这个controllerName的数据，更新这条数据
            FMResultSet *targetData = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM LifeCycleTrackTable WHERE controllerName = '%@';",model.controllerName]];
            NSInteger times = [targetData intForColumn:@"times"];
            times += 1;
            [_database executeUpdate:@"UPDATE LifeCycleTrackTable SET viewDuration = ？ startDuration = ？ TIMES = ? timestamp = ?",model.viewDuration,model.startDuration,model.times,model.timestamp];
            NSLog(@"更新数据成功");
        }
    }
}



- (NSDictionary *)getData{
    return [NSDictionary dictionary];
    //MARK: -  返回用户点击轨迹数据和用户页面访问轨迹 返回字典
    
    
}

- (void)resetDataBase{
    
    //清空本地缓存数据 清理自增字段
    [_database executeUpdate:@"DELETE FROM EventTrackTable"];
    [_database executeUpdate:@"DELETE FROM LifeCycleTrackTable"];
    [_database executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='viewController_id'"];
}

@end
