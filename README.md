# HLNetWorkReachability
Reachability 已经升级了，新版的Reachability已经支持IPv6了。<br>
我是在新版的Reachability上做了改进，主要是判断网络环境2G/3G/4G/WiFi等。

# 使用到的系统库
```
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <netinet/in.h>
```

#  改进
1、扩展了原来网络环境的枚举类型
```
typedef NS_ENUM(NSUInteger, HLNetWorkStatus) {
    HLNetWorkStatusNotReachable = 0,
    HLNetWorkStatusUnknown = 1,
    HLNetWorkStatusWWAN2G = 2,
    HLNetWorkStatusWWAN3G = 3,
    HLNetWorkStatusWWAN4G = 4,

    HLNetWorkStatusWiFi = 9,
};
```
2、修改了原来的网络粗略判断
```
- (HLNetWorkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return HLNetWorkStatusNotReachable;
    }

    HLNetWorkStatus returnValue = HLNetWorkStatusNotReachable;
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = HLNetWorkStatusWiFi;
    }

    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */

        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = HLNetWorkStatusWiFi;
        }
    }

    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];

        NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];

        NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
            NSString *accessString = teleInfo.currentRadioAccessTechnology;
            if ([typeStrings4G containsObject:accessString]) {
                return HLNetWorkStatusWWAN4G;
            } else if ([typeStrings3G containsObject:accessString]) {
                return HLNetWorkStatusWWAN3G;
            } else if ([typeStrings2G containsObject:accessString]) {
                return HLNetWorkStatusWWAN2G;
            } else {
                return HLNetWorkStatusUnknown;
            }
        } else {
            return HLNetWorkStatusUnknown;
        }
    }

    return returnValue;
}
```

# 用法
还是原来那个用法
```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kNetWorkReachabilityChangedNotification object:nil];

HLNetWorkReachability *reachability = [HLNetWorkReachability reachabilityWithHostName:@"www.baidu.com"];
self.hostReachability = reachability;
[reachability startNotifier];

```

有什么问题或者建议可以联系我。

