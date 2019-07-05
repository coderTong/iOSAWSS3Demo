//
//  SecondViewController.m
//  AWSS3Demo03
//
//  Created by codew on 7/5/19.
//  Copyright © 2019 codew. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation SecondViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = 0;
        self.statusLabel.text = @"";
    });
    
    
}

- (IBAction)start:(id)sender {
    
    
    AWSStaticCredentialsProvider * credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:@"服务器要, 调用服务器接口" secretKey:@"服务器要, 调用服务器接口"];
    // Region 问你们服务器, 如果你能拿到账号自己看, 下面是对照表
    // https://docs.amazonaws.cn/general/latest/gr/rande.html
    AWSServiceConfiguration * configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPSoutheast1 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager] .defaultServiceConfiguration = configuration;
    
    
    //Initalize the screen elements
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = 0;
        self.statusLabel.text = @"";
        self.imageView.image = nil;
    });
    
    __weak SecondViewController *weakSelf = self;
    
    //Create the completion handler for the transfer
    AWSS3TransferUtilityDownloadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityDownloadTask *task, NSURL *location, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.statusLabel.text = @"Failed to Download";
            }
            if (data) {
                weakSelf.statusLabel.text = @"Successfully Downloaded";
                weakSelf.imageView.image = [UIImage imageWithData:data];
                weakSelf.progressView.progress = 1.0;
            }
        });
    };
    
    
    //Create the TransferUtility expression and add the progress block to it.
    //This would be needed to report on progress tracking
    AWSS3TransferUtilityDownloadExpression *expression = [AWSS3TransferUtilityDownloadExpression new];
    expression.progressBlock = ^(AWSS3TransferUtilityTask *task, NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.progress = progress.fractionCompleted;
        });
    };
    
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility downloadDataFromBucket:S3BucketName
                                         key:S3DownloadKeyName
                                  expression:expression
                           completionHandler:completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.text = @"Downloading...";
            });
        }
        
        return nil;
    }];
}

@end
