//
//  ViewController.m
//  iTunesTest
//
//  Created by wangsl-iMac on 15/1/4.
//  Copyright (c) 2015年 chengtz-iMac. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *baseURL = [NSURL URLWithString:@"https://itunes.apple.com/"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0"}];
    
    //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                      diskCapacity:50 * 1024 * 1024
                                                          diskPath:nil];
    
    [config setURLCache:cache];
    
    AFHTTPSessionManager *sessinMag = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL sessionConfiguration:config];
    
    sessinMag.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionDataTask *task = [sessinMag GET:@"/search" parameters:@{ @"country" :@"TW",@"term" : @"wangfei" } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            NSLog(@"httpResponse: statusCode = 200");
            NSArray * result = responseObject[@"results"];
            
            //NSLog(@"Data :%@", result);
            for (NSUInteger index = 0; index <= result.count - 1; index++) {
                
                NSString * name = [self PraseData:result[index] Key:@"artistName"];
                NSString * pic_100 = [self PraseData:result[index] Key:@"artworkUrl100"];
                NSString * collectionCensoredName = [self PraseData:result[index] Key:@"collectionCensoredName"];
                NSString * collectionName = [self PraseData:result[index] Key:@"collectionName"];
                NSString * trackCensoredNam = [self PraseData:result[index] Key:@"trackCensoredName"];
                NSString * trackNam = [self PraseData:result[index] Key:@"trackCensoredName"];
                NSString * previewUrl = [self PraseData:result[index] Key:@"previewUrl"];
                NSLog(@"歌手名称:%@,\r\n 图片URL%@:,\r\n 专辑名:%@,\r\n  歌曲名:%@,\r\n  歌曲URL:%@,\r\n", name, pic_100, collectionCensoredName, trackCensoredNam, previewUrl);
            }
           
        } else {
            
            
            NSLog(@"Received: %@", responseObject);
            NSLog(@"Received HTTP %ld", httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error :%@", error);
    }];
}

-(NSString *)PraseData:(NSDictionary * )indexDic Key:(NSString *)key{
    
    return indexDic[key];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    }
   
//    NSURLSessionDataTask *task = [self GET:@"/search" parameters:@{ @"country" :@"TW",@"term" : @"王菲" }
//                                   success:^(NSURLSessionDataTask *task, id responseObject) {
//                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//                                       if (httpResponse.statusCode == 200) {
//                                           dispatch_async(dispatch_get_main_queue(), ^{
//                                               completion(responseObject[@"results"], nil);
//                                           });
//                                       } else {
//                                           dispatch_async(dispatch_get_main_queue(), ^{
//                                               completion(nil, nil);
//                                           });
//                                           NSLog(@"Received: %@", responseObject);
//                                           NSLog(@"Received HTTP %d", httpResponse.statusCode);
//                                       }
//                                       
//                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           completion(nil, error);
//                                       });
//                                   }];
//}

@end
