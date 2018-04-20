//
//  ActiveSquareTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/4/20.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class ActiveSquareTableViewCell: UITableViewCell {

    // 活动名称
    weak var activeNameLabel: UILabel!
    // 时间
    weak var timeLabel: UILabel!
    // 地点
    weak var addressLabel: UILabel!
    // 社团名称
    weak var societyLabel: UILabel!
    // 参加状态
    weak var statusLabel: UILabel!
    // 状态
    var status: NSInteger!
    
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.size.height -= 15
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
    
    func setup() {
        
        // 社团名称
        let activeNameLabel = setupLabel(font: 20)
        contentView.addSubview(activeNameLabel)
        self.activeNameLabel = activeNameLabel
        activeNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
        }
        
        // 参加状态
        let statusLabel = setupLabel(font: 13)
        contentView.addSubview(statusLabel)
        self.statusLabel = statusLabel
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel.snp.right).offset(3)
            make.centerY.equalTo(activeNameLabel)
        }
        
        // 发起社团
        let societyLabel = setupLabel(font: 16)
        contentView.addSubview(societyLabel)
        self.societyLabel = societyLabel
        societyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.bottom.equalTo(contentView.snp.top).offset(-10)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.white
        return label
    }
    

}
