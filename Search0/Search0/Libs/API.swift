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


/*
 테스트를 하다보면 대략 10페이지에서 에러가 발생한다.
 
 {"message":"API rate limit exceeded for xxx.xxx.xxx.xxx. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)","documentation_url":"https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting"}
 
 API 요청에 한도가 있어서 인증이 필요한듯.
 */
