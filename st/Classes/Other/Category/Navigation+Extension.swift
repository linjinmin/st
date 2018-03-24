//
//  Navigation+Extension.swift
//  st
//
//  Created by 林劲民 on 2018/3/3.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

extension NavigationController {
    
    
    public class func initializeOnceMethod() {
        
        let appearence = UINavigationBar.appearance()
        appearence.isTranslucent = false
        appearence.barTintColor = Constant.globalBarTintColor
        
        // 隐藏导航栏下面的黑线
        appearence.setBackgroundImage(UIImage(), for: .default)
        appearence.shadowImage = UIImage()
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)], for: UIControlState())
        
        
    }
    
    
}


