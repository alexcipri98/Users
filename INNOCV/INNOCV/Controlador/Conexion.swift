//
//  Conexion.swift
//  INNOCV
//
//  Created by Alex on 10/10/22.
//

import Foundation

class ConexionRest{
    
    private var users:[User] = []
    
    func getUsers()->[User]{
        return self.users
    }
    
    //Request to get Users
    func loadData(completion: @escaping ([User]) -> ()) {
        guard let url = URL(string: "https://hello-world.innocv.com/api/User") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) {data, response, error in
           
            if let error = error {
              print("Error with users: \(error)")
              return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
              return
            }
            
            if let data = data {
                let decoder = self.getDecoder()
                
                //Result:[User] --> All Users decoded of the JSON
                if let result = try? decoder.decode([User].self, from: data) {
                    self.users = result
                    completion(result)
                }
                
                return
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")

        }
        task.resume()
    }
    
    func AddUser(thisuser:User){
        
        guard let url = URL(string: "https://hello-world.innocv.com/api/User") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        let jsonData = try? JSONEncoder().encode(thisuser)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                   guard error == nil else {
                       print("Error: error calling POST")
                       print(error!)
                       return
                   }
                   guard let data = data else {
                       print("Error: Did not receive data")
                       return
                   }
                   guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                       print("Error: HTTP request failed")
                       return
                   }
               }.resume()
    }
    
    func delete(id:Int){
        guard let url = URL(string: "https://hello-world.innocv.com/api/User/\(id)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")

        }.resume()
    }
    
    //Return a decoder, with the correct format to decode the Date type.
    func getDecoder() -> JSONDecoder{
        let formatter = DateFormatter()
        var decoder: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)

                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let date = formatter.date(from: dateString) {
                    return date
                }
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                if let date = formatter.date(from: dateString) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container,
                    debugDescription: "Cannot decode date string \(dateString)")
            }
            return decoder
        }
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }

    
}
