import UIKit

// https://github.com/facebookincubator/SocketRocket  // SRWebSocket.m
// https://github.com/daltoniam/Starscream
// https://github.com/socketio/socket.io-client-swift
// https://github.com/swiftsocket/SwiftSocket
// https://github.com/tidwall/SwiftWebSocket

class WebSocketClientController: UIViewController {

    let serverUrl = "wss://echo.websocket.org"
    fileprivate var client: WebSocketClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        
        XListView(views: [
            
            UI.button("Connect", onTap: { [weak self] in
                guard let self else { return }
                self.connect()
            }),
            
            UI.button("Send message", onTap: { [weak self] in
                guard let self else { return }
                self.sendMessage(String.random(count: 10))
            }),
            
            UI.button("Disconnect", onTap: { [weak self] in
                guard let self else { return }
                self.disconnect()
            }),

        ]).add(toParentView: self.view)
    }
    
    func connect() {
        let client = WebSocketClient()
        self.client = client
        let url = URL(string: self.serverUrl)!
        client.connect(url: url)
    }
    
    func disconnect() {
        self.client?.disconnect()
    }
    
    func sendMessage(_ text: String) {
        guard let client = self.client else { return }
        client.send(message: text)
    }
    
}


fileprivate class WebSocketClient {
    var webSocketTask: URLSessionWebSocketTask!
    
    func connect(url: URL) {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask.resume()
        receiveMessages()
    }
    
    func disconnect() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }
    
    func receiveMessages() {
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received message: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
                self.receiveMessages()
            case .failure(let error):
                print("Error receiving message: \(error)")
            }
        }
    }
}
