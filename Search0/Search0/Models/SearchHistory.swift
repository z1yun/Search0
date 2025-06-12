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
    var regdt: Double // TimeInterval since ReferenceTime
    
    func dateString() -> String {
        let date = Date(timeIntervalSinceReferenceDate: regdt)
        let fmt = DateFormatter()
        fmt.dateFormat = "MM. dd"
        return fmt.string(from: date)
    }
}

class SearchHistoryViewModel {

    private(set) var list: [SearchHistory] = [] {
        didSet {
            // 리스트가 변경되면 알려주자.
            listUpdated?()
        }
    }
    private let mgr = SqliteMgr.shared
    
    var listUpdated: (() -> Void)?
    
    init() {
        _ = searchHistorys()
    }
    
    /// 검색 기록 추가
    /// - Parameters:
    ///   - text: 검색어
    ///   - regdt: 검색 시간
    func addHistory(text: String, regdt: Double) throws {
        
        // Sqlite DB에 검색 기록 추가한다.
        let result = mgr.insert(searchWord: text, regdt: regdt)
        if result == false {
            throw NSError(domain: mgr.errorMessage(), code: -1)
        }
        
        // 중복제거
        if let index = list.firstIndex(where: { $0.text == text }) {
            _ = try deleteHistory(idx: list[index].idx)
        }
        
        // 추가 성공했을때 기록이 10개 이상이면 list의 0번 삭제하고 리스트 다시 가져온다.
        if list.count >= 10 {
            if let search = list.last {
                do {
                    _ = try deleteHistory(idx: search.idx)
                } catch {
                    throw error
                }
            }
        }
        // 검색 기록 갱신한다.
        _ = searchHistorys()
    }
    
    /// 검색기록
    /// - Returns: 검색기록 리스트
    func searchHistorys() -> [SearchHistory] {
        let rows: [(Int, String, Double)] = mgr.selectAll()
        list = rows.map { SearchHistory(idx: $0.0, text: $0.1, regdt: $0.2) }
        print(list)
        return list
    }
    
    /// 한개의 검색 기록 삭제
    /// - Parameter idx: SearchHistory 의 idx
    /// - Returns: 성공/실패
    func deleteHistory(idx: Int) throws {
        if mgr.delete(idx: idx) == false {
            throw NSError(domain: mgr.errorMessage(), code: -1)
        }
        _ = searchHistorys()
    }
    
    /// 검색기록 전체 삭제
    func deleteAllHistory() throws {
        if  mgr.deleteAll() == false {
            throw NSError(domain: mgr.errorMessage(), code: -1)
        }
        _ = searchHistorys()
    }
}
