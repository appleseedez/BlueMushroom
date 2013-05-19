
#import "EVAGoodyListViewController.h"

@interface EVAGoodyListViewController ()

@end

@implementation EVAGoodyListViewController
- (void) loadGoodies{
	
}
#pragma mark - 各种交互操作
/*
 关闭列表页
 */
- (IBAction)closeListModal:(UIButton *)closeBtn{
	[self dismissViewControllerAnimated:YES completion:nil];
}
/*
 隐藏/显示过滤面板
 */
-(IBAction)toggleFilter:(UIButton *)titleBtn{
	
}
/*
 点击刷新列表
 */
- (IBAction)reloadList:(UIButton *)refreshBtn{
	// 用户主动刷新
	[self loadGoodies];
}

@end
