//
//  TeamLogoCellViewModel.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import RxSwift

final class TeamLogoCellViewModel {
	
	var logoURL = Variable<String>("")
	
	init(logoURL: String) {
		self.logoURL.value = logoURL
	}
}
