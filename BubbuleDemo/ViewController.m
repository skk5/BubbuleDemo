//
//  ViewController.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ViewController.h"
#import "../Bubble/Macros.h"
#import "../Bubble/ESDBDoer+DBOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ESDBDoer *doer = [ESDBDoer DBDoerWithFilePath:@"" createIfNotExists:YES];
    [doer queryDBModel:[ESDBDoer class] with:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
