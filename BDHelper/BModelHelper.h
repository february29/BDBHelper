//
//  BModelHelper.h
//  BDBHelperDemo
//
//  Created by bai on 2017/9/15.
//  Copyright © 2017年 北京仙指信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface BModelHelper : NSObject

/**
 根据类获取类属性名称和属性类型  objectc类型  数据创建时不能使用。
 
 NSInteger等typedef的包装类无法准确识别类型到oc类型智能识别到typedef的类型
 

 @param cls 类
 @return 属性名称array[0],属性类型array[1] NSString类型
 */
+(NSArray *)getPropertyNameAndType:(Class)cls;




/**
 根据类获取类属性名称和属性类型 返回sqlite类型
 
 对应关系
 char,unsigned char,short,unsigned short,int,unsigned int,bool,BOOL ---->int
 long,unsigned long,long long,unsigned long long --->long
 float --->float
 double --->double
 NSString --->text
 other --->blob
 
 int long 会被sqlite以integer类型存储，float double 会以real类型存储。
 

 @param cls 类
 @return 属性名称array[0],属性类型array[1] NSString类型
 */
+(NSArray *)getSqlitePropertyNameAndType:(Class)cls;

@end
