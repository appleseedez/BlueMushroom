
#import <UIKit/UIKit.h>

@interface EVAGoodyListViewController : CoreDataTableViewController
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
- (IBAction)closeListModal:(UIButton*)closeBtn;// 关闭当前页
- (IBAction)toggleFilter:(UIButton*)titleBtn;// 显示/隐藏筛选条件
- (IBAction)reloadList:(UIButton*)refreshBtn; // 刷新列表
- (void) updateLocation;
@end
