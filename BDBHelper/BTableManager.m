//
//  TableFactory.m
//  DBHelper
//
//  Created by bai on 15/11/5.
//  Copyright © 2015年 bai.xianzhi. All rights reserved.
//

#import "BTableManager.h"
#import "BBaseTableHelper.h"
#import "BModelHelper.h"


@implementation BTableManager
//单例
+ (id)sharedInstance {
    static BTableManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableDictionary = [[NSMutableDictionary alloc]init];
        self.dbHelper = [[BBaseDBHelper alloc]init];
       
        //将已经创建的表格加入到tableDictionary当中
        NSMutableArray *tables = [self tables];
        for (NSString *tableName in tables) {
            [self addTableToManagerDictionary:tableName];
        }
        NSLog(@"db has tables %lu: %@",(unsigned long)tables.count,tables);
        
        
    }
    return self;
}


 
-(void)createTableWithName:(NSString *)tableName columnNameArray:(NSArray *)columnNameArray columnTypeArray:(NSArray*)columnTypeArray{
    
    [self createTableWithName:tableName columnNameArray:columnNameArray columnTypeArray:columnTypeArray primeryKey:nil];
}

-(void)createTableWithName:(NSString *)tableName columnNameAndTypeDictionary:(NSDictionary *)columnNameAndTypeDic{
    [self createTableWithName:tableName columnNameArray:[columnNameAndTypeDic allKeys] columnTypeArray:[columnNameAndTypeDic allValues]];
}

-(void)createTableWithName:(NSString *)tableName columnNameAndTypeDictionary:(NSDictionary *)columnNameAndTypeDic primeryKey:(NSString *)keyName{
    [self createTableWithName:tableName columnNameArray:[columnNameAndTypeDic allKeys] columnTypeArray:[columnNameAndTypeDic allValues] primeryKey:keyName];
}


-(void)createTableWithName:(NSString *)tableName columnNameArray:(NSArray *)columnNameArray columnTypeArray:(NSArray*)columnTypeArray primeryKey:(NSString *)keyName{
    if (![self.tableDictionary objectForKey:tableName]) {
        BBaseTableHelper *newTable = [self createTableClass:tableName columnNameArray:columnNameArray columnTypeArray:columnTypeArray];
        
        //在数据库中创建表格
        !newTable?:![self createtableInDBByTableHelper:newTable primaryKey:keyName]?:[self.tableDictionary setObject:newTable forKey:tableName];
    }else{
//        NSLog(@"表格%@已存在",tableName);
    }
    
    
    
}

-(void)createTableWithName:(NSString *)tableName modleClass:(Class )modelClass primeryKey:(NSString *)keyName{
    NSArray *nameAndTypeArray = [BModelHelper getSqlitePropertyNameAndType:modelClass];
    
    [self createTableWithName:tableName columnNameArray:nameAndTypeArray[0] columnTypeArray:nameAndTypeArray[1] primeryKey:keyName];
}
 

/**
 在数据库中创建表格
 */
