//
//  AutoCompleteCell.swift
//  Search0
//
//  Created by shbaek on 6/12/25.
//

import UIKit

class AutoCompleteCell: UITableViewCell {
    static let identifier: String = "AutoCompleteCell"
    private let textLb: UILabel = UILabel.label("", 17)
    private let dateLb = UILabel.label("", 14)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews() {
        
        // 날짜를 먼저 붙이고 날짜가 차지하는 width를 제외한 부분을 textLb로 채운다.
        
        // 날짜 Label
        dateLb.textColor = .lightGray
        self.contentView.addSubview(dateLb)
        dateLb.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        // 검색어 보여주는 Label
        textLb.numberOfLines = 0
        textLb.textColor = .darkGray
        self.contentView.addSubview(textLb)
        textLb.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.lessThanOrEqualTo(dateLb.snp.leading).offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    func setText(text: String, dateText: String) {
        textLb.text = text
        dateLb.text = dateText
    }
    
}
