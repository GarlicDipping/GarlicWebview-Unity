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
    /**
     *  Starts Swifter shared instance and loads the required API keys.
     *
     *  @param consumerKey      (Required) Twitter App Consumer Key (API Key).
     *  @param consumerSecret   (Required) Twitter App Consumer Secret (API Secret).
     */
    void Initialize()
    {
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [[GarlicWebviewWrapper webviewInstance] InitializeWithParentUIView:(rootViewController)]; //InitializeWithConsumerKey:(_consumerKey) consumerSecret:(_consumerSecret) appOnly:(false)];
    }
    
    void Show(const char* url)
    {
        NSString * _url = NSStringFromCString(url);
        [[GarlicWebviewWrapper webviewInstance] ShowWithUrl:(_url)];
    }
    
    void Close()
    {
        [[GarlicWebviewWrapper webviewInstance] Close];
    }
    
    void Dispose()
    {
        [[GarlicWebviewWrapper webviewInstance] Dispose];
    }
}
