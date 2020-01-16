//
//  Canzone.swift
//  CarLayout
//
//  Created by Davide Vitiello on 12/12/2019.
//  Copyright © 2019 Davide Vitiello. All rights reserved.
//

import Foundation

class Canzone: Decodable
{
   var nome: String
   var autore: String
   var percorso: String
    var dati : Data?
   
    
    init(nome: String, percorso: String, autore: String)
    {
        self.nome = nome
        self.percorso = percorso
        self.autore = autore
    }
    
    func getPercorso() -> URL
    {
        let percorso = self.percorso.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: percorso)!
        
        
        
    }
}

