//
//  NoticeTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/3/27.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SDWebImage

class NoticeTableViewCell: UITableViewCell {

    // 头像
    weak var logo: UIImageView!
    // 标题
    weak var title: UILabel!
    // 内容
    weak var content:UILabel!
    // 红色的view
    weak var red: UIView!
    
    var message: UserMessage! {
        didSet {
            
            if message.head_pic == "" {
                // 显示社团图标
                logo.image = UIImage(named: "logo")
            } else {
                // 显示用户图标
                logo.sd_setImage(with: URL(string: message.head_pic as String), placeholderImage: UIImage(named: "image_placeholder"))
            }
            
            title.text = "\(message.title ?? "")"
            content.text = "\(message.msg ?? "")"
            
            if message.status == "0" && message.type != "0" {
                red.isHidden = false
            } else {
                red.isHidden = true
            }
            
        }
    }
    
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.size.height -= 1
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
        
        let logo = UIImageView(image: UIImage(named:"logo"))
        logo.layer.cornerRadius = 20
        logo.layer.masksToBounds = true
        contentView.addSubview(logo)
        self.logo = logo
        logo.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(15)
            make.height.width.equalTo(40)
        }
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = UIColor.black
        title.numberOfLines = 0
        contentView.addSubview(title)
        self.title = title
        title.snp.makeConstraints { (make) in
            make.left.equalTo(logo.snp.right).offset(10)
            make.centerY.equalTo(logo)
            make.right.equalTo(contentView).offset(-20)
        }
        
        let content = UILabel()
        content.font = UIFont.systemFont(ofSize: 14)
        content.textColor = UIColor.black
        content.numberOfLines = 2
        contentView.addSubview(content)
        self.content = content
        content.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.right.equalTo(title).offset(-20)
            make.top.equalTo(title.snp.bottom).offset(10)
        }
        
        let red = UIView()
        red.backgroundColor = UIColor.red
        red.layer.cornerRadius = 5
        contentView.addSubview(red)
        self.red = red
        red.snp.makeConstraints { (make) in
            make.centerY.equalTo(title)
            make.right.equalTo(contentView).offset(-20)
            make.height.width.equalTo(10)
        }
        
        let henBottom = UIView()
        henBottom.backgroundColor = Constant.littleGray
        contentView.addSubview(henBottom)
        henBottom.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(1)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
