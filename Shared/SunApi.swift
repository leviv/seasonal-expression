//
//  APIResponse.swift
//  seasonal-expression
//
//  Created by Levi Villarreal on 1/14/22.
//

import Foundation

struct Response: Codable {
    var results: Results
    var status: String
}

struct Results: Codable {
    // All times are in UTC
    var sunrise: String
    var sunset: String
    var day_length: String
}

// https://sunrise-sunset.org/api
// options include lat, lng and date (formatted as YYYY-MM-DD)
let API_URL = "https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400"

class Api : ObservableObject{
    @Published var fetchedData = [Response]()
    
    func loadData(completion:@escaping (Response) -> ()) {
        guard let url = URL(string: "\(API_URL)=\(36.7201600)&lng=\(-4.4203400)") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("levi")
            let fetchedData = try! JSONDecoder().decode(Response.self, from: data!)
            print(fetchedData)
            DispatchQueue.main.async {
                completion(fetchedData)
            }
        }.resume()
        
    }
}
