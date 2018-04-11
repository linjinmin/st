//
//  SocietyTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/4/3.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class SocietyTableViewCell: UITableViewCell {

    // 社团名称
    weak var nameLabel: UILabel!
    // 职务名称
    weak var jobLabel: UILabel!
    // 简介
    weak var briefLabel: UILabel!
    
    var briefSociety: BriefSociety! {
        didSet {
            
            self.nameLabel.text = (briefSociety.tissue_name! as String)
            self.briefLabel.text = (briefSociety.tissue_describe! as String)
            if briefSociety.position_name != nil {
                self.jobLabel.text = (briefSociety.position_name! as String)
            }
            
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
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.white
        contentView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
        }
        
        // 职务
        let jobLabel = UILabel()
        jobLabel.font = UIFont.systemFont(ofSize: 16)
        jobLabel.textColor = UIColor.white
        contentView.addSubview(jobLabel)
        self.jobLabel = jobLabel
        jobLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        // 简介
        let briefLabel = UILabel()
        briefLabel.font = UIFont.systemFont(ofSize: 13)
        briefLabel.textColor = UIColor.white
        briefLabel.numberOfLines = 0
        briefLabel.contentMode = .left
        contentView.addSubview(briefLabel)
        self.briefLabel = briefLabel
        briefLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.equalTo(80)
            make.width.equalTo(contentView.width * 0.6)
        }
        
        contentView.sizeToFit()
        
    }
    
    func test() {
        nameLabel.text = "计算机系红十字会"
        jobLabel.text = "部长"
        briefLabel.text = "测试测试测试测试测试测试测试测试测试测试"
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
