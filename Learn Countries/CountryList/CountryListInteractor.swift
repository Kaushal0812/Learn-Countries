//
//  CountryListInteractor.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

import Foundation
import PromiseKit

typealias CountryListState = InteractorState<CountryListViewModel>

protocol CountryListInteractorInput {
    var delegate: CountryListInteractorDelegate? { get set }

    var viewModel: CountryListViewModel? { get }

    var state: CountryListState { get }

    func fetchCountries()
}

protocol CountryListInteractorDelegate: AnyObject {
    /// Tells the delegate that the interactor state did update
    ///
    /// - Parameters:
    ///   - interactor: The interactor object informing the delegate of this impending event.
    ///   - state: The `interactor`  state
    func interactor(_ interactor: CountryListInteractorInput,
                    didUpdate state: CountryListState)
}

final class CountryListInteractor: CountryListInteractorInput {
    weak var delegate: CountryListInteractorDelegate?

    let provider = MoyaNetworkProvider<CountryAPI>()

    internal var viewModel: CountryListViewModel?

    /// The object describing the state of the Interactor
    internal var state: CountryListState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.delegate?
                    .interactor(self, didUpdate: self.state)
            }
        }
    }

    init() {}

    func fetchCountries() {
        state = .loading

        provider.request(.countries).decode(as: [Country].self)
            .map { countries -> CountryListViewModel in
                CountryListViewModel(countries: countries)
            }
            .done { countryListViewModel in
                self.state = .success(countryListViewModel)
            }
            .catch { error in
                self.state = .failure(error, retryHandler: self.fetchCountries)
            }
    }
}

protocol CountryListInteractorFactory {
    func makeCountryListInteractor() -> CountryListInteractorInput
}
