//
//  API.swift
//  Search0
//
//  Created by shbaek on 6/11/25.
//

import Foundation

class API {
    
    private func getUrl(word: String, page: Int) -> String {
        return "https://api.github.com/search/repositories?q=\(word)&page=\(page)"
    }
    
    func sendRequest(word: String, page: Int) async -> (Data, URLResponse)? {
        let url = URL(string: getUrl(word: word, page: page))!
        do {
            let res: (Data, URLResponse) = try await URLSession.shared.data(from: url)
            return res
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}


