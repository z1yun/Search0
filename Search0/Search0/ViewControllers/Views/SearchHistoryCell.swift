//
//  SearchHistoryCell.swift
//  Search0
//
//  Created by shbaek on 6/10/25.
//

import UIKit

class SearchHistoryCell: UITableViewCell {
    static let identifier = "SearchHistoryCell"
    
    private let textLb: UILabel = {
        let lbl = UILabel.label("", 17)
        return lbl
    }()
    
    var searchIdx: Int = -1
    // 삭제 버튼 눌렀을 때
    var historyDelete: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubViews()
    }
    
    func setSubViews() {
        
        // 검색어 보여주는 Label
        textLb.numberOfLines = 0
        textLb.textColor = .darkGray
        self.contentView.addSubview(textLb)
        textLb.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.lessThanOrEqualTo(self.contentView.snp.trailing).offset(-40)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        // 삭제버튼
        let action = UIAction { [weak self] _ in
            guard let `self` = self else { return }
            self.historyDelete?(self.searchIdx)
        }
        
        let img = UIImage(systemName: "xmark.circle.fill")
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setImage(img?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        deleteBtn.addAction(action, for: .touchUpInside)
        self.contentView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.leading.equalTo(textLb.snp.trailing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    func setText(idx: Int, text: String) {
        textLb.text = text
        searchIdx = idx
    }
    
    func getText() -> (Int, String) {
        return (searchIdx, textLb.text ?? "")
    }
    
}



// 최근 검색어가 아무것도 없을 때 보여줄 셀 하나 만든다.
class NoHistoryCell: UITableViewCell {
    static let identifier = "NoHistoryCell"
    
    private let textLb: UILabel = {
        let lbl = UILabel.label("최근 검색 기록이 없습니다.", 13)
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubViews()
    }
    
    func setSubViews() {
        
        // 검색어 보여주는 Label
        textLb.numberOfLines = 0
        textLb.textColor = .darkGray
        textLb.textAlignment = .center
        self.contentView.addSubview(textLb)
        textLb.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
