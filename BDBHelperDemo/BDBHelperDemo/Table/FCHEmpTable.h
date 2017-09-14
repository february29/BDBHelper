//
//  FCHEmpTable.h
//  Fch_OA
//
//  Created by bai on 16/8/16.
//  Copyright © 2016年 bai.xianzhi. All rights reserved.
//

#import "BaseTableHelper.h"

@interface FCHEmpTable : BaseTableHelper
/**
 *  根据部门ID获得同事列表
 *
 *  @param departmentId
 *
 *  @return 
 */
-(NSMutableArray *)getColleagueWithDepartmentID:(int)departmentId;

-(NSMutableArray *)getHandleManagerColleagueByDepartmentID:(int)departmentId;




@end
