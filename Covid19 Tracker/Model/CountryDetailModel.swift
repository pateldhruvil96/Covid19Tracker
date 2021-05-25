//
//  CountryDetailModel.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 23/05/21.
//

import Foundation

typealias CountryDetail = [CountryDetails]

struct CountryDetails: Codable {
    let country: String
    let countryCode: String
    let province, city, cityCode, lat: String
    let lon: String
    let confirmed, deaths, recovered, active: Int
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case countryCode = "CountryCode"
        case province = "Province"
        case city = "City"
        case cityCode = "CityCode"
        case lat = "Lat"
        case lon = "Lon"
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
        case active = "Active"
        case date = "Date"
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.country = try container.decode(String.self, forKey: .country)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.province = try container.decode(String.self, forKey: .province)
        self.city = try container.decode(String.self, forKey: .city)
        self.cityCode = try container.decode(String.self, forKey: .cityCode)
        self.lat = try container.decode(String.self, forKey: .lat)
        self.lon = try container.decode(String.self, forKey: .lon)
        self.confirmed = try container.decode(Int.self, forKey: .confirmed)
        self.deaths = try container.decode(Int.self, forKey: .deaths)
        self.recovered = try container.decode(Int.self, forKey: .recovered)
        self.active = try container.decode(Int.self, forKey: .active)
        self.date = try container.decode(String.self, forKey: .date)
    }
    var timeline: Timeline {
        return Timeline(cases: confirmed, active: active, deaths: deaths, recovered: recovered)
    }
}
