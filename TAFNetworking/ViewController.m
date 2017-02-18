//
//  ViewController.m
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/11.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "ViewController.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import "HHSomeViewTranslator.h"

#import "HHUserAPIManager.h"
#import "HHTopicAPIManager.h"
#import "HHNetworkTaskGroup.h"
#import "HHNormalAPIManager.h"
#import "HHSpecialAPIManager.h"

@interface ViewController ()<UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *topics;

@property (strong, nonatomic) HHTopicAPIManager *topicAPIManager;
@end

#define ReuseIdentifier @"cell"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    TableView拉的是微博的免费接口 如果你没看到任何数据 那就是每天的请求限制次数到了
    [self addUI];
    
    [self configuration];
    
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    这两个是映客的数据 到是没什么限制
    [self normalRequest];
    
    [self specialRequest];
}
#pragma mark - Action

- (void)dispatchGroup:(UIButton *)button {
    
    button.userInteractionEnabled = NO;
    [button setTitle:@"" forState:UIControlStateNormal];
    HHNetworkTaskGroup *group = [HHNetworkTaskGroup new];
    HHTopicAPIManager *manager = [HHTopicAPIManager new];
    for (int i = 1; i < 6; i++) {
        
        NSURLSessionDataTask *task = [manager topicListDataTaskWithPage:i pageSize:20 completionHandler:^(NSError *error, id result) {
            NSLog(@"page:%d\n %@", i, result);
            dispatch_async(dispatch_get_main_queue(), ^{
               
                NSString *title = [button titleForState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@-%d",title, i] forState:UIControlStateNormal];
            });
        }];
        [group addTask:(id)task];
    }
    [group dispatchWithNotifHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSString *title = [button titleForState:UIControlStateNormal];
            button.userInteractionEnabled = YES;
            [button setTitle:[NSString stringWithFormat:@"%@-done",title] forState:UIControlStateNormal];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld: %@",indexPath.row, self.topics[indexPath.row]];
    cell.userInteractionEnabled = NO;
    return cell;
}

#pragma mark - Utils

- (void)addUI {
    
    CGFloat buttonHeight = 64;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), buttonHeight)];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(dispatchGroup:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"dispatchGroup" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, buttonHeight, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - buttonHeight) style:UITableViewStylePlain];
    tableView.dataSource = self;
    [self.view addSubview:self.tableView = tableView];
}

- (void)configuration {
    
    self.topics = [NSMutableArray array];
    self.topicAPIManager = [HHTopicAPIManager new];
    
    [self configTableView];
}

- (void)configTableView {
    
    __weak typeof(self) weakSelf = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.topicAPIManager refreshTopicListWithCompletionHandler:^(NSError *error, id result) {
            [weakSelf.tableView.header endRefreshing];
            
            if (!error) {
                
                [weakSelf.topics removeAllObjects];
                [weakSelf reloadTableViewWithNames:result];
                [weakSelf.tableView.footer resetNoMoreData];
            } else {
                
//                错误逻辑处理...
            }
        }];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.topicAPIManager loadmoreTopicListWithCompletionHandler:^(NSError *error, id result) {
            [weakSelf.tableView.footer endRefreshing];
            
            if (!error) {
                [self reloadTableViewWithNames:result];
            } else {
                
                switch (error.code) {
                    case HHNetworkTaskErrorNoMoreData: {
                        
                        [[[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
                    }   break;
//                        错误逻辑处理...
                    default:break;
                }
            }
        }];
    }];
}

- (void)fetchData {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"加载中...";
    [hud show:YES];
    NSNumber *taskIdentifier = [self.topicAPIManager refreshTopicListWithCompletionHandler:^(NSError *error, id result) {
        [hud hide:YES];
        
        if (!error) {
            [self reloadTableViewWithNames:result];
        } else {
            
            switch (error.code) {//如果情况复杂就自己switch
                case HHNetworkTaskErrorTimeOut: {
                    //                    展示请求超时错误页面
                }   break;
                case HHNetworkTaskErrorCannotConnectedToInternet: {
                    //                    展示网络错误页面
                }
                case HHUserInfoTaskErrorNotExistUserId: {
                    //                    ...
                }
                    //                    ...
                default:break;
            }
        }
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        //如果你持有了APIManger
//        [self.topicAPIManager cancelAllTask];
//        [self.topicAPIManager cancelTaskWithtaskIdentifier:taskIdentifier];
        //如果你只持有了taskIdentifier
//        [HHAPIManager cancelTaskWithtaskIdentifier:taskIdentifier];
//        [HHAPIManager cancelTasksWithtaskIdentifiers:@[taskIdentifier]];
//    });
}


- (void)reloadTableViewWithNames:(NSArray *)names {
    
    [self.topics addObjectsFromArray:names];
    [self.tableView reloadData];
}

- (void)normalRequest {
    
    [[HHNormalAPIManager new] fetchNearLiveListWithUserId:133825214 isWomen:YES completionHandler:^(NSError *error, id result) {
        if (!error) {
            
            for (NSString *live in result) {
                NSLog(@"%@", live);
            }
        } else {
            
//            switch (error.code) {
//                case <#constant#>:
//                    <#statements#>
//                    break;
//                    
//                default:
//                    break;
//            }
        }
    }];
}

- (void)specialRequest {
    [[HHSpecialAPIManager new] fetchNearLiveListWithUserId:133825214 isWomen:YES resultType:HHSpecialResultAlertView completionHandler:^(NSError *error, id result) {
        if (!error) {
            [result show];
        } else {
            
            //            switch (error.code) {
            //                case <#constant#>:
            //                    <#statements#>
            //                    break;
            //
            //                default:
            //                    break;
            //            }
        }
    }];
}

@end
