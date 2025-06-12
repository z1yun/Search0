//
//  SearchHistoryView.swift
//  Search0
//
//  Created by shbaek on 6/10/25.
//

import UIKit

/// 최근검색 기록 보여주는 뷰
class SearchHistoryView: UIView {
    
    let viewModel = SearchHistoryViewModel()
    private let table = UITableView()

    var listSelected: ((SearchHistory) -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setSubViews()
        setClosure()
    }
    
    func setSubViews() {
        
        // 검색기록 리스트 보여줄 UITableView
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 70
        table.sectionHeaderHeight = 40
        table.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.identifier)
        self.addSubview(table)
        
        table.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // n개의 저장소 Label을 self에 직접 붙이면 UITableView를 스크롤할때 navigation bar title이 .large와 .inline 자동으로 변경이 안된다.
    // n개의 저장소 Label은 UITableView section header에 붙인다.
    func headerView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        // 최근 검색 타이틀
        let titleLb = UILabel.label("최근 검색", 20, true)
        headerView.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
        }
        
        return headerView
    }
    
    func tableViewSeparatorStyleNone() {
        table.separatorStyle = .none
    }
    
    // viewModel에있는 클로저 세팅한다.
    func setClosure() {
        viewModel.listUpdated = { [weak self] in
            guard let self = self else { return }
            table.reloadData()
        }
    }
    
    func deleteHistory(idx: Int) {
        do {
            try viewModel.deleteHistory(idx: idx)
        } catch {
            print(error)
        }
    }
    
    func deleteAllHistory() {
        do {
            try viewModel.deleteAllHistory()
        } catch {
            print(error)
        }
    }
    
}

// MARK: - UITableView Delegate / DataSource
extension SearchHistoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }

    // 여기에 전체삭제 버튼 만들어서 붙이자.
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.list.count > 0 {
            let view = SectionDeleteFooterView()
            // 전체 삭제
            view.allHistoryDelete = { [weak self] in
                guard let self = self else { return }
                self.deleteAllHistory()
            }
            return view
        } else {
            return SectionNoDataFooter()
        }
    }
    
    // 테이블뷰 셀 높이 = 자동
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryCell.identifier, for: indexPath) as? SearchHistoryCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let search = viewModel.list[indexPath.row]
        cell.setText(idx: search.idx, text: search.text)
     
        // 셀에 있는 검색어 삭제 버튼 누르면 여기 실행된다.
        cell.historyDelete = { [weak self] (idx) in
            guard let `self` = self else { return }
            deleteHistory(idx: idx)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 이전 검색어 누름. idx 랑 검색어 가져온다
        let searchHistory = viewModel.list[indexPath.row]
        listSelected?(searchHistory)
    }
    
}


// MARK: - Section Footer View

// 최근 검색어가 아무것도 없을 때 보여줄 셀 하나 만든다.
class SectionNoDataFooter: UIView {
    
    private let textLb: UILabel = {
        let lbl = UILabel.label("최근 검색 기록이 없습니다.", 13)
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
    }
    
    func setSubViews() {
        
        // 검색어 보여주는 Label
        textLb.numberOfLines = 0
        textLb.textColor = .darkGray
        textLb.textAlignment = .center
        self.addSubview(textLb)
        textLb.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}


/// 리스트가 있을때 붙는 SectionFooter. 전체삭제.
class SectionDeleteFooterView: UIView {
    
    var allHistoryDelete: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubView()
    }
    
    func setSubView() {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.allHistoryDelete?()
        }
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setTitle("전체 삭제", for: .normal)
        deleteBtn.setTitleColor(.red, for: .normal)
        deleteBtn.addAction(action, for: .touchUpInside)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(deleteBtn)
        
        deleteBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
    }
}
