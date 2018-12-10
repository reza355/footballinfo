//
//  SoccerTeam.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import ObjectMapper

struct SoccerTeam: Mappable {
	
	var formedYear: Int = 0
	var stadiumName: Int = 0
	var teamDescription: String = ""
	var teamLogoURL: URL? = nil

	init?(map: Map) {
		mapping(map: map)
	}
	
	mutating func mapping(map: Map) {
		
		formedYear <- map["intFormedYear"]
		stadiumName <- map["strStadium"]
		teamDescription <- map["strDescriptionEN"]
		teamLogoURL <- map["strTeamLogo"]
	}
}
