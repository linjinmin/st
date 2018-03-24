//
//  NavigationController.swift
//  st
//
//  Created by 林劲民 on 2018/3/3.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
