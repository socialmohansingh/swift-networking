import Combine
import Foundation

public struct SwiftNetworking {
    
    /// make the instance shared
    private static var `default` = SwiftNetworking()
    private init() {}
    
    /// The networking configuration
    private var config: NetworkingConfiguration?
    
    /// Method to set the configuartion from client side
    /// - Parameter config: The networking configuration
    public static func initialize(with config: NetworkingConfiguration) {
        SwiftNetworking.default.config = config
    }
    
    /// Method to create a response publisher for data
    /// - Returns: Publisher of the data response
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    public static func dataRequest(router: NetworkingRouter) -> AnyPublisher<NetworkingResponse, NetworkingError> {
        createAndPerformRequest(router, config: SwiftNetworking.default.config)
    }
    
    /// Method to create a response publisher for file upload
    /// - Returns: Publisher of the data response
    ///
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    public static func uploadRequest(router: NetworkingRouter) -> AnyPublisher<NetworkingResponse, NetworkingError> {
        fatalError("Not Implemented yet")
    }
    
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    private static func createAndPerformRequest(_ router: NetworkingRouter, config: NetworkingConfiguration?) -> AnyPublisher<NetworkingResponse, NetworkingError> {
        
        guard let config = config else {
            return Fail<NetworkingResponse, NetworkingError>(error: NetworkingError(.networkingNotInitialized)).eraseToAnyPublisher()
        }
        
        guard Connectivity.shared.status == .connected else {
            return Fail<NetworkingResponse, NetworkingError>(error: NetworkingError(.noConnectivity)).eraseToAnyPublisher()
        }
        
        return RequestMaker(router: router, config: config).makeDataRequest()
    }
}