-(BOOL)createtableInDBByTableHelper:(BBaseTableHelper *)tableHelper  primaryKey:(NSString *)keyName{
    if ([self.dbHelper.db open]) {
        
        
        NSAssert(tableHelper.NameTypeArray!=nil&& tableHelper.NameArray, @"表格字段与字段数据类型为空!!!");
        NSAssert([tableHelper.NameArray count] == [tableHelper.NameTypeArray count], @"表格字段数量与字段数据类型数量不一致!!!");
        
        
        NSMutableString *createSQLStr = [NSMutableString stringWithFormat:@"%@ %@(",@"create table if not exists",tableHelper.TableName];
        if (keyName) {//主键放倒数组第一个位置
            NSInteger idx =  [tableHelper.NameArray indexOfObject:keyName];
            [tableHelper.NameArray exchangeObjectAtIndex:idx withObjectAtIndex:0];
            [tableHelper.NameTypeArray exchangeObjectAtIndex:idx withObjectAtIndex:0];
            
        }
        
        
        for (int i = 0; i<[tableHelper.NameTypeArray count]; i++) {
            
            [createSQLStr appendString:tableHelper.NameArray[i]];
            [createSQLStr appendString:@" "];
            [createSQLStr appendString:tableHelper.NameTypeArray[i]];
            
            if (i==0) {
                [createSQLStr appendString:@" primary key,"];//默认array中第一个为主键
            }else if(i== [tableHelper.NameTypeArray count]-1){
                [createSQLStr appendString:@")"];
                
            }else{
                [createSQLStr appendString:@","];
            }
            
        }
        
        
        BOOL res = [self.dbHelper.db executeUpdate:createSQLStr];
        if (!res) {
            NSLog(@"error when creating db table: %@",tableHelper.TableName);
            NSLog(@"sqlCreateTable = %@",createSQLStr);
        } else {
            NSLog(@"success to creating db table: %@",tableHelper.TableName);
            return YES;
        }
        [self.dbHelper.db close];
    }else{
        NSLog(@"db error");
    }
    return NO;
    
}




-(BBaseTableHelper *)getTableByName:(NSString *) tableName{
   
    
//    return [self.tableDictionary objectForKey:tableName];
    if (![self.tableDictionary objectForKey:tableName]) {
        NSLog(@"数据库中不存在表格:%@",tableName);
        return nil;
    }else{
    
        return [self.tableDictionary objectForKey:tableName];
    }
    
   
}
/**
 查询db文件中的表格
 */
-(NSMutableArray *)tables{
     NSMutableArray *tableArray = [NSMutableArray array];
    if ([_dbHelper.db open]) {
        FMResultSet *tables = [_dbHelper.db executeQuery:@"select * from sqlite_master WHERE type='table'"];
        while ([tables next]) {
            [tableArray addObject:[tables stringForColumn:@"name"]];
        }
        
    }
    return tableArray;
}
/**
 用于数据库中已存在表格，而manager中没有这个表格的记录时添加到manager方便管理，添加前应当创建表格类
 */
-(void)addTableToManagerDictionary:(NSString *)tableName{
    
    NSAssert(tableName!=nil, @"表格名字不能为空");
   
    if ([self.tableDictionary objectForKey:tableName]) {
        NSLog(@"表格%@已在Manager中存在!!!",tableName);
        return;
    }
    NSMutableArray *columnNameArray = [NSMutableArray array];
    NSMutableArray *columnTypeArray = [NSMutableArray array];
    if ([_dbHelper.db open]) {
        NSString *sql =  [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName ];
        FMResultSet *result = [_dbHelper.db executeQuery:sql];
        while ([result next]) {
            [columnNameArray addObject:[result stringForColumnIndex:1]];//列名
            [columnTypeArray addObject:[result stringForColumnIndex:2]];//数据类型
        }
        [_dbHelper.db close];
    }
    
    BBaseTableHelper *newTable = [self createTableClass:tableName columnNameArray:columnNameArray columnTypeArray:columnTypeArray];
    !newTable?:[self.tableDictionary setObject:newTable forKey:tableName];
    
}

/**
 创建表格类
 */
-(BBaseTableHelper *)createTableClass:(NSString *)tableName columnNameArray:(NSArray *)columuNameArray columnTypeArray:(NSArray*)columnTypeArray{
    
    NSAssert(columnTypeArray!=nil&& columuNameArray!=nil, @"表格字段与字段数据类型为空!!!");
    NSAssert(columnTypeArray.count == columuNameArray.count, @"表格字段数量与字段数据类型数量不一致!!!");
    
    BBaseTableHelper *newTable = [[NSClassFromString(tableName) alloc]init];
    NSAssert(newTable!=nil,@"创建表格失败，请首先创建同名的表格类，再进行数据库表格创建");
    NSAssert([[newTable class]isSubclassOfClass:[BBaseTableHelper class]],@"创建表格失败，表格类应当继承BBaseTableHelper");
    
    newTable.db = _dbHelper.db;
    newTable.TableName = tableName;
    newTable.NameTypeArray = [[NSMutableArray alloc ]initWithArray: columnTypeArray];
    newTable.NameArray = [[NSMutableArray alloc]initWithArray:columuNameArray];
    return newTable;
}

