//
//  BModelHelper.m
//  BDBHelperDemo
//
//  Created by bai on 2017/9/15.
//  Copyright © 2017年 北京仙指信息技术有限公司. All rights reserved.
//

#import "BModelHelper.h"
#import <objc/runtime.h>

/**
 sqlite 存数据
 nil||NULL   ->  sqlite3_bind_null
 NSData      ->  sqlite3_bind_blob
 NSDate      ->  sqlite3_bind_text(hasDateFormatter)  sqlite3_bind_double
 NSNumber    ->  sqlite3_bind_int(char，unsigned char，short，unsigned short，int，BOOL) sqlite3_bind_int64(unsigned int，long，unsigned long，long long，unsigned long long) sqlite3_bind_double(float，double)  sqlite3_bind_text(其他)
 
 strcmp([obj objCType], @encode(char)) == 0
 其他         ->  sqlite3_bind_text
 
 **/


/**
 sqlite 取数据时
 integer ->  NSNumber(sqlite3_column_int64) ,
 double  ->  NSNumber( sqlite3_column_double)
 bolb    ->  NSData(sqlite3_column_blob )
 其他     ->   NSString(sqlite3_column_text)
 
 nil     ->  [NSNull null]

**/




//apple 官方对照表:https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
NSString *const BPropertyTypeChar = @"c";
NSString *const BPropertyTypeInt = @"i";
NSString *const BPropertyTypeShort = @"s";
NSString *const BPropertyTypeLong = @"l";
NSString *const BPropertyTypeLongLong = @"q";
NSString *const BPropertyTypeuUnsignedChar = @"C";
NSString *const BPropertyTypeUnsignedInt = @"I";
NSString *const BPropertyTypeUnsignedShort = @"S";
NSString *const BPropertyTypeUnsignedLong = @"L";
NSString *const BPropertyTypeUnsignedLongLong = @"Q";
NSString *const BPropertyTypeFloat = @"f";
NSString *const BPropertyTypeDouble = @"d";

NSString *const BPropertyTypeC99 = @"B";
NSString *const BPropertyTypeVoid = @"v";
NSString *const BPropertyTypePointer = @"*";
NSString *const BPropertyTypeId = @"@";
NSString *const BPropertyTypeClass = @"#";
NSString *const BPropertyTypeSEL = @":";

NSString *const BPropertyTypeArray = @"[array type]";
NSString *const BPropertyTypeStruct = @"{name=type...}";
NSString *const BPropertyTypeUnion = @"(name=type...)";

NSString *const BPropertyTypeIvar = @"^{objc_ivar=}";
NSString *const BPropertyTypeMethod = @"^{objc_method=}";
NSString *const BPropertyTypeBlock = @"@?";

NSString *const BPropertyTypeBOOL1 = @"c";
NSString *const BPropertyTypeBOOL2 = @"b";






@implementation BModelHelper




+(NSArray *)getPropertyNameAndType:(Class)cls {
    NSMutableArray *mNameArray = [NSMutableArray array];
    NSMutableArray *mTypeArray = [NSMutableArray array];
    unsigned int numIvars; //成员变量个数
    objc_property_t *properties = class_copyPropertyList(cls, &numIvars);
  
    for(int i = 0; i < numIvars; i++) {
        objc_property_t thisIvar = properties[i];
        NSString* key = @(property_getName(thisIvar));//获取成员变量的名
        //获取成员变量的数据类型
        
        // 2.成员类型
        NSString *attrs = @(property_getAttributes(thisIvar));
        NSUInteger dotLoc = [attrs rangeOfString:@","].location;
        NSString *code = nil;
        NSUInteger loc = 1;
        if (dotLoc == NSNotFound) { // 没有,
            code = [attrs substringFromIndex:loc];
        } else {
            code = [attrs substringWithRange:NSMakeRange(loc, dotLoc - loc)];
        }

        const char * typeEncoding0 = [code UTF8String];;
//        NSString* typeEncoding = code;

        NSArray *numberTypes = @[BPropertyTypeInt, BPropertyTypeShort,BPropertyTypeLong, BPropertyTypeLongLong, BPropertyTypeChar,BPropertyTypeUnsignedInt,BPropertyTypeUnsignedShort,BPropertyTypeUnsignedLong,BPropertyTypeUnsignedLongLong,BPropertyTypeuUnsignedChar,BPropertyTypeFloat, BPropertyTypeDouble, BPropertyTypeBOOL1, BPropertyTypeBOOL2,BPropertyTypeC99];
        NSString *type = @"unknow";
        
        if ([code isEqualToString:BPropertyTypeId]) {
            type = @"id";
        }else if ([code isEqualToString:BPropertyTypeClass]) {
            type = @"class";
        }else if ([code isEqualToString:BPropertyTypeSEL]) {
            type = @"SEL";
        }else if ([code isEqualToString:BPropertyTypePointer]) {
            type = @"Pointer";
        }else if ([numberTypes containsObject:code]) {
            //数字 （包括 oc包装类型,char  bool Bool）
            if (strcmp(typeEncoding0, @encode(char)) == 0) {
                type = @"char";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned char)) == 0) {
                type = @"unsigned char";
            }
            else if (strcmp(typeEncoding0, @encode(short)) == 0) {
                type = @"short";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned short)) == 0) {
                type = @"unsigned short";
            }
            else if (strcmp(typeEncoding0, @encode(int)) == 0) {
                type = @"int";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned int)) == 0) {
                type = @"unsigned int";
            }
            else if (strcmp(typeEncoding0, @encode(long)) == 0) {
                type = @"long";  //typedef long NSInteger
            }
            else if (strcmp(typeEncoding0, @encode(unsigned long)) == 0) {
                type = @"unsigned long";
            }
            else if (strcmp(typeEncoding0, @encode(long long)) == 0) {
                type = @"long long";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned long long)) == 0) {
                type = @"unsigned long long";
            }
            else if (strcmp(typeEncoding0, @encode(float)) == 0) {
                type = @"float";
            }
            else if (strcmp(typeEncoding0, @encode(double)) == 0) {
                type = @"double";
            }
            else if (strcmp(typeEncoding0, @encode(BOOL)) == 0) {
                type = @"BOOL";
            }
            else if (strcmp(typeEncoding0, @encode(bool)) == 0) {
                type = @"bool";
            }

            else {
                type = @"unknown";
            }
        } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
            //objctc 类型
            // 去掉@"和"，截取中间的类型名称
            type = [code substringWithRange:NSMakeRange(2, code.length - 3)];
            
        }else{
            type = @"unknown2";
        }
        [mNameArray addObject:key];//存储对象的变量名
        [mTypeArray addObject:type];
    }
    free(properties);//释放资源
    
    return @[mNameArray,mTypeArray];
}


