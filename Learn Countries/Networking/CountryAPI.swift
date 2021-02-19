//
//  CountryAPI.swift
//  Learn Countries
//
//  Created by Kaushal on 19/02/21.
//

import Foundation
import Moya

enum CountryAPI {
    case countries
    case provinces(country: Int)
}

extension CountryAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://connect.mindbodyonline.com")!
    }

    var limit: Int {
        return 10
    }

    var path: String {
        switch self {
        case .countries:
            return "/rest/worldregions/country"
        case let .provinces(country):
            return "/rest/worldregions/country/\(country)/province"
        }
    }

    var method: Moya.Method {
        switch self {
        case .countries, .provinces:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .countries, .provinces:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return nil
    }
}
