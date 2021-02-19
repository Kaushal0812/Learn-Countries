//
//  CountryDetailViewModel.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

struct Province: Codable {
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

typealias ProvinceSection = SectionModel<String, ProvinceRowViewModel, Void>

struct ProvinceViewModel: ViewModelSectionType {
    var sections: [ProvinceSection] = []

    init(province: [Province]?) {
        guard let province = province else {
            return
        }
        initialise(provinces: province)
    }

    fileprivate mutating func initialise(provinces: [Province]) {
        let rows = provinces.map { (province) -> ProvinceRowViewModel in
            ProvinceRowViewModel(province: province)
        }
        sections = [SectionModel(header: "", footer: nil, rows: rows)]
    }
}

struct ProvinceRowViewModel {
    let iD: Int?
    let name: String?
    let code: String?
    let phoneCode: String?

    init(province: Province) {
        iD = province.iD
        name = province.name
        code = province.code
        phoneCode = province.phoneCode
    }
}
