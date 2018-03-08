//
//  HomeViewController.m
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 leica-geosystems. All rights reserved.
//

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
    
//    [_btnSearch jk_setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//    [_btnSearch jk_setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
