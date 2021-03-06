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
#import "ProductTable.h"

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
    
    [super viewDidLoad];
    
    //===================================创建表格=======================================//
    //方法一 通过 列名 列类型创建
    NSArray *NameArray = [[NSArray alloc]initWithObjects:
                          @"id",@"intkey",@"floatkey",@"doublekey",@"stringkey",@"longkey", nil];
    NSArray  *NameTypeArray = [[NSArray alloc]initWithObjects:
                               @"int",@"int",@"float",@"double",@"string",@"long", nil];
    [[BTableManager sharedInstance] createTableWithName:@"ApplistTable" columnNameArray:NameArray columnTypeArray:NameTypeArray];
    
    
    //方法2 通过字典创建
    NSDictionary *DIC = @{
                          @"COLOUM1":@"int",
                          @"COLOUM2":@"double",
                          @"COLOUM3":@"text",
                          @"COLOUM4":@"long",

                          };
    [[BTableManager sharedInstance]createTableWithName:@"DICTABLE" columnNameAndTypeDictionary:DIC primeryKey:@"COLOUM2"];
    
    
//    方法3 通过model创建
    [[BTableManager sharedInstance]createTableWithName:@"ProductTable" modleClass:[LuosProductModel class] primeryKey:@"productId"];
    
    
    //方法4自主创建  block返回表格名称方便manager管理
    [[BTableManager sharedInstance]createTable:@"BlockCreateTable" withCreateBlock:^(FMDatabase *db) {
        BOOL ISOK = [db executeUpdate:@"create table if not exists BlockCreateTable (id int primary key, content string);"];
        
    }];
    
    //===================================获取表格=======================================//

    //获取表格
    ApplistTable  *testtable = [[BTableManager sharedInstance]getTableByName:@"ApplistTable"];
    
    ProductTable *productTable = [[BTableManager sharedInstance]getTableByName:@"ProductTable"];

    
    
    

    //===================================清空表格=======================================//

    [testtable clearTable];
    [productTable clearTable];

    //===================================插入数据=======================================//
    // 支持 字典 model 单条多条插入
    //model array插入
    LuosProductModel *product = [LuosProductModel new];
    product.productId = 12;
    product.name = @"hellow";
    product.num = 11;
    
    LuosProductModel *product2 = [LuosProductModel new];
    product2.productId = 13;
    product2.name = @"he42llow";
    product2.num = 114;
    
    [productTable insertDataArrayToDB:@[product,product2]];
    
    
    
    //===================================获取数据=======================================//
    
    NSArray *dicArray = [productTable getAllDateFromDB ];
    NSDictionary *dic = [productTable getDataByPrimeryKeyName:@"productId" value:12 ];
    NSArray *modelArray = [productTable getAllDateFromDBWithModleClass:[LuosProductModel class] ];
    LuosProductModel *model = [productTable getDataByPrimeryKeyName:@"productId" value:12 modleClass:[LuosProductModel class]];
//
//    //插入
//    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:
//                          @311,@"id",
//                          @1,@"intkey",
//                          @1.22,@"floatkey",
//                          @1.54323,@"doublekey",
//                          @"hellow worid",@"stringkey",
//                          @111222323,@"longkey",
//                          @1.0,@"version",
//                          nil];
//    
//    //添加列
//    [[BTableManager sharedInstance]addColumnInable:@"ApplistTable" columnName:@"version" columnType:@"long"];
//    
//    [testtable  tableColummeInfo];
//    [testtable insertDataToDB:dic2];
//    //[testtable getDateFromDB];
//    //基类方法调用
//    NSArray *array = [testtable getAllDateFromDB];
//    NSLog(@"%@",array);
//    //子类方法调用
//    // NSLog(@"%@",[testtable getDataBySQL:@""]);
//    
//    // 错误测试
//    //    [[TableManager sharedInstance]getTableByName:@"se"];
//    //    [[TableManager sharedInstance] createTableWithName:@"ApplistTable2" columnNameArray:NameArray columnTypeArray:NameTypeArray];
//    //    [[TableManager sharedInstance] createTableWithName:@"ViewController" columnNameArray:NameArray columnTypeArray:NameTypeArray];
//    
//    
//    
////    [BModelHelper  getProperties:[LuosProductModel class]];
//    NSArray *arry = [BModelHelper getSqlitePropertyNameAndType:[LuosProductModel class]];
//    
//    NSArray *arry2 = [BModelHelper getPropertyNameAndType:[LuosProductModel class]];
//    
////    BlockCreateTable *BlockCreateTable =  [[TableManager sharedInstance]getTableByName:@"BlockCreateTable"];
//    //    NSDictionary *BlockCreateTableDic = [[NSDictionary alloc]initWithObjectsAndKeys:
//    //    @(234),@"id",
//    //    @"hellow customblocktable",@"content",nil];
//    //
//    //    [BlockCreateTable insertToDB:BlockCreateTableDic];
//    
////    NSLog(@"%@",[BlockCreateTable getAllDateFromDB]);
//    [[BTableManager sharedInstance]deleTableByName:@"BlockCreateTable"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
