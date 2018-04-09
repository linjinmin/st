//
//  NoticeTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/3/27.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    // 标题
    weak var title: UILabel!
    // 内容
    weak var content:UILabel!
    
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
        
        let logo = UIImageView(image: UIImage(named:"logo"))
        logo.layer.cornerRadius = 15
        logo.layer.masksToBounds = true
        contentView.addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(15)
            make.height.width.equalTo(30)
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
            make.right.equalTo(contentView).offset(-10)
        }
        
        let content = UILabel()
        content.font = UIFont.systemFont(ofSize: 16)
        content.textColor = UIColor.black
        content.numberOfLines = 0
        contentView.addSubview(content)
        self.content = content
        content.snp.makeConstraints { (make) in
            make.left.right.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(10)
        }
        
    }
    
    func test() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
