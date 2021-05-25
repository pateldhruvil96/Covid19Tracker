//
//  WorldStatsModel.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 24/05/21.
//

import Foundation

struct WorldStatsModel:Codable{
    let totalConfirmed, totalDeaths, totalRecovered: Int
    
    enum CodingKeys: String, CodingKey {
        case totalConfirmed = "TotalConfirmed"
        case totalDeaths = "TotalDeaths"
        case totalRecovered = "TotalRecovered"
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalConfirmed = try container.decode(Int.self, forKey: .totalConfirmed)
        self.totalDeaths = try container.decode(Int.self, forKey: .totalDeaths)
        self.totalRecovered = try container.decode(Int.self, forKey: .totalRecovered)
    }
}

