
#import <UIKit/UIKit.h>

@interface EVAHomeViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate>
@property(nonatomic,weak) IBOutlet UIScrollView* advertiseScrollView;
@property(nonatomic,weak) IBOutlet UIPageControl* advertiseScrollViewPageControl;
@end
