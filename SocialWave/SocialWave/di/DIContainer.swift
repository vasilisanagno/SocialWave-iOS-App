import Foundation
import Swinject

//container that is useful for dependency injection and keeps all the classes that are useful from many views
class DIContainer {
    static let shared = DIContainer()
    let container = Container()
    
    private init() {
        container.register(AuthProtocol.self) { _ in AuthProtocolImpl() }.inObjectScope(.container)
        container.register(AuthRepository.self) { r in
            AuthRepository(service: r.resolve(AuthProtocol.self)!)
        }.inObjectScope(.container)
        container.register(UserProtocol.self) { _ in UserProtocolImpl() }.inObjectScope(.container)
        container.register(UserRepository.self) { r in
            UserRepository(service: r.resolve(UserProtocol.self)!)
        }.inObjectScope(.container)
        container.register(PostProtocol.self) { _ in PostProtocolImpl() }.inObjectScope(.container)
        container.register(PostRepository.self) { r in
            PostRepository(service: r.resolve(PostProtocol.self)!)
        }.inObjectScope(.container)
        container.register(CommentProtocol.self) { _ in CommentProtocolImpl() }.inObjectScope(.container)
        container.register(CommentRepository.self) { r in
            CommentRepository(service: r.resolve(CommentProtocol.self)!)
        }.inObjectScope(.container)
        container.register(NotificationProtocol.self) { _ in NotificationProtocolImpl() }.inObjectScope(.container)
        container.register(NotificationRepository.self) { r in
            NotificationRepository(service: r.resolve(NotificationProtocol.self)!)
        }.inObjectScope(.container)
        container.register(ChatProtocol.self) { _ in ChatProtocolImpl() }.inObjectScope(.container)
        container.register(ChatRepository.self) { r in
            ChatRepository(service: r.resolve(ChatProtocol.self)!)
        }.inObjectScope(.container)
        container.register(SharedViewModel.self) { _ in SharedViewModel() }.inObjectScope(.container)
        container.register(SocketViewModel.self) { _ in SocketViewModel() }.inObjectScope(.container)
    }
}
