//
//  GarlicWebviewWrapper.mm
//  GarlicWebviewiOS-Bridge
//
//  Created by TeamTapas on 18/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GarlicWebviewUnityBridge-Bridging-Header.h"
#import "GarlicWebviewWrapper.h"

#pragma mark - String Helpers

static NSString * const NSStringFromCString(const char *string)
{
    if (string != NULL) {
        return [NSString stringWithUTF8String:string];
    } else {
        return nil;
    }
}

#pragma mark - Obj C Wrapper

static GarlicWebviewUnityWrapper *_webviewInstance = nil;

@implementation GarlicWebviewWrapper

+ (GarlicWebviewUnityWrapper *)webviewInstance
{
    if(_webviewInstance == nil){
        _webviewInstance = [[GarlicWebviewUnityWrapper alloc] init];
    }
    return _webviewInstance;
}

@end

#pragma mark - C interface

extern "C" {
    
    void __IOS_Initialize()
    {
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [[GarlicWebviewWrapper webviewInstance] InitializeWithParentUIView:(rootViewController)];
    }
    
    void __IOS_SetMargins(int left, int right, int top, int bottom) {
        [[GarlicWebviewWrapper webviewInstance] SetMarginsWithLeft:((NSInteger)left) right:((NSInteger)right) top:((NSInteger)top) bottom:((NSInteger)bottom)];
    }
    
    void __IOS_SetFixedRatio(int width, int height) {
        [[GarlicWebviewWrapper webviewInstance] SetFixedRatioWithWidth:((NSInteger)width) height:((NSInteger)height)];
    }
    
    void __IOS_UnsetFixedRatio() {
        [[GarlicWebviewWrapper webviewInstance] UnsetFixedRatio];
    }
    
    void __IOS_Show(const char* url)
    {
        NSString * _url = NSStringFromCString(url);
        [[GarlicWebviewWrapper webviewInstance] ShowWithUrl:(_url)];
    }
    
    void __IOS_Close()
    {
        [[GarlicWebviewWrapper webviewInstance] Close];
    }
    
    void __IOS_Dispose()
    {
        [[GarlicWebviewWrapper webviewInstance] Dispose];
    }
    
    bool __IOS_IsShowing()
    {
        return [[GarlicWebviewWrapper webviewInstance] IsShowing];
    }
}
