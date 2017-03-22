//
//  DataStore.swift
//  SpotifyCodingChallenge
//
//  Created by Michael Young on 3/20/17.
//  Copyright © 2017 Michael Young. All rights reserved.
//

import SwiftyJSON
import Alamofire
import TRON

class People: NSObject {
    var name: String?
    var favoriteCity: String?
    var id: Int?
    
    init(jsonDictionary: NSDictionary) {
        self.name = jsonDictionary["name"] != nil ? jsonDictionary["name"] as! String! : nil
        self.favoriteCity = jsonDictionary["favoritecity"] != nil ? jsonDictionary["favoritecity"] as! String! : nil
        self.id = jsonDictionary["id"] != nil ? jsonDictionary["id"] as? Int : nil
    }
}

class DataStore {
    static let sharedInstance = DataStore()
    
    private init()  {}
    
    var results = [JSON]()
    var last = [Any]()
    var updated = [Any]()
    
    var deleted = String()
    var first = String()
    var newPerson = String()
    var people = String()
    var peopleData = [People]()
    var statusString = String()
    
    func getPeople() {
        Alamofire.request("\(baseURL)/people").responseJSON { response in
            var newPeopleData = [People]()
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.people = self.prettyJSON(from: data)
            }
            
            guard response.result.isSuccess else {
                print("Error while fetching people: \(response.result.error)")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                print("Invalid tag information received from the service")
                return
            }
            
            guard let people = responseJSON["people"] as? [[String : Any]] else {
                print("Error while pulling people Array")
                return
            }
            
            for element in people {
                newPeopleData.append(People(jsonDictionary: element as NSDictionary))
            }
            self.peopleData = newPeopleData
        }
    }
    
    func postPeopleData(name: String, city: String) {
        let parameters: Parameters = [
            "name": name,
            "favoritecity": city
        ]
        
        let request = Alamofire.request("\(baseURL)/people",
                                        method: .post,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default)
        
        
        request.response { (response) in
            guard let data = response.data else {
                print("Error fetching data")
                return
            }
            
            let statusCode = response.response?.statusCode
            let url = response.response?.url
            self.statusString = "◎ Status Code: \(statusCode!) \n \n ◎ URL: \(url!)"
            
            let jsonObject = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if let id = jsonObject?["id"] {
                self.fetchPerson(with: id as! Int)
            }
        }
    }
    
    func fetchPerson(with id: Int) {
        Alamofire.request("\(baseURL)/people/\(id)").responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.newPerson = self.prettyJSON(from: data)
            }
        }
    }
    
    func updateFavoriteCity(name: String, city: String, id: Int) {
        let parameters: Parameters = [
            "name": name,
            "favoritecity": city,
            "id" : id
        ]
        
        let request = Alamofire.request("\(baseURL)/people/\(id)",
            method: .put,
            parameters: parameters,
            encoding: JSONEncoding.default)
        
        request.response { (response) in
            print("Response:\(response)")
        }

    }
    
    func getFirst() {
        Alamofire.request("\(baseURL)/people/1").responseJSON { response in
            if let data = response.data {
                self.first = self.prettyJSON(from: data)
            }
        }
    }
    
    func deleteFirst() {
        let request = Alamofire.request("\(baseURL)/people/\(1)",
            method: .delete,
            parameters: nil,
            encoding: JSONEncoding.default)
        
        request.response { response in
            if let data = response.data {
                self.deleted = self.prettyJSON(from: data)
            }
        }
    }
    
    // TODO: Safely unwrap and error handling
    func prettyJSON(from data: Data) -> String {
        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
        let prettyJsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        let prettyJson = String(data: prettyJsonData, encoding: String.Encoding.utf8)
        return prettyJson!
    }
}
