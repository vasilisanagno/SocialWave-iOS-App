import Foundation
import SwiftUI

//struct model that helps to keep info about the upload-post images
struct IdentifiableUIImage: Identifiable {
    let id = UUID()
    let image: UIImage
}
