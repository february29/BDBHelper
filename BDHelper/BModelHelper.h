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
 根据类获取类属性名称和属性类型  objectc类型  数据创建时不能使用。 因为包含NSString等sqlite无法识别
 
 

 @param cls 类
 @return 属性名称array[0],属性类型array[1] NSString类型
 */
+(NSArray *)getPropertyNameAndType:(Class)cls;

+(NSArray *)getSqlitePropertyNameAndType:(Class)cls;

@end
