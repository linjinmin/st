//
//  SocietyDetailActiveTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/4/12.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SocietyDetailActiveTableViewCell: UITableViewCell {

    // 活动名称
    weak var activeNameLabel: UILabel!
    // 地点
    weak var addressLabel: UILabel!
    // 社团名称
    weak var societyLabel: UILabel!
    // 活动详情
    weak var detailLabel: UILabel!
    // 状态
    var status: NSInteger!
    
    var active: SocietyDetailActive! {
        didSet {
            
            activeNameLabel.text = "\(active.active_name ?? "")"
            addressLabel.text = "地点：\(active.address ?? "")"
            detailLabel.text = "详情：\(active.detail ?? "")"
        }
    }
    
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
        
        // 地点
        let addressLabel = setupLabel(font: 16)
        contentView.addSubview(addressLabel)
        self.addressLabel = addressLabel
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activeNameLabel)
            make.bottom.equalTo(detailLabel.snp.top).offset(-3)
        }
        
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
