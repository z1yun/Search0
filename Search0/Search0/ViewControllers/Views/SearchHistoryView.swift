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
        
        // 최근 검색 타이틀
        let titleLb = UILabel.label("최근 검색", 20, true)
        self.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
        }
        
        // 검색기록 리스트 보여줄 UITableView
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 70
        table.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.identifier)
        table.register(NoHistoryCell.self, forCellReuseIdentifier: NoHistoryCell.identifier)
        self.addSubview(table)
        
        table.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
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
        print(">>> " + #function)
        
        do {
            try viewModel.deleteHistory(idx: idx)
        } catch {
            print(error)
        }
    }
    
    func deleteAllHistory() {
        print(">>> " + #function)
        
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
        return viewModel.list.count == 0 ? 1 : viewModel.list.count
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
            return nil
        }
    }
    
    // 테이블뷰 셀 높이 = 자동
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.list.count > 0 ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 검색 기록이 없음. 기록없음 셀을 보여준다.s
        if viewModel.list.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoHistoryCell.identifier, for: indexPath) as? NoHistoryCell else {
                return UITableViewCell()
            }
            return cell
        }
        
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
