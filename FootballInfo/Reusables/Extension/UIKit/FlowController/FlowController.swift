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
	Stores `NavigationScreen` of vertical navigation, e.g. `present` and `dismiss`.
	*/
	var verticalNavigationStack: [NavigationScreen<Screen>] { get set }
	
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
	
	/// Sets the passed `screens` to this instance's `navigationController` and `horizontalNavigationStack`.
	func set(screens: [Screen], animated: Bool = true, completion: (() -> ())? = nil) {
		
		let navigationScreens = screens.map { screen -> NavigationScreen<Screen> in
			
			return NavigationScreen(
				screen: screen,
				viewController: self.viewControllerFor(screen: screen)
			)
		}
		
		let viewControllers = navigationScreens.map { (screen: NavigationScreen) -> UIViewController in
			return screen.viewController
		}
		
		horizontalNavigationStack = navigationScreens
		navigationController.setViewControllers(viewControllers, animated: animated)
		
		delay(animated: animated, completion: completion)
	}
	
	
	/// Pushes the `screen` to this instance's `navigationController` and append it to the `horizontalNavigationStack`.
	func push(screen: Screen, animated: Bool = true, customTransition: Bool = false, completion: (() -> ())? = nil) {
		
		let viewController = self.viewControllerFor(screen: screen)
		let navigationScreen = NavigationScreen(screen: screen, viewController: viewController)
		
		horizontalNavigationStack.append(navigationScreen)
		
		navigationController.push(
			viewController: viewController,
			animated: animated,
			customTransition: customTransition
		)
		
		delay(animated: animated, completion: completion)
	}
	
	/// Pushes multiple screens to this instance's `navigationController` and append it to the `horizontalNavigationStack`.
	func append(screens: [Screen], animated: Bool = true, completion: (() -> ())? = nil) {
		
		let newNavigationScreens = screens.map { (screen: Screen) -> NavigationScreen<Screen> in
			
			return NavigationScreen(
				screen: screen,
				viewController: viewControllerFor(screen: screen)
			)
		}
		
		let newViewControllers = newNavigationScreens.map { (screen: NavigationScreen) -> UIViewController in
			return screen.viewController
		}
		
		let currentViewControllers = horizontalNavigationStack.map { (stack: NavigationScreen<Screen>) -> UIViewController in
			return stack.viewController
		}
		
		var updatedViewControllers = currentViewControllers
		updatedViewControllers.append(contentsOf: newViewControllers)
		
		horizontalNavigationStack.append(contentsOf: newNavigationScreens)
		navigationController.setViewControllers(updatedViewControllers, animated: animated)
		
		delay(animated: animated, completion: completion)
	}
	
	/// Pops the latest screen from `horizontalNavigationStack` and `navigationController`.
	func pop(animated: Bool = true, customTransition: Bool = false, completion: (() -> ())? = nil) {
		
		let _ = horizontalNavigationStack.popLast()
		navigationController.pop(animated: animated, customTransition: customTransition)
		
		delay(animated: animated, completion: completion)
	}
	
	/// Pops to the passed `screen`. If it's not available in current `horizontalNavigationStack`, it will do nothing.
	func popTo(screenInStack screen: Screen, animated: Bool = true, completion: (() -> ())? = nil) {
		
		let screens = horizontalNavigationStack.map { (stack: NavigationScreen<Screen>) -> Screen  in
			return stack.screen
		}
		
		guard let screenIndex = screens.reverseIndex(of: screen) else  {
			return
		}
		
		let destinationViewController = horizontalNavigationStack[screenIndex].viewController
		let validDestination = navigationController.viewControllers.contains(destinationViewController)
		
		guard validDestination else {
			return
		}
		
		let _ = navigationController.popToViewController(destinationViewController, animated: animated)
		
		
		delay(animated: animated) { [weak self] in
			
			guard let `self` = self else {
				completion?()
				return
			}
			
			self.horizontalNavigationStack = Array(self.horizontalNavigationStack[0...screenIndex])
			completion?()
		}
	}
	
	/**
	Prepends the passed `screen` right before the current `Screens` in `horizontalNavigationStack`, then pops to it.
	
	- note: This will replace all of current `horizontalNavigationStack`'s `Screens` with the passed `screen`.
	*/
	func prependThenBack(to screen: Screen, completion: (() -> ())? = nil) {
		
		let currentViewControllers = navigationController.viewControllers
		let targetViewController = viewControllerFor(screen: screen)
		
		var newViewControllers = [ targetViewController ]
		newViewControllers.append(contentsOf: currentViewControllers)
		
		navigationController.setViewControllers(newViewControllers, animated: false)
		navigationController.popToViewController(targetViewController, animated: true)
		
		let navigationScreen = NavigationScreen<Screen>(
			screen: screen,
			viewController: targetViewController
		)
		
		horizontalNavigationStack = [ navigationScreen ]
		
		delay(animated: true, completion: completion)
	}
	
	// MARK: - Vertical navigation methods
	
	/**
	Presents the passed `screen` to the top most of `verticalNavigationStack`.
	*/
	func present(screen: Screen, animated: Bool = true, completion: (() -> Void)? = nil) {
		
		let viewController = viewControllerFor(screen: screen)
		
		let presenterViewController: UIViewController
		
		if let topScreen = verticalNavigationStack.last {
			presenterViewController = topScreen.viewController
		} else {
			presenterViewController = navigationController
		}
		
		presenterViewController.present(viewController, animated: animated, completion: completion)
		
		let navigationScreen = NavigationScreen(
			screen: screen,
			viewController: viewController
		)
		
		verticalNavigationStack.append(navigationScreen)
	}
	
	/**
	Dismiss the top most `screen`, and removes it from `verticalNavigationStack`.
	*/
	func dismissTop(animated: Bool = true, completion: (() -> Void)? = nil) {
		
		let lastScreen = verticalNavigationStack.popLast()
		lastScreen?.viewController.dismiss(animated: animated, completion: completion)
	}
	
	/**
	Dismiss all presented screen in `verticalNavigationStack`, and clears it too.
	*/
	func dismissAll(animated: Bool = true, completion: (() -> Void)? = nil) {
		
		verticalNavigationStack = []
		navigationController.dismiss(animated: animated, completion: completion)
	}
	
	// MARK: - Utility methods
	
	/**
	Run through current `navigationController`'s view controllers, and remove invalid `NavigationScreen` from current `navigationStack`.
	*/
	func validateHorizontalNavigationStack() {
		
		var newStack = [NavigationScreen<Screen>]()
		
		let currentViewControllers = navigationController.viewControllers
		
		for screen in horizontalNavigationStack {
			
			let validScreen = currentViewControllers.contains(where: { (viewController: UIViewController) -> Bool in
				return screen.viewController === viewController
			})
			
			guard validScreen else {
				continue
			}
			
			newStack.append(screen)
		}
		
		horizontalNavigationStack = newStack
	}
	
	/**
	Checks whether `horizontalStack` contains passed `screen`.
	*/
	func isHorizontalStackContains(screen: Screen) -> Bool {
		
		return isNavigationStackContains(screen: screen, navigationStack: horizontalNavigationStack)
	}
	
	/**
	Checks whether `verticalStack` contains passed `screen`.
	*/
	func isVerticalStackContains(screen: Screen) -> Bool {
		return isNavigationStackContains(screen: screen, navigationStack: verticalNavigationStack)
	}
	
	/**
	Checks whether `horizontalStack` only contain a single screen.
	*/
	func isHorizontalStackHasSingleScreen() -> Bool {
		return horizontalNavigationStack.count == 1
	}
	
	// MARK: - Private methods
	
	/**
	Helper method to handle completion blocks where UINavigationControllers' methods doesn't provide, e.g. push and pop.
	
	- note: The executed block will always be on main thread.
	*/
	private func delay(animated: Bool, completion: (() -> ())?) {
		
		guard animated else {
			completion?()
			return
		}
		
		let deadline = DispatchTime.now() + AnimationConstants.viewControllerPopDuration
		DispatchQueue.main.asyncAfter(deadline: deadline) {
			completion?()
		}
	}
	
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
