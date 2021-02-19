//
//  CountryListViewModel.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

struct Country: Codable {
    let iD: Int?
    let name: String?
    let code: String?
    let phoneCode: String?

    enum CodingKeys: String, CodingKey {
        case iD = "ID"
        case name = "Name"
        case code = "Code"
        case phoneCode = "PhoneCode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iD = try values.decodeIfPresent(Int.self, forKey: .iD)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        phoneCode = try values.decodeIfPresent(String.self, forKey: .phoneCode)
    }
}

typealias CountrySection = SectionModel<String, CountryListRowViewModel, Void>

struct CountryListViewModel: ViewModelSectionType {
    var sections: [CountrySection] = []

    init(countries: [Country]?) {
        guard let countries = countries else {
            return
        }
        initialise(countries: countries)
    }

    fileprivate mutating func initialise(countries: [Country]) {
        let rows = countries.map { (country) -> CountryListRowViewModel in
            CountryListRowViewModel(country: country)
        }
        sections = [SectionModel(header: "", footer: nil, rows: rows)]
    }
}

struct CountryListRowViewModel {
    let iD: Int?
    let name: String?
    let code: String?
    let phoneCode: String?

    init(country: Country) {
        iD = country.iD
        name = country.name
        code = country.code
        phoneCode = country.phoneCode
    }
}
