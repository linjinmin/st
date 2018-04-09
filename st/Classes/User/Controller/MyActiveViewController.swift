//
//  MyActiveViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/29.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class MyActiveViewController: UIViewController, UIScrollViewDelegate {

    // scrllview
    weak var contentView: UIScrollView!
    // 指示
    weak var indicator: UIView!
    // 当前btn
    weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的活动"
        view.backgroundColor = Constant.viewBackgroundColor
        
        setupChild()
        setupContentView()
        setupHeadView()
        
    }
    
    func setupChild() {
        
        // 报名中
        let joinVc = MyActiveTableViewController()
        joinVc.title = "报名中"
        self.addChildViewController(joinVc)
        
        // 进行中
        let startVc = MyActiveTableViewController()
        startVc.title = "进行中"
        self.addChildViewController(startVc)
        
        // 已结束
        let endVc = MyActiveTableViewController()
        endVc.title = "已结束"
        self.addChildViewController(endVc)
        
    }
    
    func setupHeadView() {
        
        let headView = UIView()
        view.addSubview(headView)
        headView.backgroundColor = UIColor.white
        headView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(0)
            make.height.equalTo(40)
        }
        
        let indicator = UIView()
        headView.addSubview(indicator)
        indicator.backgroundColor = Constant.viewColor
        indicator.frame = CGRect(x: 0, y: 38, width: Constant.screenW/3, height: 2);
        self.indicator = indicator
        let btnW:CGFloat = Constant.screenW / 3
        let btnH:CGFloat = 40
        let btnY:CGFloat = 0
        
        for index in 0...2 {
            
            let btn = setupBtn(title: self.childViewControllers[index].title!, tag: CGFloat(index+1))
            let x = CGFloat(index) * btnW
            btn.frame = CGRect(x: x, y: btnY, width: btnW, height: btnH)
            headView.addSubview(btn)
            
            if index == 0 {
                self.btn = btn
                headBtnClick(btn: btn)
            }
        }
        
    }
    
    func setupContentView() {
        
        let contentView = UIScrollView()
        contentView.frame = CGRect(x: 0, y: 44, width: Constant.screenW, height: Constant.screenH - 44)
        contentView.contentSize = CGSize(width: 3 * Constant.screenW, height: 0)
        contentView.delegate = self
        contentView.bounces = false
        contentView.isPagingEnabled = true
        view.addSubview(contentView)
        self.contentView = contentView
        scrollViewDidEndScrollingAnimation(contentView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / Constant.screenW
        let vc = childViewControllers[Int(index)]
        vc.view.frame = contentView.bounds
        vc.view.x = scrollView.contentOffset.x
        contentView.addSubview(vc.view)
        contentView.isUserInteractionEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.contentView.isUserInteractionEnabled = false
    }
    
    func setupBtn(title: String, tag: CGFloat) -> UIButton {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(Constant.viewColor, for: .disabled)
        btn.addTarget(self, action: #selector(headBtnClick), for: .touchUpInside)
        btn.tag = Int(tag)
        return btn
    }
    
    @objc func headBtnClick(btn: UIButton) {
        self.contentView.isUserInteractionEnabled = false
        self.btn.isEnabled = true
        btn.isEnabled = false
        self.btn = btn
        
        UIView.animate(withDuration: 0.25) {
            self.indicator.center.x = btn.center.x
        }
        
        var offset = contentView.contentOffset
        offset.x = CGFloat((btn.tag - 1) * Int(Constant.screenW))
        self.contentView.setContentOffset(offset, animated: true)
    }
    
}
