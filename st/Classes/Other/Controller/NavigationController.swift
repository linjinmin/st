//
//  NavigationController.swift
//  st
//
//  Created by 林劲民 on 2018/3/3.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let _sysTarget = self.navigationController?.interactivePopGestureRecognizer?.delegate
//        //0.2.1 "handleNavigationTransition:" 是存在于_sysTarget中的方法，导航控制器侧滑返回就是调用该方法
//        let _newGesture = UIPanGestureRecognizer.init(target: _sysTarget, action:Selector(("handleNavigationTransition:")))
//
//        self.view.addGestureRecognizer(_newGesture)
        
        //0.3 禁用系统自带的边缘侧滑手势
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //0.4 以上全屏滑动返回功能已经实现了，但还有一个细节
        //需要在导航控制器中的根控制器中设置手势代理，拦截手势触发,因为根控制器已经没有可以再返回的View。而再触发会卡屏
//        _newGesture.delegate = self
        
        self.interactivePopGestureRecognizer!.delegate = self
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        let button = UIButton()
        button.frame = CGRect(x:0 ,y:0, width:20, height:32)
        button.setImage(UIImage(named: "common_back"), for: .normal)
        button.setTitleColor(UIColor(red:230/255.0, green:230/255.0, blue:230/255.0, alpha:1), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        viewController.hidesBottomBarWhenPushed = true
        
        super.pushViewController(viewController, animated: animated)
        
    }
    
    
    @objc func back() {
        if childViewControllers.count > 1 {
            popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        back()
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
