//
//  FootballTeam.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import ObjectMapper

struct FootballTeam: Mappable {
	
	var formedYear: String = ""
	var stadiumName: String = ""
	var teamDescription: String = ""
	var teamLogoURL: String = ""
	var teamName: String = ""

	init?(map: Map) {
		mapping(map: map)
	}
	
	mutating func mapping(map: Map) {
		
		formedYear <- map["intFormedYear"]
		stadiumName <- map["strStadium"]
		teamDescription <- map["strDescriptionEN"]
		teamLogoURL <- map["strTeamLogo"]
		teamName <- map["strTeam"]
	}
}
