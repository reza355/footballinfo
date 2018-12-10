//
//  TeamListsNetworkModel.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 08/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

final class TeamListsNetworkModel {
	
	private let provider = MoyaProvider<TeamListsMoyaTarget>()
	
	func getTeamLists() -> Observable<[FootballTeam]> {
		
		return provider.requestWithValidation(.getTeamLists)
			.mapResponseArray(to: FootballTeam.self, keyPath: "teams")
			.flatMapForServerResponse()
	}
}
