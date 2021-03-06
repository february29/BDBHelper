//
//  TableFactory.h
//  DBHelper
//
//  Created by bai on 15/11/5.
//  Copyright © 2015年 bai.xianzhi. All rights reserved.
//


#define BDBHelperDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#import <Foundation/Foundation.h>
#import "BBaseDBHelper.h"
#import "BBaseTableHelper.h"
//使用说明
//1.创建表格类继承BaseTableHelper（包含常用的几个方法）
//2.如果需要，实现自己要实现的方法。
//3.用[TableManager sharedInstance]得到管理类，使用createTableWithName...创建表格。表格名与表格类必须同名。(建议在启动页创建)
//4.需要的时候用[[TableManager sharedInstance]getTableByName:@"表格名"]得到表格实体类进行操作。


typedef void(^creatBlock) ( FMDatabase *db);

@interface BTableManager :NSObject
@property(nonatomic ,retain,readwrite) NSMutableDictionary *tableDictionary ;// 用于管数据库中的表格
@property(nonatomic,retain,readwrite)BBaseDBHelper *dbHelper;

+(id)sharedInstance;


/**
 创建表格，表格类与表格同名
 
 @param tableName 表格名称
 @param columnNameArray 数据库中列的名字
 @param columnTypeArray 数据库中列的类型 （NSString 用 text代替，fmdb在识别string时可能出错）
 */
-(void)createTableWithName:(NSString *)tableName columnNameArray:(NSArray *)columnNameArray columnTypeArray:(NSArray*)columnTypeArray;


/** 
 创建表格，表格类与表格同名
 
 @param tableName 表格名称
 @param columnNameAndTypeDic 数据库中列的名字类型健值对 （NSString 用 text代替，fmdb在识别string时可能出错）
 
 这个方法创建的表格列在数据库中排列可能不会按字典中书写的顺序排列，而是以健值对在字典中的排序决定（系统决定，字典升序）导致premerykey未知 后续插入可能存在问题。
 */
-(void)createTableWithName:(NSString *)tableName columnNameAndTypeDictionary:(NSDictionary *)columnNameAndTypeDic BDBHelperDeprecated("方法存在问题，请使用带参数keyName的方法代替");


/**
 创建表格，表格类与表格同名

 @param tableName 表格名称
 @param columnNameAndTypeDic 数据库中列的名字类型健值对 （NSString 用 text代替，fmdb在识别string时可能出错）
 @param keyName 主键名称
 */
-(void)createTableWithName:(NSString *)tableName columnNameAndTypeDictionary:(NSDictionary *)columnNameAndTypeDic primeryKey:(NSString *)keyName;

/**
 创建表格，表格类与表格同名

 @param tableName 表格名称
 @param columnNameArray 数据库中列的名字
 @param columnTypeArray 数据库中列的类型 （NSString 用 text代替，fmdb在识别string时可能出错）
 @param keyName 主键名称
 */
-(void)createTableWithName:(NSString *)tableName columnNameArray:(NSArray *)columnNameArray columnTypeArray:(NSArray*)columnTypeArray primeryKey:(NSString *)keyName;


-(void)createTableWithName:(NSString *)tableName modleClass:(Class )modelClass primeryKey:(NSString *)keyName;

/**
 自主创建表格

 @param tableName 表格名称
 @param block 回掉回去db
 */
-(void)createTable:(NSString *)tableName withCreateBlock:(creatBlock) block;


/**
 通过表名 获取表格类  获取后强制转化可以调用自己实现的方法

 @param tableName 表格名称
 @return 表格类
 */
-(BBaseTableHelper *)getTableByName:(NSString *) tableName;


/**
 通过表名删除表格

 @param tableName 删除表格名称
 */
-(void)deleTableByName:(NSString *)tableName;



/**
 为表格添加一列

 @param tableName 表格名称
 @param columnName 列名
 @param columnType 列数据类型
 */
-(void)addColumnInable:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType;


/**
 sqlite的alter功能只是alter table的一个子集，只有部分功能，比如重命名表名，新增列到现有表中。
 不支持现有列的重命名，删除和修改。
 
 sqlite> create table D_BrandService(id int);
 sqlite> alter table D_BrandService add column a int default 0;
 sqlite> create table tmp as select id from D_BrandService;
 sqlite> drop table D_BrandService;
 sqlite> alter table tmp rename to D_BrandService;
 */
//-(void)dropColumnInTable:(NSString *)tableName columnName:(NSString *)columnName ;


//-(void)alterColumnInTable:(NSString *)tableName columnName:(NSString *)columnName;



//-(void)addTableToManagerDictionary:(NSString *)tableName;

@end
