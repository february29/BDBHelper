//
//  ApplistTable.h
//  DBHelper
//
//  Created by bai on 15/11/5.
//  Copyright © 2015年 bai.xianzhi. All rights reserved.
//

#import "BBaseTableHelper.h"

@interface ApplistTable : BBaseTableHelper



-(NSMutableArray *)getDataBySQL:(NSString *)sqlstr ;

@end
