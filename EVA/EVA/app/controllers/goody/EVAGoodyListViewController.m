#import "EVAGoodyListViewController.h"
#import "EVAGoodyListCell.h"
#import "UIButton+animateIcon.h"
#import "NSDate+Format.h"
#import "Goody.h"
#import "Goody+CRUD.h"

@interface EVAGoodyListViewController ()
@property(nonatomic) NSNumberFormatter* currencyFormatter;
@end

@implementation EVAGoodyListViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setup];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)dealloc {
    [self tearDown];
}
#pragma  tableView datasource 
#define CELL_HEIGHT 80.0
// 确定每个单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return CELL_HEIGHT;
}
- (void)renderCell:(NSIndexPath *)indexPath cell:(EVAGoodyListCell *)cell {
    //    单元测试中发现. 如果Coredata中没有数据.尼玛这里会直接出现地址越界问题
    // 原因找到了 是因为fetchedResultsController使用了cache
    Goody* goody = [self.fetchedResultsController objectAtIndexPath:indexPath];
	if (goody) {
		cell.goodyNameLabel.text = goody.name;
		// 使用货币格式化器对价格进行格式化
		cell.goodyPriceLabel.text = [self.currencyFormatter stringFromNumber:goody.price];
		double distanceValue = [goody.distance doubleValue];
		cell.goodyDistanceLabel.text = [NSString stringWithFormat:@"%4.1f公里",distanceValue*0.001];//(distanceValue>0.0)?[NSString stringWithFormat:@"%4.1f公里",[goody.distance doubleValue]*0.001]:@"获取中...";
		[cell.goodyThumbnailView setImageWithURL:[NSURL URLWithString:goody.thumbnail] placeholderImage:[UIImage imageNamed:@"belle@2x.jpg"]];
        
		cell.goodyTimeIntervalSinceNowLabel.text = [NSDate formateInterval:[goody.distanceUpdateTime timeIntervalSinceNow]];
	}
}
# pragma mark - 关键方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* GoodyListCellIdentifier = @"GoodyListCell";
	EVAGoodyListCell* cell = [tableView dequeueReusableCellWithIdentifier:GoodyListCellIdentifier];
	if (nil == cell) {
		cell = [[EVAGoodyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GoodyListCellIdentifier];
	}
    [self renderCell:indexPath cell:cell];
	return cell;
}
#pragma  mark - 各种自定义函数
- (void)setupMisc {
    // 右侧的刷新按钮
    [self.refreshBtn cosplayActivityIndicator];
	// 使用货币格式
	self.currencyFormatter  = [[NSNumberFormatter alloc] init];
	[self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}
#pragma mark - 关键方法 setup
- (void) setup {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation) name:LOCATION_CHANGE_NOTIFICATION object:nil];
    // 首次定位
//    [[[EVALocationMonitor shared] locationManager] startUpdatingLocation];
    [self setupMisc];
    [self setupFetchReqeustController];
    
}
- (void) setupFetchReqeustController{
    // 记住研究下cache的问题. 在单元测试中使用cache 会造成fetchedResultsController报错
    NSFetchRequest* fetchGoodies = [NSFetchRequest fetchRequestWithEntityName:@"Goody"];
    NSNumber* range = @10000;
	
	// dirt =@"DONE"表示数据更新完成. 可以显示.
	// 因为从服务器过来的数据是没有距离的.距离是客户端根据坐标计算出来的.增加这个字段保证fetchResultController不会
	// 把还没有计算出距离的数据展示了出来. dirt字段的更新在Goody的update方法里面
    NSString* showFlag = @"DONE";
	fetchGoodies.predicate = [NSPredicate predicateWithFormat:@"distance<=%@ && dirt==%@",range,showFlag];
    fetchGoodies.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES] ];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchGoodies managedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}
#pragma  mark - 关键方法 tearDown
- (void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOCATION_CHANGE_NOTIFICATION object:nil];
}

#pragma mark - 各种交互操作
- (void) loadGoodies{
    // 去服务器取数据. 获取到数据后,会自动更新本地core data
	// 导致fetchResultController刷新数据
	[self.refreshBtn.imageView startAnimating];
	[[RKObjectManager sharedManager] getObjectsAtPath:@"services"
                                           parameters:@{@"apiKey": @"1gdxdp157X9xPkkGHFsH4MYBWWYaS37o"}
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         [self.refreshBtn.imageView stopAnimating];
         // 如何用户主动刷新. 则此时应该再获取一次用户位置,以便
         // 距离数据刷新
         [[[EVALocationMonitor shared] locationManager ] startUpdatingLocation];
     }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [self.refreshBtn.imageView stopAnimating];
     }];
}
#pragma mark - locationChage事件的监听
- (void) updateLocation{
    [[[EVALocationMonitor shared] locationManager] stopUpdatingLocation];
    [self updateDistance];
}

/*
 根据用户当前位置对core data数据的distance进行刷新
 局部更新用户与服务的距离. 达到的效果就是始终保持距离用户指定范围内的距离数据是最新的
 */
-(void) updateDistance{
	dispatch_queue_t updateDistanceQueue= dispatch_queue_create("Update the distance data", NULL);
	dispatch_async(updateDistanceQueue, ^{
		// 查找所有范围内的goody 更新其距离当前位置的值
		[Goody updateDistanceWithCurrentLocation:[[EVALocationMonitor shared] currentLocation]
									lastLocation:[[EVALocationMonitor shared] lastLocation]
										   range:10.0
									   inContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
		// 更新操作进行完成, 再初始化界面
		dispatch_async(dispatch_get_main_queue(), ^{
		});
		
	});
}
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
