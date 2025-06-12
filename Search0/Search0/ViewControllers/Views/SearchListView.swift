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

    // getNextRequest 사용할때만 바꾼다.
    private var isLoading = false
    
    var listSelected: ((Repository) -> Void)?
    var errorOccored: ((Error) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        setSubViews()
        setClosure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews() {
        
        // 검색기록 리스트 보여줄 UITableView
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.estimatedRowHeight = 80
        table.sectionHeaderHeight = 40
        
        table.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.identifier)
        // 테이블뷰 하단에 보여질 로딩뷰 등록
        table.register(LoadingFooterView.self, forHeaderFooterViewReuseIdentifier: LoadingFooterView.identifier)

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
        
        // n개의 저장소
        titleLb.textColor = .gray
        titleLb.text = "\(viewModel.totalCount.decimalString())개 저장소"
        headerView.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(30)
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
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateList()
                loadingFinished()
            }
        }
        
        viewModel.errorOccured = { [weak self] (error) in
            guard let self = self else { return }
            print("========= \(error.localizedDescription)")
            loadingFinished()
            errorOccored?(error)
        }
    }
    
    // 리스트를 업데이트 한다.
    func updateList() {
        // 전체 리스트 업데이트
        table.reloadData()
    }
    
    func loadingStarted() {
        isLoading = true
        showLoadingView(show: true)
    }
    
    func loadingFinished() {
        isLoading = false
        showLoadingView(show: false)
    }
    
    
    func showLoadingView(show: Bool) {
        if show == true {   // 로딩 보여준다
            let loadingView = table.dequeueReusableHeaderFooterView(withIdentifier: LoadingFooterView.identifier) as? LoadingFooterView
            table.tableFooterView = loadingView
        } else {            // 로딩 숨김
            table.tableFooterView = nil
        }
    }
    
}

// MARK: - UITableView Delegate / DataSource
extension SearchListView: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.list.count == 0 ? 1 : viewModel.list.count
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView()
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
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
/*
        // 마지막에서 -5 번째 셀이 보여지려고 준비할때
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        if maxRow >= viewModel.list.count - 1  && isLoading == false {
            // 다음 리스트 가져오자.
            isLoading = true
            viewModel.getNextRepository()
        }
*/
//        if indexPaths.contains(where: { $0.row >= viewModel.list.count - 1 })
//            && isLoading == false {
//            isLoading = true
//            showLoadingView(show: true)
//            viewModel.getNextRepository()
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if viewModel.totalCount > viewModel.list.count &&
            indexPath.row >= viewModel.list.count - 1  &&
            isLoading == false {
            loadingStarted()
            viewModel.getNextRepository()
        }
        
    }
    
}

// MARK: - Section Footer View
class LoadingFooterView: UITableViewHeaderFooterView {
    static let identifier = "LoadingFooterView"
    
    let indicatorView = UIActivityIndicatorView(style: .medium)
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setSubViews()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setSubViews() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        indicatorView.startAnimating()
    }
    
}
