//
//  BaseDBHelper.h
//  DBHelper
//
//  Created by bai on 15/11/4.
//  Copyright © 2015年 bai.xianzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


@interface BBaseDBHelper : NSObject

@property(nonatomic ,retain,readwrite) FMDatabase *db;//默认在doc文件夹下 名字DB_defulut.db
@property(nonatomic ,retain,readwrite) NSString *dbName;
@property(nonatomic ,retain,readwrite) NSString *dbPath;




-(BBaseDBHelper *)initDBWithDBPath:(NSString *)dbPath dbName:(NSString *)dbName;
@end
