//
//  FlowController.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import UIKit

protocol FlowController: class {
	
	associatedtype Screen: Equatable
	
	/**
	Stores `NavigationScreen` of horizontal navigation, e.g. `push`, `pop`, and `set`.
	*/
	var horizontalNavigationStack: [NavigationScreen<Screen>] { get set }
	
	/**
	Navigation controller used for this instance.
	*/
	var navigationController: UINavigationController { get }
	
	/**
	Factory method of this instance. Returns `UIViewController` instance for corresponding `screen`.
	*/
	func viewControllerFor(screen: Screen) -> UIViewController
	
}

extension FlowController {
	
	// MARK: - Horizontal navigation methods
	
	/// Pushes the `screen` to this instance's `navigationController` and append it to the `horizontalNavigationStack`.
	func push(screen: Screen, animated: Bool = true, customTransition: Bool = false, completion: (() -> ())? = nil) {
		
		let viewController = self.viewControllerFor(screen: screen)
		let navigationScreen = NavigationScreen(screen: screen, viewController: viewController)
		
		horizontalNavigationStack.append(navigationScreen)
		
		navigationController.push(
			viewController: viewController,
			animated: animated)
	}
	
	/// Pops the latest screen from `horizontalNavigationStack` and `navigationController`.
	func pop(animated: Bool = true, customTransition: Bool = false, completion: (() -> ())? = nil) {
		
		let _ = horizontalNavigationStack.popLast()
		navigationController.pop(animated: animated)
	}
	
	// MARK: - Private methods
	
	private func isNavigationStackContains(screen: Screen, navigationStack: [NavigationScreen<Screen>]) -> Bool {
		
		for navigationScreen in navigationStack {
			
			if navigationScreen.screen == screen {
				return true
			} else {
				continue
			}
		}
		
		return false
	}
}
