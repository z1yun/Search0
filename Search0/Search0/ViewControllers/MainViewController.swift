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
    // 이전 검색 기록
    let historyView = SearchHistoryView()
    // 검색 결과
    let listView = SearchListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setSubViews()
        setClosure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         Navigation largeTitle 사용시 다른 ViewController로 push후 다시 back 했을때
         largeTitle이 제대로 동작하지 않는 문제가 있다. 그래서 viewWillAppear에 아래 두줄 추가한다.
         */
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func setNavigationBar() {
        self.title = "Search"
        
        // UISearchController 세팅
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "저장소 검색"
        self.navigationItem.searchController = searchController
        
    }

    func setSubViews() {
        // 테이블뷰 세팅
        self.view.addSubview(listView)
        listView.isHidden = true
        listView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        // 검색 기록 뷰 일단 붙여둔다.
        self.view.addSubview(historyView)
        historyView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // searchView가 property로 설정되어 있어 선언과 동시에 할당하다보니 UITableView의 separatorStyle 적용이 안되는 문제가 있다.
        // viewDidLoad에서 separatorStyle 설정하면 된다. 그래서 여기에 코드가 있다.
        historyView.tableViewSeparatorStyleNone()
        listView.tableViewSeparatorStyleNone()
        
    }
    
    func setClosure() {
        // 각 뷰에 있는 클로저도 설정한다.
        // 이전 검색기록에서 검색어 눌렀음
        historyView.listSelected = { [weak self] (history) in
            guard let self = self else { return }
            // 검색을 해야 한다. listView가 갖고 있는 viewModel을 사용하자.
            // 이건 검색기록을 눌렀으니 무조건 1페이지
            listView.viewModel.getRepository(word: history.text, page: 1)
            // 검색 결과 리스트를 보여주기 위해 historyView는 숨긴다.
            hideHistoryView(hide: true)
        }
        
        // 검색 결과에서 눌렀음.
        listView.listSelected = { [weak self] (repo) in
            guard let self = self else { return }

            // WebViewController의 back버튼 조금만 바꿔주자.
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = .red
            navigationItem.backBarButtonItem = backItem
            
            let vc = WebViewController(url: repo.owner.htmlURL)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func hideHistoryView(hide: Bool) {
        historyView.isHidden = hide
        listView.isHidden = !hide
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
        print(#function)
        
        if let text = searchBar.text, text.isEmpty == false {
            try? historyView.viewModel.addHistory(text: text, regdt: Date.timeIntervalSinceReferenceDate)
            // 검색 request
            listView.viewModel.getRepository(word: text, page: 1)
            // listView 보여준다.
            hideHistoryView(hide: true)
            searchViewController.dismiss(animated: true)
        }
    }
    
}
