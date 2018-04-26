//
//  SocietyMemberListTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/4/26.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SocietyMemberListTableViewCell: UITableViewCell {

    // 头像
    weak var head: UIImageView!
    // 昵称
    weak var name: UILabel!
    // 发起人label
    weak var releaseLabel: UILabel!
    // 是否第一个用户
    var is_first: NSString!
    
    var member: SocietyMember! {
        didSet {
            
            head.sd_setImage(with: URL(string: member.head_pic as String), placeholderImage: UIImage(named: "image_placeholder"))
            name.text = "\(member.name ?? "")"
            
            if is_first == "1" {
                name.snp.makeConstraints { (make) in
                    make.centerY.equalTo(contentView)
                    make.left.equalTo(releaseLabel.snp.right)
                }
            } else {
                name.snp.makeConstraints { (make) in
                    make.centerY.equalTo(contentView)
                    make.left.equalTo(head.snp.right).offset(10)
                }
                releaseLabel.isHidden = true
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
        
    }
    
    func setupLabel(font: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.black
        return label
    }

}
