//
//  CountryListViewController.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

import UIKit

public typealias ClosureEmptyParameter = (() -> Void)

public protocol BaseView: NSObjectProtocol {}

enum InteractorState<T> {
    case loading
    case idle
    case success(_ viewModel: T)
    case failure(_ error: Error, retryHandler: ClosureEmptyParameter)
}

open class NiblessViewController: UIViewController {
    // MARK: - Methods

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("Not using it.")
    }
}

/// Protocol that abstract the CountryListViewController
protocol CountryListView: BaseView {
    var onfinish: ClosureEmptyParameter? { get set }
}

final class CountryListViewController: NiblessViewController, CountryListView, CountryDetailControllerFactory {
    // MARK: - CountryListView

    var onfinish: ClosureEmptyParameter?

    // MARK: - Properties

    /// A wrapper to the root view
    var rootView: CountryListRootView {
        return view as! CountryListRootView
    }

    /// The object responsible of the view business logic
    var interactor: CountryListInteractorInput

    // MARK: - LifeCycle

    init(interactor: CountryListInteractorInput) {
        self.interactor = interactor
        super.init()
    }

    override func loadView() {
        view = CountryListRootView()
        rootView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.delegate = self
        interactor.fetchCountries()
    }
}

// MARK: - CountryListInteractorDelegate

extension CountryListViewController: CountryListInteractorDelegate {
    func interactor(_: CountryListInteractorInput,
                    didUpdate state: CountryListState)
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

// MARK: - CountryListRootViewDelegate

extension CountryListViewController: CountryListRootViewDelegate {
    func didselectRow(code: Int) {
        if let province = makeCountryDetailController(id: code) as? CountryDetailViewController {
            navigationController?.pushViewController(province, animated: true)
        }
    }

    func refreshData() {
        interactor.fetchCountries()
    }
    
    func showAlert(alert: UIAlertController){
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - CountryListController Factory

/// CountryListController Factory
protocol CountryListControllerFactory {
    func makeCountryListController() -> CountryListView
}

extension CountryListControllerFactory {
    func makeCountryListController() -> CountryListView {
        let interactor = CountryListInteractor()
        return CountryListViewController(interactor: interactor)
    }
}
