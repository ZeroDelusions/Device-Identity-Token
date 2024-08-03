//
//  DITViewModel.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//

import SwiftUI
import Combine
import Foundation

@MainActor
class DITViewModel: ObservableObject {
    @Published private(set) var fetchedDit: DIT
    @Published var dit: DIT
    @Published private(set) var isLoading = true
    @Published private(set) var isPolling = false
    @Published var error: IdentifiableError?
    
    private let sqlService: SQLServiceProtocol
    private let ditContract: DITContractProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(sqlService: SQLServiceProtocol, ditContract: DITContractProtocol) {
        self.sqlService = sqlService
        self.ditContract = ditContract
        self.fetchedDit = .empty
        self.dit = .empty
        fetchData()
    }
    
    var isChanged: Bool {
        fetchedDit != dit
    }
    
    func fetchData() {
        isLoading = true
        sqlService.request(queryType: .selectAll)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.setError(error as? LocalizedError ?? RequestError.unknown)
                }
            } receiveValue: { [weak self] data in
                self?.fetchedDit = data
                self?.dit = data.copy() as? DIT ?? .empty
            }
            .store(in: &cancellables)
    }
    
    func connectMetaMask() async {
        do {
            try await ContractCommunicator.shared.connectMetaMask()
        } catch {
            setError(error as? LocalizedError ?? RequestError.unknown)
        }
    }

    func mint() async {
        do {
            try await ditContract.mint(dit)
            await pollForResponse()
        } catch {
            setError(error as? LocalizedError ?? RequestError.unknown)
        }
    }
    
    func update() async {
        do {
            try await ditContract.update(dit)
            await pollForResponse()
        } catch {
            setError(error as? LocalizedError ?? RequestError.unknown)
        }
    }
    
    func burn() async {
        do {
            try await ditContract.burn(dit)
            self.fetchedDit = DIT.empty
            self.dit = DIT.empty
        } catch {
            setError(error as? LocalizedError ?? RequestError.unknown)
        }
    }
    
    private func pollForResponse() async {
        let maxAttempts = 15
        let delaySeconds: UInt64 = 1_000_000_000 // 1 second
        
        self.isPolling = true
        
        for _ in 1...maxAttempts {
            fetchData()
            
            if !isLoading && error == nil {
                self.isPolling = false
                return // Fetch was successful
            }
            
            try? await Task.sleep(nanoseconds: delaySeconds)
        }
        
        self.isPolling = false
        setError(RequestError.pollingTimeout)
    }
    
    private func setError(_ error: LocalizedError) {
        Task {
            self.error = IdentifiableError(underlyingError: error)
        }
    }
}
