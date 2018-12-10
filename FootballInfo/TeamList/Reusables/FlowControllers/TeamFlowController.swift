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
		case teamDetail(team: FootballTeam)
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
			
		case .teamLists:
			return createTeamListsViewController()
		case .teamDetail(let team):
			return createTeamDetailViewController(team: team)
		}
	}
	
	// MARK: - Private Methods
	
	private func createTeamListsViewController() -> TeamListsViewController {
		
		let viewModel = TeamListsViewModel()
		let viewController = TeamListsViewController(viewModel: viewModel)
		
		viewController.onNavigationEvent = { [weak self] (event: TeamListsViewController.NavigationEvent) in
			switch event {
			case .teamDetail(let team):
				self?.push(screen: .teamDetail(team: team))
			}
		}
		
		return viewController
	}
	
	private func createTeamDetailViewController(team: FootballTeam) -> TeamDetailViewController {
		
		let viewModel = TeamDetailViewModel(team: team)
		let viewController = TeamDetailViewController(viewModel: viewModel)
		
		return viewController
	}
}

extension TeamFlowController.Screen: Equatable {
	
	static func ==(lhs: TeamFlowController.Screen, rhs: TeamFlowController.Screen) -> Bool {
		
		switch (lhs, rhs) {
		case (.teamDetail, .teamDetail):
			return true
			
		default:
			return false
		}
	}
}
