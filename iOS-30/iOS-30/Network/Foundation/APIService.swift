//
//  APIService.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import Foundation

final class APIService: Requestable {

    var requestTimeout: Float = 30

    func request<T>(_ request: NetworkRequest) async throws -> T? where T : Decodable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(request.requestTimeout ?? requestTimeout)

        guard let encodedUrl = request.url
            .addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrl) else {
            throw APIServiceError.urlEncodingError
        }

        let session = URLSession(configuration: sessionConfig)
        let (data, response) = try await session.data(
            for: request.buildURLRequest(with: url)
        )

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<500) ~= httpResponse.statusCode
        else {
            throw APIServiceError.serverError
        }

        let baseModelData = try JSONDecoder().decode(
            BaseModel<T>.self,
            from: data
        )

        if baseModelData.success {
            return baseModelData.data
        }
        throw APIServiceError.clientError(message: baseModelData.message)
    }
}
