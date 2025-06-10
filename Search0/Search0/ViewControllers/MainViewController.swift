//
//  SearchViewController.swift
//  Search0
//
//  Created by shbaek on 6/9/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    let table = UITableView()
    let searchViewController = SearchViewController()
    let historyView = SearchHistoryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        viewLayout()
    }

    func setNavigationBar() {
        self.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .automatic
        
        // UISearchController 세팅
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "저장소 검색"
        self.navigationItem.searchController = searchController
        
    }

    func viewLayout() {
        // 테이블뷰 세팅
        self.view.addSubview(table)
        table.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // 검색 기록 뷰 일단 붙여둔다.
        self.view.addSubview(historyView)
        historyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // searchView가 property로 설정되어 있어 선언과 동시에 할당하다보니 UITableView의 separatorStyle 적용이 안되는 문제가 있다.
        // viewDidLoad에서 separatorStyle 설정하면 된다. 그래서 여기에 코드가 있다.
        historyView.tableViewSeparatorStyleNone()
    }
    
}

// MARK: - UISearchControl Protocol
extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        print(#function)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print(#function)
    }
    
    
    // UISearchREsultsUPdating ---------
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        print(#function, text)
        
//        filteredData = data.filter { $0.lowercased().contains(text) }
//        tableView.reloadData()
    }
    
    // UISearchBarDelegate -----
    // 검색 키보드에서 Enter(Search) 눌렀음.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // DB에 검색에 추가 해야함. SearchHistoryView가 갖고 있는 SearchHistoryViewModel을 통해서 추가하자.
        try? historyView.viewModel.addHistory(text: searchBar.text!, regdt: Date.timeIntervalSinceReferenceDate)

    }
    
}
