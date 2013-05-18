//
//  EVAHomeViewController.h
//  EVA
//
//  Created by Pharaoh on 13-5-15.
//  Copyright (c) 2013年 365iCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVAHomeViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate>
@property(nonatomic,weak) IBOutlet UIScrollView* advertiseScrollView;
@property(nonatomic,weak) IBOutlet UIPageControl* advertiseScrollViewPageControl;
@end
