//
//  MyActiveTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/4/11.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class MyActiveTableViewCell: UITableViewCell {

    // 活动名称
    weak var activeNameLabel: UILabel!
    // 时间
    weak var timeLabel: UILabel!
    // 地点
    weak var addressLabel: UILabel!
    // 社团名称
    weak var societyLabel: UILabel!
    // 活动详情
    weak var detailLabel: UILabel!
    // 状态
    var status: NSInteger!
    
    var myActive: MyActive! {
        didSet {
            
            activeNameLabel.text = (myActive.tissue_name! as String)
            
            switch status {
            case 1:
                timeLabel.text = "报名时间：" + (myActive.sign_begin! as String) + "-" + (myActive.sign_end! as String)
            case 2:
                timeLabel.text = "开始时间：" + (myActive.active_begin! as String) + "-" + (myActive.active_end! as String)
            default:
                timeLabel.text = "结束时间：" + (myActive.active_end! as String)
            }
            
            addressLabel.text = "地点：" + (myActive.address! as String)
            societyLabel.text = "社团：" + (myActive.tissue_name! as String)
            detailLabel.text = "详情：" + (myActive.detail! as String)
        }
    }
    
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.size.height -= 15
            newFrame.origin.x += 30
            newFrame.size.width -= 60
            super.frame = newFrame
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.white
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        // 社团名称
        let activeNameLabel = setupLabel(font: 20)
        contentView.addSubview(activeNameLabel)
        self.activeNameLabel = activeNameLabel
        activeNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
        }
        
        // 活动详情
        let detailLabel = setupLabel(font: 16)
        contentView.addSubview(detailLabel)
        self.detailLabel = detailLabel
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        // 发起社团
        let societyLabel = setupLabel(font: 16)
        contentView.addSubview(societyLabel)
        self.societyLabel = societyLabel
        societyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.bottom.equalTo(detailLabel.snp.top).offset(-7)
        }
        
        // 地点
        let addressLabel = setupLabel(font: 16)
        contentView.addSubview(addressLabel)
        self.addressLabel = addressLabel
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.bottom.equalTo(societyLabel.snp.top).offset(-3)
        }
        
        // 时间label
        let timeLabel = setupLabel(font: 16)
        contentView.addSubview(timeLabel)
        self.timeLabel = timeLabel
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.bottom.equalTo(addressLabel.snp.top).offset(-3)
        }
        
    }
    
    func test() {
        activeNameLabel.text = "撕名牌"
        timeLabel.text = "时间：2018/5/6-5/8"
        addressLabel.text = "地址：福州白马院"
        societyLabel.text = "发起社团：闽江学院红十字会"
        detailLabel.text = "1级阿斯顿发生的范德萨发生对抗感觉的撒看个家的是就过撒第噶死哦的就过撒就的个"
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.white
        return label
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
