//
//  WebService.swift
//  WeatherApp
//
//  Created by Florijan Stankir on 09.07.2024..
//

import Foundation

enum APIError: Error {
    case requestFailed
    case invalidResponse
    case decodingFailed
}

class WebService {
    static func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let url = endpoint.url
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed))
                print("Request failed with error: \(error)")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                print("Invalid response or status code")
                return
            }
            
            do {
                //: PRINTING API RESPONSE
                //=============
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let prettyJSONData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                
                if let prettyPrintedString = String(data: prettyJSONData, encoding: .utf8) {
                    print(prettyPrintedString)
                }
                //=============
                
                //: MAPPING RESOPNSE WITH GIVEN TYPE MODEL
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingFailed))
                print("Decoding failed with error: \(error)")
            }
        }.resume()
    }
}


