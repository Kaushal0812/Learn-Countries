//
//  MoyaNetworkProvider.swift
//  Learn Countries
//
//  Created by Kaushal on 19/02/21.
//

import Alamofire
import Foundation
import Moya
import PromiseKit

final class MoyaNetworkProvider<Target: TargetType>: NetworkProvider {
    init() {}

    var provider = MoyaProvider<Target>()

    func request(_ target: Target, callbackQueue: DispatchQueue?, progress: ProgressBlock?) -> Promise<Response> {
        return provider
            .request(target: target,
                     queue: callbackQueue,
                     progress: progress)
    }
}
