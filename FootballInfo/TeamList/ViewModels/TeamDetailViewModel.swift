//
//  TeamDetailViewModel.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import RxSwift

final class TeamDetailViewModel {
	
	var teamDetail: Variable<FootballTeam>
	
	init(team: FootballTeam) {
		
		self.teamDetail = Variable<FootballTeam>(team)
	}
}
