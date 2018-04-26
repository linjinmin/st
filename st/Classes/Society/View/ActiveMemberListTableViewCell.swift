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
    // 发起人label
    weak var releaseLabel: UILabel!
    // 人员label
    weak var join: UILabel!
    // 人员图标
    weak var joinImageView: UIImageView!
    // 是否第一个用户
    var is_first: NSString!
    
    
    var member: SignMember! {
        didSet {
            
            head.sd_setImage(with: URL(string: member.pic as String), placeholderImage: UIImage(named: "image_placeholder"))
            name.text = "\(member.name ?? "")"
            
            if is_first == "1" {
                self.join.text = "\(member.sign ?? "")/\(member.number ?? "")"
                self.signLabel.isHidden = true
                self.signImageView.isHidden = true
                name.snp.makeConstraints { (make) in
                    make.centerY.equalTo(contentView)
                    make.left.equalTo(releaseLabel.snp.right)
                }
            } else if member.sign_status == "1" {
                self.releaseLabel.isHidden = true
                self.join.isHidden = true
                self.joinImageView.isHidden = true
                self.signLabel.isHidden = false
                self.signImageView.isHidden = false
                name.snp.makeConstraints { (make) in
                    make.centerY.equalTo(contentView)
                    make.left.equalTo(head.snp.right).offset(10)
                }
            } else {
                self.releaseLabel.isHidden = true
                self.join.isHidden = true
                self.joinImageView.isHidden = true
                self.signLabel.isHidden = true
                self.signImageView.isHidden = true
                name.snp.makeConstraints { (make) in
                    make.centerY.equalTo(contentView)
                    make.left.equalTo(head.snp.right).offset(10)
                }
            }
            
            
            
        }
    }
    
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.size.height -= 5
            super.frame = newFrame
        }
    }
    
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
        self.backgroundColor = UIColor.clear
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
            make.width.height.equalTo(50)
        }
        
        // 发起人
        let releaseLabel = setupLabel(font: 16)
        releaseLabel.textColor = UIColor.lightGray
        releaseLabel.text = "发起人："
        contentView.addSubview(releaseLabel)
        self.releaseLabel = releaseLabel
        releaseLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(head.snp.right).offset(10)
        }
        
        // 名称
        let name = setupLabel(font: 16)
        contentView.addSubview(name)
        self.name = name
        
        // 参与人员logo
        let joinImageView = UIImageView(image: UIImage(named:"user"))
        contentView.addSubview(joinImageView)
        self.joinImageView = joinImageView
        joinImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
            make.height.width.equalTo(18)
        }
        
        // 参与人员
        let join = setupLabel(font: 16)
        contentView.addSubview(join)
        self.join = join
        join.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(joinImageView.snp.left).offset(1)
        }
        
        // 签到图标
        let signImageView = UIImageView(image: UIImage(named: "green_confirm"))
        contentView.addSubview(signImageView)
        self.signImageView = signImageView
        signImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
            make.height.width.equalTo(16)
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
