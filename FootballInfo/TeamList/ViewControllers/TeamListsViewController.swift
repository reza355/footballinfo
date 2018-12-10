//
//  TeamListsViewController.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 08/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

final class TeamListsViewController: UIViewController {
	
	enum NavigationEvent {
		case teamDetail(team: FootballTeam)
	}
	
	var onNavigationEvent: ((NavigationEvent) -> (Void))?
	
	// MARK: - Private Properties
	
	fileprivate var viewModel: TeamListsViewModel?
	
	@IBOutlet private var collectionView: UICollectionView!
	
	private let disposeBag = DisposeBag()
	
	// MARK: - Public Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureCollectionView()
		
		bindViewModel()
		showProgress()
		
		SVProgressHUD.show()
    }
	
	convenience init(viewModel: TeamListsViewModel) {
		self.init()
		
		self.viewModel = viewModel
	}
	
	// MARK: - Private Methods
	
	private func configureCollectionView() {
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		self.collectionView.register(collectionViewCell: TeamLogoCell.self)
	}
	
	private func bindViewModel() {
		
		guard let viewModel = viewModel else {
			return
		}
		
		viewModel.cellViewModels.asObservable()
			.subscribe(onNext: { [weak self] _ in
				self?.collectionView.reloadData()
			})
			.disposed(by: disposeBag)
	}
	
	
	private func showProgress() {
		
		viewModel?.retrieveTeamDetailSuccessObservable.asObservable()
			.subscribe(onNext: { _ in
				SVProgressHUD.dismiss()
			})
			.disposed(by: disposeBag)
		
		viewModel?.retrieveTeamDetailFailedObservable.asObservable()
			.subscribe(onNext: { (error: Error) in
				
				print(error)
				SVProgressHUD.dismiss()
			})
			.disposed(by: disposeBag)
	}
}

extension TeamListsViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as TeamLogoCell
		
		return cell
	}
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		guard let numberOfCell =  viewModel?.getNumberOfItems() else {
			return 0
		}
		
		return numberOfCell
	}
}

extension TeamListsViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		guard let teamLogoCell = cell as? TeamLogoCell,
			let cellViewModel = viewModel?.getCellViewModel(indexPath: indexPath) else {
				return
		}
		
		teamLogoCell.bind(viewModel: cellViewModel)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		guard let teamLists = viewModel?.getTeamList(indexPath: indexPath) else {
			return
		}
		
		onNavigationEvent?(.teamDetail(team: teamLists))
	}
}

extension TeamListsViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let frameSize = self.collectionView.frame.size
		let width = (frameSize.width / 2.5)
		//let height = 300
		return CGSize(width: width, height: width)
	}
}
