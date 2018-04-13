//
//  ActiveTableViewCell.swift
//  st
//
//  Created by 林劲民 on 2018/3/23.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class HomeActiveTableViewCell: UITableViewCell {
    
    // 活动名称
    weak var activeNameLabel: UILabel!
    // 报名人数
    weak var peopleLabel: UILabel!
    // 日期
    weak var timeLabel: UILabel!
    // 社团名称
    weak var teamLabel: UILabel!
    
    var homeActive: HomeActive! {
        didSet {
            
            self.activeNameLabel.text = "\(homeActive.name ?? "")"
            self.peopleLabel.text = "\(homeActive.join_num ?? "")/\(homeActive.num ?? "")"
            self.timeLabel.text = "\(homeActive.begin ?? "")-\(homeActive.end ?? "")"
            self.teamLabel.text = "\(homeActive.tissue_name ?? "")"
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
        test()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化设置
    func setup() {
        
        // 活动名称
        let activeNameLabel = setupLabel(20)
        contentView.addSubview(activeNameLabel)
        self.activeNameLabel = activeNameLabel
        activeNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.width.equalTo(120)
        }
        
        // 参与人数icon
        let peopleIcon = UIImageView(image: UIImage(named: "user_white"))
        contentView.addSubview(peopleIcon)
        peopleIcon.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(activeNameLabel)
            make.height.width.equalTo(20)
        }
        
        // 参与人数
        let peopleLabel = setupLabel(20)
        contentView.addSubview(peopleLabel)
        peopleLabel.textAlignment = .right
        self.peopleLabel = peopleLabel
        peopleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(activeNameLabel)
            make.right.equalTo(peopleIcon.snp.left).offset(-2)
            make.width.equalTo(120)
        }
        
        // 时间label
        let timeLabel = setupLabel(16)
        contentView.addSubview(timeLabel)
        self.timeLabel = timeLabel
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-10)
            make.left.equalTo(activeNameLabel)
            make.width.equalTo(120)
        }
        
        // 社团名称
        let teamLabel = setupLabel(16)
        contentView.addSubview(teamLabel)
        teamLabel.textAlignment = .right
        self.teamLabel = teamLabel
        teamLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(timeLabel)
            make.right.equalTo(peopleIcon)
            make.width.equalTo(150)
        }
        
    }
    
    func test() {
        activeNameLabel.text = "献血活动"
        peopleLabel.text = "15/25"
        teamLabel.text = "计算机系红十字会"
        timeLabel.text = "2018/5/6-5/8"
    }
    
    func setupLabel(_ font: CGFloat) -> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = UIColor.white
        return label
    }
    
}
