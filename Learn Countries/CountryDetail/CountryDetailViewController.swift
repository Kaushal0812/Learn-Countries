//
//  CountryDetailViewController.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

import UIKit
/// Protocol that abstract the CountryDetailViewController
protocol CountryDetailView: BaseView {
    var onfinish: ClosureEmptyParameter? { get set }
}

final class CountryDetailViewController: NiblessViewController, CountryDetailView {
    // MARK: - CountryDetailView

    var onfinish: ClosureEmptyParameter?

    // MARK: - Properties

    /// A wrapper to the root view
    var rootView: CountryDetailRootView {
        return view as! CountryDetailRootView
    }

    /// The object responsible of the view business logic
    var interactor: CountryDetailInteractorInput

    // MARK: - LifeCycle

    init(interactor: CountryDetailInteractorInput) {
        self.interactor = interactor
        super.init()
    }

//    @available(*, unavailable)
//    public required init?(coder _: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func loadView() {
        view = CountryDetailRootView()
        rootView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.delegate = self
        interactor.fetchProvinces()
    }
}

// MARK: - CountryDetailInteractorDelegate

extension CountryDetailViewController: CountryDetailInteractorDelegate {
    func interactor(_: CountryDetailInteractorInput,
                    didUpdate state: CountryDetailState)
    {
        switch state {
        case .loading:
            rootView.showLoading()
        case .idle:
            break
        case let .success(viewModel):
            rootView.hideLoading()
            rootView.configure(with: viewModel)
        case let .failure(error, retry):
            rootView.hideLoading()
            rootView.showError(error: error.localizedDescription, retryClosure: retry)
        }
    }
}

// MARK: - CountryDetailRootViewDelegate

extension CountryDetailViewController: CountryDetailRootViewDelegate {
    func refreshData() {
        interactor.fetchProvinces()
    }
    
    func showAlert(alert: UIAlertController){
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - CountryDetailController Factory

/// CountryDetailController Factory
protocol CountryDetailControllerFactory {
    func makeCountryDetailController(id: Int) -> CountryDetailView
}

extension CountryDetailControllerFactory {
    func makeCountryDetailController(id: Int) -> CountryDetailView {
        let interactor = CountryDetailInteractor(countryCode: id)
        return CountryDetailViewController(interactor: interactor)
    }
}
