//
//  TestCViewController.m
//  AOP4Statistics
//
//  Created by dzw on 2019/1/3.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "TestCViewController.h"

@interface TestCViewController ()
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;

@end

@implementation TestCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:206.0/255.0 blue:85.0/255.0 alpha:255.0/255.0];
    

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_repostButton.frame), CGRectGetMaxY(_repostButton.frame)+50, CGRectGetWidth(_repostButton.frame), CGRectGetHeight(_repostButton.frame))];
    button.backgroundColor = _repostButton.backgroundColor;
    [button setTitle:@"掀桌" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(duangButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
- (IBAction)favoriteButtonResponse:(UIButton *)sender {
    NSLog(@"点赞");
}

- (IBAction)collecteButtonResponse:(UIButton *)sender {
    NSLog(@"收藏");
}

- (IBAction)repostButtonResponse:(UIButton *)sender{
    NSLog(@"转发");
}

- (void)duangButtonResponse{
    NSLog(@"【掀桌～】：按钮绑定的是无参数方法");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
