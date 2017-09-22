#简介

BDBHelper是对FMDBD的二次封装，更加方便的对数据库进行操作，使用简单方便。拓展简单方便。
- 常用数据库方法已集成，支持NSDictionary Model 两种模式插入，获取数据。
- 创建表格对应实体类，数据库中表格构成可见，实体类中实现对应表格方法，调理清晰、拓展方便。
- 。。。


#集成说明



##pod

```
尚未支持
```

##手动集成

将DBHealper文件夹拖入工程。

#使用说明

```
#import "BTableManager.h"
```

**创建表格**
1. 创建表格对应实体类继承BaseTableHelper
2. 调用代码
```
//===================================创建表格=======================================//
//方法一
NSArray *NameArray = [[NSArray alloc]initWithObjects:
@"id",@"intkey",@"floatkey",@"doublekey",@"stringkey",@"longkey", nil];
NSArray  *NameTypeArray = [[NSArray alloc]initWithObjects:
@"int",@"int",@"float",@"double",@"string",@"long", nil];
[[BTableManager sharedInstance] createTableWithName:@"ApplistTable" columnNameArray:NameArray columnTypeArray:NameTypeArray];


//方法2
NSDictionary *DIC = @{
@"COLOUM1":@"int",
@"COLOUM2":@"double",
@"COLOUM3":@"text",
@"COLOUM4":@"long",

};
[[BTableManager sharedInstance]createTableWithName:@"DICTABLE" columnNameAndTypeDictionary:DIC primeryKey:@"COLOUM2"];


//    方法3
[[BTableManager sharedInstance]createTableWithName:@"ProductTable" modleClass:[LuosProductModel class] primeryKey:@"productId"];


//方法4自主创建  block返回表格名称方便manager管理
[[BTableManager sharedInstance]createTable:@"BlockCreateTable" withCreateBlock:^(FMDatabase *db) {
BOOL ISOK = [db executeUpdate:@"create table if not exists BlockCreateTable (id int primary key, content string);"];

}];

```
**获取表格**
```
ApplistTable  *testtable = [[BTableManager sharedInstance]getTableByName:@"ApplistTable"];

ProductTable *productTable = [[BTableManager sharedInstance]getTableByName:@"ProductTable"];
```

**插入数据**
```
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
```
**获取数据**
```
//===================================获取数据=======================================//
//dic 模式
NSArray *dicArray = [productTable getAllDateFromDB ];
NSDictionary *dic = [productTable getDataByPrimeryKeyName:@"productId" value:12 ];
//model模式
NSArray *modelArray = [productTable getAllDateFromDBWithModleClass:[LuosProductModel class] ];
LuosProductModel *model = [productTable getDataByPrimeryKeyName:@"productId" value:12 modleClass:[LuosProductModel class]];

```
