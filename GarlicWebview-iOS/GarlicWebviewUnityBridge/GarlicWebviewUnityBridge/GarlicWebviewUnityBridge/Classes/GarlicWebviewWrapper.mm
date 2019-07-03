//
//  GarlicWebviewWrapper.mm
//  GarlicWebviewiOS-Bridge
//
//  Created by TeamTapas on 18/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GarlicWebview/GarlicWebview.h>
#import "GarlicWebviewWrapper.h"
#import "GarlicWebviewUnityProtocol.h"

#pragma mark - String Helpers

static NSString * const NSStringFromCString(const char *string)
{
    if (string != NULL) {
        return [NSString stringWithUTF8String:string];
    } else {
        return nil;
    }
}

#pragma mark - C interface

extern "C" {
    
    void __IOS_Initialize()
    {
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        GarlicWebviewUnityProtocol *callback = [[GarlicWebviewUnityProtocol alloc] init];
        [[GarlicWebviewController GetInstance] InitializeWithParentUIView:[rootViewController view] garlicDelegate:callback];
    }
    
    void __IOS_SetMargins(int left, int right, int top, int bottom) {
        [[GarlicWebviewController GetInstance] SetMarginsWithLeft:left right:right top:top bottom:bottom];
    }
    
    void __IOS_SetFixedRatio(int width, int height) {
        [[GarlicWebviewController GetInstance] SetFixedRatioWithWidth:width height:height];
    }
    
    void __IOS_UnsetFixedRatio() {
        [[GarlicWebviewController GetInstance] UnsetFixedRatio];
    }
    
    void __IOS_Show(const char* url)
    {
        NSString * _url = NSStringFromCString(url);
        [[GarlicWebviewController GetInstance] ShowWithUrl:_url];
    }
    
    void __IOS_Close()
    {
        [[GarlicWebviewController GetInstance] Close];
    }
    
    void __IOS_Dispose()
    {
        [[GarlicWebviewController GetInstance] Dispose];
    }
    
    bool __IOS_IsShowing()
    {
        return [[GarlicWebviewController GetInstance] IsShowing];
    }
    
    float __IOS_PxToPt(int px)
    {
        CGFloat f_px = (CGFloat)px;
        return [GarlicUtils PxToPointWithPx:f_px];
    }
    
    float __IOS_PtToPx(int pt)
    {
        CGFloat f_pt = (CGFloat)pt;
        return [GarlicUtils PointToPxWithPt:f_pt];
    }
}
