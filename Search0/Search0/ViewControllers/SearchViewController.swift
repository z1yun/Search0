//
//  ResultViewController.swift
//  Search0
//
//  Created by shbaek on 6/9/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    let table = UITableView()
    private var list: [SearchHistory] = []
    var listSelected: ((SearchHistory) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        seteSubViews()
    }
    
    func seteSubViews() {
        
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 50
        table.separatorStyle = .none
        table.register(AutoCompleteCell.self, forCellReuseIdentifier: AutoCompleteCell.identifier)
        self.view.addSubview(table)
        
        table.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MainViewController 에서 자동완성 리스트 여기로...
    func updateList(_ list: [SearchHistory]) {
        self.list = list
        table.reloadData()
    }
    
}

// MARK: - UITableViewDelegate / DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutoCompleteCell.identifier, for: indexPath) as? AutoCompleteCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let search = list[indexPath.row]
        cell.setText(text: search.text, dateText: search.dateString())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let search = list[indexPath.row]
        listSelected?(search)
    }
    
}
