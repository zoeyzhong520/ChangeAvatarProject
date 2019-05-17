//
//  UIDevice+Extension.swift
//  ChangeAvatarProject
//
//  Created by zhifu360 on 2019/5/17.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

extension UIDevice {
    
    ///判断iPad设备
    class func isIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    ///判断iPhone设备
    class func isIphone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
}
