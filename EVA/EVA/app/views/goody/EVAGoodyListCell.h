
#import <UIKit/UIKit.h>

@interface EVAGoodyListCell : EVAGenericCell
@property (weak, nonatomic) IBOutlet UILabel *goodyPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodyScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodyAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodyDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodyNameLabel;
@property(nonatomic,weak) IBOutlet UIImageView* goodyThumbnailView;
@property(nonatomic,weak) IBOutlet UILabel *goodyTimeIntervalSinceNowLabel;
@end
