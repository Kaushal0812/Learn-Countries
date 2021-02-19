//
//  NetworkProvider.swift
//  Learn Countries
//
//  Created by Kaushal on 19/02/21.
//

import Foundation
import Moya
import PromiseKit

protocol NetworkProvider: AnyObject {
    associatedtype Target: TargetType

    /// Designated request-making method. Returns a `Future<Response>`.
    func request(_ target: Target, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?) -> Promise<Response>
}

extension NetworkProvider {
    func request(_ target: Target) -> Promise<Response> {
        return request(target, callbackQueue: nil, progress: nil)
    }
}

import Foundation
import Moya
import PromiseKit

public typealias PendingRequestPromise = (promise: Promise<Moya.Response>, cancellable: Moya.Cancellable)
public extension MoyaProvider {
    func request(target: Target,
                 queue: DispatchQueue? = nil,
                 progress: Moya.ProgressBlock? = nil) -> Promise<Moya.Response>
    {
        return requestCancellable(target: target,
                                  queue: queue,
                                  progress: progress).promise
    }

    func requestCancellable(target: Target,
                            queue: DispatchQueue?,
                            progress: Moya.ProgressBlock? = nil) -> PendingRequestPromise
    {
        let pending = Promise<Moya.Response>.pending()
        let completion = promiseCompletion(fulfill: pending.resolver.fulfill,
                                           reject: pending.resolver.reject)
        let cancellable = request(target, callbackQueue: queue, progress: progress, completion: completion)
        return (pending.promise, cancellable)
    }

    private func promiseCompletion(fulfill: @escaping (Moya.Response) -> Void,
                                   reject: @escaping (Swift.Error) -> Void) -> Moya.Completion
    {
        return { result in
            switch result {
            case let .success(response):
                fulfill(response)
            case let .failure(error):
                reject(error)
            }
        }
    }
}

extension Promise where Promise.T == Moya.Response {
    /// Decode an object from a `Moya.Response`
    /// - Parameters:
    ///   - decoder: The decoder used to decode the data
    ///   - type: The indicated type.
    func decode<U: Decodable>(decoder: JSONDecoder = JSONDecoder(),
                              as type: U.Type) -> Promise<U>
    {
        return map { (response) -> U in
            try decoder.decode(type, from: response.data)
        }
    }
}
