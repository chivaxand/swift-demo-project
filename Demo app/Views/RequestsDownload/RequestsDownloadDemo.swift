import SwiftUI
import Combine

// JSON
// https://jsonplaceholder.typicode.com/users/1
// https://jsonplaceholder.typicode.com/posts/1

// JSON + image
// https://api.github.com/users
// https://reqres.in/api/users?delay=1
// https://reqres.in/api/users/1
// https://dog.ceo/api/breeds/image/random // {"message":"https://...img.jpg"}
// https://randomuser.me/api/
// https://api.thedogapi.com/v1/images/search?size=med&mime_types=jpg&format=json&order=RANDOM&page=0&limit=10

// Image
// https://source.unsplash.com/random
// https://picsum.photos/200        // 200 x 200
// https://picsum.photos/200/300    // 200 x 300
// https://picsum.photos/id/237/200/300

// WebSocket
// wss://echo.websocket.org

struct RequestsDownloadDemo: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                
                Button("Load image") {
                    viewModel.loadImageWithFuture()
                }
                
                Button("Load and parse json model") {
                    viewModel.fetchPostAndParseToModel()
                }
                
            }
            .padding(.top, 20)
            
            Spacer()
        }
    }
    
    
    struct Post: Codable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
    
    class ViewModel: ObservableObject {
        @Published var image: UIImage? = nil
        private var cancellables = Set<AnyCancellable>()
        
        func loadImageWithFuture() {
            UIImage.loadImageAsFuture(url: URL(string: "https://picsum.photos/200"))
                .receive(on: DispatchQueue.main)
                .sink { result in
                    print("Result: \(result)")
                } receiveValue: { image in
                    self.image = image
                }
                .store(in: &cancellables)

        }
        
        func fetchPostAndParseToModel() {
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
            
            let publisher = URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: Post.self, decoder: JSONDecoder())
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
            
            publisher
                .receive(on: DispatchQueue.main)
                .sink { result in
                    print("Result: \(result)")
                } receiveValue: { value in
                    print("Model: \(value)")
                }
                .store(in: &cancellables)
        }
    }
    
    
}

#Preview {
    RequestsDownloadDemo()
}
