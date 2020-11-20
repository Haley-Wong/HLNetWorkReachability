//
//  ViewController.m
//  HLNetWorkReachability
//
//  Created by Harvey on 16/7/13.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import "ViewController.h"
#import "HLNetWorkReachability.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kNetWorkReachabilityChangedNotification object:nil];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    HLNetWorkReachability *curReach = [notification object];
    HLNetWorkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case HLNetWorkStatusNotReachable:
            self.statusLabel.text = @"网络不可用";
            break;
        case HLNetWorkStatusUnknown:
            self.statusLabel.text = @"未知网络";
            break;
        case HLNetWorkStatusWWAN2G:
            self.statusLabel.text = @"2G网络";
            break;
        case HLNetWorkStatusWWAN3G:
            self.statusLabel.text = @"3G网络";
            break;
        case HLNetWorkStatusWWAN4G:
            self.statusLabel.text = @"4G网络";
            break;
        case HLNetWorkStatusWWAN5G:
            self.statusLabel.text = @"5G网络";
            break;
        case HLNetWorkStatusWiFi:
            self.statusLabel.text = @"WiFi";
            break;
            
        default:
            break;
    }
}


@end
