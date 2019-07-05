//
//  ViewController.m
//  AWSS3Demo03
//
//  Created by codew on 7/5/19.
//  Copyright © 2019 codew. All rights reserved.
//

#import "ViewController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)btnUploadClik:(id)sender {
    
    FirstViewController *vc = [[FirstViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:NO completion:nil];
    
}
- (void)btnDownloadClick:(id)sender {
    
    SecondViewController *vc = [[SecondViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:NO completion:nil];
}


@end
