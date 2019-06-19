//
//  GarlicWebviewWrapper_h
//  GarlicWebviewUnityBridge
//
//  Created by TeamTapas on 19/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

#ifndef GarlicWebviewWrapper_h
#define GarlicWebviewWrapper_h

#import <Foundation/Foundation.h>
#import "GarlicWebview/GarlicWebview-Swift.h"
#import "GarlicWebviewUnityBridge/GarlicWebviewUnityBridge-Swift.h"

@interface GarlicWebviewWrapper : NSObject
+ (GarlicWebviewUnityWrapper *) webviewInstance;
@end

#endif /* GarlicWebviewWrapper_h */
