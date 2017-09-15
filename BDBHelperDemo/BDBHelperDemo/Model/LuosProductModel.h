//
//  LuosProductModel.h
//  Lou_s
//
//  Created by bai on 2017/6/14.
//  Copyright © 2017年 北京仙指信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 产品的model
 */
@interface LuosProductModel : NSObject

@property(nonatomic)NSInteger productId ;

@property(nonatomic,strong)NSString *unit;

@property(nonatomic)long long gmTime;

@property(nonatomic,copy)NSString *packaging;

@property(nonatomic)int productlineId;

@property(nonatomic,copy)NSString *lineName;

@property(nonatomic) float price;

@property(nonatomic)int num ;

@property(nonatomic,copy)NSString *attribute;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,copy)NSString *spec;

@property(nonatomic,copy)NSString *pic ;

@property(nonatomic)BOOL hidden ;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *place;


-(void)add ;

@end
