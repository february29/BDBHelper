//
//  BaseDBHelper.m
//  DBHelper
//
//  Created by bai on 15/11/4.
//  Copyright © 2015年 bai.xianzhi. All rights reserved.
//

#import "BBaseDBHelper.h"

@interface BBaseDBHelper()



@end


@implementation BBaseDBHelper

-(instancetype)init{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
    return [self initDBWithDBPath:nil dbName:nil];
}

-(BBaseDBHelper *)initDBWithDBPath:(NSString *)dbPath dbName:(NSString *)dbName{
    self = [super init];
    if (self) {
        _dbPath = dbPath;
        _dbName = dbName;
        [self createDB];
    }
    return self;
}

-(void)createDB{
    if (!_db) {
        if (_dbPath==nil) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if (_dbName == nil) {
                _dbName = @"DB_defulut.db"; //默认数据库名字
            }
            _dbPath  = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],_dbName];
        }
        NSLog(@"dbpath = %@",_dbPath);
        _db=[FMDatabase databaseWithPath:_dbPath];
        
    }

}





@end
