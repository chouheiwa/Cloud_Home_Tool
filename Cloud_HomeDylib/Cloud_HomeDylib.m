//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  Cloud_HomeDylib.m
//  Cloud_HomeDylib
//
//  Created by flh on 2018/4/8.
//  Copyright (c) 2018年 flh. All rights reserved.
//

#import "Cloud_HomeDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <UIKit/UIDevice.h>
#import "DTGPSButton.h"
#import <CoreLocation/CoreLocation.h>
CHConstructor{
    NSLog(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        static dispatch_once_t onceToken_setting;
        dispatch_once(&onceToken_setting, ^{
            CGRect bounds = [UIScreen mainScreen].bounds;
            // 在Window最上层添加一个位置设置按钮
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            UIViewController *rootViewController = window.rootViewController;
            DTGPSButton *button = [DTGPSButton sharedInstance];
            button.frame = CGRectMake(bounds.size.width - 39 - 15, bounds.size.height - 100, 40, 40);
            [rootViewController.view addSubview:button];
        });
#ifndef __OPTIMIZE__
        CYListenServer(6666);
#endif
        
    }];
}

@interface UIDevice (Additions)
+ (id)uniqueDeviceIdentifier;
@end

CHDeclareClass(UIDevice)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, id, UIDevice, uniqueDeviceIdentifier){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"WD_UUID_KEY"];
    
    if (string.length == 0) {
        string = CHSuper0(UIDevice, uniqueDeviceIdentifier);
    }
    
    return string;
}

CHDeclareClass(CLLocation);

CHOptimizedMethod0(self, CLLocationCoordinate2D, CLLocation, coordinate){
    CLLocationCoordinate2D coordinate = CHSuper(0, CLLocation, coordinate);
    id LONGITUDE = [[NSUserDefaults standardUserDefaults]valueForKey:@"JF_GPS_LONGITUDE"];
    id LATITUDE = [[NSUserDefaults standardUserDefaults]valueForKey:@"JF_GPS_LATITUDE"];
    if (LONGITUDE && LATITUDE) {
        coordinate = CLLocationCoordinate2DMake([LATITUDE floatValue], [LONGITUDE floatValue]);
    }
    return coordinate;
}

CHConstructor{
    CHLoadLateClass(UIDevice);
    CHClassHook0(UIDevice, uniqueDeviceIdentifier);
    CHLoadLateClass(CLLocation);
    CHClassHook(0, CLLocation, coordinate);
}

