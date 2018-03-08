//
//  MovieViewController.m
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 leica-geosystems. All rights reserved.
//

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
//        [ProgressHUD dismiss];
        [SVProgressHUD dismiss];
    }];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"q"] = _conditions;
    [self.movieVM.requestCommand execute:parameters];
//    [ProgressHUD show:@"数据获取中..."];
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
    //    NSLog(@"%@",imageUrl);
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    //    cell.movieImageView.yy_imageURL = imageUrl;
    
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



@end
