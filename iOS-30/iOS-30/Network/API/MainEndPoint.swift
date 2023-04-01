//
//  MainEndPoint.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import Foundation

enum MainEndPoint: EndPointable {
    case postImage(imageSize: (Int, Int), name: String, body: Data?)

    var requestTimeout: Float {
        return 20
    }

    var httpMethod: HttpMethod {
        switch self {
        case .postImage:
            return .POST
        }
    }

    var requestBody: Data? {
        return nil
    }
/* https://3qt14ezkgb.execute-api.ap-northeast-2.amazonaws.com/img/test/request/512x256?img_name=test.jpeg
 */

    func getURL(baseURL: String) -> String {
        switch self {
        case let .postImage(size, name, _):
            return "\(baseURL)/\(size.0)x\(size.1)?img_name=\(name).jpeg"
        }
    }

    func createRequest(environment: APIEnvironment) -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "image/jpeg"
        return NetworkRequest(
            httpMethod: httpMethod,
            url: getURL(baseURL: environment.baseURL),
            headers: headers,
            body: requestBody,
            requestTimeout: requestTimeout
        )
    }
}
