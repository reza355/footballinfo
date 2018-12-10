//
//  AppDelegate.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 05/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	private var rootFlowController: RootFlowController?
	
	// MARK: - Public Methods

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		createWindow()
		createRootFlowController()
		rootFlowController?.createInitialScreen()
		
		return true
	}
	
	// MARK: - Private Methods
	
	private func createWindow() {
		
		let windowFrame = UIScreen.main.bounds
		self.window = UIWindow(frame: windowFrame)
		self.window?.makeKeyAndVisible()
	}
	
	private func createRootFlowController() {
		
		let rootFlowController = RootFlowController()
		window?.rootViewController = rootFlowController.navigationController
		
		self.rootFlowController = rootFlowController
	}

}

