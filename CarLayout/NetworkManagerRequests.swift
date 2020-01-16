//
//  NetworkManagerRequests.swift
//  CarLayout
//
//  Created by Davide Vitiello on 09/12/2019.
//  Copyright © 2019 Davide Vitiello. All rights reserved.
//

import Foundation


class NetworkManagerRequests
{
    
    static let sitoMappe = "https://provabreakapp.altervista.org/CarLayout/FetchNomePosto/"
    static let sitoMusica = "https://provabreakapp.altervista.org/CarLayout/FetchMusica/"
    
    static func fetchNomePosto(sito: String) -> RispostaPosto? {
        
        let url = URL(string: sito)!
        
       do {
            let contents = try String(contentsOf: url)
            print(contents)
            
            let tmp = try JSONDecoder().decode(RispostaPosto.self, from: contents.data(using: .utf8)!)
        
            return tmp
        } catch let error{
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func fetchCanzoni(sito: String) -> [Canzone]? {
        
        
        
       let url = URL(string: sito.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
       do {
            let contents = try String(contentsOf: url)
            print(contents)
            
            let tmp = try JSONDecoder().decode([Canzone].self, from: contents.data(using: .utf8)!)
        
            return tmp
        } catch let error{
            print(error.localizedDescription)
        }
        return nil
    }
}
