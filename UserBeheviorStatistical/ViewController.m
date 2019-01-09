//
//  ViewController.m
//  AOP4Statistics
//
//  Created by dzw on 2019/1/2.
//  Copyright © 2019 dzw. All rights reserved.
//

#import "ViewController.h"
#import "AspectsLocalStorage.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *testVCs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testVCs = @[@"TestAViewController",
                     @"TestBViewController",
                     @"TestCViewController",];
    
    self.title = @"main view controller";
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:246.0/255.0 blue:229.0/255.0 alpha:255.0/255.0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.testVCs.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.testVCs[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [[NSClassFromString(self.testVCs[indexPath.row]) class]new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)testVCs{
    if(!_testVCs){
        _testVCs = [NSArray new];
    }
    return _testVCs;
}

@end
