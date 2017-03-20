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

class DataStore {
    static let sharedInstance = DataStore()
    
    private init()  {}
    
    var results = [JSON]()
    var last = [Any]()
    var updated = [Any]()
    var first = [Any]()
    var deleted = [Any]()
    
    let tron = TRON(baseURL: "https://shielded-gorge-22087.herokuapp.com")
    
    func fetchPeopleData() {
        // start json fetch
        let request: APIRequest<Home, JSONError> = tron.request("/people")
        request.perform(withSuccess: { (home) in
            print("Success! Fetched JSON objects")
        }) { (error) in
            print("Failed! Unable to fetch JSON", error)
        }
    }
    
    func postPeopleData(name: String, city: String) {
        let parameters: Parameters = [
            "name": name,
            "favoritecity": city
        ]
        
        let request = Alamofire.request("https://shielded-gorge-22087.herokuapp.com/people",
                                        method: .post,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default)
        
        
        request.response { (response) in
            print("Response:\(response)")
        }
    }
    
    func fetchLast() {
        Alamofire.request("https://shielded-gorge-22087.herokuapp.com/last").responseJSON { (response) in
            if let value = response.result.value {
                self.last = [value]
            }
        }
    }
    
    // TODO: Change to update last
    func updateFirst() {
        Alamofire.request("https://shielded-gorge-22087.herokuapp.com/update").responseJSON { (response) in
            if let value = response.result.value {
                self.updated = [value]
            }
        }
    }
    
    func getFirst() {
        Alamofire.request("https://shielded-gorge-22087.herokuapp.com/people/1").responseJSON { (response) in
            print("REQUEST \(response.request!)")
            print("RESPONSE \(response.response!)")
            print("DATA \(response.data!)")
            print("RESULT \(response.result)")
            
            if let value = response.result.value {
                self.first = [value]
            }
        }
    }
    
    func deleteFirst() {
        Alamofire.request("https://shielded-gorge-22087.herokuapp.com/people/1/delete").responseJSON { (response) in
            if let value = response.result.value {
                self.deleted = [value]
            }
        }
    }
    
    func deleteAll() {
        Alamofire.request("https://shielded-gorge-22087.herokuapp.com/deleteall").responseJSON { (response) in
            if let value = response.result.value {
                print(value)
            }
        }
    }
}

class Home: JSONDecodable {
    let store = DataStore.sharedInstance
    required init(json: JSON) throws {
        print("Ready to parse JSON: \n", json)
        
        // TODO: unwarp safely
        let array = json["people"].array
        store.results = array!
        print("Results: \(store.results)")
        
        // TODO: unwarp safely
        for personJson in array! {
            print(personJson["name"])
            print(personJson["id"])
            print(personJson["favoritecity"])
        }
    }
}

class JSONError: JSONDecodable {
    required init(json: JSON) throws {
        print("JSON Error")
    }
}
