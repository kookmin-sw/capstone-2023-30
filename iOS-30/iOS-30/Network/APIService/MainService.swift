//
//  MainService.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import Foundation


struct MainService: MainServiceable {
    private let apiService: Requestable
    private let environment: APIEnvironment

    init(apiService: Requestable, environment: APIEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }

    func postImage(imageSize: (Int, Int), name: String, body: Data?) async throws -> Int? {
        let request = MainEndPoint
            .postImage(imageSize: imageSize, name: name, body: body)
            .createRequest(environment: .develop)
        return try await self.apiService.request(request)
    }
}
