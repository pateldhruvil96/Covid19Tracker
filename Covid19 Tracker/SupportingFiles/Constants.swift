//
//  Constants.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Patel on 5/22/21.
//

import Foundation
import UIKit
let BASEURL = "https://api.covid19api.com/"
let WORLDSTATSURL = BASEURL + "world/total"
let COUNTRYDETAILURL = BASEURL + "total/dayone/country/"
let FLAGURL = "https://www.countryflags.io/"
let COUNTRY = "summary"
let IPADTABLECELLHEIGHT:CGFloat = 150
let IPHONETABLECELLHEIGHT:CGFloat = 100

//Identifier Name's
let FINDERVC = "FinderViewController"
let SELECTEDVC = "SelectedCountryViewController"
let SAVEDVC = "SavedViewController"


//Nib's Name's
let COUNTRYLISTCELL = "CountryListsTableViewCell"
let TOTALCASESCELL = "TotalCasesCollectionViewCell"

enum EndPoints:String{
    case summary = "summary"
    case flagImage = "/shiny/64.png"
}
