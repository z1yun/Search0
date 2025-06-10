//
//  SearchHistory.swift
//  Search0
//
//  Created by shbaek on 6/9/25.
//

import Foundation

struct SearchHistory: Codable {
    var idx: Int
    var text: String
    var regdt: Int // TimeInterval since 1970
}

class SearchHistoryViewModel {
    
    private var list: [SearchHistory]? {
        didSet {
            // 리스트가 변경되면 알려주자.
            listUpdated?(list ?? [])
        }
    }
    private let mgr = SqliteMgr.shared
    
    var listUpdated: (([SearchHistory]) -> Void)?
    
    func addHistory(text: String, regdt: Int) throws -> Bool {
        
        // Sqlite DB에 검색 기록 추가한다.
        let result = mgr.insert(searchWord: text, regdt: regdt)
        if result == false {
            throw NSError(domain: mgr.errorMessage(), code: -1)
        }
        return result
    }
    
    func searchHistorys(keyword: String) -> [SearchHistory] {
        let rows: [(Int, String, Int)] = mgr.selectAll()
        list = rows.map { SearchHistory(idx: $0.0, text: $0.1, regdt: $0.2) }
        return list ?? []
    }
    
    func deleteHistory(idx: Int) throws -> Bool {
        
        if mgr.delete(idx: idx) == false {
            throw NSError(domain: mgr.errorMessage(), code: -1)
        }
        return true
    }
    
    func deleteAllHistory() throws -> Bool {
        if  mgr.deleteAll() == false {
            throw NSError(domain: mgr.errorMessage(), code: -1)
        }
        return true
    }
}
