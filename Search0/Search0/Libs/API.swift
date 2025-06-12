//
//  API.swift
//  Search0
//
//  Created by shbaek on 6/11/25.
//

import Foundation

enum APIError: Error {
    case jsonDecodingFailed
    case responseDataNil
}


class API {
    
    private func getUrl(word: String, page: Int) -> String {
        return "https://api.github.com/search/repositories?q=\(word)&page=\(page)"
    }
    
    func sendRequest(word: String, page: Int) async -> (Data?, URLResponse?, Error?) {
        URLSession.shared.configuration.timeoutIntervalForRequest = 10
        let url = URL(string: getUrl(word: word, page: page))!
        print(">> request url : \(url)")
        do {
            let res: (Data, URLResponse) = try await URLSession.shared.data(from: url)
            return (res.0, res.1, nil)
        } catch {
            print(error.localizedDescription)
            return (nil, nil, error)
        }
    }
}


