//
//  SearchListCell.swift
//  Search0
//
//  Created by shbaek on 6/11/25.
//
import UIKit

class SearchListCell: UITableViewCell {
    static let identifier = "SearchListCell"
    
    private let iv = UIImageView()
    private let titleLb = UILabel.label("", 18)
    private let subTitleLb = UILabel.label("", 14)
    
    // 왼쪽에 있는 아이콘이 로딩 안될때 표시할 이미지
    let placeHolderImage = UIImage(systemName: "face.smiling.inverse")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubViews()
    }

    func setSubViews() {
        
        // 왼쪽에 붙는 이미지
        let imageSize: CGFloat = 40
        let sideMargin: CGFloat = 20
        // 원으로 자르자.
        iv.clipsToBounds = true
        iv.layer.cornerRadius = imageSize / 2
//        iv.shadow()
        self.contentView.addSubview(iv)
        
        iv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(sideMargin)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        // 타이틀
        self.contentView.addSubview(titleLb)
        titleLb.lineBreakMode = .byTruncatingTail
        titleLb.snp.makeConstraints { make in
            make.leading.equalTo(iv.snp.trailing).offset(10)
            make.top.equalTo(iv.snp.top)
            make.trailing.equalToSuperview().offset(-sideMargin)
            make.height.equalTo(25)
        }
        
        // 서브타이틀
        self.contentView.addSubview(subTitleLb)
        subTitleLb.lineBreakMode = .byTruncatingTail
        subTitleLb.textColor = .lightGray
        subTitleLb.snp.makeConstraints { make in
            make.leading.equalTo(iv.snp.trailing).offset(10)
            make.top.equalTo(titleLb.snp.bottom)
            make.trailing.equalToSuperview().offset(-sideMargin)
            make.height.equalTo(15)
        }
    }
    
    func setCell(imageUrl: String, title: String, subTitle: String) {
        // 이미지 set. SDWebImage 사용하자.
        iv.sd_setImage(with: URL(string: imageUrl),
                       placeholderImage: UIImage(named: "placeholder.png"))
        // 타이틀
        titleLb.text = title
        // 서브타이틀
        subTitleLb.text = subTitle
    }
    
}

