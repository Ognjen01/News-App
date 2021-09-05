//
//  APICaller.swift
//  News App
//
//  Created by Ognjen Lazic on 5. 9. 2021..
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2021-09-05&sortBy=popularity&apiKey=71b2fd22529a47aca6fadb231b022d4b")
    }
    
    private init()
    {
        
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}

struct APIResponse: Codable {
    let articles : [Article]
}

struct Article: Codable{
    let title: String
    let description:  String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let source: Source
}

struct Source: Codable {
    let name: String
}
