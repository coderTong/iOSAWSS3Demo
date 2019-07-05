//
//  FirstViewController.m
//  AWSS3Demo03
//
//  Created by codew on 7/5/19.
//  Copyright © 2019 codew. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.statusLabel.text = @"";
    self.progressView.progress = 0;
}

- (IBAction)start:(id)sender {
    
    AWSStaticCredentialsProvider * credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:@"问服务器要, 调用服务器接口" secretKey:@"问服务器要, 调用服务器接口"];
    // Region 问你们服务器, 如果你能拿到账号自己看, 下面是对照表
    // https://docs.amazonaws.cn/general/latest/gr/rande.html
    AWSServiceConfiguration * configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPSoutheast1 credentialsProvider:credentialsProvider];                
    [AWSServiceManager defaultServiceManager] .defaultServiceConfiguration = configuration;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"Creating a test file...";
        self.progressView.progress = 0;
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        UIImage * image = [UIImage imageNamed:@"kk"];
        
        NSData *data =  UIImageJPEGRepresentation(image, 1.0f);
        
        [self uploadData:data];
    });
}


- (void)uploadData:(NSData *)testData {
    //Initalize the screen elements
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = 0;
        self.statusLabel.text = @"";
    });
    
    
    __weak FirstViewController *weakSelf = self;
    
    //Create the completion handler for the transfer
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.statusLabel.text = @"Failed to Upload";
            } else {
                weakSelf.statusLabel.text = @"Successfully Uploaded";
                weakSelf.progressView.progress = 1.0;
            }
        });
    };
    
    //Create the TransferUtility expression and add the progress block to it.
    //This would be needed to report on progress tracking
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.progressBlock = ^(AWSS3TransferUtilityTask *task, NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( weakSelf.progressView.progress < progress.fractionCompleted) {
                weakSelf.progressView.progress = progress.fractionCompleted;
            }
        });
    };
    // application/x-png @"text/plain"
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility uploadData:testData
                          bucket:S3BucketName
                             key:S3UploadKeyName
                     contentType:@"application/x-png"
                      expression:expression
               completionHandler:completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.text = @"Uploading...";
            });
        }
        return nil;
    }];
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
