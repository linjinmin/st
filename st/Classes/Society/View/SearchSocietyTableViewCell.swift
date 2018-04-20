//
//  SocietyTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/4/3.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import SDWebImage

class SearchSocietyTableViewCell: UITableViewCell {
    
    
    // 社团头像
    weak var headImageView: UIImageView!
    // 社团名称
    weak var nameLabel: UILabel!
    
    var briefSociety: SearchSociety! {
        didSet {
            
            headImageView.sd_setImage(with: URL(string: briefSociety.pic as String), placeholderImage: UIImage(named: "image_placeholder"))
            nameLabel.text = "\(briefSociety.name ?? "")"
           
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
        
        // 社团头像
        let headImageView = UIImageView()
        headImageView.layer.cornerRadius = 25
        headImageView.layer.masksToBounds = true
        contentView.addSubview(headImageView)
        self.headImageView = headImageView
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(50)
        }
        
        // 社团名称
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.black
        contentView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.centerY.equalTo(contentView)
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

