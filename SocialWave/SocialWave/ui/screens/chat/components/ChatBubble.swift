import SwiftUI

//chat shape for each message to fit the cell according the text
struct ChatBubble: Shape {
    let isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [
            .topLeft,
            .topRight,
            isFromCurrentUser ? .bottomLeft : .bottomRight
        ], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
}
