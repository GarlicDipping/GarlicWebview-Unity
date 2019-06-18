//
//  GarlicWebviewWrapper.h
//  GarlicWebviewiOS-Bridge
//
//  Created by TeamTapas on 18/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

#ifndef GarlicWebviewWrapper_h
#define GarlicWebviewWrapper_h

#import <Foundation/Foundation.h>
#import "AppDelegateListener.h"
#include "RegisterMonoModules.h"

@interface GarlicWebviewWrapper
//@interface SwifterUnityWrapper : NSObject
+ (GarlicWebviewUnityWrapper *)webviewInstance;
@end


#endif /* GarlicWebviewWrapper_h */