-(void)deleTableByName:(NSString *)tableName{
    
    BOOL res = [_dbHelper.db executeUpdate:[NSString stringWithFormat:@"drop table %@",tableName]];
    if (res) {
        NSLog(@"删除表格成功");
        [self.tableDictionary removeObjectForKey:tableName];
    }else{
        NSLog(@"删除表格失败");
    }
}



//自主创建表格。
-(void)createTable:(NSString *)tableName withCreateBlock:(creatBlock) block;{
    NSAssert(block,@"请使用block中的db创建你的表格");
    if (![self.tableDictionary objectForKey:tableName]) {
        
        if (block) {
            @try {
                [_dbHelper.db open];
                block(_dbHelper.db);
                [self addTableToManagerDictionary:tableName];
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"exception%@",exception);
            }
            @finally {
                [_dbHelper.db close];
            }
        }else{
            
        }
        

    }else{
//        NSLog(@"表格%@已存在",tableName);
    }
    
    
}

-(void)addColumnInable:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType{
    BBaseTableHelper *table = [self getTableByName:tableName];
    if (![table.NameArray containsObject:columnName]) {
        if ([_dbHelper.db  open]) {
            
            
            NSString *sql =  [NSString stringWithFormat:@"alter table %@ add %@ %@;",tableName,columnName,columnType];
            if ([_dbHelper.db executeUpdate:sql]) {
                
                [table.NameArray addObject:columnName];
                [table.NameTypeArray addObject:columnType];
                NSLog(@"数据库表格%@添加列 %@ 类型%@",tableName,columnName,columnType);
                NSLog(@"%@ ",[[self getTableByName:tableName] NameArray]);
                
            }
            
            [_dbHelper.db close];
            
            //正常情况下应该更改manager内的表格类中的columnArray columnTypeArray 以防止此次程序生命周期内能够正常插入数据。
            [table.NameArray addObject:columnName];
            [table.NameTypeArray addObject:columnType];
        }

    }
   
}
// sqilite 不支持删除列 方法无效 
-(void)dropColumnInTable:(NSString *)tableName columnName:(NSString *)columnName{
    if ([_dbHelper.db  open]) {
       
        NSString *sql =  [NSString stringWithFormat:@"alter table %@ drop column %@;",tableName,columnName];
        if ([_dbHelper.db executeUpdate:sql]) {
            
            BBaseTableHelper *table = [self getTableByName:tableName];
            NSUInteger indext = [table.NameArray indexOfObject:tableName];
            [table.NameArray removeObjectAtIndex:indext];
            [table.NameTypeArray removeObjectAtIndex:indext];
            NSLog(@"数据库表格%@删除列 %@ ",tableName,columnName);
            NSLog(@"%@ ",[[self getTableByName:tableName] NameArray]);
            
        }
        [_dbHelper.db close];
        
    }

}

-(void)alterColumnInTable:(NSString *)tableName columnName:(NSString *)columnName{
    if ([_dbHelper.db  open]) {
        NSString *sql =  [NSString stringWithFormat:@"alter table %@ drop colunm %@;",tableName,columnName];
        if ([_dbHelper.db executeUpdate:sql]) {
            
            BBaseTableHelper *table = [self getTableByName:tableName];
            NSUInteger indext = [table.NameArray indexOfObject:tableName];
            [table.NameArray removeObjectAtIndex:indext];
            [table.NameTypeArray removeObjectAtIndex:indext];
//            NSLog(@"数据库表格%@修改列 %@ 修改为 ",tableName,columnName);
//            NSLog(@"%@ ",[[self getTableByName:tableName] NameArray]);
            
        }
        [_dbHelper.db close];
        
    }

}

@end
