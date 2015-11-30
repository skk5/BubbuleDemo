//
//  ESDBDoer+TableManager.h
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESDBDoer.h"

@interface ESDBDoer (TableManager)

// register model class to db.
- (BOOL)registerDBModel:(Class<ESDBModelProtocol>)modelClass, ...;

@end
