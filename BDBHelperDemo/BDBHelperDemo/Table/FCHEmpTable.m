//
//  FCHEmpTable.m
//  Fch_OA
//
//  Created by bai on 16/8/16.
//  Copyright © 2016年 bai.xianzhi. All rights reserved.
//

#import "FCHEmpTable.h"

@implementation FCHEmpTable


-(NSMutableArray *)getColleagueWithDepartmentID:(int)departmentId{
    NSMutableArray *arrayFromDB = [[NSMutableArray alloc]init];
    if ([self.db open]) {
        
        NSMutableString *selectSql;
        if (departmentId == -1) {
             selectSql=[NSMutableString stringWithFormat:@"select * from %@ order by d_id asc",self.TableName];
        }else{
             selectSql=[NSMutableString stringWithFormat:@"select * from %@ where d_id=%d",self.TableName,departmentId];
        }
       
        
        
        
        
        FMResultSet *resultSet =  [self.db executeQuery:selectSql];
        
        while([resultSet next]) {
            NSDictionary *dic =  [resultSet resultDictionary];
            [arrayFromDB addObject:dic];
            
        };
      //  NSLog(@"%lu",(unsigned long)[arrayFromDB count]);
        
    }else{
        NSLog(@"db open error");
    }
    return arrayFromDB;
}

-(NSMutableArray *)getHandleManagerColleagueByDepartmentID:(int)departmentId{
    NSMutableArray *arrayFromDB = [[NSMutableArray alloc]init];
    if ([self.db open]) {
        
        NSMutableString *selectSql;
        if (departmentId == -1) {
            selectSql=[NSMutableString stringWithFormat:@"select * from %@ where d_id=1 or e_id in (14,28,191,2) order by d_id asc",self.TableName];
        }else if(departmentId == 1){
            selectSql=[NSMutableString stringWithFormat:@"select * from %@ where d_id=%d",self.TableName,departmentId];
        }else{
            selectSql=[NSMutableString stringWithFormat:@"select * from %@ where d_id=%d and e_id in (14,28,191,2)",self.TableName,departmentId];

        }
        
        
        
        
        
        FMResultSet *resultSet =  [self.db executeQuery:selectSql];
        
        while([resultSet next]) {
            NSDictionary *dic =  [resultSet resultDictionary];
            [arrayFromDB addObject:dic];
            
        };
        //  NSLog(@"%lu",(unsigned long)[arrayFromDB count]);
        
    }else{
        NSLog(@"db open error");
    }
    return arrayFromDB;

}

@end
