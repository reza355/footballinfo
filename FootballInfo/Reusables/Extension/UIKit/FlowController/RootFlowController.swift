//
//  RootFlowController.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import UIKit

final class RootFlowController {
	
	let navigationController: UINavigationController
	
	private let teamFlowController: TeamFlowController
	
	init(navigationController: UINavigationController = UINavigationController()) {
		
		self.navigationController = navigationController
		
		teamFlowController = TeamFlowController(navigationController: navigationController)
	}
	
	// MARK: - Public Methods
	
	func createInitialScreen() {
		teamFlowController.push(screen: .teamLists)
	}
}
