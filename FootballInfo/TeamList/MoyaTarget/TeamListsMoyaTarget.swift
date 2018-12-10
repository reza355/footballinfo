//
//  TeamListsMoyaTarget.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 08/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import Moya

enum TeamListsMoyaTarget {
	case getTeamLists
}

extension TeamListsMoyaTarget: TargetType {
	
	var baseURL: URL {
		
		if let validURL = URL(string: "https://www.thesportsdb.com/api/v1/json/1") {
			return validURL
		} else {
			return NSURL() as URL
		}
	}
	
	var path: String {
		switch self {
		case .getTeamLists:
			return "/search_all_leagues.php"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .getTeamLists:
			return .get
		}
	}
	
	var parameterEncoding: ParameterEncoding {
		return URLEncoding.default
	}
	
	var parameters: [String: Any] {
		switch self {
		default:
			return ["c":"England"]
		}
	}
	
	var task: Task {
		return .requestParameters(parameters: parameters, encoding: parameterEncoding)
	}
	
	var headers: [String : String]? {
		return [:]
	}
	
	var sampleData: Data {
		return Data()
	}
}
