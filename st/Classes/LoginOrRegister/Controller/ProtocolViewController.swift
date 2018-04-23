//
//  ProtocolViewController.swift
//  st
//
//  Created by 林劲民 on 2018/4/22.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import WebKit

class ProtocolViewController: UIViewController {

    weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "注册协议"
        automaticallyAdjustsScrollViewInsets = false
        
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.processPool = WKProcessPool()
        webView = WKWebView(frame: view.bounds, configuration: config)
        let path = Bundle.main.url(forResource: "xieyi", withExtension: "html")
        webView.load(URLRequest(url: path!))
        view.addSubview(webView)
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
