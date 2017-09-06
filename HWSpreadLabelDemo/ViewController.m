//
//  ViewController.m
//  HWSpreadLabelDemo
//
//  Created by hongw on 2017/9/6.
//  Copyright © 2017年 hongw. All rights reserved.
//

#import "ViewController.h"
#import "HWSpreadLabel.h"

@interface ViewController ()
@property (strong, nonatomic) HWSpreadLabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[HWSpreadLabel alloc] init];
    _label.font = [UIFont systemFontOfSize:14];
    _label.numberOfLines = 0;
    _label.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_label];
    self.label.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 60);
    self.label.originalText = @"Native的插件化和HotFix方面，我们在iOS端使用开源的解决方案JSPatch，在Android端采用了自研的解决方案DynamicAPK，可以支持各组件的资源及代码的更新。DynamicAPK方案无需做任何activity/fragment/resource的proxy实现，使得原有的业务代码无需修改即可支持，迁移代码很小，同时可以提升App启动时间，详情请参考GitHub";
}

@end
