//
//  GarlicUtils.swift
//  GarlicWebview
//
//  Created by TeamTapas on 21/06/2019.
//  Copyright © 2019 TeamTapas. All rights reserved.
//

import Foundation
import UIKit

@objc public class GarlicUtils : NSObject {
    
    @objc public static func PointToPx(pt: CGFloat) -> CGFloat {
        return pt * GetScale()
    }
    
    @objc public static func PxToPoint(px: CGFloat) -> CGFloat {
        return px / GetScale()
    }
    
    @objc public static func GetScale() -> CGFloat {
        return UIScreen.main.nativeScale
    }
    
}
