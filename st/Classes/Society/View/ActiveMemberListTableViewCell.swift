//
//  ActiveMemberListTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/4/25.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class ActiveMemberListTableViewCell: UITableViewCell {

    // 头像
    weak var head: UIImageView!
    // 昵称
    weak var name: UILabel!
    // 签到label
    weak var signLabel: UILabel!
    // 签到图标
    weak var signImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        // 头像
        let head = UIImageView()
        head.layer.cornerRadius = 25
        contentView.addSubview(head)
        self.head = head
        head.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
        }
        
        // 名称
        let name = setupLabel(font: 16)
        contentView.addSubview(name)
        self.name = name
        name.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(head.snp.right).offset(10)
        }
        
        // 签到图标
        let signImageView = UIImageView()
        contentView.addSubview(signImageView)
        self.signImageView = signImageView
        signImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
        }
        
        // 签到label
        let signLabel = setupLabel(font: 16)
        signLabel.textColor = UIColor(red: 100/255, green: 219/255, blue: 156/255, alpha: 1)
        signLabel.text = "已签到"
        contentView.addSubview(signLabel)
        self.signLabel = signLabel
        signLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(signImageView.snp.left).offset(-1)
        }
        
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.black
        return label
    }

}
