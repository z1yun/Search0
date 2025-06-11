//
//  SearchListView.swift
//  Search0
//
//  Created by shbaek on 6/11/25.
//

import UIKit
import SDWebImage

class SearchListView: UIView {
    let viewModel = RepositoriesViewModel()
    private let table = UITableView()
    private var titleLb = UILabel.label("0개 저장소", 15)

    var listSelected: ((Repository) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setClosure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews() {
        
        // n개의 저장소
        titleLb.textColor = .gray
        self.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.height.equalTo(40)
        }
        
        // 검색기록 리스트 보여줄 UITableView
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 80
        table.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.identifier)
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
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateList()
            }
        }
        viewModel.errorOccured = { [weak self] (error) in
            guard let self = self else { return }
        }
    }
    
    // 리스트를 업데이트 한다.
    func updateList() {
        // n개 저장소 업데이트
        let str = "\(viewModel.list.count)개 저장소"
        titleLb.text = str
        // 전체 리스트 업데이트
        table.reloadData()
    }
    
}

// MARK: - UITableView Delegate / DataSource
extension SearchListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.list.count == 0 ? 1 : viewModel.list.count
        return viewModel.list.count
    }
    
    // 테이블뷰 셀 높이 = 자동
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.identifier, for: indexPath) as? SearchListCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let repo = viewModel.list[indexPath.row]
        
        cell.setCell(imageUrl: repo.owner.avatarURL, title: repo.name, subTitle: repo.owner.login)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 리스트에서 repository선택. 여기서 처리하기 애매한 부분이 있다.
        // ViewController로 넘겨주자.
        let repo = viewModel.list[indexPath.row]
        listSelected?(repo)
    }
}

// MARK: - Section Footer View
class LoadingFooterView: UIView {
    
    var allHistoryDelete: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
    }
    
    func setSubViews() {
        
    }
}
