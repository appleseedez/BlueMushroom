//
//  EVAHomeViewController.m
//  EVA
//
//  Created by Pharaoh on 13-5-15.
//  Copyright (c) 2013年 365iCar. All rights reserved.
//

#import "EVAHomeViewController.h"
#import "EVAHomeMenuViewCell.h"
@interface EVAHomeViewController ()
@property(nonatomic) NSArray* menuDataSource;
@property(nonatomic) NSArray* advertiseScrollViewDataSource;
@end

@implementation EVAHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setup];
}

- (void) setup{
	[self setupMenu];
	[self setupPageControl];
	[self setupScrollView];
}

// 九宫格按钮菜单
- (void) setupMenu {
	self.menuDataSource = @[@{@"title":@"汽车服务",@"icon":@"goods"},@{@"title":@"养护咨询",@"icon":@"faq"},
	@{@"title":@"酒后代驾",@"icon":@"proxy"},@{@"title":@"超值车险",
	@"icon":@"insure"},@{@"title":@"快速救援",@"icon":@"warm"},@{@"title":@"上门洗车",@"icon":@"wash"}];
	
}
#define LOADING_ALT_PIC @"480x150.jpg"
// 根据所需容器的个数.为advertiseScrollView生成图片容器
- (void)generateSubViewsEachSize:(CGSize) size
						   count:(NSInteger)count{
	UIImageView* page = nil;
    for (NSInteger index = 0; index<count; ++index) {
		page = [[UIImageView alloc] initWithFrame:CGRectMake(index*size.width, 0, size.width, size.height)];
		NSInteger dataIndex = (index == 0)?[self.advertiseScrollViewDataSource count]+index -1:index-1;
		[page setImageWithURL:[NSURL URLWithString:self.advertiseScrollViewDataSource[dataIndex]] placeholderImage:[UIImage imageNamed:LOADING_ALT_PIC]];
		page.tag = dataIndex;
		[self.advertiseScrollView addSubview:page];
	}
}

- (void)setupScrollViewEachPageSize:(CGSize)size count:(NSInteger)count {
    self.advertiseScrollView.contentSize = CGSizeMake(size.width*count, size.height);
	self.advertiseScrollView.contentOffset = CGPointMake(size.width*floorf(count*.5f), 0);
	self.advertiseScrollView.delegate = self;
}

// 滚动展示的初始状态
- (void) setupScrollView{
	// 如果数据多余一条,则容器应该有3个.否则是1个
	NSInteger count = ([self.advertiseScrollViewDataSource count]<=1)?1:3;
	[self generateSubViewsEachSize:self.advertiseScrollView.bounds.size count:count ];
	[self setupScrollViewEachPageSize:self.advertiseScrollView.bounds.size count:count];
}

- (void) setupPageControl{
	// pageControl 初始状态
	self.advertiseScrollViewDataSource = @[@"http://pasion-juvenil.com/wp-content/uploads/2011/02/VIDEO-2-480x150.jpg",
										@"http://www.livewiremobile.com/wp-content/uploads/2011/08/20100505_150157_H5B-480x150.jpg",
										@"http://www.kpmg.com/EU/en/PublishingImages/differences_eu_480x150.jpg",
										@"http://www.livewiremobile.com/wp-content/uploads/2011/08/abstract-480x150.jpg",
										@"http://www.languageonthemove.com/wp-content/uploads/2012/04/velcro-tape-480x150.jpg"];
	[self.advertiseScrollViewPageControl setCurrentPage:0];
	[self.advertiseScrollViewPageControl setNumberOfPages:[self.advertiseScrollViewDataSource count]];
}

// 向后翻页
- (void)flipNextPage:(UIImageView *)page nextPageToLoad:(NSInteger)nextPageToLoad pageBounds:(CGRect)pageBounds dx:(CGFloat)dx {
    if (page.frame.origin.x>=dx) {
        page.frame = CGRectOffset(page.frame, -dx, 0);
    }else{
        page.frame = CGRectMake(CGRectGetMaxX(pageBounds), 0, pageBounds.size.width, pageBounds.size.height);
        page.tag = nextPageToLoad;
        [page setImageWithURL:[NSURL URLWithString:self.advertiseScrollViewDataSource[page.tag]] placeholderImage:[UIImage imageNamed:LOADING_ALT_PIC]];
    }
}
// 向前翻页
- (void)flipPrevPage:(UIImageView *)page prevPageToLoad:(NSInteger)prevPageToLoad pageBounds:(CGRect)pageBounds dx:(CGFloat)dx {
    if (page.frame.origin.x<=dx) {
        page.frame = CGRectOffset(page.frame, dx, 0);
    }else{
        page.frame = CGRectMake(0, 0, pageBounds.size.width, pageBounds.size.height);
        page.tag = prevPageToLoad;
        [page setImageWithURL:[NSURL URLWithString:self.advertiseScrollViewDataSource[page.tag]] placeholderImage:[UIImage imageNamed:LOADING_ALT_PIC]];
    }
}

