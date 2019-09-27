//
//  GarlicWebviewUnityProtocol.m
//  GarlicWebviewUnityBridge
//
//  Created by TeamTapas on 01/07/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GarlicWebviewUnityProtocol.h"
#import "UnityInterface.h"

@implementation GarlicWebviewUnityProtocol

- (void)onClose {
    UnitySendMessage("GarlicWebview", "__fromnative_onClose", "");
}

- (void)onPageFinishedWithUrl:(NSString * _Nonnull)url {
    UnitySendMessage("GarlicWebview", "__fromnative_onPageFinished", [url UTF8String]);
}

- (void)onPageStartedWithUrl:(NSString * _Nonnull)url {
    UnitySendMessage("GarlicWebview", "__fromnative_onPageStarted", [url UTF8String]);
}

- (void)onReceivedErrorWithMessage:(NSString * _Nonnull)message {
    UnitySendMessage("GarlicWebview", "__fromnative_onReceivedError", [message UTF8String]);
}

- (void)onShow {
    UnitySendMessage("GarlicWebview", "__fromnative_onShow", "");
}

@end
