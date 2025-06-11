//
//  Repositories.swift
//  Search0
//
//  Created by shbaek on 6/11/25.
//

import Foundation

struct Repositories: APIModelCodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Repository: Codable {
    
    let name: String
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case name
        case owner
    }
}

struct Owner: Codable {
    let login: String
    let avatarURL: String
    let htmlURL: String
    
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}


class RepositoriesViewModel {
    private(set) var list: [Repository] = [] {
        didSet {
            listUpdated?()
        }
    }
    let api = API()
    var totalCount = 0
    
    var listUpdated: (() -> Void)?
    var errorOccured: ((Error?) -> Void)?
    
    func getRepository(word: String, page: Int) {
        Task {
            if let data: (Data, URLResponse) = await api.sendRequest(word: word, page: page),
               let repos = Repositories.from(data: data.0) {
                totalCount = repos.totalCount
                
                // Repositories 로 받음
                if page == 1 {  // 데이터를 받아왔는데 1페이지임. 처음 받아온 데이터. items를 그냥 list
                    list = repos.items
                } else {        // 2페이지 부터는 list에 append해야 함.
                    list.append(contentsOf: repos.items)
                    
                    Task { @MainActor in
                        self.listUpdated?()
                    }
                }
                
            } else {        // 에러.
                errorOccured?(nil)
            }
        }
    }
    
    
    
}