- (void)flipPageInScrollView:(UIScrollView *)scrollView totalPages:(NSInteger)totalPages dx:(CGFloat)dx prevPageToLoad:(NSInteger)prevPageToLoad nextPageToLoad:(NSInteger)nextPageToLoad centerX:(CGFloat)centerX offsetX:(CGFloat)offsetX {
    CGRect pageBounds = scrollView.bounds; 
    //判断向前还是向后翻页
    if (offsetX-centerX>0) { // 向后翻页
        for (UIImageView* page in scrollView.subviews) {
            [self flipNextPage:page nextPageToLoad:nextPageToLoad pageBounds:pageBounds dx:dx];// 依次前移
        }
        self.advertiseScrollViewPageControl.currentPage = (self.advertiseScrollViewPageControl.currentPage+1)%totalPages;
    }else{
        for (UIImageView* page in scrollView.subviews) {
            [self flipPrevPage:page prevPageToLoad:prevPageToLoad pageBounds:pageBounds dx:dx];// 依次后移
        }
        self.advertiseScrollViewPageControl.currentPage = (self.advertiseScrollViewPageControl.currentPage-1+totalPages)%totalPages;
    }
}
// 翻页
- (void) flip:(UIScrollView *)scrollView totalPages:(NSInteger)totalPages dx:(CGFloat)dx centerX:(CGFloat)centerX offsetX:(CGFloat)offsetX {
	NSInteger prevPageToLoad = 0;
	NSInteger nextPageToLoad = 0;
    for(UIView* page in scrollView.subviews){
        if(page.frame.origin.x == 0){
			prevPageToLoad = (page.tag-1+totalPages)%totalPages;
        }
        if(page.frame.origin.x == CGRectGetMaxX(scrollView.bounds)){
			nextPageToLoad = (page.tag+1)%totalPages;
        }
    }
	[self flipPageInScrollView:scrollView totalPages:totalPages dx:dx prevPageToLoad:prevPageToLoad nextPageToLoad:nextPageToLoad centerX:centerX offsetX:offsetX];
}

- (void)recenterView:(UIScrollView *)scrollView {
	CGFloat centerX = [scrollView bounds].size.width*floorf([scrollView.subviews count]*.5f);
	CGFloat offsetX = scrollView.contentOffset.x;
	NSInteger totalPages = self.advertiseScrollViewPageControl.numberOfPages; // 总的数据页数
	CGFloat dx = scrollView.bounds.size.width; // 每次翻页移动的距离
	if (offsetX != centerX ) {
		scrollView.contentOffset = CGPointMake(centerX, 0);// 将scrollView居中
		[self flip:scrollView totalPages:totalPages dx:dx centerX:centerX offsetX:offsetX];
	}
}

#pragma mark - scrollView的代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if (scrollView == self.advertiseScrollView) {
		[self recenterView:scrollView];
	}
}
#pragma mark - 首页按钮九宫格代理/数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* CollectionViewCellIdentifier = @"MenuCell";
	EVAHomeMenuViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    [self renderCell:cell AtIndexPath:indexPath];
	return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row == 0) {
		// 加载服务列表
//		[self presentViewController:[[UIStoryboard storyboardWithName:@"GoodyListView" bundle:nil] instantiateInitialViewController] animated:YES completion:nil];
	}
	if (indexPath.row == 1) {
		/// 供测试. 目前加载的是商品详情页
//		[self presentViewController:[[UIStoryboard storyboardWithName:@"GoodyListView" bundle:nil] instantiateViewControllerWithIdentifier:@"GoodyDetailView"] animated:YES completion:nil];
	}
}

#pragma mark - 自定义的方法们
- (void)renderCell:(EVAHomeMenuViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
	// 首页按钮的文字和icon
    cell.iconImageView.image  = [UIImage imageNamed:[self.menuDataSource[indexPath.row] valueForKey:@"icon"]];
	cell.menuTitleLabel.text = [self.menuDataSource[indexPath.row] valueForKey:@"title"];
}

@end
