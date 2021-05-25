//
//  Country.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Patel on 5/22/21.
//

import Foundation

struct Summary: Codable {
    let id, message: String
    let global: Global
    let countries: [Country]
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case message = "Message"
        case global = "Global"
        case countries = "Countries"
        case date = "Date"
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.message = try container.decode(String.self, forKey: .message)
        self.global = try container.decode(Global.self, forKey: .global)
        self.countries = try container.decode([Country].self, forKey: .countries)
        self.date = try container.decode(String.self, forKey: .date)
    }
}

// MARK: - Country
struct Country: Codable {
    let id, country, countryCode, slug: String
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
    let date: String
    let premium: Premium
    
    enum CodingKeys1: String, CodingKey {
        case id = "ID"
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
        case premium = "Premium"
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys1.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.country = try container.decode(String.self, forKey: .country)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.newConfirmed = try container.decode(Int.self, forKey: .newConfirmed)
        self.totalConfirmed = try container.decode(Int.self, forKey: .totalConfirmed)
        self.newDeaths = try container.decode(Int.self, forKey: .newDeaths)
        self.totalDeaths = try container.decode(Int.self, forKey: .totalDeaths)
        self.newRecovered = try container.decode(Int.self, forKey: .newRecovered)
        self.totalRecovered = try container.decode(Int.self, forKey: .totalRecovered)
        self.date = try container.decode(String.self, forKey: .date)
        self.premium = try container.decode(Premium.self, forKey: .premium)
    }
}

// MARK: - Premium
struct Premium: Codable {
}

// MARK: - Global
struct Global: Codable {
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
    let date: String
    
    enum CodingKeys2: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys2.self)
        self.newConfirmed = try container.decode(Int.self, forKey: .newConfirmed)
        self.totalConfirmed = try container.decode(Int.self, forKey: .totalConfirmed)
        self.newDeaths = try container.decode(Int.self, forKey: .newDeaths)
        self.totalDeaths = try container.decode(Int.self, forKey: .totalDeaths)
        self.newRecovered = try container.decode(Int.self, forKey: .newRecovered)
        self.totalRecovered = try container.decode(Int.self, forKey: .totalRecovered)
        self.date = try container.decode(String.self, forKey: .date)
    }
    
}

