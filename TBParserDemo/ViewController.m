//
//  ViewController.m
//  TBParserDemo
//
//  Created by cy on 2017/11/3.
//  Copyright © 2017年 cy. All rights reserved.
//

#import "ViewController.h"
#import "TBPaserTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Wukong.torrent" ofType:nil];
    NSDictionary *resultDict = [TBPaserTool parseWithFilePath:path];
    NSLog(@"%@",resultDict);
}

@end
