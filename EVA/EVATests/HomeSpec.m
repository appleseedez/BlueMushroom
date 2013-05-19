
#import "Kiwi.h"
#import "Goody.h"
#import "EVAHomeViewController.h"
#import "EVAGoodyListViewController.h"
SPEC_BEGIN(HomeSpec)
	describe(@"测试启动完成后", ^{
		beforeAll(^{
			//
		});
		it(@"RKManagedObjectStore 存在", ^{
			[[[RKManagedObjectStore defaultStore] shouldNot] equal:nil];
		});
		it(@"RKObjectManager 对象存在", ^{
			RKObjectManager* objectManager = [RKObjectManager sharedManager];
			[[objectManager shouldNot] equal:nil];
		});
		it(@"ManagedObjectContexts 存在", ^{
			[[[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] shouldNot] equal:nil];
		});
		
		afterAll(^{
		});
	});

	describe(@"测试数据存储", ^{
		it(@"保存goody数据", ^{
			NSError* saveError = nil;
			NSError* fetchError = nil;
			NSManagedObjectContext* context = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
			Goody* goody = [NSEntityDescription insertNewObjectForEntityForName:@"Goody" inManagedObjectContext:context];
			goody.name= @"邓丽君";
			BOOL saveSuccess = [context save:&saveError];
			[[theValue(saveSuccess) should] beYes];
			NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Goody"];
			NSArray* matches = [context executeFetchRequest:request error:&fetchError];
			NSInteger count = [matches count];
			[[theValue(count==1) should] beYes];
		});
	});
	describe(@"测试首页功能", ^{
		__block EVAHomeViewController* homeViewController = nil;
		__block UIScrollView* advertiseScrollView = nil;
		__block UIPageControl* advertisePageControl = nil;
		beforeAll(^{
			UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
			homeViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"Home View"];
			[homeViewController view];// 触发loadView
			advertiseScrollView = [homeViewController advertiseScrollView];
			advertisePageControl = [homeViewController advertiseScrollViewPageControl];
		});
		it(@"EVAHomeViewController 存在", ^{
			[homeViewController shouldNotBeNil];
		});
		it(@"pageControl 存在", ^{
			[[homeViewController advertiseScrollViewPageControl] shouldNotBeNil];
		});
		it(@"advertiseScrollView 存在", ^{
			[ advertiseScrollView shouldNotBeNil];
		});
//		it(@"只有一张图片, advertiseScrollView 应该无法滑动", ^{
//			id scrollViewDataSource = [NSArray mock];
//			[scrollViewDataSource stub:@selector(one) andReturn:@1];
//			
//		});
		it(@"advertiseScrollView 有3个容器", ^{
			CGFloat pageWidth = [advertiseScrollView bounds].size.width;
			CGFloat contentWidth = [advertiseScrollView contentSize].width;
			if([advertisePageControl numberOfPages] <= 1){
				[[theValue(contentWidth == pageWidth) should] beYes];
			}else{
				[[theValue(contentWidth == pageWidth*3) should] beYes];
			}
			for(UIView* view  in advertiseScrollView.subviews){
				[[theValue([view isKindOfClass:[UIImageView class]]) should] beYes];
			}
		});
		
		it(@"advertiseScrollView 只能横向滚动", ^{
			[[theValue([advertiseScrollView alwaysBounceHorizontal]) should] beYes];
			[[theValue([advertiseScrollView alwaysBounceVertical]) should] beNo];
		});
		it(@"advertiseScrollView 的代理设置完成", ^{
			[[theValue(advertiseScrollView.delegate == nil) should] beNo];
		});
		it(@"advertiseScrollView 分页模式", ^{
			[[theValue(advertiseScrollView.pagingEnabled) should] beYes];
		});
		it(@"advertiseScrollView 内容是居中显示的", ^{
			NSInteger containerCount = [advertiseScrollView.subviews count];
			[[theValue(advertiseScrollView.contentOffset.x == [advertiseScrollView bounds].size.width*floorf(containerCount*.5f)) should] beYes];
		});
		it(@"advertiseScrollView 向后翻页后,会恢复居中", ^{
			// 向后翻页
			advertiseScrollView.contentOffset = CGPointMake(advertiseScrollView.contentOffset.x+[advertiseScrollView bounds].size.width , 0);
			[advertiseScrollView.delegate scrollViewDidEndDecelerating:advertiseScrollView];
			NSInteger containerCount = [advertiseScrollView.subviews count];	
			[[theValue(advertiseScrollView.contentOffset.x == [advertiseScrollView bounds].size.width*floorf(containerCount*.5f)) should] beYes];
		});
		it(@"advertiseScrollView 向前翻页后,会恢复居中", ^{
			// 向前翻页
			advertiseScrollView.contentOffset = CGPointMake(advertiseScrollView.contentOffset.x-[advertiseScrollView bounds].size.width , 0);
			[advertiseScrollView.delegate scrollViewDidEndDecelerating:advertiseScrollView];
			NSInteger containerCount = [advertiseScrollView.subviews count];
			[[theValue(advertiseScrollView.contentOffset.x == [advertiseScrollView bounds].size.width*floorf(containerCount*.5f)) should] beYes];
		});
		it(@"向后翻页 pageControl的指示增大", ^{
			NSInteger before =  advertisePageControl.currentPage;
			NSInteger totalPages =advertisePageControl.numberOfPages;
			// 向后翻页
			advertiseScrollView.contentOffset = CGPointMake(advertiseScrollView.contentOffset.x+[advertiseScrollView bounds].size.width , 0);
			[advertiseScrollView.delegate scrollViewDidEndDecelerating:advertiseScrollView];
			NSInteger after = advertisePageControl.currentPage;
			[[theValue((before+1)% totalPages== after) should] beYes];
			
		});
		it(@"向前翻页 pageControl的指示减小", ^{
			NSInteger before =  advertisePageControl.currentPage;
			NSInteger totalPages =advertisePageControl.numberOfPages;
			// 向前翻页
			advertiseScrollView.contentOffset = CGPointMake(advertiseScrollView.contentOffset.x-[advertiseScrollView bounds].size.width , 0);
			[advertiseScrollView.delegate scrollViewDidEndDecelerating:advertiseScrollView];
			NSInteger after = advertisePageControl.currentPage;
			[[theValue((before-1+totalPages)%totalPages == after) should] beYes];
		});
		it(@"向前翻页 page依次后移,最右变成最左", ^{
			UIView* mostRightView = nil;
			for(UIView* page in advertiseScrollView.subviews){
				if(page.frame.origin.x == CGRectGetMaxX(advertiseScrollView.bounds)){
					mostRightView = page;
				}
			}
			advertiseScrollView.contentOffset = CGPointMake(advertiseScrollView.contentOffset.x-[advertiseScrollView bounds].size.width , 0);
			[advertiseScrollView.delegate scrollViewDidEndDecelerating:advertiseScrollView];
			[[theValue(mostRightView.frame.origin.x) should] equal:@0];
		});
		it(@"向后翻页 page依次前移,最左变成最右", ^{
			UIView* mostLeftView = nil;
			for(UIView* page in advertiseScrollView.subviews){
				if(page.frame.origin.x == 0){
					mostLeftView = page;
				}
			}
			advertiseScrollView.contentOffset = CGPointMake(advertiseScrollView.contentOffset.x+[advertiseScrollView bounds].size.width , 0);
			[advertiseScrollView.delegate scrollViewDidEndDecelerating:advertiseScrollView];
			[[theValue(mostLeftView.frame.origin.x == CGRectGetMaxX(advertiseScrollView.bounds)) should] beYes];
		});
		it(@"向后翻页,原来的最左加载新页", ^{
			NSInteger totalPages =advertisePageControl.numberOfPages;
			UIView* mostLeftView = nil;
			UIView* mostRightView = nil;
			for(UIView* page in advertiseScrollView.subviews){
				if(page.frame.origin.x == 0){
					mostLeftView = page;
				}
				if(page.frame.origin.x == CGRectGetMaxX(advertiseScrollView.bounds)){
					mostRightView = page;
				}
			}
			advertiseScrollView.contentOffset = CGPointMake(advertiseScrollView.contentOffset.x+[advertiseScrollView bounds].size.width , 0);
			[advertiseScrollView.delegate scrollViewDidEndDecelerating:advertiseScrollView];
			[[theValue(mostLeftView.tag == (mostRightView.tag+1)%totalPages) should] beYes];
		});
		it(@"向前翻页,原来的最右加载新页", ^{
			NSInteger totalPages =advertisePageControl.numberOfPages;
			UIView* mostLeftView = nil;
			UIView* mostRightView = nil;
			for(UIView* page in advertiseScrollView.subviews){
				if(page.frame.origin.x == 0){
					mostLeftView = page;
				}
				if(page.frame.origin.x == CGRectGetMaxX(advertiseScrollView.bounds)){
					mostRightView = page;
				}
			}
			advertiseScrollView.contentOffset = CGPointMake(advertiseScrollView.contentOffset.x-[advertiseScrollView bounds].size.width , 0);
			[advertiseScrollView.delegate scrollViewDidEndDecelerating:advertiseScrollView];
			[[theValue(mostRightView.tag == (mostLeftView.tag-1+totalPages)%totalPages) should] beYes];
		});
		afterAll(^{
			homeViewController = nil;
			advertiseScrollView = nil;
			advertisePageControl = nil;
		});
	});
    describe(@"测试goody数据列表", ^{
		beforeAll(^{
		});
        it(@"获取到了新的位置", ^{
//			EVAGoodyListViewController* listController = [[EVAGoodyListViewController alloc] init];
//			[listController viewDidLoad];
			
		});
    });




SPEC_END
