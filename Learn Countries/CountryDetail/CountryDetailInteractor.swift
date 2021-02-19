//
//  CountryDetailInteractor.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

import Foundation
import PromiseKit

typealias CountryDetailState = InteractorState<ProvinceViewModel>

protocol CountryDetailInteractorInput {
    var delegate: CountryDetailInteractorDelegate? { get set }

    var viewModel: ProvinceViewModel? { get }

    var state: CountryDetailState { get }

    func fetchProvinces()
}

protocol CountryDetailInteractorDelegate: AnyObject {
    /// Tells the delegate that the interactor state did update
    ///
    /// - Parameters:
    ///   - interactor: The interactor object informing the delegate of this impending event.
    ///   - state: The `interactor`  state
    func interactor(_ interactor: CountryDetailInteractorInput,
                    didUpdate state: CountryDetailState)
}

final class CountryDetailInteractor: CountryDetailInteractorInput {
    weak var delegate: CountryDetailInteractorDelegate?

    internal var viewModel: ProvinceViewModel?

    let provider = MoyaNetworkProvider<CountryAPI>()

    var countryCode = 0

    /// The object describing the state of the Interactor
    internal var state: CountryDetailState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.delegate?
                    .interactor(self, didUpdate: self.state)
            }
        }
    }

    init(countryCode: Int) {
        self.countryCode = countryCode
    }

    func fetchProvinces() {
        state = .loading
        provider.request(.provinces(country: countryCode)).decode(as: [Province].self)
            .map { provinces -> ProvinceViewModel in
                ProvinceViewModel(province: provinces)
            }
            .done { provinceViewModel in
                self.state = .success(provinceViewModel)
            }
            .catch { error in
                self.state = .failure(error, retryHandler: self.fetchProvinces)
            }
    }
}

protocol CountryDetailInteractorFactory {
    func makeCountryDetailInteractor() -> CountryDetailInteractorInput
}
