//
//  ViewController.m
//  TestForNSURLSession
//
//  Created by new on 16/10/12.
//  Copyright © 2016年 new. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AFURLSessionManager.h"
#import "SVProgressHUD.h"
#import "WeatherInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
}

- (void)setupLayout {
    [SVProgressHUD setMinimumDismissTimeInterval:0.1];
    
    _resultTextView.layer.borderWidth = 0.5;
    _resultTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]] || [touch.view isKindOfClass:[UITextView class]]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)hideKeyboard:(id)tap {
    [_resultTextView resignFirstResponder];
}

- (IBAction)onHitBtnSendRequestWithSession:(id)sender {
    /*
    // 系统NSURLSession，GET请求;POST请求设置request的参数
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *strUrl = @"http://www.weather.com.cn/data/cityinfo/101010100.html";
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result :%@",dic);
            [self handleSuccessResponse:dic];

        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"error:%@",error]];
        }
    }];
    [task resume];
    */
    
    // 使用AFN3.0
    NSString *strUrl = @"http://www.weather.com.cn/data/cityinfo/101010100.html";
    //    http://www.weather.com.cn/m2/i/icon_weather/29x20/d0.gif
#if 1
    // 使用AFHTTPSessionManager进行POST请求
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *dicParameters = nil;
    [sessionManager POST:strUrl parameters:dicParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccessResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed, error is:%@",error);
    }];

#else
    // 使用AFURLSessionManager进行请求，请求前需要手动配置好NSURLRequest和NSURLSessionConfiguration

    // set urlsessionConfiguration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    // set url request
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    // set urlsessionDataTask
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"result - %@:",responseObject);
        [self handleSuccessResponse:responseObject];
    }];
    [task resume];
#endif
}

- (void)handleSuccessResponse:(id)response {
    if (response) {
        NSDictionary *dic = (NSDictionary *)response;
        [SVProgressHUD showSuccessWithStatus:@"success"];
        dispatch_async(dispatch_get_main_queue(), ^{
            WeatherInfo *weatherInfo = [WeatherInfo initWeathInfoWithDictionary:[dic objectForKey:@"weatherinfo"]];
            _resultTextView.text = [NSString stringWithFormat:@"From NSURLSession:\n地区：%@， 天气：%@",weatherInfo.city,weatherInfo.weather];
        });
    }
}

- (IBAction)onHitbtnSendRequestWithConnection:(id)sender {
    // NSURLConnection
    NSString *strUrl = @"http://www.weather.com.cn/data/cityinfo/101010100.html";
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"result :%@",dic);
            [SVProgressHUD showSuccessWithStatus:@"success"];
            dispatch_async(dispatch_get_main_queue(), ^{
                WeatherInfo *weatherInfo = [WeatherInfo initWeathInfoWithDictionary:[dic objectForKey:@"weatherinfo"]];
                _resultTextView.text = [NSString stringWithFormat:@"From NSURLConnection:\n地区：%@， 天气：%@",weatherInfo.city,weatherInfo.weather];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"error:%@",connectionError]];
        }
    }];
}

- (IBAction)onHitBtnDownload:(id)sender {
    // AFN测试sessionDownloadTask
    NSLog(@"systemVersion is :%@%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion);
    
    NSString *strUrl = @"http://gold.xitu.io/images/loading.png";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress.count:%.2lf - %.2lf",(double)downloadProgress.completedUnitCount, (double)downloadProgress.totalUnitCount);
        NSLog(@"downlaodTask.countOfBtyes:%.2lf - %.2lf",(double)downloadTask.countOfBytesReceived,(double)downloadTask.countOfBytesExpectedToReceive);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"默认下载地址targetPath：%@",targetPath);
        // 设置文件存放地址
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"response:%@\nfilePath:%@",response,filePath);
    }];
    [downloadTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
