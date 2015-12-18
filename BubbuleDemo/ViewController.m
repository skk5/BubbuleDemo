//
//  ViewController.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ViewController.h"
#import "../Bubble/Macros.h"
#import "../Bubble/ESDBDoer.h"
#import "ESDBDoer+DBOperation.h"
#import "ESDBDoer+TableManager.h"
#import "ESBaseModel.h"

@interface TestModel: ESBaseModel

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy)   NSString *name;

@end

@implementation TestModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld\t%@: %ld\n", (long)self.defaultKey, _name, _age];
}

@end

@interface ViewController ()
{
    ESDBDoer *doer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    doer = [ESDBDoer DBDoerWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.db"] createIfNotExists:YES];
    
    [doer registerDBModel:[TestModel class], nil];
    
    TestModel *tm = [[TestModel alloc] init];
    
    tm.age = 11;
    tm.name = @"Tom";
    [doer saveDBModel:tm];
    


    NSArray *allTestModel = [doer queryDBModel:[TestModel class]];
    NSLog(@"allTestModel: %@", allTestModel);

    
    for(TestModel *m in allTestModel) {
        [doer deleteDBModel:m];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    TestModel *tm = [[TestModel alloc] init];
    
    tm.age = arc4random() % 40;
    tm.name = @"Tom";
    [doer saveDBModel:tm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
