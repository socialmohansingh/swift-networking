# SwiftNetworking
A simple networking library over the URLSession to manage networking requests using Publishers.

# Usage

1. Configure the package once when the app launches
```swift 
        // set the logger if required
        let logger = Logger.current
        logger.set(with: .debug)

        // set the networking configuration once
        let config = NetworkingConfiguration(baseURL: BASE_URL, logger: logger)
        SwiftNetworking.initialize(with: config)
        return true
```

2. Create routes for the endpoints
    ```swift
        enum PostRoute: NetworkingRouter {
            // Add the endpoint as cases
            case posts(Parameters)
    
            // set the apth to resource
            var path: String {
                switch self {
                case .posts: return "posts"
                }
            }
    
            // set the request method
            var httpMethod: HTTPMethod {
                switch self {
                case .posts:
                    return .post
                }
            }
    
            // set the encoders
            var encoder: [EncoderType] {
                switch self {
                case .posts(let parameters):
                    return [.json(parameters)]
                }
            }
        }
    ```

    3. Build the router and peform the request
    ```swift 
        // 1. Set the required parameters
        let parameters: Parameters = ["title": "foo", "body": "bar", "userId": 1,]
        
        // 2. Get the required route
        let postRoute = PostRoute.posts(parameters)
        
        // 3. Call the request
        cancellable = Networking.dataRequest(router: postRoute).sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        } receiveValue: { response in
            debugPrint(response)
        }
    ```

    Since the response received is through publisher we can use all the methods to modify the response according to our needs. For more info on Combine read the swift combine documentations.


    Also the networking library supports RequestInterceptor so that we can intercept and inject any additional stuff like authorization header in the request.
