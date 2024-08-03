//
//  SQLCommunicator.swift
//  Device Identity Token
//
//  Created by Косоруков Дмитро on 11/05/2024.
//

import Foundation
import Combine

enum RequestError: LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case pollingTimeout
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .pollingTimeout:
            return "Polling timeout: Failed to fetch updated data after multiple attempts"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

enum QueryType {
    case checkExistence
    case selectAll
    
    static private let _baseURI = "https://testnets.tableland.network/api/v1/query?extract=true&unwrap=true&statement="
    static private let _deviceId = Device.shared.AD_ID
    
    @MainActor func uri(from databaseName: String) -> URL? {
        let query: String
        switch self {
        case .checkExistence:
            query = "SELECT json_object('state',\(databaseName).state) FROM \(databaseName) WHERE \(databaseName).device_id='\(QueryType._deviceId)'"
        case .selectAll:

            query = "SELECT json_object('id',cast(\(databaseName).id as text),'name',\(databaseName).model_name||' '||\(databaseName).os_version,'image','https://gateway.pinata.cloud/ipfs/QmR11GfmA7typHXgmqgoLwz2qcSMLCu9Un4AacFZYLfn6s','description',\(databaseName).description,'state',\(databaseName).state,'wallet_address',\(databaseName).wallet_address,'device_id',\(databaseName).device_id,'model_name',\(databaseName).model_name,'screen_size',\(databaseName).screen_size,'os_version',\(databaseName).os_version,'last_update',\(databaseName).last_update,'dit_hash', \(databaseName).dit_hash) FROM \(databaseName) WHERE \(databaseName).device_id='\(QueryType._deviceId)'"
        }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: QueryType._baseURI + encodedQuery)
    }
}


protocol SQLServiceProtocol {
    func request(queryType: QueryType) -> AnyPublisher<DIT, Error>
}

class SQLService: SQLServiceProtocol {
    static let shared = SQLService()
    
    private init() {}
    
    func request(queryType: QueryType) -> AnyPublisher<DIT, Error> {
        Future { promise in
            Task {
                do {
                    let databaseName = try await DITContract.shared.getDITDatabaseName()
                    guard let uri = await queryType.uri(from: databaseName) else {
                        throw RequestError.invalidURL
                    }
                    
                    let (data, response) = try await URLSession.shared.data(from: uri)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw RequestError.invalidResponse
                    }
                    
                    let ditData = try JSONDecoder().decode(DIT.self, from: data)
                    promise(.success(ditData))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}



