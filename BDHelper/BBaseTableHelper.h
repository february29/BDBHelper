//
//  TestTableDBHelper.h
//  DBHelper
//
//  Created by bai on 15/11/4.
//  Copyright © 2015年 bai.xianzhi. All rights reserved.
//


//基本的表格类 提供了几个简单的方法。
//用户如果想自己扩展至需要建立新的类继承该类  类名必须与表格名字一致.只需要写要扩展的方法即可
//通过TableManager类 进行创建表格。 通过TableManager类获得表格，只需声明为自定义子类即可调用扩展方法。

#import "BBaseDBHelper.h"
#import "FMDatabase.h"
typedef  void(^FMDBProcessCompleteBlock) (FMDatabase *db );

@interface BBaseTableHelper :NSObject
@property(nonatomic ,retain,readwrite) NSMutableArray *NameTypeArray ;//用于存放表格字段数据类型
@property(nonatomic ,retain,readwrite) NSMutableArray *NameArray ;//用于存放表格字段名字 默认第一个为主键
@property(nonatomic ,retain,readwrite) NSString *TableName;
@property(nonatomic ,retain,readwrite) FMDatabase *db;



//===========================================================================
//================================常用的方法===================================
//===========================================================================

/**
 *  清理数据库
 */
-(void)clearTable;


/**
 *  根据主键获取详情
 *
 *  @param name  主键名称
 *  @param value 主键值
 *
 *  @return 详情
 */
-(NSDictionary *)getDataByPrimeryKeyName:(NSString *)name value:(int)value;


/**
 根据主键获取详情

 @param name 主键名称
 @param value 主键值
 @param modelClass model类
 @return model
 */
-(id)getDataByPrimeryKeyName:(NSString *)name value:(int)value modleClass:(Class )modelClass;

/**
 *  获取表格所有信息
 *
 *  @return 表格信息
 */
-(NSMutableArray *)getAllDateFromDB;

-(NSMutableArray *)getAllDateFromDBWithModleClass:(Class )modelClass;


/**
 *  获取表格所有信息
 *
 *  @param orderByName 按什么排序
 *  @param isDesc      排序方式
 *
 *  @return 列表
 */
-(NSMutableArray *)getAllDateFromDBOrderBy:(NSString *)orderByName isDesc:(BOOL )isDesc;

-(NSMutableArray *)getAllDateFromDBOrderBy:(NSString *)orderByName isDesc:(BOOL )isDesc modleClass:(Class )modelClass;


/**
 *  插入某条数据 
 *
 *  @param data 数据
 */
-(void)insertDataToDB:(id)data;




/**
 插入某条数据

 @param data       数据
 @param isDataPart 数据库中字段包含该条数据所有字段？
 */
-(void)insertDataToDB:(id)data isDataPart:(BOOL)isDataPart;




/**
 *  插入array
 *
 *  @param dataArray 插入的array
 */
-(void)insertDataArrayToDB:(NSArray*)dataArray;





/**
 插入array

 @param dataArray  数据
 @param isDataPart 数据库中字段包含改条数据所有字段？
 */
-(void)insertDataArrayToDB:(NSArray*)dataArray isDataPart:(BOOL)isDataPart;

/**
 *  异步插入array  调用时注意如果在执行过程中需要向其他表完插入数据 应当在一次事务完成后调用 否则无法成功
 *
 *  @param dataArray 数据
 *  @param complete  完成后回调
 */
-(void)insertDataArrayToDBAsy:(NSArray*)dataArray completeBlock:(FMDBProcessCompleteBlock)complete;



/**
 通过主键删除某条数据

 @param name 主键名称
 @param value 主键值
 @return 是否成功
 */
-(BOOL )deleteDataByPrimeryKeyName:(NSString *)name value:(int)value;

/**
 *  输出表格中有哪些列（数据库中查询）
 */
-(void)tableColummeInfo;


@end
