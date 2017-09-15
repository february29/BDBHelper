//
//  TestTableDBHelper.m
//  DBHelper
//
//  Created by bai on 15/11/4.
//  Copyright © 2015年 bai.xianzhi. All rights reserved.
//

#import "BBaseTableHelper.h"



static dispatch_queue_t fmdb_operation_processing_queue(){
    static dispatch_queue_t bai_fmdb_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bai_fmdb_operation_processing_queue = dispatch_queue_create("com.xianzhi.bai.fmdb.process.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return bai_fmdb_operation_processing_queue;
}

@interface BBaseTableHelper()

@end

@implementation BBaseTableHelper



-(void)clearTable{
    if ([self.db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@" ,
                               _TableName];
        BOOL res = [self.db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when clear db table:%@",_TableName);
        } else {
            NSLog(@"success to clear db table:%@",_TableName);
        }
        [self.db close];
        
    }else{
        NSLog(@"DB oppen error");
    }
}


-(NSDictionary *)getDataByPrimeryKeyName:(NSString *)name value:(int)value{
     NSDictionary *dic ;
    if ([self.db open]) {
        
        NSMutableString *selectSql;
        selectSql=[NSMutableString stringWithFormat:@"select * from %@ where %@=%d ",_TableName,name,value];
        
        FMResultSet *resultSet =  [self.db executeQuery:selectSql];
       
        // NSLog( @"columnNameToIndexMap%@",[resultSet columnNameToIndexMap]);
        while([resultSet next]) {
           dic =  [resultSet resultDictionary];
        };
       
        
    }else{
        NSLog(@"db open error");
    }
    return dic;
}

//sql语句后面的 orderby 等为完善

-(NSMutableArray *)getAllDateFromDB{
    
    return [self getAllDateFromDBOrderBy:nil isDesc:YES];
   
}

-(NSMutableArray *)getAllDateFromDBOrderBy:(NSString *)orderByName isDesc:(BOOL )isDesc{
   
    NSMutableArray *arrayFromDB = [[NSMutableArray alloc]init];
    if ([self.db open]) {
        
        NSMutableString *selectSql;
        if (orderByName!=nil) {
             selectSql=[NSMutableString stringWithFormat:@"select * from %@ order by %@ ",_TableName,orderByName];
        }else{
             selectSql=[NSMutableString stringWithFormat:@"select * from %@ ",_TableName];
        }
      
        
        isDesc?[selectSql appendString:@" desc"]:[selectSql appendString:@" asc"];
        FMResultSet *resultSet =  [self.db executeQuery:selectSql];
        // NSLog( @"columnNameToIndexMap%@",[resultSet columnNameToIndexMap]);
        while([resultSet next]) {
            //            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:[_NameTypeArray count]];
            //
            //            for (int i = 0; i<[_NameTypeArray count]; i++) {
            //
            //                [ dic setValue:[resultSet objectForColumnName:_NameArray[i]] forKey:_NameArray[i]];
            //
            //            }
            NSDictionary *dic =  [resultSet resultDictionary];
            [arrayFromDB addObject:dic];
            
        };
        NSLog(@"%lu",(unsigned long)[arrayFromDB count]);
        
    }else{
        NSLog(@"db open error");
    }
    return arrayFromDB;
}


//NSDictionary 中的字段名字与数据库中的字段名字严格一致
-(void)insertDataToDB:(NSDictionary*)dic{
   
    [self insertDataToDB:dic isDataPart:NO];

}


-(void)insertDataToDB:(NSDictionary*)dic isDataPart:(BOOL)isDataPart{
    
    if ([self.db open]) {
        [self insertDataToDBWithNoOpenOpertate:dic isDataPart:isDataPart];
        [self.db close];
        
    }else{
        NSLog(@"db open error");
    }
}




-(void)insertDataArrayToDB:(NSArray*)dataArray{
    [self insertDataArrayToDB:dataArray isDataPart:YES];
}


-(void)insertDataArrayToDB:(NSArray*)dataArray isDataPart:(BOOL)isDataPart{
    if ([self.db open]) {
        [self.db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (NSDictionary *insertDic in dataArray) {
                [self insertDataToDBWithNoOpenOpertate:insertDic isDataPart:isDataPart];
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [self.db rollback];
        }
        @finally {
            if (!isRollBack) {
                [self.db commit];
            }
        }
    }

}

/**
 插入某条数据  数据key必须与表格列严格对应（列个数，名字）

 @param dic 插入的数据
 */
-(void)insertDataToDBWithNoOpenOpertate:(NSDictionary*)dic{
    
    [self insertDataToDBWithNoOpenOpertate:dic isDataPart:NO];
    
   
}



/**
 插入某条数据

 @param dic        插入的数据
 @param isDataPart 数据库存储改条数据的部分数据
 */
-(void)insertDataToDBWithNoOpenOpertate:(NSDictionary*)dic isDataPart:(BOOL)isDataPart{

    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"replace into %@ (",_TableName];
   
    NSArray *dicKeys = isDataPart?_NameArray:[dic allKeys];
    
    
    for (int i = 0; i<[dicKeys count]; i++) {
        i==[dicKeys count]-1?[sqlStr appendFormat:@"%@) values(",dicKeys[i]]:[sqlStr appendFormat:@"%@,",dicKeys[i]];
        
    }
    
    for (int i = 0; i<[dicKeys count]; i++) {
        i==[dicKeys count]-1?[sqlStr appendFormat:@":%@)",dicKeys[i]]:[sqlStr appendFormat:@":%@,",dicKeys[i]];
    }

    
    
    
    
    BOOL res=  [self.db executeUpdate:sqlStr withParameterDictionary:dic];
    if (!res) {
        NSLog(@"error when insert db table :%@",_TableName);
    } else {
        // NSLog(@"success to insert db table ");
    }

}


-(void)insertDataArrayToDBAsy:(NSArray*)dataArray completeBlock:(FMDBProcessCompleteBlock)complete{
    dispatch_async(fmdb_operation_processing_queue(), ^{
        [self insertDataArrayToDB:dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(self.db);
            }
        });
    });
}




-(BOOL )deleteDataByPrimeryKeyName:(NSString *)name value:(int)value{
    if ([self.db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where name=%d" ,
                               _TableName,value];
        BOOL res = [self.db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when delete db table:%@ :%d",_TableName, value);
        } else {
            NSLog(@"success to delete db table:%@ :%d",_TableName,value);
        }
        [self.db close];
         return res;
    }else{
        NSLog(@"DB oppen error");
        return false;
    }

}

-(void)tableColummeInfo{
    NSMutableArray *columnNameArray = [NSMutableArray array];
    NSMutableArray *columnTypeArray = [NSMutableArray array];
    if ([self.db open]) {
        NSString *sql =  [NSString stringWithFormat:@"PRAGMA table_info(%@)",_TableName ];
        FMResultSet *result = [self.db executeQuery:sql];
        // NSLog( @"columnNameToIndexMap%@",[result columnNameToIndexMap]);
        while ([result next]) {
            [columnNameArray addObject:[result stringForColumnIndex:1]];//列名
            [columnTypeArray addObject:[result stringForColumnIndex:2]];//数据类型
        }
        NSLog(@"columnNameArray%@",columnNameArray);
         NSLog(@"columnTypeArray%@",columnTypeArray);
        
        [self.db close];
    }

}

@end
