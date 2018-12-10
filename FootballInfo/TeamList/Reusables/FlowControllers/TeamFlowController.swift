//
//  TeamFlowController.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import UIKit

final class TeamFlowController: FlowController {
	
	enum Screen {
		case teamLists
		case teamDetail
	}
	
	enum NavigationEvent {}
	
	var horizontalNavigationStack = [NavigationScreen<Screen>]()
	var verticalNavigationStack = [NavigationScreen<Screen>]()
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	let navigationController: UINavigationController
	
	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public methods
	
	func viewControllerFor(screen: Screen) -> UIViewController {
		
		switch screen {
			
		}
	}
	
	// MARK: - Private Methods
}
