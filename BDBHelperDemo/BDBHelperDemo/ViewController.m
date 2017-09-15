//
//  ViewController.m
//  BDBHelperDemo
//
//  Created by bai on 2017/9/14.
//  Copyright © 2017年 北京仙指信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "BBaseTableHelper.h"
#import "BTableManager.h"
#import "ApplistTable.h"
#import "BlockCreateTable.h"
#import "BModelHelper.h"
#import "LuosProductModel.h"

//使用说明
//1.创建表格类继承BaseTableHelper（包含常用的几个方法）
//2.如果需要，实现自己要实现的方法。
//3.用[TableManager sharedInstance]得到管理类，使用createTableWithName...创建表格。表格名与表格类必须同名。(建议在启动页创建)
//4.需要的时候用[[TableManager sharedInstance]getTableByName:@"表格名"]得到表格实体类进行操作。
@interface ViewController (){
    BBaseTableHelper *THelper;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    NSArray *NameArray = [[NSArray alloc]initWithObjects:
                          @"id",@"intkey",@"floatkey",@"doublekey",@"stringkey",@"longkey", nil];
    
    NSArray  *NameTypeArray = [[NSArray alloc]initWithObjects:
                               @"int",@"int",@"float",@"double",@"string",@"long", nil];
    
    
    
    [[BTableManager sharedInstance] createTableWithName:@"ApplistTable" columnNameArray:NameArray columnTypeArray:NameTypeArray];
    
    ApplistTable  *testtable = [[BTableManager sharedInstance]getTableByName:@"ApplistTable"];
    
    
    
    
    [testtable clearTable];
    NSDictionary *DIC = [[NSDictionary alloc]initWithObjectsAndKeys:
                         @"COLOUM1",@"int",
                         @"COLOUM2",@"double",
                         @"COLOUM3",@"text",
                         @"COLOUM4",@"long",
                         
                         nil];
//    [[BTableManager sharedInstance]createTableWithName:@"DICTABLE" columnNameAndTypeDictionary:DIC];
    
    
    
    //插入
    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:
                          @311,@"id",
                          @1,@"intkey",
                          @1.22,@"floatkey",
                          @1.54323,@"doublekey",
                          @"hellow worid",@"stringkey",
                          @111222323,@"longkey",
                          @1.0,@"version",
                          nil];
    
    //添加列
    [[BTableManager sharedInstance]addColumnInable:@"ApplistTable" columnName:@"version" columnType:@"long"];
    
    [testtable  tableColummeInfo];
    [testtable insertDataToDB:dic2];
    //[testtable getDateFromDB];
    //基类方法调用
    NSArray *array = [testtable getAllDateFromDB];
    NSLog(@"%@",array);
    //子类方法调用
    // NSLog(@"%@",[testtable getDataBySQL:@""]);
    
    // 错误测试
    //    [[TableManager sharedInstance]getTableByName:@"se"];
    //    [[TableManager sharedInstance] createTableWithName:@"ApplistTable2" columnNameArray:NameArray columnTypeArray:NameTypeArray];
    //    [[TableManager sharedInstance] createTableWithName:@"ViewController" columnNameArray:NameArray columnTypeArray:NameTypeArray];
    
    //自主创建  block返回表格名称方便manager管理
    [[BTableManager sharedInstance]createTable:@"BlockCreateTable" withCreateBlock:^(FMDatabase *db) {
        BOOL ISOK = [db executeUpdate:@"create table if not exists BlockCreateTable (id int primary key, content string);"];
        
    }];
    
    
//    [BModelHelper  getProperties:[LuosProductModel class]];
    NSArray *arry = [BModelHelper getSqlitePropertyNameAndType:[LuosProductModel class]];
    
    NSArray *arry2 = [BModelHelper getPropertyNameAndType:[LuosProductModel class]];
    
//    BlockCreateTable *BlockCreateTable =  [[TableManager sharedInstance]getTableByName:@"BlockCreateTable"];
    //    NSDictionary *BlockCreateTableDic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //    @(234),@"id",
    //    @"hellow customblocktable",@"content",nil];
    //
    //    [BlockCreateTable insertToDB:BlockCreateTableDic];
    
//    NSLog(@"%@",[BlockCreateTable getAllDateFromDB]);
    [[BTableManager sharedInstance]deleTableByName:@"BlockCreateTable"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