+(NSArray *)getSqlitePropertyNameAndType:(Class)cls{
    NSMutableArray *mNameArray = [NSMutableArray array];
    NSMutableArray *mTypeArray = [NSMutableArray array];
    unsigned int numIvars; //成员变量个数
    objc_property_t *properties = class_copyPropertyList(cls, &numIvars);
    
    for(int i = 0; i < numIvars; i++) {
        objc_property_t thisIvar = properties[i];
        NSString* key = @(property_getName(thisIvar));//获取成员变量的名
        //获取成员变量的数据类型
        
        // 2.成员类型
        NSString *attrs = @(property_getAttributes(thisIvar));
        NSUInteger dotLoc = [attrs rangeOfString:@","].location;
        NSString *code = nil;
        NSUInteger loc = 1;
        if (dotLoc == NSNotFound) { // 没有,
            code = [attrs substringFromIndex:loc];
        } else {
            code = [attrs substringWithRange:NSMakeRange(loc, dotLoc - loc)];
        }
        
        const char * typeEncoding0 = [code UTF8String];
        //        NSString* typeEncoding = code;
        
        NSArray *numberTypes = @[BPropertyTypeInt, BPropertyTypeShort,BPropertyTypeLong, BPropertyTypeLongLong, BPropertyTypeChar,BPropertyTypeUnsignedInt,BPropertyTypeUnsignedShort,BPropertyTypeUnsignedLong,BPropertyTypeUnsignedLongLong,BPropertyTypeuUnsignedChar,BPropertyTypeFloat, BPropertyTypeDouble, BPropertyTypeBOOL1, BPropertyTypeBOOL2,BPropertyTypeC99];
        NSString *type = @"unknow";
        
        
        if (code.length > 3 && [code hasPrefix:@"@\""]) {
            //objctc 类型
            // 去掉@"和"，截取中间的类型名称
            code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
            
            
            if ([code isEqualToString:@"NSString"]) {
                type = @"text";
            }else{
                type = @"blob";
            }
            
            
        }else{
            if (strcmp(typeEncoding0, @encode(char)) == 0) {
                type = @"int";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned char)) == 0) {
                type = @"int";
            }
            else if (strcmp(typeEncoding0, @encode(short)) == 0) {
                type = @"int";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned short)) == 0) {
                type = @"int";
            }
            else if (strcmp(typeEncoding0, @encode(int)) == 0) {
                type = @"int";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned int)) == 0) {
                type = @"int";
            }
            else if (strcmp(typeEncoding0, @encode(long)) == 0) {
                type = @"long";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned long)) == 0) {
                type = @"long";
            }
            else if (strcmp(typeEncoding0, @encode(long long)) == 0) {
                type = @"long";
            }
            else if (strcmp(typeEncoding0, @encode(unsigned long long)) == 0) {
                type = @"long";
            }
            else if (strcmp(typeEncoding0, @encode(float)) == 0) {
                type = @"float";
            }
            else if (strcmp(typeEncoding0, @encode(double)) == 0) {
                type = @"double";
            }
            else if (strcmp(typeEncoding0, @encode(BOOL)) == 0) {
                type = @"int";
            }
            else if (strcmp(typeEncoding0, @encode(bool)) == 0) {
                type = @"int";
            }
            else {
                type = @"blob";
            }

        }
        [mNameArray addObject:key];//存储对象的变量名
        [mTypeArray addObject:type];
    }
    free(properties);//释放资源
    
    return @[mNameArray,mTypeArray];

}


@end
