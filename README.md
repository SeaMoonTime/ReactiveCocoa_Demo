
# 前言
网上介绍Reactive Cocoa的使用文档很多，但是应用demo要么一带而过，要么过于庞大不适合初学者（大神写的），本人自学一段时间后，略有心得，特意编写了一个完整的demo，该demo完全遵循MVVM架构设计。[Github传送门](https://github.com/SeaMoonTime/ReactiveCocoa_Demo)

>本文并不适合无任何reactive cocoa基础的童鞋，如需学习reactive cocoa基础请参考。
[最快让你上手ReactiveCocoa之基础篇](https://www.jianshu.com/p/87ef6720a096)
[最快让你上手ReactiveCocoa之进阶篇](https://www.jianshu.com/p/e10e5ca413b7)
[iOS ReactiveCocoa 最全常用API整理（可做为手册查询）](https://www.jianshu.com/p/a4fefb434652)
[ReactiveCocoa 官方GitHub](https://github.com/ReactiveCocoa/ReactiveObjC)
[ReactiveCocoa v2.5 源码解析之架构总览](http://blog.leichunfeng.com/blog/2015/12/25/reactivecocoa-v2-dot-5-yuan-ma-jie-xi-zhi-jia-gou-zong-lan/)

# demo运行
- 运行前请先进行`pod install`
- 运行后，搜索框未输入时，搜索按钮不可用，在搜索框输入`电影名`或`导演名`等，如张艺谋，搜索按钮可用，点击按钮可得到相关的电影搜索结果；
- demo网络数据采用的[豆瓣Api V2](https://developers.douban.com/wiki/?title=api_v2)中的电影搜索功能；

![电影搜索2.gif](https://upload-images.jianshu.io/upload_images/6416189-8ff1b3e77b424e1f.gif?imageMogr2/auto-orient/strip)

# 程序说明

## 主界面

- 主界面包括两个类`HomeViewController`和`HomeViewModel`，因为model过于简单就直接定义在ViewModel中了
- `HomeViewModel`定义了搜索条件`searchConditons`字符串，并将字符串是否为空与按钮是否可用信号`searchBtnEnableSignal`绑定；
- `HomeViewController`则首先将ViewModel中的`searchConditons`字符串与输入框内容绑定，再将搜索按钮的`enable`属性与ViewModel中的`searchBtnEnableSignal`绑定;
- 以上两个步骤即可实现通过判断输入框内容是否为空从而确定搜索按钮的`enable`属性；
- 点击按钮后页面跳转；

`HomeViewModel`定义如下:

```
#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface HomeViewModel : NSObject
@property (nonatomic, copy) NSString *searchConditons;

@property (nonatomic, strong, readonly) RACSignal  *searchBtnEnableSignal;
@end

```

```
#import "HomeViewModel.h"

@implementation HomeViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self setupSearchBtnEnableSignal];
}

- (void)setupSearchBtnEnableSignal {
    _searchBtnEnableSignal = [RACSignal combineLatest:@[RACObserve(self, searchConditons)] reduce:^id(NSString *searchConditions){
        return @(searchConditions.length);
    }];
}

@end
```

`HomeViewController`定义如下:

```
#import "HomeViewController.h"
#import "MovieViewController.h"
#import "UIButton+FillColor.h"
#import "HomeViewModel.h"
#import <UIButton+JKBackgroundColor.h>

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textContent;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property(nonatomic, strong) HomeViewModel *homeVM;

@end

@implementation HomeViewController

-(HomeViewModel *)homeVM{
    if (!_homeVM) {
        _homeVM = [[HomeViewModel alloc]init];
    }
    
    return  _homeVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _btnSearch.enabled = false;
    
    [_btnSearch setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_btnSearch setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    RAC(self.homeVM, searchConditons) = self.textContent.rac_textSignal;
    RAC(self.btnSearch, enabled) = self.homeVM.searchBtnEnableSignal;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClick:(UIButton *)sender {
    // 进入下一界面
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MovieViewController * destViewController = [storyboard instantiateViewControllerWithIdentifier:@"MovieViewController"];
    destViewController.conditions = _textContent.text;
    [self.navigationController pushViewController:destViewController animated:YES];
    
}


@end

```
## 搜索结果界面
- 搜索结果界面包括3个类`Movie`和`MovieViewModel`以及`MovieViewController`；
- `Movie`包括电影名称、时间、导演、主演、图片；实际上，[豆瓣Api V2](https://developers.douban.com/wiki/?title=api_v2)返回的电影数据远不止这么多，这里只选择了一部分；
```
#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * year;
@property(nonatomic, strong) NSArray *casts;
@property(nonatomic, strong) NSArray *directors;
@property(nonatomic, strong) NSDictionary *images;

+ (instancetype)movieWithDict:(NSDictionary *)dict;

@end
```

```
#import "Movie.h"

@implementation Movie

+(instancetype)movieWithDict:(NSDictionary *)dict{
    Movie *movie = [[Movie alloc]init];
    movie.year = dict[@"year"];
    movie.title = dict[@"title"];
    movie.casts = dict[@"casts"];
    movie.directors = dict[@"directors"];
    movie.images = dict[@"images"];
    
    return movie;
}

@end
```
- `MovieViewModel`则包括了业务逻辑代码：定义命令、网络请求、获取数据、发送数据，
> 注意: 这里使用的是`RACCommand`，而不是`RACSignal`，初学者可能很难理解两者之间的差别，个人是这样理解：`RACSignal`是单向的，就像1个人在做演讲，观众听到就结束了；而`RACCommand`是双向的，演讲者做演讲，下面的观众听到后还反馈了意见，而演讲者对反馈还做了回复。
该demo中，首先在`MovieViewController`中做出发出命令，`MovieViewModel`收到命令后进行网络请求，并将获取的网络数据包发送出去，`MovieViewController`对收到的数据进行解析和显示；

定义如下：

```
#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface MovieViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *requestCommand;
@property (nonatomic, copy, readonly) NSArray *movies;

@end
```

```
#import "MovieViewModel.h"
#import "NetworkManager.h"
#import "Movie.h"


@implementation MovieViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"%@", input);
        
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NetworkManager *manager = [NetworkManager manager];
            [manager getDataWithUrl:@"https://api.douban.com/v2/movie/search" parameters:input success:^(id json) {
                [subscriber sendNext:json];
                [subscriber sendCompleted];
            } failure:^(NSError *error) {
                
            }];
            
            return nil;
        }];
        return [requestSignal map:^id _Nullable(id  _Nullable value) {
            NSMutableArray *dictArray = value[@"subjects"];
            NSArray *modelArray = [dictArray.rac_sequence map:^id(id value) {
                return [Movie movieWithDict:value];
            }].array;
           NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO];
            _movies = [modelArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            NSLog(@"%@",_movies.description);
            
            return nil;
        }];
    }];
    
}

@end
```

- `MovieViewController`则包含：发送命令、数据解析、数据显示；
定义如下:
```
#import <UIKit/UIKit.h>

@interface MovieViewController : UITableViewController

@property(nonatomic, copy)NSString *conditions;

@end
```

```
#import "MovieViewController.h"
#import "Movie.h"
#import "MovieViewModel.h"
#import "MovieCell.h"
#import <YYWebImage/YYWebImage.h>
#import <ProgressHUD.h>
#import <SVProgressHUD.h>
#import "UITableView+FDTemplateLayoutCell.h"

@interface MovieViewController ()
@property (nonatomic, strong)MovieViewModel *movieVM;
@end

@implementation MovieViewController

-(MovieViewModel *)movieVM{
    if (!_movieVM) {
        _movieVM = [[MovieViewModel alloc]init];
    }
    
    return _movieVM;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.movieVM.requestCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"q"] = _conditions;
    [self.movieVM.requestCommand execute:parameters];
    [SVProgressHUD show];
    
    self.tableView.fd_debugLogEnabled = YES;  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.movieVM.movies.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"cellID" configuration:^(MovieCell* cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    
    return cell;
}

- (void)configureCell:(MovieCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Movie *movie = self.movieVM.movies[indexPath.row];
    
    NSDictionary *dicImage = movie.images;
    NSString *imageStr = dicImage[@"large"];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    
    // progressive
    [cell.movieImageView yy_setImageWithURL:imageUrl options:YYWebImageOptionProgressive];
    
    // progressive with blur and fade animation (see the demo at the top of this page)
    [cell.movieImageView yy_setImageWithURL:imageUrl options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    
    cell.title.text = movie.title;
    NSString *year = @"上映时间:";
    cell.year.text = [year stringByAppendingString:movie.year];
    NSString *directors = @"导演：";
    for (NSDictionary *dict in movie.directors) {
        NSString *directname = dict[@"name"];
        directors = [directors stringByAppendingFormat:@"%@,",directname];
    }
    cell.directors.text = directors;
    NSString *casts = @"主演：";
    for (NSDictionary *dict in movie.casts) {
        NSString *castname = dict[@"name"];
        casts = [casts stringByAppendingFormat:@"%@,",castname];
    }
    cell.casts.text = casts;
        
}

```

参考:
[最快让你上手ReactiveCocoa之基础篇](https://www.jianshu.com/p/87ef6720a096)
[最快让你上手ReactiveCocoa之进阶篇](https://www.jianshu.com/p/e10e5ca413b7)
[iOS ReactiveCocoa 最全常用API整理（可做为手册查询）](https://www.jianshu.com/p/a4fefb434652)
[ReactiveCocoa 官方GitHub](https://github.com/ReactiveCocoa/ReactiveObjC)
[ReactiveCocoa v2.5 源码解析之架构总览](http://blog.leichunfeng.com/blog/2015/12/25/reactivecocoa-v2-dot-5-yuan-ma-jie-xi-zhi-jia-gou-zong-lan/)



