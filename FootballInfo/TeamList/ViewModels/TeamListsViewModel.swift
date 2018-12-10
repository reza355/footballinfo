//
//  TeamListsViewModel.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

final class TeamListsViewModel {
	
	// MARK: - Public Properties
	
	let teamListsCacheModel = TeamListsCacheModel.sharedInstance
	let networkModel: TeamListsNetworkModel = TeamListsNetworkModel()
	let disposeBag = DisposeBag()
	
	let cellViewModels = Variable<[TeamLogoCellViewModel]>([])
	
	var retrieveTeamDetailSuccessObservable: Observable<Void> {
		return _retrieveTeamDetailSuccessObservable.asObservable()
	}
	
	var retrieveTeamDetailFailedObservable: Observable<Error> {
		return _retrieveTeamDetailFailedObservable.asObservable()
	}
	
	// MARK: - Private Properties
	
	private let _retrieveTeamDetailSuccessObservable = PublishSubject<Void>()
	private let _retrieveTeamDetailFailedObservable = PublishSubject<Error>()
	
	// MARK: - Public Methods

	init() {
		
		retrieveTeamLists()
		bindToCellViewModel()
	}
	
	func getNumberOfItems() -> Int {
		return cellViewModels.value.count
	}
	
	func getCellViewModel(indexPath: IndexPath) -> TeamLogoCellViewModel {
		
		return cellViewModels.value[indexPath.row]
	}
	
	func getTeamList(indexPath: IndexPath)  -> FootballTeam {
		return teamListsCacheModel.currentFootballTeam.value[indexPath.row]
	}
	
	// MARK: - Private Methods
	
	private func retrieveTeamLists() {
		
		networkModel.getTeamLists()
			.bind(to: teamListsCacheModel.currentFootballTeam)
			.disposed(by: disposeBag)
	}
	
	private func bindToCellViewModel() {
		
		teamListsCacheModel.currentFootballTeam.asObservable()
			.map { (footballTeam: [FootballTeam]) -> [TeamLogoCellViewModel] in
				
				return footballTeam.map({ (footballTeam: FootballTeam) -> TeamLogoCellViewModel in
					
					return TeamLogoCellViewModel(logoURL: footballTeam.teamLogoURL)
				})
			}
			.do(onNext: { [weak self] _ in
				self?._retrieveTeamDetailSuccessObservable.onNext(())
			}, onError: { [weak self] (error: Error) in
				self?._retrieveTeamDetailSuccessObservable.onError(error)
			})
			.bind(to: cellViewModels)
			.disposed(by: disposeBag)
	}
}
