//
//  ActiveTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/3/23.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class ActiveTableViewCell: UITableViewCell {

    // 活动名称
    weak var activeNameLabel: UILabel!
    // 总报名人数
    weak var totalNumLabel: UILabel!
    // 当前报名人数
    weak var currentNumLabel: UILabel!
    // 日期
    weak var timeLabel: UILabel!
    // 社团名称
    weak var teamNameLabel: UILabel!
    
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
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化设置
    func setup() {
        
        // 活动名称
        let activeNameLabel = UILabel()
//        activeNameLabel.font = UIFont
        
        
    }
    
    
    func setupLabel(_ font: CGFloat, textColor: UIColor) -> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        
        return label
    }
    
}
