//
//  ApplistTable.m
//  DBHelper
//
//  Created by bai on 15/11/5.
//  Copyright © 2015年 bai.xianzhi. All rights reserved.
//

#import "ApplistTable.h"

@implementation ApplistTable


//自己实现的方法  可以调用父类中的属性：
//  @property(nonatomic ,retain,readwrite) NSArray *NameTypeArray ;//用于存放表格字段数据类型
//  @property(nonatomic ,retain,readwrite) NSArray *NameArray ;//用于存放表格字段名字 第一个为主键
//  @property(nonatomic ,retain,readwrite) NSString *TableName;


-(NSMutableArray *)getDataBySQL:(NSString *)sqlstr{
    NSLog(@"ApplistTable get dataFrom table :%@",self.TableName);
    NSMutableArray *arrayFromDB = [[NSMutableArray alloc]init];
    if ([self.db open]) {
        NSString *selectSql=[NSString stringWithFormat:@"select * from %@ ",self.TableName];
        FMResultSet *resultSet =  [self.db executeQuery:selectSql];
        while([resultSet next]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:[self.NameTypeArray count]];
            
            for (int i = 0; i<[self.NameTypeArray count]; i++) {
                
                [ dic setValue:[resultSet objectForColumnName:self.NameArray[i]] forKey:self.NameArray[i]];
                
            }
            [arrayFromDB addObject:dic];
            
            
            
        };
        NSLog(@"%lu",(unsigned long)[arrayFromDB count]);
        
    }else{
        NSLog(@"db open error");
    }
  
    return arrayFromDB;

}

-(void)getDateByID:(id)ID{
    if ([self.db open]) {
        
        NSString *Sql = [NSString stringWithFormat:
                               @"select * from %@ where id=%@" ,
                               self.TableName,ID];
        BOOL res = [self.db executeUpdate:Sql];
        
        if (!res) {
            NSLog(@"error when delete db table:%@ id:%@",self.TableName,ID);
        } else {
            NSLog(@"success to delete db table:%@ id:%@",self.TableName,ID);
        }
        [self.db close];
        
    }else{
        NSLog(@"DB oppen error");
    }

}

@end
