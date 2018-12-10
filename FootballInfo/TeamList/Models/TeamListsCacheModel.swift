//
//  TeamListsCacheModel.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

final class TeamListsCacheModel {
	
	// MARK: - Public Properties
	
	static let sharedInstance = TeamListsCacheModel()
	
	var currentFootballTeam = Variable<[FootballTeam]>([])
	
	// MARK: - Private Properties
	
	private static let footballTeamKey = "FootballTeam"
	
	private let userDefaults = UserDefaults.standard
	
	// MARK: - Public Methods
	
	func saveFootballTeamCache(footballTeam: [FootballTeam]) {
		
		guard let footballTeamObjectString = Mapper().toJSONString(footballTeam) else {
			return
		}
		
		currentFootballTeam.value = footballTeam
		
		userDefaults.set(footballTeamObjectString, forKey: TeamListsCacheModel.footballTeamKey)
	}
	
	func clearCache() {
		
		currentFootballTeam.value = []
		
		userDefaults.removeObject(forKey: TeamListsCacheModel.footballTeamKey)
	}
	
	// MARK: - Private Methods
	
	private init() {
		
		loadCachedFootballTeam()
	}
	
	private func loadCachedFootballTeam() {
		
		guard let footballTeamObjectString = userDefaults.string(forKey: TeamListsCacheModel.footballTeamKey),
			let footballTeam = Mapper<FootballTeam>().mapArray(JSONString: footballTeamObjectString) else {
				
				return
		}
		
		currentFootballTeam.value = footballTeam
	}
}
